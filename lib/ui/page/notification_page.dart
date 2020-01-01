import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifikasi'),
      ),
      body: Container(
        child: ListView.builder(

          itemCount: 0,
          itemBuilder: (BuildContext context,int index){
            return new ListTile(
              leading: Icon(FontAwesomeIcons.info),
              title: Text('AAA'),
              subtitle: Text('AAA'),
            );
          },

        ),
      ),
    );
  }
}