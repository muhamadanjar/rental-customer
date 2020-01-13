import 'package:customer/scope/main_model.dart';
import 'package:customer/ui/fragments/history_view.dart';
import 'package:customer/ui/fragments/profile_view.dart';
import 'package:customer/ui/widgets/menu_dashboard.dart';
import 'package:customer/ui/widgets/promo.dart';
import 'package:customer/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  final MainModel model;

  HomePage(this.model);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  BuildContext _ctx;
  List<MenuUtamaItems> menuUtamaItem;
  int _bottomNavCurrentIndex = 0;
  List<Widget> _container= [
//    _homeView(_ctx, widget.model)
  ];


  TabController _tabController;
  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
     _container = [
      _homeView(_ctx, widget.model)
    ];
    menuUtamaItem = [
      MenuUtamaItems(
        title: "Promo",
        icon: Icons.local_taxi,
        colorBox: Colors.blue,
        colorIcon: Colors.white,
        onPress: (){
          print(RoutePaths.Rental);
          Navigator.pushNamed(_ctx, RoutePaths.Rental);
        },
      ),
      MenuUtamaItems(
        title: "Reguler",
        icon: Icons.local_taxi,
        colorBox: Colors.grey,
        colorIcon: Colors.white,
        onPress: (){
          Navigator.pushNamed(_ctx, RoutePaths.Rental);
        },
      ),
    ];
    ScopedModel.of<MainModel>(context).getPromo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return Scaffold(
      
      appBar: new AppBar(
        title: new Text('Home',style: TextStyle(wordSpacing: 2),),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        actions: <Widget>[
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return IconButton(
                icon: Icon(FontAwesomeIcons.bell),
                onPressed: () {
                  Navigator.pushNamed(context, RoutePaths.Notifications);
                },
              );
            },
          )
        ],
        
      ),
      body:TabBarView(
        children: <Widget>[
          ScopedModelDescendant<MainModel>(
              builder:(BuildContext context,Widget child,MainModel model){
            return _homeView(context,model);
          }),
          HistoryView(),
          ProfileView(),
        ],
        controller: _tabController,
      ),
