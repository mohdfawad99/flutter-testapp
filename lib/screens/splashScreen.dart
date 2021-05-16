import 'package:flutter/material.dart';
import 'package:splash_app/main.dart';
import 'package:splash_app/screens/setLang.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

Widget selectPage() {
  bool _seen = (sp.getBool('seen') ?? false);
  print('Language is set as ${sp.getString('langValue')}');
  print('OnBoard page visited: ${sp.getBool('seen')}');
  // _seen = false;
  if (_seen) {
    return MyHomePage(title: 'Flutter Demo Home Page');
  } else {
    return SetLang();
  }
}

Widget splashScreen = SplashScreenView(
  navigateRoute: selectPage(),
  duration: 3000,
  imageSize: 200,
  imageSrc: "assets/logo.png",
  text: "EyeMate",
  textType: TextType.NormalText,
  textStyle: TextStyle(
    fontSize: 30.0,
  ),
  backgroundColor: Colors.white,
);
