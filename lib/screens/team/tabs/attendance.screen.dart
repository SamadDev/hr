import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/models/attendance.model.dart';
import 'package:nandrlon/models/hrms/attendance/attendance-parameter.dart';
import 'package:nandrlon/models/user.model.dart';
import 'package:nandrlon/services/team.service.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/image.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key key}) : super(key: key);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  var searchController = TextEditingController();
  String searchQuery = "Search query";
  List<Attendance> _attendances;
  var attendanceParameters = new AttendanceParameters();

  @override
  void initState() {
    onLoad();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> onLoad() async {
    var prefs = await SharedPreferences.getInstance();
    var user = User.fromJson(json.decode(prefs.getString("user")));

    attendanceParameters.reportingTo = user.id;
    attendanceParameters.fromDate = "05/02/2022";
    attendanceParameters.toDate = "05/02/2022";
    var attendances = await TeamService.getAttendance(attendanceParameters);
    setState(() {
      _attendances = attendances;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListViewHelper(
      onRefresh: onLoad,
      list: _attendances,
      itemBuilder: (context, index) {
        return AttendanceListTile(
          attendance: _attendances[index],
        );
      },
    );
  }
}

class AttendanceListTile extends StatelessWidget {
  AttendanceListTile({
    Key key,
    this.attendance,
    this.onTap,
  }) : super(key: key);

  final Attendance attendance;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    int color = int.parse("0xff" + attendance.statusColor.substring(1));
    return CardWidget(
      margin: EdgeInsets.only(top: 15, bottom: 10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 15,
              top: 0,
              bottom: 10,
              right: 15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ImageWidget(
                            imageUrl:
                                "${box.read('api')}/Uploads/HRMS/Employees/${attendance.employeeImage}",
                            errorText: attendance.employeeName[0],
                            width: 40,
                            height: 40,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          AttendanceItem(
                            title: "Employee",
                            value: attendance.employeeName,
                            iconBackgroundColor: Colors.green.shade50,
                            iconColor: Colors.green,
                            icon: Icons.date_range_outlined,
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.fromLTRB(10, 4.5, 10, 6.5),
                        decoration: BoxDecoration(
                          color: Color(color),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          attendance.status,
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AttendanceItem(
                      title: "Day",
                      value: "Sunday",
                      iconBackgroundColor: Colors.orange.shade50,
                      iconColor: Colors.orange,
                      icon: Icons.today_outlined,
                    ),
                    AttendanceItem(
                      title: "Check In",
                      value: attendance.firstIn,
                      iconColor: Colors.red,
                      iconBackgroundColor: Colors.red.shade50,
                      icon: Icons.login_outlined,
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 25),
                      child: AttendanceItem(
                        title: "Check Out",
                        value: attendance.lastOut,
                        iconColor: Colors.red,
                        iconBackgroundColor: Colors.red.shade50,
                        icon: Icons.logout_outlined,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 5,
            color: Colors.grey.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}

class AttendanceItem extends StatelessWidget {
  AttendanceItem({
    Key key,
    this.title,
    this.value,
    this.icon,
    this.iconColor,
    this.iconBackgroundColor,
  }) : super(key: key);

  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          // Row(
          //   children: [
          //     Container(
          //       padding: EdgeInsets.all(8),
          //       decoration: BoxDecoration(
          //         color: iconBackgroundColor,
          //         borderRadius: BorderRadius.circular(50),
          //       ),
          //       child: Icon(
          //         icon,
          //         size: 17,
          //         color: iconColor,
          //       ),
          //     ),
          //   ],
          // ),
          // SizedBox(
          //   width: 15,
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                value,
                style: TextStyle(
                  color: Color(0xff0F1B2D),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
