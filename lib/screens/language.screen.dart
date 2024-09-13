import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:location/location.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/screens/home/home.screen.dart';
import 'package:nandrlon/services/employee.service.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart' as geolocator;

import '../company.dart';
import 'authentication/login/login.screen.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen();

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  bool _isLoading = false;
  String _languageCode = "";

  int _counter = 0;
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  // CollectionReference users = FirebaseFirestore.instance.collection('users');
  LocationData _currentLocation;
  Location location = Location();
  double latitude;
  double longitude;
  String company = "";

  @override
  void initState() {
    onLoad();
    // box.erase();
    super.initState();
  }


  Future<geolocator.Position> _determinePosition() async {
    bool serviceEnabled;
    geolocator.LocationPermission permission;

    serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.denied) {
      permission = await geolocator.Geolocator.requestPermission();
      if (permission == geolocator.LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == geolocator.LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await geolocator.Geolocator.getCurrentPosition();
  }


  onLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // messaging.getToken().then((token) async {
    //   prefs.setString("fcmToken", token);
    // });

    // var settings = await messaging.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );

    String firestoreId = prefs.getString("firestoreId");
    // prefs.setBool("isLogin", false);

    bool isLogin = box.read('isLoggedIn');


    var position = await _determinePosition();

    prefs.setDouble("longitude", position.longitude);
    prefs.setDouble("latitude", position.latitude);
  }

  @override
  void dispose() {
    super.dispose();
  }

  setLanguage(Locale locale) async {
    //

    if (_isLoading == true) return;

    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("languageCode", locale.languageCode);

    context.setLocale(locale);

    var languageCode = context.locale.languageCode;
    languageCode = languageCode == "fa" ? "ku" : languageCode;

    setState(() {
      _languageCode = languageCode;
    });

    box.write('languageCode', languageCode);

    bool isLogin = box.read('isLoggedIn');
    var company = box.read('company');

    var id = prefs.getInt("id");

    if(id != null){
    var team = await EmployeeService.getTeam(id);
    prefs.setString('team', json.encode(team));
    }

    if (id != null)
      await EmployeeService.updateLanguage(id, locale.languageCode)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });

    if (isLogin == true) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route<dynamic> route) => false,
      );
    }
    // else if (company == null) {
    //   Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => CompanyScreen()),
    //     (Route<dynamic> route) => false,
    //   );
    // }
    else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => CompanyScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LanguageButton(
              language: "English",
              onTap: () => setLanguage(Locale('en', 'US')),
              isLoading: _isLoading,
              languageCode: _languageCode,
            ),
            LanguageButton(
              language: "عربي",
              onTap: () => setLanguage(Locale('ar', 'IQ')),
              isLoading: _isLoading,
              languageCode: _languageCode,
            ),
            LanguageButton(
              language: "کوردی",
              onTap: () => setLanguage(Locale('fa', 'IR')),
              isLoading: _isLoading,
              languageCode: _languageCode,
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageButton extends StatelessWidget {
  LanguageButton({
    Key key,
    this.language,
    this.isLoading,
    this.onTap,
    this.languageCode,
  }) : super(key: key);
  String language;
  final GestureTapCallback onTap;
  bool isLoading = false;
  String languageCode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(25, 0, 25, 25),
        height: 55,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(25),
            border:
                Border.all(color: Theme.of(context).primaryColor, width: 1)),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading == true &&
                      ((language == "English" && languageCode == "en") ||
                          (language == "عربي" && languageCode == "ar") ||
                          (language == "کوردی" && languageCode == "ku"))
                  ? Container(
                      width: 15,
                      height: 15,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                width: 10,
              ),
              Text(
                language,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: language == "English" ? "aileron" : "DroidKufi",
                  fontSize: language == "English" ? 18 : 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
