import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer/scope/main_model.dart';
import 'package:customer/ui/widgets/ui_elements/logout_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

class SettingPage extends StatefulWidget {
  final MainModel model;
  SettingPage(this.model);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(title: Text('Pengaturan'),),
      body: Container(
        child: ScopedModelDescendant(
          builder:(BuildContext context,Widget child,MainModel models) => SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Card(
                  elevation: 0.5,
                  margin: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 0,
                  ),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider("'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fdev_sid.png?alt=media',"),
                        ),
                        title: Text(models.user.email),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),


                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0,),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    children: <Widget>[
                      SwitchListTile(
                        activeColor: Colors.blue.shade50,
                        value: true,
                        title: Text("Received notification"),
                        onChanged: (val) {},
                      ),
                      _buildDivider(),
                      SwitchListTile(
                        activeColor: Colors.blue.shade50,
                        value: false,
                        title: Text("Received newsletter"),
                        onChanged: null,
                      ),
                      _buildDivider(),
                      SwitchListTile(
                        activeColor: Colors.blue,
                        value: true,
                        title: Text("Received Offer Notification"),
                        onChanged: (val) {},
                      ),
                      _buildDivider(),
                      SwitchListTile(
                        activeColor: Colors.blue,
                        value: true,
                        title: Text("Received App Updates"),
                        onChanged: null,
                      ),
                      ListTile(
                        leading: Icon(FontAwesomeIcons.passport),
                        subtitle: Text("Ubah Password"),
                      ),
                      ListTile(
                        leading: Icon(FontAwesomeIcons.file),
                        subtitle: Text("Faq"),
                        onTap: (){},
                      ),
                      LogoutListTile()
                    ],
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade300,
    );
  }
}