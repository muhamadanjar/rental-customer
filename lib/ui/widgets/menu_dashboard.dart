import 'package:customer/utils/size_config.dart';
import 'package:flutter/material.dart';

class MenuUtama extends StatelessWidget {
  final List menuList;
  MenuUtama({this.menuList});
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 4.0,
      mainAxisSpacing: 4.0,
      childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 2),
      children: menuList,
    );
  }
}

class MenuUtamaItems extends StatelessWidget {
  MenuUtamaItems({this.title, this.icon, this.colorBox, this.colorIcon,this.onPress});
  final String title;
  final IconData icon;
  final Color colorBox, colorIcon;
  final Function onPress;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return InkWell(
        onTap: onPress,
        child:Card(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                Container(
                  width: SizeConfig.blockWidth * 15,
                  height: SizeConfig.blockHeight * 15,
                  decoration: BoxDecoration(
                    color: colorBox,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: colorIcon,
                    size: 40.0,
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
      ],
      ),
          ),
        )
    );
  }
}
