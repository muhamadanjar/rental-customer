import 'dart:async';
import 'dart:convert';

import 'package:customer/enum/auth.dart';
import 'package:customer/enum/viewstate.dart';
import 'package:customer/models/promo.dart';
import 'package:customer/models/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../utils/constant.dart';
import 'package:google_maps_webservice/places.dart';

class MainModel extends Model with ConnectedModel, UserModel,RequestSaldo,OrderModel, UtilityModel {}

mixin ConnectedModel on Model {
  User _authenticatedUser;
  bool _isLoading = false;
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

mixin OrderModel on Model{
  PlacesSearchResult originLocation;
  PlacesSearchResult destinationLocation;
  BehaviorSubject _placeCtrl = new BehaviorSubject();

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
  void setFrom(PlacesSearchResult item){
    originLocation = item;
    notifyListeners();
  }
  void setDestination(PlacesSearchResult item){
    destinationLocation = item;
    notifyListeners();
  }
}


mixin UserModel on ConnectedModel {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  User get user {
    return _authenticatedUser;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
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
    print(response.statusCode);
    final Map<String, dynamic> responseData = json.decode(json.encode(response.data));
    bool hasError = true;
    String message = 'Something went wrong.';
    print(responseData['data']);
    if (responseData.containsKey('data')) {
      var data = responseData['data'];
      int ex;
      if(data['expireTime'] != null){
        ex = data['expireTime'];
      }else{
        ex = 3600;
      }

      hasError = false;
      message = 'Authentication succeeded!';
      _authenticatedUser = User(
          id: responseData['id'],
          email: email,
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
    } else if (responseData['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists.';
    } else if (responseData['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email was not found.';
    } else if (responseData['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid.';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
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
      final int tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
      _authenticatedUser = User(id: userId, email: userEmail, token: token);
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

//    if(status){
//      message = response.data.message;
//    }

    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  } 
}

mixin UtilityModel on ConnectedModel {
  bool get isLoading {
    return _isLoading;
  }
  BehaviorSubject promo = BehaviorSubject();
  Observable get lp => promo.stream;


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

}

