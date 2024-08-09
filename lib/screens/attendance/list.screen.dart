import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nandrlon/helper/formatter.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/models/attendance.model.dart';
import 'package:nandrlon/models/hrms/attendance/attendance-parameter.dart';
import 'package:nandrlon/models/hrms/attendance/attendance-status.model.dart';
import 'package:nandrlon/models/hrms/attendance/attendance-summary.model.dart';
import 'package:nandrlon/models/user.model.dart';
import 'package:nandrlon/screens/team/screens/attendance/filter.screen.dart';
import 'package:nandrlon/services/team.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:nandrlon/widgets/loading.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key key}) : super(key: key);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<AttendanceStatus> _attendanceStatuses;
  var _attendanceParameters = new AttendanceParameters();
  var searchController = TextEditingController();
  String searchQuery = "Search query";
  List<Attendance> _attendances;
  List<AttendanceSummary> _attendanceSummaries;

  @override
  void initState() {
    _attendanceParameters.fromDate =
        dateFormat.format(DateTime.now().subtract(Duration(days: 10)));
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
    var prefs = await SharedPreferences.getInstance();
    var user = User.fromJson(json.decode(prefs.getString("user")));

    _attendanceParameters.employeeId = user.id;
    _attendanceParameters.reportingTo = 0;

    var result = await TeamService.getAttendance(_attendanceParameters);

    var attendances = result['employeeAttendance']
        .map<Attendance>((json) => Attendance.fromJson(json))
        .toList();

    var attendanceSummaries = result['summary']
        .map<AttendanceSummary>((json) => AttendanceSummary.fromJson(json))
        .toList();

    var attendanceFormResult = await TeamService.getAttendanceFormResult();

    setState(() {
      _attendanceStatuses = attendanceFormResult['statuses']
          .map<AttendanceStatus>((json) => AttendanceStatus.fromJson(json))
          .toList();
    });

    setState(() {
      _attendanceSummaries = attendanceSummaries;
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
      body: Container(
        margin: EdgeInsets.only(top: 5),
        child: _attendances == null
            ? LoadingWidget()
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 100,
                      child: ListView.builder(
                          itemCount: _attendanceSummaries == null
                              ? 0
                              : _attendanceSummaries.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              width: 100,
                              margin: EdgeInsets.only(
                                  right: index == 0
                                      ? isLTR(context)
                                          ? 10
                                          : 15
                                      : 10,
                                  left: index == 0
                                      ? (isLTR(context) ? 15 : 0)
                                      : 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _attendanceSummaries[index]
                                          .count
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(int.parse("0xff" +
                                            _attendanceSummaries[index]
                                                .statusColor
                                                .replaceAll("#", ""))),
                                      ),
                                    ),
                                    Text(
                                      _attendanceSummaries[index].status,
                                      style: TextStyle(
                                        color: Color(int.parse("0xff" +
                                            _attendanceSummaries[index]
                                                .statusColor
                                                .replaceAll("#", ""))),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListViewHelper(
                      onRefresh: onLoad,
                      physics: NeverScrollableScrollPhysics(),
                      list: _attendances,
                      itemBuilder: (context, index) {
                        return AttendanceListTile(
                          attendance: _attendances[index],
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
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
    var firstIn = DateFormat('HH:mm:ss', 'en_Us').parse(attendance.firstIn);
    var shiftMissIn =
        DateFormat('HH:mm:ss', 'en_Us').parse(attendance.shiftMissIn);
    var lastOut = DateFormat('HH:mm:ss', 'en_Us').parse(attendance.lastOut);
    var shiftMissOut =
        DateFormat('HH:mm:ss', 'en_Us').parse(attendance.shiftMissOut);

    int color = int.parse("0xff" + attendance.statusColor.substring(1));
    return CardWidget(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: EdgeInsets.only(bottom: 10, top: 5),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: isLTR(context) ? 15 : 0,
                    right: isLTR(context) ? 0 : 15,
                    top: 15,
                    bottom: 10),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.date_range_outlined,
                            size: 17,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "date".tr(),
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                            fontFamily: getFontFamily(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              attendance.date.toString().substring(0, 10),
                              style: TextStyle(
                                color: Color(0xff0F1B2D),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              " (${DateFormat("EEEE", 'en_Us').format(DateFormat("dd/MM/yyyy", 'en_Us').parse(attendance.date.toString().substring(0, 10)))})",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.fromLTRB(15, 6.5, 25, 8),
                decoration: BoxDecoration(
                  color: Color(color),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      isLTR(context) ? 25 : 0,
                    ),
                    topRight: Radius.circular(
                      isLTR(context) ? 0 : 25,
                    ),
                    bottomLeft: Radius.circular(
                      isLTR(context) ? 25 : 0,
                    ),
                    bottomRight: Radius.circular(
                      isLTR(context) ? 0 : 25,
                    ),
                  ),
                ),
                child: Text(
                  attendance.status,
                  textAlign: TextAlign.end,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AttendanceItem(
                title: "check_in".tr(),
                value: attendance.firstIn,
                valueColor: shiftMissIn.isAfter(firstIn) ? null : Colors.red,
                iconColor: Colors.red,
                iconBackgroundColor: Colors.red.shade50,
                icon: Icons.login_outlined,
              ),
              AttendanceItem(
                title: "check_out".tr(),
                valueColor:
                    lastOut != "00:00:00" || shiftMissOut.isBefore(lastOut)
                        ? null
                        : Colors.red,
                value: attendance.lastOut,
                iconColor: Colors.red,
                iconBackgroundColor: Colors.red.shade50,
                icon: Icons.logout_outlined,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AttendanceItem(
                title: "leave".tr(),
                value: attendance.leave,
                iconColor: Colors.red,
                iconBackgroundColor: Colors.red.shade50,
                icon: Icons.transfer_within_a_station_outlined,
              ),
              AttendanceItem(
                title: "working_hours".tr(),
                value: attendance.workingHours,
                iconColor: Colors.red,
                iconBackgroundColor: Colors.red.shade50,
                icon: Icons.timer,
              ),
            ],
          )
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
    this.valueColor,
    this.iconBackgroundColor,
  }) : super(key: key);

  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color valueColor;
  final Color iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width / 2.3),
      padding: EdgeInsets.only(
          left: isLTR(context) ? 15 : 0,
          right: isLTR(context) ? 0 : 15,
          top: 15,
          bottom: 10),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  icon,
                  size: 17,
                  color: iconColor,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  fontFamily: getFontFamily(context),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                value,
                style: TextStyle(
                  color: valueColor == null ? Color(0xff0F1B2D) : valueColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
