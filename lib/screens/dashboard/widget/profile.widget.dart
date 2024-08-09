import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/screens/attendance/list.screen.dart';
import 'package:nandrlon/screens/employee/employee.screen.dart';
import 'package:nandrlon/screens/leave/leave.screen.dart';
import 'package:nandrlon/screens/profile/profile.screen.dart';
import 'package:nandrlon/screens/salary/salary.screen.dart';
import 'package:nandrlon/screens/team/dashboard.screen.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "profile".tr(),
            style: TextStyle(
              fontSize: context.locale.languageCode == "en" ? 17 : 15,
              fontFamily: getFontFamily(context),
              fontWeight: FontWeight.w600,
              color: Color(
                0xff29304D,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ProfileButton(
                title: "profile",
                icon: Icons.person_outline,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                },
              ),
              ProfileButton(
                title: "leave",
                icon: Icons.exit_to_app_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LeaveScreen()),
                  );
                },
              ),
              ProfileButton(
                title: "attendance",
                icon: Icons.calendar_today_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AttendanceScreen()),
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ProfileButton(
                title: "salary",
                icon: Icons.money,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SalaryScreen()),
                  );
                },
              ),
              ProfileButton(
                title: "my_team",
                icon: Icons.groups_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TeamDashboardScreen()),
                  );
                },
              ),
              ProfileButton(
                title: "employees",
                icon: Icons.supervised_user_circle_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmployeeScreen()),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  ProfileButton({
    Key key,
    this.title,
    this.icon,
    this.onTap,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        width: (width / 3) - 20,
        height: 115,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 20,
              offset: Offset(0, 10), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                this.title.tr(),
                style: TextStyle(
                  fontSize: context.locale.languageCode == "en" ? 15 : 13,
                  fontFamily: getFontFamily(context),
                  fontWeight: FontWeight.w600,
                  color: Color(0xff3A3A3A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