//      body:_container[_bottomNavCurrentIndex],
      bottomNavigationBar: _buildBottomTab(),
    );
  }

  Widget _homeView(BuildContext context,MainModel model){
    return Container(
      child: RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          children: <Widget>[
            new Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
              color: Colors.white,
              child: new Column(
                children: <Widget>[
                  _buildMenu(),
                  MenuUtama(
                    menuList: menuUtamaItem,
                  ),
                  StreamBuilder(
                  stream: model.promo.stream,
                  builder: (BuildContext context,AsyncSnapshot snapshot){
                    print(snapshot);
                    if (snapshot.hasError) {
                      return new Text("Error!");
                    } else if (snapshot.hasData) {
                      print(snapshot.data);
                      return PromoWidget(listPromo: snapshot.data,);
                    }else{
                      print(snapshot.data);
                      return Container();

                    }
                  },
                ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildMenu() {
    return new Container(
        height: 120.0,
        decoration: new BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [const Color(0xff3164bd), const Color(0xff295cb5)],
            ),
            borderRadius: new BorderRadius.all(new Radius.circular(3.0))),
        child: new Column(
          children: <Widget>[
            new Container(
              padding: EdgeInsets.all(12.0),
              decoration: new BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [const Color(0xff3164bd), const Color(0xff295cb5)],
                  ),
                  borderRadius: new BorderRadius.only(
                      topLeft: new Radius.circular(3.0),
                      topRight: new Radius.circular(3.0))),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                    "Saldo",
                    style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontFamily: "NeoSansBold"),
                  ),
                  new Container(
                    child: new Text(
                      "Rp. ",
                      style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                          fontFamily: "NeoSansBold"),
                    ),
                  )
                ],
              ),
            ),
            new Container(
              padding: EdgeInsets.only(left: 32.0, right: 32.0, top: 12.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap:(){
                      Navigator.pushNamed(_ctx, RoutePaths.Rental);
                    },
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Image.asset(
                          "assets/icon_menu.png",
                          width: 32.0,
                          height: 32.0,
                        ),
                        new Padding(
                          padding: EdgeInsets.only(top: 10.0),
                        ),
                        new Text(
                          "Booking",
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        )
                      ],
                    ),
                  ),
                  
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, RoutePaths.Payment);
                    },
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Image.asset(
                          "assets/icon_menu.png",
                          width: 32.0,
                          height: 32.0,
                        ),
                        new Padding(
                          padding: EdgeInsets.only(top: 10.0),
                        ),
                        new Text(
                          "Isi Saldo",
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(behavior: HitTestBehavior.opaque,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Image.asset(
                          "assets/icon_menu.png",
                          width: 32.0,
                          height: 32.0,
                        ),
                        new Padding(
                          padding: EdgeInsets.only(top: 10.0),
                        ),
                        new Text(
                          "Lainnya",
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        )
                      ],
                    ),
                    onTap: (){
                      showModalBottomSheet<void>(
                          context: context,
                          builder: (context) {
                            return _buildMenuBottomSheet();
                          });
                    },
                  )
                  ,
                ],
              ),
            )
          ],
        ));
  }

  Widget _buildBottomNavigation(){
    return new BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() {
          _bottomNavCurrentIndex = index;
        });
      },
      currentIndex: _bottomNavCurrentIndex,
      items: [
        BottomNavigationBarItem(
          activeIcon: new Icon(
            Icons.home,
            color: Colors.green,
          ),
          icon: new Icon(
            Icons.home,
            color: Colors.grey,
          ),
          title: new Text(
            'Beranda',
          ),
        ),
        BottomNavigationBarItem(
          activeIcon: new Icon(
            Icons.assignment,
            color: Colors.green,
          ),
          icon: new Icon(
            Icons.assignment,
            color: Colors.grey,
          ),
          title: new Text('Pesanan'),
        ),
        BottomNavigationBarItem(
          activeIcon: new Icon(
            Icons.mail,
            color: Colors.green,
          ),
          icon: new Icon(
            Icons.mail,
            color: Colors.grey,
          ),
          title: new Text('Inbox'),
        ),
        BottomNavigationBarItem(
          activeIcon: new Icon(
            Icons.person,
            color: Colors.green,
          ),
          icon: new Icon(
            Icons.person,
            color: Colors.grey,
          ),
          title: new Text('Akun'),
        ),
      ],
    );
  }
  Widget _buildBottomTab(){
    return TabBar(
          unselectedLabelColor: Colors.black,
          labelColor: Colors.black12,
          tabs: [
              new Tab(icon: new Icon(Icons.home)),
              new Tab(
                icon: new Icon(Icons.history),
              ),
              new Tab(
                icon: new Icon(Icons.people),
              )
          ],
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
        );
  }
  Future<void> refresh() {
    ScopedModel.of<MainModel>(context).getPromo();
    return Future.delayed(Duration(seconds: 5));


  }
  Widget _buildMenuBottomSheet() {
    return new StatefulBuilder(builder: (c, s) {
      return new SafeArea(
          child: new Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            width: double.infinity,
            height: 300,
            decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(4.0), color: Colors.white),
            child: new Column(children: <Widget>[
              new Icon(
                Icons.drag_handle,
                color: Colors.grey,
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: new Text(
                      "Lebih Lengkap",
                      style: new TextStyle(fontFamily: "NeoSansBold", fontSize: 18.0),
                    ),
                  ),

                ],
              ),
              new Container(
                padding: EdgeInsets.only(top:20),
                height: 200.0,
                child: new GridView.builder(
                    physics: new NeverScrollableScrollPhysics(),
                    itemCount: 2,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemBuilder: (context, position) {
                      return Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                showModalBottomSheet<void>(
                                    context: context,
                                    builder: (context) {
                                      return _buildMenuBottomSheet();
                                    });
                              },
                              child: new Container(
                                decoration: new BoxDecoration(
                                    border: Border.all(color: Colors.grey[200], width: 1.0),
                                    borderRadius:
                                    new BorderRadius.all(new Radius.circular(20.0))),
                                padding: EdgeInsets.all(12.0),
                                child: new Icon(
                                  FontAwesomeIcons.cogs,
                                  color: Colors.green,
                                  size: 32.0,
                                ),
                              ),
                            ),
                            new Padding(
                              padding: EdgeInsets.only(top: 6.0),
                            ),
                            new Text("Setting", style: new TextStyle(fontSize: 10.0))

                          ],
                        ),
                      );
                    }),
              ),
            ]),
          ));
    });
  }
}

