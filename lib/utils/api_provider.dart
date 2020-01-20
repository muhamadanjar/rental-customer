import 'dart:convert';

import 'package:customer/models/cartype.dart';
import 'package:customer/models/order.dart';
import 'package:customer/models/response_api.dart';
import 'package:customer/models/user_notification.dart';
import 'package:dio/dio.dart';
import 'constant.dart';
class ApiProvider{
  Dio _dio = new Dio();

  Future<List<UserNotification>> getUserNotification(String token) async{
    Response response = await _dio.get("$apiURL/users-notification",
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization':'Bearer $token'
        }
      )
    );
    
    final body =  ResponseApi.fromJson(response.data);
    final List rawData = jsonDecode(jsonEncode(body.data));
    List<UserNotification> listUserNotificationModel = rawData.map((f)=>UserNotification.fromMap(f)).toList();
    // print(api.data);
    return listUserNotificationModel;
  }
  Future postReviews() async{
    Response response = await _dio.post("$apiURL/users/post-reviews");
    final api = ResponseApi.fromJson(response.data);
    return api;
  }
  Future userMeta() async{
    Response response = await _dio.post("$apiURL/user/post/meta");
    final api = ResponseApi.fromJson(response.data);
    return api;
  }
  Future checkMeta() async{
    Response response = await _dio.post("$apiURL/user/post/check-meta-value");
    final api = ResponseApi.fromJson(response.data);
    return api;
    
  }
  Future changeStatusOnline() async{
    
    Response response = await _dio.post("$apiURL/user/changestatus");
    final api = ResponseApi.fromJson(response.data);
    return api;
  }
  Future registerDataUser() async{
    Response response = await _dio.post("$apiURL/auth/user");
    final api = ResponseApi.fromJson(response.data);
    return api;
  }

  Future getDataUser() async{
    
    Response response = await _dio.post("$apiURL/auth/user");
    final api = ResponseApi.fromJson(response.data);
    return api;
  }
  Future<List<CarType>> getCarType() async{
    Response response = await _dio.get("$apiURL/car-types");
    final body = ResponseApi.fromJson(response.data);
    final List  rawData = jsonDecode(jsonEncode(body));
    List<CarType> listCarTypeModel = rawData.map((f)=>CarType.fromJson(f)).toList();
    return listCarTypeModel;
  }

  Future getDataPromo() async{
    Response response = await _dio.post("$apiURL/promo");
    final api = ResponseApi.fromJson(response.data);
    return api;
  }

  Future getBookingHistory(String token) async{
    Response response = await _dio.post("$apiURL/getHistoryOrderByUser",
      options: Options(
        headers: {
          
        }
      )
    );
    final ResponseApi body =  ResponseApi.fromJson(response.data);
    List rawData = jsonDecode(jsonEncode(body));
    List<Order> listOrderModel = rawData.map((f)=>Order.fromJson(f)).toList();
    return listOrderModel;
  }

  Future getGlobalSetting() async{
    Response response = await _dio.get("$apiURL/global-settings");
    final api = ResponseApi.fromJson(response.data);
    return api;
    
  }

  Future getServiceType() async{
    Response response = await _dio.get("$apiURL/services-type");
    final api = ResponseApi.fromJson(response.data);
    return api;

  }

  
  
  
}