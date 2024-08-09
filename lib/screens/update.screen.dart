import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({Key key}) : super(key: key);

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  String APP_STORE_URL = 'https://apps.apple.com/us/app/nandrlon/id1589434417';
  String PLAY_STORE_URL =
      'https://play.google.com/store/apps/details?id=com.kardo.nandrlonco';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  getLogo() {
    return box.read('company') == "Nandrlon"
        ? "assets/svg/logo.svg"
        : box.read('company') == "Power Pharma"
            ? "assets/svg/powerpharma.svg"
            : "assets/svg/sarinaz.svg";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () =>
            _launchURL(Platform.isIOS ? APP_STORE_URL : PLAY_STORE_URL),
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width - 30,
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: primaryColor,
          ),
          child: Center(
            child: Text(
              "update".tr(),
              style: TextStyle(
                color: Colors.white,
                  fontSize: context.locale.languageCode == "en" ? 20 : 17,
                  fontWeight: FontWeight.bold,
                  fontFamily: getFontFamily(context),
              ),
            ),
          ),
        ),
      ),
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
              box.read('company'),
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
              width: 350,
              child: Text(
                "update_msg".tr(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                    fontSize: context.locale.languageCode == "en" ? 20 : 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: getFontFamily(context),
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
