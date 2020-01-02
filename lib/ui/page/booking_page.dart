import 'dart:async';

import 'package:customer/scope/main_model.dart';
import 'package:customer/ui/widgets/rider_picker.dart';
import 'package:customer/utils/constant.dart';
import 'package:customer/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart' as GDirections;
import 'package:google_maps_webservice/places.dart';

import 'package:scoped_model/scoped_model.dart';

class BookingPage extends StatefulWidget {
  final MainModel model;
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  BookingPage(this.model);
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Completer<GoogleMapController> _controller = Completer();
  PolylineId selectedPolyline;


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

  void _onPolylineTapped(PolylineId polylineId) {
    setState(() {
      selectedPolyline = polylineId;
    });
  }

  void onPlaceSelected(PlacesSearchResult place, bool fromAddress) {

    var mkId = fromAddress ? "from_address" : "to_address";
    print("place selected : ${mkId}");
    var state = ScopedModel.of<MainModel>(context);

    if(fromAddress){
      state.setFrom(place);
    }else{
      state.setDestination(place);
    }


    _addMarker(mkId, place);
    _moveCamera();
    _checkDrawPolyline();
  }

  void _addMarker(String mkId, PlacesSearchResult place) async {
    // remove old
    markers.remove(mkId);
    markers[MarkerId(mkId)] = Marker(
//        icon: _markerIcon,
      markerId:MarkerId(mkId),
      position: LatLng(place.geometry.location.lat, place.geometry.location.lng),
//        infoWindow: InfoWindow(title: place.name,snippet: place.address)
    );
    print(markers);
  }

  void _moveCamera() async {
    final GoogleMapController controller = await _controller.future;
    print("move camera: ${markers.values.elementAt(0).position}");
    var fromLatLng,toLatLng;
    markers.forEach((mkid,v){
      print(mkid.value);
      if(mkid.value == "from_address"){
        fromLatLng = v.position;
      }else{
        toLatLng = v.position;
      }
      var sLat, sLng, nLat, nLng;
      print("fromLatLng:${fromLatLng}");
      print("toLatLng:${toLatLng}");
      if(fromLatLng != null && toLatLng != null){
        if(fromLatLng.latitude <= toLatLng.latitude) {
          sLat = fromLatLng.latitude;
          nLat = toLatLng.latitude;
        } else {
          sLat = toLatLng.latitude;
          nLat = fromLatLng.latitude;
        }
        if(fromLatLng.longitude <= toLatLng.longitude) {
          sLng = fromLatLng.longitude;
          nLng = toLatLng.longitude;
        } else {
          sLng = toLatLng.longitude;
          nLng = fromLatLng.longitude;
        }
        LatLngBounds bounds = LatLngBounds(northeast: LatLng(nLat, nLng), southwest: LatLng(sLat, sLng));
        controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      }else{
        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: markers.values.elementAt(0).position,
          zoom: 12.10,
        )));
      }

    });

  }

  void _checkDrawPolyline() async {
    final String polylineIdVal = 'polyline_id_distance';
    print("Draw Polyline");
    var state = ScopedModel.of<MainModel>(context);
    polylines.remove(polylineIdVal);
    if (markers.length > 1) {
      var from, to;
      markers.forEach((mkid,v){
        print(mkid.value);
        if(mkid.value == "from_address"){
          from = v.position;
        }else{
          to = v.position;
        }
      });
      final directions = new GDirections.GoogleMapsDirections(apiKey: google_web_api);
      GDirections.DirectionsResponse response = await directions.directions(new Location(from.latitude,from.longitude), new Location(to.latitude,to.longitude));
      print(response);
      print("checkDrawPolyline from: ${from}");
//      PlaceService.getStep(from.latitude, from.longitude, to.latitude, to.longitude).then((vl) {
//        TripInfoRes infoRes = vl;
//        _tripDistance = infoRes.distance * 0.001;
//        var timerate = _tripDistance / infoRes.time;
//        var durationrate = 10;
//        double price = state.calculatePrice(10000, infoRes.time, timerate, durationrate, infoRes.distance, 1);
//        int priceConvert = price.toInt();
//        print("info harga ${price.toInt()}");
//
//        state.setJarak(_tripDistance.toInt());
//        state.setHarga(priceConvert);
//        // var harga = kalkulasiHarga(int.parse(basicCar['per_miles']), _tripDistance.toInt(), int.parse(basicCar['per_min']));
//        var harga = 100;
//        List<StepsRes> rs = infoRes.steps;
//        List<LatLng> paths = new List();
//        for (var t in rs) {
//          paths.add(LatLng(t.startLocation.latitude, t.startLocation.longitude));
//          paths.add(LatLng(t.endLocation.latitude, t.endLocation.longitude));
//        }
//        final PolylineId polylineId = PolylineId(polylineIdVal);
//        final Polyline polyline = Polyline(
//          polylineId: polylineId,
//          consumeTapEvents: true,
//          color: Colors.black,
//          width: 5,
//          points: paths,
//          onTap: () {
//            _onPolylineTapped(polylineId);
//          },
//        );
//        setState(() {
//          tripTotal = harga;
//          polylines[polylineId] = polyline;
//        });
//      });
    }
  }


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
              ScopedModelDescendant<MainModel>(
                builder:(BuildContext context,Widget child,MainModel model) => Positioned(
                  child: Column(
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () async {

                        },
                        child: Text('Pick location'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: RidePicker(onPlaceSelected,fromAddress:model.originLocation,toAddress:model.destinationLocation,),
                      ),
                    ],
                  ),
                ),
              ),
              buildInfo()
            ],
          ),
        )
      ],
    );
  }

  Widget buildInfo(){
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      height: SizeConfig.blockHeight * 15,
      child: Container(color: Color(0xFFFAAAAA),height: 50,
      child: ,),
    );
  }
}