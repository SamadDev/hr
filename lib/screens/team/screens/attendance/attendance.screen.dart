import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/helper/formatter.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/models/attendance.model.dart';
import 'package:nandrlon/models/hrms/attendance/attendance-parameter.dart';
import 'package:nandrlon/models/hrms/attendance/attendance-status.model.dart';
import 'package:nandrlon/models/user.model.dart';
import 'package:nandrlon/screens/team/screens/attendance/filter.screen.dart';
import 'package:nandrlon/services/team.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/image.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen();

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  var searchController = TextEditingController();
  String searchQuery = "Search query";
  List<Attendance> _attendances;
  List<AttendanceStatus> _attendanceStatuses;
  var _attendanceParameters = new AttendanceParameters();
  SharedPreferences prefs;

  @override
  void initState() {
    _attendanceParameters.employeeId = 0;
    _attendanceParameters.fromDate = dateFormat.format(DateTime.now());
    _attendanceParameters.toDate = dateFormat.format(DateTime.now());
    _attendanceParameters.sortColumn = "date";
    _attendanceParameters.sortDirection = "desc";
    onLoad();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> onLoad() async {
    prefs = await SharedPreferences.getInstance();
    var user = User.fromJson(json.decode(prefs.getString("user")));

    _attendanceParameters.reportingTo = user.id;

    var result = await TeamService.getAttendance(_attendanceParameters);
    var attendances = result['employeeAttendance']
        .map<Attendance>((json) => Attendance.fromJson(json))
        .toList();

    var attendanceFormResult = await TeamService.getAttendanceFormResult();

    setState(() {
      _attendanceStatuses = attendanceFormResult['statuses']
          .map<AttendanceStatus>((json) => AttendanceStatus.fromJson(json))
          .toList();
    });

    setState(() {
      _attendances = attendances;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "attendance".tr(),
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_alt_outlined,
              color: Colors.white,
            ),
            onPressed: () async {
              var attendanceParameters = (await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendanceFilterScreen(
                    attendanceStatuses: _attendanceStatuses,
                    attendanceParameters: _attendanceParameters,
                  ),
                ),
              )) as AttendanceParameters;

              if (attendanceParameters != null) {
                setState(() {
                  _attendances = null;
                  _attendanceParameters = attendanceParameters;
                });

                onLoad();
              }
            },
          ),
        ],
      ),
      body: ListViewHelper(
        onRefresh: onLoad,
        list: _attendances,
        itemBuilder: (context, index) {
          return AttendanceListTile(
            attendance: _attendances[index],
          );
        },
      ),
    );
  }
}

class AttendanceListTile extends StatelessWidget {
  AttendanceListTile({
    Key key,
    this.attendance,
    this.onTap,
    this.prefs,
  }) : super(key: key);

  final Attendance attendance;
  final GestureTapCallback onTap;
  SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    int color = int.parse("0xff" + attendance.statusColor.substring(1));
    return CardWidget(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 15,
              top: 20,
              bottom: 20,
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                attendance.employeeName,
                                style: TextStyle(
                                  color: Color(0xff0F1B2D),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                attendance.branch,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
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
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AttendanceItem(
                      title: "date".tr(),
                      value: attendance.date.split(" ")[0],
                    ),
                    AttendanceItem(
                      title: "check_in".tr(),
                      value: attendance.firstIn,
                    ),
                    AttendanceItem(
                      title: "check_out".tr(),
                      value: attendance.lastOut,
                    ),
                    AttendanceItem(
                      title: "working".tr(),
                      value: attendance.workingHours,
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
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: getFontFamily(context),
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
