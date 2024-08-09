import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/models/team.model.dart';
import 'package:nandrlon/screens/profile/profile.screen.dart';
import 'package:nandrlon/widgets/image.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeamWidget extends StatelessWidget {
  TeamWidget({
    Key key,
    this.teams,
    this.prefs,
  }) : super(key: key);

  final List<Team> teams;
  SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0xff4F62C0).withOpacity(0.15),
                  spreadRadius: 0,
                  blurRadius: 20,
                  offset: Offset(0, 10), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 8, top: 20,right: 8),
                  child: Text(
                    "team".tr(),
                    style: TextStyle(
                      fontSize: context.locale.languageCode == "en"
                          ? 17 : 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: getFontFamily(context),
                      color: Color(
                        0xff29304D,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: teams == null ? 0 : teams.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: TeamButton(
                          title: teams[index].employeeName.split(" ")[0],
                          image:
                              "${box.read('api')}/Uploads/HRMS/Employees/${teams[index].employeeImage}",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                  id: teams[index].id,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TeamButton extends StatelessWidget {
  TeamButton({
    Key key,
    this.title,
    this.image,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String image;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 124,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageWidget(
                imageUrl: image,
                errorText: this.title[0],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                this.title,
                style: TextStyle(
                  fontSize: context.locale.languageCode == "en"
                      ? 13 : 11,
                  color: Color(0xff3A3A3A),
                  fontFamily: getFontFamily(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
