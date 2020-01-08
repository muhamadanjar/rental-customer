import 'package:customer/scope/main_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../utils/size_config.dart';


class RidePickerPage extends StatefulWidget {
  final String selectedAddress;
  final Function(PlacesSearchResult, bool) onSelected;
  final bool _isFromAddress;
  RidePickerPage(this.selectedAddress, this.onSelected, this._isFromAddress);

  @override
  _RidePickerPageState createState() => _RidePickerPageState();
}

class _RidePickerPageState extends State<RidePickerPage> {
  var _addressController = new TextEditingController();
  BuildContext _ctx;

  @override
  void initState() {
    print("data alamat : ${widget.selectedAddress}");
    _addressController = TextEditingController(text: widget.selectedAddress);
    super.initState();
  }

  @override
  void dispose() {

//    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationPicker = ScopedModel.of<MainModel>(context);
    _ctx = context;
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(),
      body: Container(
        color: Color(0xfff8f8f8),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  child: Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: <Widget>[
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: Center(
                          child: Image.asset("assets/ic_location_black.png"),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        width: 40,
                        height: 50,
                        child: Center(
                          child: FlatButton(
                              onPressed: () {
                                _addressController.text = "";
                              },
                              child: Image.asset("assets/ic_remove_x.png")),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 40, right: 50),
                        child: ScopedModelDescendant<MainModel>(
                          builder:(BuildContext context,Widget child,MainModel model)=>TextField(
                            controller: _addressController,
                            textInputAction: TextInputAction.search,
                            onChanged: (value){
                              model.searchPlace(value);
                            },
                            onSubmitted: (String str) {
                              print("onSubmit: $str");
                            },
                            style:TextStyle(fontSize: 16, color: Color(0xff323643)),

                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
                height: SizeConfig.blockHeight * 77,
                color: Colors.amber,
                child: StreamBuilder(
                    stream: locationPicker.placeSubject.stream,
                    builder: (context, AsyncSnapshot snapshot) {
                      print(snapshot.connectionState);
                      switch(snapshot.connectionState) {
                        case ConnectionState.none:
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        case ConnectionState.waiting:
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                          break;
                        case ConnectionState.active:
                          if (snapshot.hasError) {
                            return Container(
                              child: Center(child: Text("Something Wrong"),
                              ),
                            );
                          }else if(snapshot.hasData){
                            if (snapshot.data == "start") {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            List<PlacesSearchResult> places = snapshot.data;
                            return buildListPlace(places);
                          }
                          break;
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return Container(
                              child: Center(
                                child: Text("Something Wrong"),
                              ),
                            );
                          } else if (snapshot.hasData) {
                            print(snapshot.data.toString());
                            if (snapshot.data == "start") {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            print(snapshot.data.to());

                            List<PlacesSearchResult> places = snapshot.data;
                            print("Jumlah Place :${places.length}");
                            return buildListPlace(places);
                          } else {
                            return Container();
                          }
                          break;
                        default:
                          return Container();
                      }
                      return Container();


                    }),
            ),

          ],
        ),
      ),
    );
  }

  Widget buildListPlace(places){
    return ScopedModelDescendant<MainModel>(
      builder:(BuildContext context,Widget child, MainModel model)=> ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(places.elementAt(index).name),
              subtitle: Text(places.elementAt(index).formattedAddress),
              onTap: () {
                print("on tap");
                Navigator.of(context).pop();
                print(places.elementAt(index));
                if(widget._isFromAddress){
                  model.setFrom(places.elementAt(index));
                }else{
                  model.setDestination(places.elementAt(index));
                }

                widget.onSelected(places.elementAt(index),widget._isFromAddress);

              },
            );
          },
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: Color(0xfff5f5f5),
          ),
          itemCount: places.length),
    );
  }


}
