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
      appBar: AppBar(title: Text('Pengaturan'),),
      body: Container(
        child: ScopedModelDescendant(
          builder:(BuildContext context,Widget child,MainModel models) => ListView(
            children: <Widget>[
              GestureDetector(
                child: ListTile(
                  leading: Icon(FontAwesomeIcons.passport),
                  subtitle: Text("Ubah Password"),
                ),
                onTap: (){
                  
                },
              ),
              GestureDetector(
                child: ListTile(
                  leading: Icon(FontAwesomeIcons.file),
                  subtitle: Text("Faq"),
                ),
                onTap: (){

                },
              ),
              LogoutListTile()
              
            ],
          ),
        ),
      ),
    );
  }
}