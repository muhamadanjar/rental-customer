import 'package:customer/scope/main_model.dart';
import 'package:customer/ui/widgets/ui_elements/logout_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListView(
          children: <Widget>[
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [0.5, 0.9],
                    colors: [
                      Colors.blue,
                      Colors.deepPurple.shade300
                    ]
                )
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        CircleAvatar(
                          child: Icon(Icons.person, size: 30.0,),
                          minRadius: 30.0,
                          backgroundColor: Colors.green.shade600,)
                      ],
                    ),
                    SizedBox(height: 10,),
                    Text(model.user.email, style: TextStyle(fontSize: 22.0, color: Colors.white),),
                    Text(model.user.email, style: TextStyle(fontSize: 14.0, color: Colors.red.shade700),)

                  ],
              )
            ),
            
            ListTile(
              title: Text("Email", style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),),
              subtitle: Text(model.user.email, style: TextStyle(fontSize: 18.0),),
            ),
            Divider(),
            ListTile(
              title: Text("Phone", style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),),
              subtitle: Text("+977 9818225533", style: TextStyle(fontSize: 18.0),),
            ),
            Divider(),
            
            ListTile(
              title: Text("Facebook", style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),),
              subtitle: Text("facebook.com/rudi", style: TextStyle(fontSize: 18.0),),
            ),
            Divider(),
            LogoutListTile(),
          ],
        );
      }
        
    );
  }
}
