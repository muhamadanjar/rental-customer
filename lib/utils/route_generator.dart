import 'package:customer/scope/main_model.dart';
import 'package:customer/ui/page/auth_page.dart';
import 'package:customer/ui/page/home_page.dart';
import 'package:customer/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  MainModel _model;
  RouteGenerator(this._model);
  static Route<dynamic> generateRoute(RouteSettings settings ){
    final args = settings.arguments;
    switch (settings.name) {
      
      default:
        return _errorsRoute();

    }
  }

  static Route<dynamic> _errorsRoute(){
    return MaterialPageRoute(builder: (_){
      return Scaffold(body: Center(child: Text("Error"),),);
    });
  }
  
}