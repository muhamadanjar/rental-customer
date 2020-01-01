import 'dart:async';
import 'package:customer/scope/main_model.dart';
import 'package:customer/ui/page/home_page.dart';
import 'package:flutter/material.dart';
class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final MainModel model = MainModel();
  @override
  void initState() {
    startLaunching();
    super.initState();
  }
  startLaunching() async {
    var duration = const Duration(seconds: 1);
    return new Timer(duration, () {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (_) {
        return new HomePage(model);
      }));
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Image.asset(
          "assets/food.jpg",
          height: 100.0,
          width: 200.0,
        ),
      ),
    );
  }
}
