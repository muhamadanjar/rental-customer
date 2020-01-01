import 'dart:async';

import 'package:customer/scope/main_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BookingPage extends StatefulWidget {
  final MainModel model;
  
  BookingPage(this.model);
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildMap(),
    );
  }

  static final CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(3.6422756, 98.5294038),
    zoom: 11.0,
  );

  Widget _buildMap(){
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                child: GoogleMap(
                  markers: Set<Marker>.of(markers.values),
                  polylines: Set<Polyline>.of(polylines.values),
                  mapType: MapType.normal,
                  initialCameraPosition: _cameraPosition,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    //_initCameraPosition();
                  },
                ),
              ),
              Positioned(
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () async {
                        
                      },
                      child: Text('Pick location'),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}