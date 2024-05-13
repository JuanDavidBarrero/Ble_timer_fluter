import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ble_app_timer/pages/home_pages.dart';
import 'package:ble_app_timer/provider/ble_provider.dart';
import 'package:ble_app_timer/provider/dates_provider.dart';
import 'package:ble_app_timer/provider/switch_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BleProvider()),
        ChangeNotifierProvider(create: (context) => DatesProvider()),
        ChangeNotifierProvider(create: (context) => SwitchProvider(),)
      ],
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        initialRoute: 'home',
        routes: {'home': (context) => const HomePage()},
      ),
    );
  }
}
