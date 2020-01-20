import 'package:customer/scope/main_model.dart';
import 'package:customer/ui/page/auth_page.dart';
import 'package:customer/ui/page/booking_page.dart';
import 'package:customer/ui/page/home_page.dart';
import 'package:customer/ui/page/notfound.dart';
import 'package:customer/ui/page/notification_page.dart';
import 'package:customer/ui/page/request_saldo_page.dart';
import 'package:customer/ui/page/setting_page.dart';
import 'package:customer/ui/page/splash_page.dart';
import 'package:customer/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
        model: _model,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Customer App',
          theme: ThemeData(
            primaryColor: Colors.blue

          ),
          routes: {
            RoutePaths.Index: (BuildContext context) => !_isAuthenticated ? AuthPage() : HomePage(_model),
            RoutePaths.Settings : (BuildContext context) => SettingPage(_model),
            RoutePaths.Rental:(BuildContext context) => BookingPage(_model),
            RoutePaths.Notifications:(BuildContext context) => NotificationPage(),
            RoutePaths.Payment:(BuildContext context) => RequestSaldoPage(),
            RoutePaths.Splash:(BuildContext context) => SplashPage(),
          },
          // initialRoute: !_isAuthenticated ? RoutePaths.Auth : HomePage(_model),
          // onGenerateRoute: RouteGenerator.generateRoute,
          onUnknownRoute: (RouteSettings setting) {
    
            String unknownRoute = setting.name ;
              return new MaterialPageRoute(
                      builder: (context) => NotFoundPage()
              );
          }
          
        ),
    );
  }
}
