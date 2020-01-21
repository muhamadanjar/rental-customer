import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer/models/order.dart';
import 'package:customer/scope/main_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Item {
  final String title;
  final String catagory;
  final String place;
  final String ratings;
  final String discount;
  final String image;

  Item(
      {this.title,
        this.catagory,
        this.place,
        this.ratings,
        this.discount,
        this.image});
}

class HistoryView extends StatelessWidget {

  final List<Item> _data = [
    Item(
        title: 'Gardens By the Bay',
        catagory: "Gardens",
        place: "Singapore",
        ratings: "5.0/80",
        discount: "10 %",
        image: "https://images.pexels.com/photos/672142/pexels-photo-672142.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"),
    Item(
        title: 'Singapore Zoo',
        catagory: "Parks",
        place: "Singapore",
        ratings: "4.5/90",
        discount: null,
        image: "https://images.pexels.com/photos/1736222/pexels-photo-1736222.jpeg?cs=srgb&dl=adult-adventure-backpacker-1736222.jpg&fm=jpg"),
    Item(
        title: 'National Orchid Garden',
        catagory: "Parks",
        place: "Singapore",
        ratings: "4.5/90",
        discount: "12 %",
        image: "https://images.pexels.com/photos/62403/pexels-photo-62403.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"),
    Item(
        title: 'Godabari',
        catagory: "Parks",
        place: "Singapore",
        ratings: "4.5/90",
        discount: "15 %",
        image: "https://images.pexels.com/photos/189296/pexels-photo-189296.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"),
    Item(
        title: 'Rara National Park',
        catagory: "Parks",
        place: "Singapore",
        ratings: "4.5/90",
        discount: "12 %",
        image: "https://images.pexels.com/photos/1319515/pexels-photo-1319515.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
  ];

  @override
  Widget build(BuildContext context) {
    
        return FutureBuilder(
          future: ScopedModel.of<MainModel>(context).getDataOrderFromApi,
          builder: (BuildContext context, AsyncSnapshot<List<Order>> snapshot) {
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
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(6),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      print(snapshot.data);
                      return _buildCard(snapshot.data[index]);
                    },
                  );
                }
                break;
            }
            return Container();
          
          }
             
        );
      
      
  

  }

  Widget _buildCard(Order item){
    return Card(
          elevation: 3,
          child: Row(
            children: <Widget>[
              Container(
                height: 125,
                width: 110,
                padding:EdgeInsets.only(left: 0, top: 10, bottom: 70, right: 20),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider("https://via.placeholder.com/150"),
                      fit: BoxFit.cover
                  )
                ),
                child:item.orderCode==null?Container(): Container(
                  color: Colors.deepOrange,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Harga",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
                      ),
                      Text(
                        item.orderNominal.toString(),
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
       child: Row(
         children: <Widget>[
            Flexible(
               child: new Text("A looooooooooooooooooong text"))
                ],
        )),
                    Text(
                        item.orderAddressDestination,
                        overflow: TextOverflow.clip,
                        softWrap: true,
                        maxLines: 2,
                        style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.w700,
                            fontSize: 17),
                      ),
                    // Text(
                    //   item.orderAddressDestination,
                    //   maxLines: 10,
                    //   overflow: TextOverflow.ellipsis,
                    //   softWrap: false,
                    //   style: TextStyle(fontSize: 14, color: Colors.black87),
                    // ),
                    Text(
                      item.orderId.toString(),
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: Colors.pink,
                          size: 18,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.pink,
                          size: 18,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.pink,
                          size: 18,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.pink,
                          size: 18,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.pink,
                          size: 18,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(item.orderJenis, style: TextStyle(
                            fontSize: 13
                        ),),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Ratings", style: TextStyle(fontSize: 13),),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ); 
  }
}
