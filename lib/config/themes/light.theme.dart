import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

final box = GetStorage();

const brightness = Brightness.light;

// var primaryColor = Color(box.read('primaryColor') == null
//     ? 0xff124993
//     : int.parse(box.read('primaryColor')));
//const primaryColor = const Color(0xff124993);

//const primaryColor = const Color(0xff4F62C0);
const lightColor = const Color(0xFFFFFFFF);
const backgroundColor = const Color(0xfff2f1f5);
const textColor = const Color(0xff29304D);
const headerTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 16,
);

ThemeData lightTheme(context, String languageCode) {
  return ThemeData(
//    primarySwatch: primaryColor,
    brightness: brightness,
    fontFamily: languageCode == "en" ? "aileron" : "DroidKufi",

    textTheme: GoogleFonts.openSansTextTheme(),
    buttonTheme: new ButtonThemeData(
      buttonColor: Colors.orange,
      textTheme: ButtonTextTheme.primary,
      minWidth: 200,
    ),
    cardTheme: CardTheme(
      elevation: 5,
      color: Colors.red,
    ),
    primaryColor: Color(box.read('primaryColor') == null
        ? 0xff124993
        : int.parse(box.read('primaryColor'))),
    cardColor: Colors.white,
    primaryTextTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.red,
          displayColor: Colors.red,
          fontFamily: "aileron",
        ),
  );
}
