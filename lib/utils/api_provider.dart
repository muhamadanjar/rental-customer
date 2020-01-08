import 'package:dio/dio.dart';
import 'constant.dart';
class ApiProvider{
  Dio _dio = new Dio();

  Future userNotification() async{
    Response response = await _dio.post("${apiURL}/users-notification");
    return response.data;
  }
}