import 'dart:async';
import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/screens/home/home.screen.dart';
import 'package:nandrlon/services/auth.service.dart';
import 'package:nandrlon/services/employee.service.dart';
import 'package:nandrlon/services/menu.service.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class VerifyScreen extends StatefulWidget {
  VerifyScreen({
    Key key,
    this.phoneNumber,
    this.user,
  }) : super(key: key);

  final String phoneNumber;
  final dynamic user;

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  // CollectionReference users = FirebaseFirestore.instance.collection('users');
  // FirebaseAuth _auth = FirebaseAuth.instance;
  var _codeController = TextEditingController();
  var errorController = StreamController<ErrorAnimationType>();
  String verId;
  String phone;
  bool codeSent = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();

    verifyPhone();
  }

  Future<void> verifyPhone() async {
    // await FirebaseAuth.instance.verifyPhoneNumber(
    //   phoneNumber: "+964" + widget.phoneNumber.substring(1).trim(),
    //   verificationCompleted: (PhoneAuthCredential credential) async {
    //     // await FirebaseAuth.instance.signInWithCredential(credential);
    //     // final snackBar = SnackBar(content: Text("Login Success"));
    //     // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //   },
    //   verificationFailed: (FirebaseAuthException e) {
    //     final snackBar = SnackBar(content: Text("${e.message}"));
    //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //   },
    //   codeSent: (String verficationId, int resendToken) {
    //     setState(() {
    //       codeSent = true;
    //       verId = verficationId;
    //     });
    //   },
    //   codeAutoRetrievalTimeout: (String verificationId) {
    //     setState(() {
    //       verId = verificationId;
    //     });
    //   },
    //   timeout: Duration(seconds: 60),
    // );
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

  Future<void> verifyPin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("id");

    setState(() {
      loading = true;
    });

    try {
      // PhoneAuthCredential credential = PhoneAuthProvider.credential(
      //     verificationId: verId, smsCode: _codeController.text);

      // final User user =
      //     (await FirebaseAuth.instance.signInWithCredential(credential)).user;

      // if (user != null) {
      //   prefs.setBool("isLoggedIn", true);
      //   box.write("isLoggedIn", true);
      //   // var currentLocation = await Geolocator.getCurrentPosition();
      //
      //   // var user = await users
      //   //     .where('id', isEqualTo: widget.user['id'])
      //   //     .snapshots()
      //   //     .first;
      //
      //   // widget.user['latitude'] = currentLocation.latitude;
      //   // widget.user['longitude'] = currentLocation.longitude;
      //
      //   if (user.docs.isEmpty) {
      //     var newUser = await users.add(widget.user);
      //     prefs.setString('firestoreId', newUser.id);
      //   } else {
      //     prefs.setString('firestoreId', user.docs.first.id);
      //     users.doc(user.docs.first.id).set(widget.user);
      //   }
      //   var token = prefs.getString("fcmToken");
      //
      //   if (token != null) {
      //     if (token != null) await EmployeeService.updateToken(id, token);
      //   }
      //
      //   await EmployeeService.updateLanguage(id, context.locale.languageCode);
      //
      //   crmLogin();
      //   Navigator.of(context)
      //       .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      // }
    }  catch (e) {
    // } on FirebaseAuthException catch (e) {
      prefs.setBool("isLogin", false);

      setState(() {
        loading = false;
      });

      final snackBar = SnackBar(content: Text("${e.message}"));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          verifyPin();
        },
        child: Container(
          height: 55,
          margin: EdgeInsets.only(left: 30, right: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(int.parse(box.read('primaryColor'))),
          ),
          child: Center(
            child: loading == true
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    "sign_in".tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: getFontFamily(context),
                      fontSize: context.locale.languageCode == "en" ? 17 : 15,
                    ),
                  ),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 144),
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "verify_account".tr(),
                style: TextStyle(
                  color: Color(0xff29304D),
                  fontWeight: FontWeight.bold,
                  fontFamily: getFontFamily(context),
                  fontSize: context.locale.languageCode == "en" ? 35 : 33,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "enter_code".tr(),
                style: TextStyle(
                  fontFamily: getFontFamily(context),
                  fontSize: context.locale.languageCode == "en" ? 15 : 13,
                  color: Color(0xff29304D),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Directionality(
                textDirection: ui.TextDirection.ltr,
                child: Text(
                  "+964 ${widget.phoneNumber.substring(0, 3) + " " + widget.phoneNumber.substring(3, 6) + " " + widget.phoneNumber.substring(6, widget.phoneNumber.length)}.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(int.parse(box.read('primaryColor'))),
                  ),
                ),
              ),
              SizedBox(
                height: 66,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Directionality(
                  textDirection: ui.TextDirection.ltr,
                  child: PinCodeTextField(
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textStyle: TextStyle(color: Colors.white),
                    length: 6,
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    validator: (v) {
                      if (v.length < 3) {
                        return "";
                      } else {
                        return null;
                      }
                    },
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(15),
                      borderWidth: 0,
                      fieldHeight: 50,
                      fieldWidth: 50,
                      activeFillColor: Color(0xffA5E8F0),
                      activeColor: Colors.white,
                      selectedFillColor: Color(0x33A5E8F0),
                      selectedColor: Color(0xffA5E8F0),
                      inactiveColor: Color(0xffF7F7F7),
                      inactiveFillColor: Color(0xffF7F7F7),
                    ),
                    cursorColor: Color(0xffA5E8F0),
                    animationDuration: Duration(milliseconds: 300),
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    onCompleted: (v) {},
                    onChanged: (value) {
                      setState(() {
                        // currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      return true;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  CustomTextField({Key key, this.hintText}) : super(key: key);

  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        maxLength: 10,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          counterText: "",
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(10, 35, 10, 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          hintStyle: TextStyle(
            color: Color(0x8C323232),
            fontSize: 15,
          ),
          hintText: this.hintText,
          fillColor: Color(0xffF7F7F7),
        ),
        style: TextStyle(
          color: Color(
            0xff323232,
          ),
        ),
      ),
    );
  }
}
