import 'package:flutter/material.dart';
import '../../models/promo.dart';
class PromoWidget extends StatelessWidget {
  final List<Promo> listPromo;
  PromoWidget({this.listPromo});
  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 250.0,
          padding: const EdgeInsets.only(left: 8.0),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: listPromo.length,
              itemBuilder: (context,idx){
                var listCon = Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(100, 176, 223, 229),
                            Color.fromARGB(100, 0, 142, 204)
                          ]),
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                          image: NetworkImage(listPromo[idx].imgUrl),
                          fit: BoxFit.cover
                      )
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                  height: 250.0,
                  width: 300.0,
                );
                return (idx == 0) ? listCon:listCon;
              }
          ),
        )
      ],
    );
  }
}


