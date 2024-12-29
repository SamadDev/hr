import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/models/login.dart';
import 'package:nandrlon/screens/home/home.screen.dart';
import 'package:nandrlon/screens/language.screen.dart';
import 'package:nandrlon/services/employee.service.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/hrms/RequestResult.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var phoneController = new TextEditingController();
  var userNameController = new TextEditingController();
  var passwordController = new TextEditingController();
  var loginRequest = new LoginRequest();
  var requestResult = new RequestResult();
  bool _isUserExists = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  checkPhone() async {
    setState(() {
      _isUserExists = true;
      _isLoading = true;
    });

    loginRequest.userName = userNameController.text;
    loginRequest.password = passwordController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = await EmployeeService.signIn(loginRequest);

    if (result.state == -1) {
      print("result111");
      print(result.state);

      setState(() {
        requestResult = result;
        _isUserExists = false;
        _isLoading = false;
      });
    } else {
      print(result.data);

      // return;

      int id = result.data["user"]["employeeId"];
      String token = result.data["accessToken"];

      dynamic profile = await EmployeeService.getProfile(id);
      print("profile");
      print(profile);

      var dashboard = await EmployeeService.getDashboard(profile.id);
      var team = await EmployeeService.getTeam(profile.id);

      prefs.setString('team', json.encode(team));
      prefs.setString('dashboard', json.encode(dashboard));

      // prefs.setString('user', json.encode(result));
      prefs.setString('user', json.encode(profile));
      prefs.setInt('id', id);
      prefs.setString('token', token);
      box.write('token', token);
      box.write('isLoggedIn', true);
      prefs.setString('phone', phoneController.text);

      setState(() {
        _isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          checkPhone();
        },
        child: Container(
          height: 55,
          margin: EdgeInsets.only(left: 30, right: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xff124993),
          ),
          child: Center(
            child: _isLoading == true
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
        margin: EdgeInsets.only(top: 50),
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 60,
                padding: EdgeInsets.only(
                  right: context.locale.languageCode == "en" ? 0 : 10,
                  left: context.locale.languageCode == "en" ? 10 : 0,
                  top: 2,
                  bottom: 2,
                ),
                child: Center(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LanguageScreen()),
                            (Route<dynamic> route) => false,
                      );
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xff124993),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "sign_in_msg".tr(),
                style: TextStyle(
                  color: Color(0xff29304D),
                  fontFamily: getFontFamily(context),
                  fontSize: context.locale.languageCode == "en" ? 35 : 33,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "please_enter_phone_msg".tr(),
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: getFontFamily(context),
                  color: Color(0xff29304D),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Text(
                "userName".tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: getFontFamily(context),
                  fontSize: context.locale.languageCode == "en" ? 15 : 13,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                controller: userNameController,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "password".tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: getFontFamily(context),
                  fontSize: context.locale.languageCode == "en" ? 15 : 13,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                  controller: passwordController,
                  obscureText:true
              ),
              SizedBox(
                height: 20,
              ),
              requestResult.state == -1
                  ? Center(
                child: Text(
                  requestResult.msg,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: getFontFamily(context),
                    fontSize:
                    context.locale.languageCode == "en" ? 15 : 13,
                    color: Colors.red,
                  ),
                ),
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  CustomTextField({Key key, this.hintText, this.controller, this.obscureText = false})
      : super(key: key);

  final String hintText;
  final TextEditingController controller;
  final bool obscureText ;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: controller,
        obscureText: obscureText,
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
