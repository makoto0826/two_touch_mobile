import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:two_touch_mobile/screen/screen.dart';

final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();

// ignore: must_be_immutable
class App extends StatelessWidget {
  bool _isDevelopment;

  App({bool isDevelopment}) {
    _isDevelopment = isDevelopment;

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: _isDevelopment,
      title: 'TwoTouch',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ja', 'JP'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/time_card',
      navigatorObservers: <NavigatorObserver>[
        routeObserver,
      ],
      routes: <String, WidgetBuilder>{
        '/time_card': (BuildContext context) => TimeCardScreen(),
        '/number': (BuildContext context) => NumberScreen(),
        '/time_card/select': (BuildContext context) {
          TimeCardSelectArguments arguments = ModalRoute.of(context).settings.arguments;
          return TimeCardSelectScreen(arguments: arguments);
        },
        '/admin': (BuildContext context) => AdminScreen(),
        '/admin/server': (BuildContext context) => ServerSettingScreen(),
        '/admin/device': (BuildContext context) => DeviceSettingScreen(),
        '/admin/user_list': (BuildContext context) => UserListScreen(),
      },
    );
  }
}
