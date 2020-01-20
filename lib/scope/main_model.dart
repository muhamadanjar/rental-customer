import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:customer/enum/auth.dart';
import 'package:customer/enum/connection.dart';
import 'package:customer/enum/viewstate.dart';
import 'package:customer/models/cartype.dart';
import 'package:customer/models/order.dart';
import 'package:customer/models/promo.dart';
import 'package:customer/models/response_api.dart';
import 'package:customer/models/user.dart';
import 'package:customer/models/user_notification.dart';
import 'package:customer/utils/api_provider.dart';
import 'package:customer/utils/connection.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../utils/constant.dart';
import 'package:google_maps_webservice/places.dart';

class MainModel extends Model with ConnectedModel, UserModel, RequestSaldo, OrderModel, UtilityModel {}

mixin ConnectedModel on Model {
  ResponseApi globResult = new ResponseApi();
  ApiProvider _apiProvider =  new ApiProvider(); 
  User _authenticatedUser;
  bool _isLoading = false;
  MyConnectivity _connectivity;
  Dio dio = new Dio();
  final JsonDecoder _decoder = new JsonDecoder();
  final JsonEncoder _encoder = new JsonEncoder();

  ViewState _state;
  ViewState get state => _state;

  void setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }
  
}

mixin OrderModel on UserModel{
  PlacesSearchResult originLocation;
  PlacesSearchResult destinationLocation;
  Leg _leg;
  Order orderData;
  BehaviorSubject _placeCtrl = new BehaviorSubject();
  double harga = 0;
  Leg get legInformation => _leg;
  Future get getDataOrderFromApi => _apiProvider.getBookingHistory(_authenticatedUser.token);
  BehaviorSubject get placeSubject => _placeCtrl;
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: google_web_api);
  void searchPlace(String keyword) {
    print("place bloc search: " + keyword);

    _placeCtrl.add("start");
    _places.searchByText(keyword,radius: 10).then((rs){

      _placeCtrl.add(rs.results);
    }).catchError(() {
      _placeCtrl.add("stop");
    });
    notifyListeners();
  }
  void nearbyLocation(Location location) async{
    PlacesSearchResponse response = await _places.searchNearbyWithRadius(location, 10);
    print(response);
  }
  void clearOrderData(){
    orderData = Order.initialData();
  }
  void setFrom(PlacesSearchResult item){
    originLocation = item;
    notifyListeners();
  }
  void setDestination(PlacesSearchResult item){
    destinationLocation = item;
    notifyListeners();
  }
  void setHarga(double value){
    harga = value;
    notifyListeners();
  }
  int kalkulasiHarga(base,tempuhKm,tarifKm){
    var ta = base+(tempuhKm-1)*tarifKm;
    var tm = 0;
    return ta +tm;
  }
  calculatePrice(base,time,timeRate,distanceRate,distance,surge){
    final double distanceInKm = distance * 0.001;

    final timeInMin = time * 0.0166667;
    final pricePerKm = timeRate * timeInMin;
    final pricePerMinute = distanceRate * distanceInKm;
//    final totalFare = (base + pricePerKm + pricePerMinute) * surge;
    final totalFare = (base * distanceInKm.roundToDouble());
//    var ta = base+(distanceInKm-(distanceInKm*0.01))*pricePerKm;
//    var tm = 0;
//    return ta +tm;
    return totalFare;
  }
  void setLeg(Leg leg){
    _leg = leg;
    
    print('Legs :');
    print(leg.distance);
    // orderData.distance = _leg.distance.value;
    // orderData.duration = _leg.duration.value;
    
    // orderData.origin = _leg.endAddress;
    // orderData.originLat = _leg.startLocation.lat;
    // orderData.originLng = _leg.startLocation.lng;

    // orderData.destination = _leg.endAddress;
    // orderData.destinationLat = _leg.endLocation.lat;
    // orderData.destinationLng = _leg.endLocation.lng;
    notifyListeners();
  }
  Future<ResponseApi> postBooking() async{
    try {
      if (_authenticatedUser == null) {
        logout();
      }
      FormData formData = new FormData();
      formData.fields.add(MapEntry("order_address_origin_lat", originLocation.geometry.location.lat.toString()));
      formData.fields.add(MapEntry("order_address_origin_lng", originLocation.geometry.location.lng.toString()));
      formData.fields.add(MapEntry("order_address_origin", originLocation.formattedAddress));

      formData.fields.add(MapEntry("order_address_destination", destinationLocation.formattedAddress));
      formData.fields.add(MapEntry("order_address_destination_lat", destinationLocation.geometry.location.lat.toString()));
      formData.fields.add(MapEntry("order_address_destination_lng", destinationLocation.geometry.location.lng.toString()));

      formData.fields.add(MapEntry("order_jenis", '1'));
      formData.fields.add(MapEntry("order_nominal", harga.toString()));
      formData.fields.add(MapEntry("order_distance", _leg.distance.value.toString()));
      formData.fields.add(MapEntry("order_duration", _leg.duration.value.toString()));

      formData.fields.add(MapEntry("order_keterangan", 'Pemesanan Rental Mobil'));

      _isLoading = true;
      notifyListeners();
      Response response = await dio.post("$apiURL/booking",data: formData,
          options: Options(
            headers: {
              'Authorization': 'Bearer ${_authenticatedUser.token}'
            }
          )
      );
      int statusCode = response.statusCode;
      final Map<String, dynamic> responseData = json.decode(json.encode(response.data));
      globResult = ResponseApi.fromJson(responseData);
      
      if (statusCode == 200) {
        setState(ViewState.Retrieved);
        
      }
      setState(ViewState.Error);
      return globResult;
      
    } catch (e) {
      
    }
    
    
  }
  
}


