import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/main.dart';
import 'package:nandrlon/screens/language.screen.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({
    Key key,
    this.automaticallyImplyLeading,
  }) : super(key: key);

  final bool automaticallyImplyLeading;

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
  }

  String getLanguage() {
    return context.locale.languageCode == "en"
        ? "English"
        : context.locale.languageCode == "ar"
            ? "عربي"
            : "کوردی";
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "setting".tr(),

        leading: widget.automaticallyImplyLeading == false ? SizedBox() : IconButton(
          icon: Icon(Icons.arrow_back_ios,
            color: Colors.white,),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.language_outlined),
              title: Text(
                "language".tr(),
                style: TextStyle(
                  fontFamily: getFontFamily(context),
                ),
              ),
              trailing: Text(getLanguage()),
              onTap: () async {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LanguageScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.code_outlined),
              title: Text(
                "version".tr(),
                style: TextStyle(
                  fontFamily: getFontFamily(context),
                ),
              ),
              trailing: Text("1.0.44"),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                "logout".tr(),
                style: TextStyle(
                  fontFamily: getFontFamily(context),
                ),
              ),
              onTap: () async {
                box.erase();
                var prefs = await SharedPreferences.getInstance();
                prefs.clear();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
