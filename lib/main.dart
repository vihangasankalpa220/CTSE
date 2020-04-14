import 'package:flutter/material.dart';
import 'package:learn_a_fruit_flutter_app/screens/login.dart';
import 'package:provider/provider.dart';
import 'package:learn_a_fruit_flutter_app/providers/app_provider.dart';
import 'package:learn_a_fruit_flutter_app/screens/splash.dart';
import 'package:learn_a_fruit_flutter_app/util/const.dart';
import 'package:learn_a_fruit_flutter_app/notifier/fruit_notifier.dart';
import 'notifier/auth_notifier.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(
          builder: (context) => AuthNotifier(),
        ),
        ChangeNotifierProvider(
          builder: (context) => FruitNotifier(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (BuildContext context, AppProvider appProvider, Widget child) {
        return MaterialApp(
          key: appProvider.key,
          debugShowCheckedModeBanner: false,
          navigatorKey: appProvider.navigatorKey,
          title: Constants.appName,
          theme: appProvider.theme,
          home://SplashScreen(),
           Consumer<AuthNotifier>(
            builder: (context, notifier, child) {
             return notifier.user != null ? SplashScreen() : Login();
            },
          ),
        );
      },
    );
  }
}