mixin UserModel on ConnectedModel {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  Future<List<UserNotification>> get getDataNotifFromApi => _apiProvider.getUserNotification(_authenticatedUser.token); 
  User get user {
    return _authenticatedUser;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  Future<ResponseApi> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    print(authData);
    Response response;
    
    if (mode == AuthMode.Login) {
      response = await dio.post(
        ResourceLink.loginUrl,
        data: json.encode(authData),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
    } else {
      response = await dio.post(
        ResourceLink.registerUrl,
        data: json.encode(authData),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        
      );
    }
    
    final Map<String, dynamic> responseData = json.decode(json.encode(response.data));
    globResult = ResponseApi.fromJson(responseData);
    bool hasError = true;
    String message = 'Something went wrong.';
    globResult = ResponseApi.fromJson(responseData);
    if (globResult.status == 'error') {
      message = globResult.message;
    }
    
    if (globResult.data != null) {
      var data = globResult.data;
      int ex = (data['expireTime'] != null)? data['expireTime']:3600;
      hasError = false;
      message = 'Authentication succeeded!';
      _authenticatedUser = User(
          id: responseData['id'],
          email: email,
          name: email,
          token: responseData['access_token']);
      setAuthTimeout(ex);
      _userSubject.add(true);
      final DateTime now = DateTime.now();
      final DateTime expiryTime = now.add(Duration(seconds: ex));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['access_token']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['id']);
      prefs.setString('expiryTime', expiryTime.toIso8601String());
    }
    _isLoading = false;
    setState(ViewState.Retrieved);
    notifyListeners();
    
    return globResult;
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String expiryTimeString = prefs.getString('expiryTime');
    if (token != null) {
      final DateTime now = DateTime.now();
      final parsedExpiryTime = DateTime.parse(expiryTimeString);
      if (parsedExpiryTime.isBefore(now)) {
        _authenticatedUser = null;
        notifyListeners();
        return;
      }
      final String userEmail = prefs.getString('userEmail');
      final String userId = prefs.getString('userId');
      final String name = prefs.getString('name');
      final int tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
      _authenticatedUser = User(id: userId,name:name, email: userEmail, token: token);
      _userSubject.add(true);
      setAuthTimeout(tokenLifespan);
      notifyListeners();
    }
  }

  void logout() async {
    _authenticatedUser = null;
    _authTimer.cancel();
    _userSubject.add(false);
    
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }

  Future<ResponseApi> getUserNotifikasi() async{
    await dio.get("$apiURL/user-notifiacations",
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_authenticatedUser.token}'
        }
      )
    );
  }
}

mixin RequestSaldo on ConnectedModel{
  Future<Map<String,dynamic>> uploadBukti(FormData formData) async{
    _isLoading = true;
    notifyListeners();
    bool hasError = true;
    String message = 'Something went wrong.';

    FormData reqData = formData;

    Response response = await dio.post("$apiURL/topup/bukti",data: reqData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_authenticatedUser.token}'
          }
        )
    );

    final int statusCode = response.statusCode;
//    final bool status = response.data.status;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }


    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  } 
}

mixin UtilityModel on ConnectedModel {
  bool get isLoading {
    return _isLoading;
  }
  Future<List<CarType>> get getDataCartypeFromApi => _apiProvider.getCarType(); 
  
  BehaviorSubject promo = BehaviorSubject();
  Observable get lp => promo.stream;
  BehaviorSubject<ConnectivityStatus> connectionStatus = new BehaviorSubject<ConnectivityStatus>();
  
  Future<List<Promo>> getPromo() async{
    Response response = await dio.get("$apiURL/promo",options: Options(
      headers: {'Content-Type': 'application/json'},
    ));
    List listPromo = new List<Promo>();
    Map body = response.data;
    var data = _decoder.convert(_encoder.convert(body['data']));

    (data as List).forEach((f){
      listPromo.add(Promo(name: f["name"],kodePromo: f["kode_promo"],discount: 10,imgUrl: f["image_path"]));
    });
    notifyListeners();
    promo.add(listPromo);
    return listPromo;


  }

  disponseConnection(){
    connectionStatus.close();
    _connectivity.disposeStream();
  }
}

