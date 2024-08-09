// import 'dart:async';
// import 'dart:convert';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:location/location.dart';
// import 'package:nandrlon/screens/authentication/login/login.screen.dart';
// import 'package:nandrlon/services/auth.service.dart';
// import 'package:nandrlon/services/employee.service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:nandrlon/widgets/layout.widget.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key key}) : super(key: key);
//
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   CollectionReference users = FirebaseFirestore.instance.collection('users');
//   Location location = new Location();
//   double latitude;
//   double longitude;
//   Position _currentLocation;
//
//   @override
//   void initState() {
//     onLoad();
//
//     super.initState();
//   }
//
//   Future<Position> _determinePosition() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     var currentLocation = await Geolocator.getCurrentPosition();
//
//     setState(() {
//       _currentLocation = currentLocation;
//     });
//
//     prefs.setDouble("longitude", _currentLocation.longitude);
//     prefs.setDouble("latitude", _currentLocation.latitude);
//
//     return currentLocation;
//   }
//
//   onLoad() async {
//
//
//
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     var signIn = {};
//     signIn['password'] = "P@ssw0rd";
//     signIn['userName'] = "karez@outlook.com";
//     var user = await AuthService.signIn(signIn);
//
//     prefs.setString("crmToken", user.data['accessToken']);
//
//
//     if (false == true) {
//
//
//       var currentLocation = await _determinePosition();
//       //
//       // bool isLogin = prefs.getBool("isLogin");
//
//
//       var phone = prefs.getString('phone');
//       dynamic result = await EmployeeService.checkPhone(phone);
//
//       await prefs.setInt('id', result['id']);
//       await prefs.setString('user', json.encode(result));
//
//
//       var user =
//           await users.where('id', isEqualTo: result['id']).snapshots().first;
//
//       if (_currentLocation != null) {
//         result['latitude'] = currentLocation.latitude;
//         result['longitude'] = currentLocation.longitude;
//       }
//
//       location.onLocationChanged.listen((LocationData currentLocation) {
//         if (_currentLocation != null) if (_currentLocation?.latitude !=
//                 currentLocation.latitude &&
//             _currentLocation?.longitude != currentLocation.longitude) {
//
//         }
//
//         String firestoreId = prefs.getString("firestoreId");
//         
//         
//
//         setState(() {
//           //  _currentLocation = currentLocation;
//         });
//
//         users.doc(firestoreId).collection("location").add({
//           "date": DateTime.now(),
//           "longitude": currentLocation.longitude,
//           "latitude": currentLocation.latitude
//         });
//
//         users.doc(user.docs.first.id).set(result);
//       });
//
//       if (user.docs.isEmpty) {
//         var newUser = await users.add(result);
//
//         prefs.setString('firestoreId', newUser.id);
//       } else {
//         prefs.setString('firestoreId', user.docs.first.id);
//         users.doc(user.docs.first.id).set(result);
//       }
//
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//       );
//     } else {
//       Timer(Duration(seconds: 3), () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => LoginScreen()),
//         );
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xff088DEC),
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SvgPicture.asset(
//               "assets/svg/logo.svg",
//               color: Colors.white.withOpacity(0.7),
//               width: 100,
//               placeholderBuilder: (BuildContext context) => Container(
//                   padding: const EdgeInsets.all(30.0),
//                   child: const CircularProgressIndicator(
//                     color: Colors.white,
//                   )),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Text(
//               "Nandrlon",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 35,
//               ),
//             ),
//             SizedBox(
//               height: 15,
//             ),
//             Container(
//               width: 250,
//               child: Text(
//                 "Live Your Best Life, Now And In The Future..",
//                 style: TextStyle(
//                   color: Colors.white.withOpacity(0.8),
//                   fontSize: 18,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
