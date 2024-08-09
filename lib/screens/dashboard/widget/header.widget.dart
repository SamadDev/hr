import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/models/employee-profile.dart';
import 'package:nandrlon/models/user.model.dart';
import 'package:nandrlon/widgets/image.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeaderWidget extends StatelessWidget {
  HeaderWidget({
    Key key,
    this.user,
    this.prefs,
  }) : super(key: key);

  EmployeeProfile user;
  SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        15,0,15,10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "hello".tr(),
                style: TextStyle(
                  color: Color(0xff8A959E),
                    fontSize: context.locale.languageCode == "en" ? 20 : 17,
                    fontWeight: FontWeight.bold,
                  fontFamily: getFontFamily(context),
                ),
              ),
              Row(
                children: [
                  Text(
                    user == null ? "" : context.locale.languageCode == "en" ? user?.fullName?.split(" ")[0]
                    : user?.fullNameKu?.split(" ")[0],
                    style: TextStyle(
                      fontSize: isLTR(context) ? 25 : 23,
                      color: Color(0xff3A3A3A),
                      fontWeight: FontWeight.bold,
                      fontFamily: getFontFamily(context),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    user == null ? "" : context.locale.languageCode == "en" ? user?.fullName?.split(" ")[1]
                        : user?.fullNameKu?.split(" ")[1],
                    style: TextStyle(
                      fontSize: isLTR(context) ? 25 : 23,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: getFontFamily(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
          ImageWidget(
            width: 60,
            height: 60,
            imageUrl:
                "${box.read('api')}/Uploads/HRMS/Employees/${user?.image}",
            errorText: user == null ? "" : (user?.fullName?.split(" ")[0])[0],
            radius: 10,
            errorTextFontSize: 20,
          )
        ],
      ),
    );
  }
}
