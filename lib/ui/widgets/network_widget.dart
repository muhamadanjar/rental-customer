import 'package:customer/enum/connection.dart';
import 'package:customer/scope/main_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class NetworkSensitive extends StatelessWidget {
  final Widget child;
  final double opacity;

  NetworkSensitive({
    this.child,
    this.opacity = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    // Get our connection status from the provider
    var connectionStatus = ScopedModel.of<MainModel>(context).connectionStatus;

    if (connectionStatus == ConnectivityStatus.wifi) {
      return child;
    }

    if (connectionStatus == ConnectivityStatus.mobileData) {
      return Opacity(
        opacity: opacity,
        child: child,
      );
    }

    return Opacity(
      opacity: 0.1,
      child: child,
    );
  }
  dispose(){

  }
}
