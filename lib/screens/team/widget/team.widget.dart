import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/models/hrms/employee/employee.model.dart';
import 'package:nandrlon/screens/profile/profile.screen.dart';
import 'package:nandrlon/screens/team/tabs/list.screen.dart';
import 'package:nandrlon/screens/team/widget/card.widget.dart';
import 'package:nandrlon/widgets/image.widget.dart';

class TeamWidget extends StatelessWidget {
  TeamWidget({
    Key key,
    this.employees,
  }) : super(key: key);

  final List<Employee> employees;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      title: "direct_reports".tr(),
      titleAction: "see_all".tr(),
      onTapAction: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyTeamListScreen()),
        );
      },
      child: Container(
        height: 110,
        padding: EdgeInsets.only(bottom: 10),
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: employees == null ? 0 : employees.length,
          itemBuilder: (context, index) {
            return TeamButton(
              title: employees[index].firstName,
              titleImage: employees[index].employeeName,
              index: index,
              image:
                  "${box.read('api')}/Uploads/HRMS/Employees/${employees[index].employeeImage}",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      id: employees[index].id,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class TeamButton extends StatelessWidget {
  TeamButton({
    Key key,
    this.title,
    this.titleImage,
    this.image,
    this.onTap,
    this.index,
  }) : super(key: key);

  final String title;
  final String titleImage;
  final String image;
  final GestureTapCallback onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        padding: EdgeInsets.only(left: index == 0 ? 0 : 10, right: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageWidget(
                height: 59,
                width: 59,
                imageUrl: image,
                errorText: this.titleImage[0],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                this.title,
                style: TextStyle(
                  fontFamily: getFontFamily(context),
                  fontSize: context.locale.languageCode == "en" ? 15 : 14,
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
