import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/main.dart';
import 'package:nandrlon/screens/authentication/login/login.screen.dart';
import 'package:nandrlon/screens/language.screen.dart';
import 'package:nandrlon/screens/splash/splash.screen.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyScreen extends StatefulWidget {
  CompanyScreen();

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  onLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    messaging.getToken().then((token) async {
      prefs.setString("fcmToken", token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      body: Container(
        margin: EdgeInsets.only(top: 50),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              padding: EdgeInsets.only(
                left: context.locale.languageCode == "en" ? 10 : 0,
                right: context.locale.languageCode == "en" ? 0 : 10,
                top: 2,
                bottom: 2,
              ),
              child: Center(
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LanguageScreen()),
                          (Route<dynamic> route) => false,
                    );
                  },
                  icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColor,),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "select_company".tr(),
              style: TextStyle(
                color: Color(0xff29304D),
                fontFamily: getFontFamily(context),
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 80,
            ),
            CompanyListTile(
              title: "Company 1",
              image: "assets/image/logo.png",
              color: Colors.blue.shade400,
              onTap: () async {
                var prefs = await SharedPreferences.getInstance();
                prefs.setString("api", "http://hr.dottech.co");
                box.write("api", "http://hr.dottech.co");
                // box.write("api", "https://localhost:5001");
                prefs.setInt("primaryColor", 0xff124993);
                prefs.setString("company", "DOTTECH");
                box.write("primaryColor", "0xff124993");
                box.write("company", "DOTTECH");
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
            // Divider(),
            // CompanyListTile(
            //   title: "Company 2",
            //   image: "assets/image/powerpharma.png",
            //   onTap: () async {
            //     var prefs = await SharedPreferences.getInstance();
            //     prefs.setString("api", "https://powerpharma.nandrlonhr.com");
            //     box.write("api", "https://powerpharma.nandrlonhr.com");
            //     prefs.setInt("primaryColor", 0xff017399);
            //     box.write("company", "Power Pharma");
            //     box.write("primaryColor", "0xff017399");
            //     prefs.setString("company", "Power Pharma");
            //     Navigator.pushAndRemoveUntil(
            //       context,
            //       MaterialPageRoute(builder: (context) => LoginScreen()),
            //       (Route<dynamic> route) => false,
            //     );
            //   },
            // ),
            // Divider(),
            // CompanyListTile(
            //   title: "Company 3",
            //   image: "assets/image/sarinaz.png",
            //   onTap: () async {
            //     var prefs = await SharedPreferences.getInstance();
            //     prefs.setString("api", "https://hr.sarinaz.com");
            //     box.write("api", "https://hr.sarinaz.com");
            //     prefs.setInt("primaryColor", 0xff2fa4a2);
            //     box.write("primaryColor", "0xff2fa4a2");
            //     box.write("company", "Sarinaz");
            //     prefs.setString("company", "Sarinaz");
            //     Navigator.pushAndRemoveUntil(
            //       context,
            //       MaterialPageRoute(builder: (context) => LoginScreen()),
            //       (Route<dynamic> route) => false,
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

class CompanyListTile extends StatelessWidget {
  CompanyListTile({
    Key key,
    this.title,
    this.image,
    this.onTap,
    this.color,
  }) : super(key: key);
  final String title;
  final String image;
  final GestureTapCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        contentPadding: EdgeInsets.fromLTRB(
          15,
          10,
          0,
          10,
        ),
        leading: Container(
          padding: EdgeInsets.zero,
          child: Image.asset(
            image,
            color: color,
            height: 50,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontFamily: "aileron",
          ),
        ),
      ),
    );
  }
}
