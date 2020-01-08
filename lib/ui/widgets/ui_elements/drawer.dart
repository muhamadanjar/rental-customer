import 'package:flutter/material.dart';
Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        const DrawerHeader(
          child: Center(
            child: Text('Flutter Map Examples'),
          ),
        ),
//        ListTile(
//          title: const Text('OpenStreetMap'),
//          selected: currentRoute == HomePage.route,
//          onTap: () {
//            Navigator.pushReplacementNamed(context, HomePage.route);
//          },
//        ),
//        ListTile(
//          title: const Text('Add Pins'),
//          selected: currentRoute == TapToAddPage.route,
//          onTap: () {
//            Navigator.pushReplacementNamed(context, TapToAddPage.route);
//          },
//        ),
//        ListTile(
//          title: const Text('Esri'),
//          selected: currentRoute == EsriPage.route,
//          onTap: () {
//            Navigator.pushReplacementNamed(context, EsriPage.route);
//          },
//        ),
//        ListTile(
//          title: const Text('Polylines'),
//          selected: currentRoute == PolylinePage.route,
//          onTap: () {
//            Navigator.pushReplacementNamed(context, PolylinePage.route);
//          },
//        ),
//        ListTile(
//          title: const Text('MapController'),
//          selected: currentRoute == MapControllerPage.route,
//          onTap: () {
//            Navigator.pushReplacementNamed(context, MapControllerPage.route);
//          },
//        ),
//        ListTile(
//          title: const Text('Animated MapController'),
//          selected: currentRoute == AnimatedMapControllerPage.route,
//          onTap: () {
//            Navigator.pushReplacementNamed(
//                context, AnimatedMapControllerPage.route);
//          },
//        ),
//        ListTile(
//          title: const Text('Marker Anchors'),
//          selected: currentRoute == MarkerAnchorPage.route,
//          onTap: () {
//            Navigator.pushReplacementNamed(context, MarkerAnchorPage.route);
//          },
//        ),
//        ListTile(
//          title: const Text('Plugins'),
//          selected: currentRoute == PluginPage.route,
//          onTap: () {
//            Navigator.pushReplacementNamed(context, PluginPage.route);
//          },
//        ),
//        ListTile(
//          title: const Text('ScaleBar Plugins'),
//          selected: currentRoute == PluginScaleBar.route,
//          onTap: () {
//            Navigator.pushReplacementNamed(context, PluginScaleBar.route);
//          },
//        ),
//        ListTile(
//          title: const Text('ZoomButtons Plugins'),
//          selected: currentRoute == PluginZoomButtons.route,
//          onTap: () {
//            Navigator.pushReplacementNamed(context, PluginZoomButtons.route);
//          },
//        ),
//        ListTile(
//          title: const Text('Offline Map'),
//          selected: currentRoute == OfflineMapPage.route,
//          onTap: () {
//            Navigator.pushReplacementNamed(context, OfflineMapPage.route);
//          },
//        ),
//        ListTile(
//          title: const Text('Offline Map (using MBTiles)'),
//          selected: currentRoute == OfflineMBTilesMapPage.route,
//          onTap: () {
//            Navigator.pushReplacementNamed(
//                context, OfflineMBTilesMapPage.route);
//          },
//        ),
//        ListTile(
//          title: const Text('OnTap'),
//          selected: currentRoute == OnTapPage.route,
//          onTap: () {
//            Navigator.pushReplacementNamed(context, OnTapPage.route);
//          },
//        ),
//        ListTile(
//          title: const Text('Moving Markers'),
//          selected: currentRoute == MovingMarkersPage.route,
//          onTap: () {
//            Navigator.pushReplacementNamed(context, MovingMarkersPage.route);
//          },
//        ),
//        ListTile(
//          title: const Text('Circle'),
//          selected: currentRoute == CirclePage.route,
//          onTap: () {
//            Navigator.pushReplacementNamed(context, CirclePage.route);
//          },
//        ),
//        ListTile(
//          title: const Text('Overlay Image'),
//          selected: currentRoute == OverlayImagePage.route,
//          onTap: () {
//            Navigator.pushReplacementNamed(context, OverlayImagePage.route);
//          },
//        ),
      ],
    ),
  );
}