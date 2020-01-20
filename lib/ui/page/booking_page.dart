import 'dart:async';
import 'dart:convert';

import 'package:customer/models/response_api.dart';
import 'package:customer/scope/main_model.dart';
import 'package:customer/ui/widgets/helpers/base_state.dart';
import 'package:customer/ui/widgets/network_widget.dart';
import 'package:customer/ui/widgets/rider_picker.dart';
import 'package:customer/utils/constant.dart';
import 'package:customer/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
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

class _BookingPageState extends BaseState<BookingPage> {
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Completer<GoogleMapController> _controller = Completer();
  PolylineId selectedPolyline;

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is BookingPage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(child: _buildMap()),
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
    print("place selected : $mkId");
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
      print("fromLatLng:$fromLatLng");
      print("toLatLng:$toLatLng");
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
    polylines.remove(polylineIdVal);
    print(markers.keys);
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
      print("response direction");
      
      var routes = response.routes[0];
      var legs = routes.legs[0];
      ScopedModel.of<MainModel>(context).setLeg(legs);
      var duration = legs.duration.value;
      var distance = legs.distance.value;
      var harga = ScopedModel.of<MainModel>(context).calculatePrice(10000,duration,10,10,distance,10);
      ScopedModel.of<MainModel>(context).setHarga(harga);
      
      List<LatLng> paths = new List();
      for (var t in legs.steps) {
          paths.add(LatLng(t.startLocation.lat, t.startLocation.lng));
          paths.add(LatLng(t.endLocation.lat, t.endLocation.lng));
      }

      final PolylineId polylineId = PolylineId(polylineIdVal);
      final Polyline polyline = Polyline(
          polylineId: polylineId,
          consumeTapEvents: true,
          color: Colors.black,
          width: 5,
          points: paths,
          onTap: () {
            _onPolylineTapped(polylineId);
          },
      );
      setState(() {
          polylines[polylineId] = polyline;
      });

    }
  }

  void _submitBooking(MainModel model) async{
    
    ResponseApi successInformation = await model.postBooking();
    if (successInformation.code == 200) {
      Navigator.pushNamed(context, RoutePaths.Home);
    }
    else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('An Error Occurred!'),
            content: Text(successInformation.message),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }
  Widget _buildInfo({driverName:'Driver',noPlat:'F000FF'}){
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 96.0),
            child: ScopedModelDescendant<MainModel>(
              builder:(BuildContext contenxt,Widget child,MainModel model)=> Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(driverName, style: Theme.of(context).textTheme.title,),
                  ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Text(noPlat),
                    subtitle: Text(noPlat),
                  ),
                ],
              ),
            ),
          ),
          
          ScopedModelDescendant<MainModel>(
            builder:(BuildContext context,Widget child,MainModel model)=> Row(
              children: <Widget>[
                Expanded(child: Column(
                  children: <Widget>[
                    Text("Jarak"),
                    Text(model.legInformation.distance.text),
                  ],
                ),),
                Expanded(child: Column(
                  children: <Widget>[
                    Text("Harga"),
                    Text(model.harga.toString()),
                  ],
                ),),
                Expanded(child: Column(
                  children: <Widget>[
                    Text("Waktu"),
                    Text(model.legInformation.duration.text),
                  ],
                ),),
              ],
            ),
          ),
          ScopedModelDescendant<MainModel>(

            builder:(BuildContext context,Widget child,MainModel model) => SizedBox(
              width: double.infinity,
              child: MaterialButton(
                child: Text("Pesan",style: TextStyle(color: Colors.white),),
                onPressed: (model.originLocation != null && model.destinationLocation != null) ? (){
                  _submitBooking(model);
                }:null,
                disabledColor: Colors.grey,
                color: Colors.blueAccent.shade400,
              ),
            ),
          )
        ],
      ),
    );
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
                          await LocationPicker.pickLocation(context, google_web_api);
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
              ScopedModelDescendant<MainModel>(
                builder:(BuildContext context,Widget child,MainModel model){
                  return model.originLocation != null && model.destinationLocation != null ? buildInfo():Container();
                }
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildInfo(){
    return Positioned(
      bottom: 30,
      left: 20,
      right: 20,
      height: SizeConfig.blockHeight * 35,
      child: Container(
        
        color: Color(0xFFFAAAAA),
        child: Center(
          child: _buildInfo(),
        ),
      ),
    );
  }

  
}