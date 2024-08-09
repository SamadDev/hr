import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/models/hrms/employee/employee.model.dart';
import 'package:nandrlon/models/team-parameter.dart';
import 'package:nandrlon/models/user.model.dart';
import 'package:nandrlon/services/team.service.dart';
import 'package:nandrlon/widgets/image.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MyTeamListScreen extends StatefulWidget {
  MyTeamListScreen({Key key}) : super(key: key);

  @override
  _MyTeamListScreenState createState() => _MyTeamListScreenState();
}

class _MyTeamListScreenState extends State<MyTeamListScreen> {
  List<Employee> _employees;
  var teamParameters = new TeamParameters();
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  Future<void> onLoad() async {
    prefs = await SharedPreferences.getInstance();
    var user = User.fromJson(json.decode(prefs.getString("user")));

    teamParameters.reportingTo = user.id;
    var employees = await TeamService.getTeam(teamParameters);

    setState(() {
      _employees = employees;
    });
  }

  showProfile(Employee employee) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45),
                    border: Border.all(width: 2, color: Color(0x334F62C0)),
                  ),
                  child: ImageWidget(
                    width: 80,
                    height: 80,
                    imageUrl:
                        "${box.read('api')}/Uploads/HRMS/Employees/${employee.employeeImage}",
                    errorText: employee.employeeName[0],
                    errorTextFontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  employee.employeeName,
                  style: TextStyle(
                    color: Color(0xff29304D),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ContactProfileListTile(
                  icon: Icons.location_city_outlined,
                  subtitle: employee.branch,
                  title: "Branch",
                ),
                ContactProfileListTile(
                  icon: Icons.schema_outlined,
                  subtitle: employee.department,
                  title: "Department",
                ),
                ContactProfileListTile(
                  icon: Icons.badge_outlined,
                  subtitle: employee.jobTitle,
                  title: "Job Title",
                ),
                ContactProfileListTile(
                  icon: Icons.work_outlined,
                  subtitle: employee.jobPosition,
                  title: "Job Position",
                ),
                ContactProfileListTile(
                  icon: Icons.phone_outlined,
                  subtitle: employee.phoneNo,
                  title: "Phone",
                  onTap: () async {
                    if (await canLaunch("tel:+964" + employee.phoneNo)) {
                      await launch("tel:+964" + employee.phoneNo);
                    } else {
                      throw 'call not possible';
                    }
                  },
                ),
                ContactProfileListTile(
                  icon: Icons.email_outlined,
                  subtitle: employee.email,
                  title: "Email",
                  onTap: () async {
                    if (await canLaunch("mailto:" + employee.email)) {
                      await launch("mailto:" + employee.email);
                    } else {
                      throw 'call not possible';
                    }
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ListViewHelper(
      onRefresh: onLoad,
      list: _employees,
      itemBuilder: (context, index) {
        return EmployeeListTile(
            employee: _employees[index],
            onTap: () {
              showProfile(_employees[index]);
            });
      },
    );
  }
}

class EmployeeListTile extends StatelessWidget {
  EmployeeListTile({
    Key key,
    this.employee,
    this.onTap,
    this.prefs,
  }) : super(key: key);

  final Employee employee;
  final GestureTapCallback onTap;
  SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                ImageWidget(
                  imageUrl:
                      "${box.read('api')}/Uploads/HRMS/Employees/${employee.employeeImage}",
                  errorText: employee.employeeName[0],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.employeeName,
                      style: TextStyle(
                        color: Color(0xff24272A),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      employee.phoneNo ?? "",
                      style: TextStyle(
                        color: Color(0xff62656B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
          ),
        ],
      ),
    );
  }
}

class ContactProfileListTile extends StatelessWidget {
  ContactProfileListTile({
    Key key,
    this.title,
    this.subtitle,
    this.icon,
    this.onTap,
  }) : super(key: key);
  final GestureTapCallback onTap;
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            margin: EdgeInsets.only(top: 10, left: 10),
            child: new Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
          ),
          title: new Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
          subtitle: Container(
            padding: EdgeInsets.only(top: 5),
            child: new Text(
              subtitle ?? "",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xff565656),
              ),
            ),
          ),
        ),
        Divider(
          height: 0,
        ),
      ],
    );
  }
}
