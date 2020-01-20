import 'package:customer/models/user_notification.dart';
import 'package:customer/scope/main_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class NotificationPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifikasi'),
      ),
      body: Container(
        child: FutureBuilder(
          future: ScopedModel.of<MainModel>(context).getDataNotifFromApi,
          builder:(BuildContext context, AsyncSnapshot<List<UserNotification>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
                break;
              case ConnectionState.waiting:
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
                break;
              case ConnectionState.active:
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
                break;
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Container(
                    child: Center(
                      child: Text("Something Wrong"),
                    ),
                  );
                } else {
                  return BuildList(
                    listData: snapshot.data,
                  );
                }
                break;
            }
            return Container();
          }

        ),
      ),
    );
  }
}

class BuildList extends StatelessWidget {
  const BuildList({Key key, this.listData}) : super(key: key);

  final List<UserNotification> listData;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: listData.length,
        itemBuilder: (context, index) {
          if (listData.length < 0 ) {
            return Text("Belum ada Notifikasi");
          }
          return ListTile(
            title: Text(listData[index].jenis),
            subtitle: Text(listData[index].message,overflow: TextOverflow.clip,),
          );
        },
      ),
    );
  }
}