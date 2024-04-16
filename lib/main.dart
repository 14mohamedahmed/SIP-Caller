import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sip_ua/sip_ua.dart';

import 'src/about.dart';
import 'src/callscreen.dart';
import 'src/dialpad.dart';
import 'src/register.dart';

void main() {
  if (WebRTC.platformIsDesktop) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
  runApp(MyApp());
}

//ws://10.10.0.150:8088/ws
//  105@10.10.0.150:8089
// 105
// mahmed@105
typedef PageContentBuilder = Widget Function(
    [SIPUAHelper? helper, Object? arguments]);

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  final SIPUAHelper _helper = SIPUAHelper();
  Map<String, PageContentBuilder> routes = {
    '/': ([SIPUAHelper? helper, Object? arguments]) => DialPadWidget(helper),
    '/register': ([SIPUAHelper? helper, Object? arguments]) =>
        RegisterWidget(helper),
    '/callscreen': ([SIPUAHelper? helper, Object? arguments]) =>
        CallScreenWidget(
          helper,
          ((arguments as Map<String, dynamic>)['call']) as Call?,
          (arguments)['remote_render'],
          (arguments)['local_render'],
        ),
    '/about': ([SIPUAHelper? helper, Object? arguments]) => AboutWidget(),
  };

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    final String? name = settings.name;
    final PageContentBuilder? pageContentBuilder = routes[name!];
    if (pageContentBuilder != null) {
      if (settings.arguments != null) {
        final Route route = MaterialPageRoute<Widget>(
            builder: (context) =>
                pageContentBuilder(_helper, settings.arguments));
        return route;
      } else {
        final Route route = MaterialPageRoute<Widget>(
            builder: (context) => pageContentBuilder(_helper));
        return route;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.grey),
          contentPadding: EdgeInsets.all(10.0),
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black12)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            textStyle: TextStyle(fontSize: 18),
          ),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: _onGenerateRoute,
    );
  }
}
