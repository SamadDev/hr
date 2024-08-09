import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:location/location.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/main.dart';
import 'package:nandrlon/models/employee-profile.dart';
import 'package:nandrlon/screens/authentication/login/login.screen.dart';
import 'package:nandrlon/screens/home/home.screen.dart';
import 'package:nandrlon/screens/update.screen.dart';
import 'package:nandrlon/services/auth.service.dart';
import 'package:nandrlon/services/employee.service.dart';
import 'package:nandrlon/services/menu.service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dashboard/dashboard.screen.dart';

class SplashScreen extends StatefulWidget {
  const
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _counter = 0;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  LocationData _currentLocation;
  Location location = Location();
  double latitude;
  double longitude;
  String company = "";

  @override
  void initState() {
    onLoad();
    versionCheck(context);
    super.initState();
  }

  versionCheck(context) async {
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // com.kardo.exchange

    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();

    double currentVersion =
    double.parse(info.version.trim().replaceAll(".", ""));

    //Get Latest version info from firebase config
    final FirebaseRemoteConfig remoteConfig = await FirebaseRemoteConfig.instance;
    await remoteConfig.ensureInitialized();

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await remoteConfig.fetchAndActivate();

      remoteConfig.getString(Platform.isIOS ? 'iosVersion' : 'androidVersion');
      double newVersion = double.parse(remoteConfig
          .getString(Platform.isIOS ? 'iosVersion' : 'androidVersion')
          .trim()
          .replaceAll(".", ""));

      print("currentVersion");
      print(currentVersion);
      print(newVersion);

      if (newVersion > currentVersion) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => UpdateScreen(),
          ),
        );
      } else {
        onLoad();
      }
    } on Exception catch (exception) {
      // Fetch throttled.

    } catch (exception) {}
  }

  onLoad() async {
    crmLogin();
    EmployeeProfile employeeProfile;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = prefs.getInt('id');
    bool isLogin = box.read('isLoggedIn');

    if (isLogin != true) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false,
      );
      return;
    }

    if (id != null) {
      var dashboard = await EmployeeService.getDashboard(id);
      var team = await EmployeeService.getTeam(id);
      employeeProfile = await EmployeeService.getProfile(id);
      prefs.setString('user', json.encode(employeeProfile));
      prefs.setString('team', json.encode(team));
      prefs.setString('dashboard', json.encode(dashboard));
    }

    messaging.getToken().then((token) async {
      prefs.setString("fcmToken", token);
      if (employeeProfile != null && employeeProfile.token != token) {
        await EmployeeService.updateToken(id, token);
      }
    });

    setState(() {
      company = prefs.getString("company");
    });

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
          (Route<dynamic> route) => false,
    );

    onLoad1();
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

  crmLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var signIn = {};
    signIn['password'] = "P@ssw0rd";
    signIn['userName'] = "karez@outlook.com";
    var user = await AuthService.signIn(signIn);
    prefs.setString("crmToken", user.data['accessToken']);
    var menus = await MenuService.getMenus(2);
    prefs.setString("menus", json.encode(menus));
  }

  getLoc() async {
    var location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    try {
      var currentLocation = await location
          .getLocation()
          .timeout(Duration(seconds: 5), onTimeout: () {
        setState(() {});
        return null;
      });

      setState(() {
        _currentLocation = currentLocation;
      });

      
    } on PlatformException catch (e) {
      
    }
  }



  onLoad1() async {
    var location = Location();
    // await crmLogin();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String firestoreId = prefs.getString("firestoreId");
    // prefs.setBool("isLogin", false);

    bool isLogin = box.read('isLoggedIn');


    var position = await _determinePosition();

    prefs.setDouble("longitude", position.longitude);
    prefs.setDouble("latitude", position.latitude);

    // location.enableBackgroundMode(enable: true);

    // location.changeSettings(
    //     accuracy: LocationAccuracy.high, interval: 10000, distanceFilter: 5);

    // if (firestoreId != null) {
    //   location.onLocationChanged.listen((LocationData currentLocation) {
    //     String firestoreId = prefs.getString("firestoreId");
    //     if (_currentLocation != null) if (_currentLocation?.latitude !=
    //             currentLocation.latitude &&
    //         _currentLocation?.longitude != currentLocation.longitude) {
    //       users.doc(firestoreId).collection("location").add({
    //         "date": DateTime.now(),
    //         "longitude": currentLocation.longitude,
    //         "latitude": currentLocation.latitude
    //       });

    //       users.doc(firestoreId).update({
    //         "longitude": currentLocation.longitude,
    //         "latitude": currentLocation.latitude
    //       });

    //       setState(() {
    //         _currentLocation = currentLocation;
    //       });
    //     }
    //   });

    //   // Navigator.pushAndRemoveUntil(
    //   //   context,
    //   //   MaterialPageRoute(builder: (context) => HomeScreen()),
    //   //   (Route<dynamic> route) => false,
    //   // );
    // } else {
    //   // Navigator.pushAndRemoveUntil(
    //   //   context,
    //   //   MaterialPageRoute(builder: (context) => LoginScreen()),
    //   //   (Route<dynamic> route) => false,
    //   // );
    // }
  }

  getLogo(){
    return box.read('company') == "Nandrlon"
        ? "assets/svg/logo.svg" : box.read('company') == "Power Pharma"
        ? "assets/svg/powerpharma.svg"
        : "assets/svg/sarinaz.svg";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor, // Color(0xff088DEC),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              getLogo(),
              width: 100,
              placeholderBuilder: (BuildContext context) => Container(
                padding: const EdgeInsets.all(30.0),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              // box.read('company'),
              "DOTTECH",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: 250,
              child: Text(
                "Pharmaceutical Company",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
