import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rbdevvisitasapp/misc/theme.dart';
import 'package:rbdevvisitasapp/screens/ui_home.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rbdevvisitasapp/functions/fn_utils.dart';
import 'package:rbdevvisitasapp/routes.dart';
import 'package:rbdevvisitasapp/screens/ui_login.dart';
import 'package:rbdevvisitasapp/functions/fn_business.dart';
import 'package:lottie/lottie.dart';

import 'consts/consts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new VisitaHttpOverrides();
  runApp(AgendeVisitas());
}

class AgendeVisitas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('pt'), // Hebrew
      ],
      title: 'Agende Visita',
      theme: mainSEAP,
      home: StartUpScreen(),
      navigatorKey: navigatorKey,
      routes: appRoutes,
    );
  }
}

class StartUpScreen extends StatefulWidget {
  @override
  _StartUpScreenState createState() => _StartUpScreenState();
}

class _StartUpScreenState extends State<StartUpScreen> {
  var _finished = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: FutureBuilder(
          future: _preFlight().then((value) => _finished = true),
          builder: (context, snapshot) {
            return _finished
                ? new LoginPage()
                : Center(
                    child: Lottie.asset("assets/lottie/visitor-animation.json"),
                  );
          }),
    );
  }

  Future<Widget> _preFlight() async {
    await getConfig();
    packageInfo = await PackageInfo.fromPlatform();
    var preferences = await SharedPreferences.getInstance();
    prefs = new SharedPreferencesHelper(preferences);
    return Future.value(null);
  }
}

class VisitaHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
