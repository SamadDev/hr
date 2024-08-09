import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/models/hrms/employee/employee.model.dart';
import 'package:nandrlon/models/hrms/item-list.dart';
import 'package:nandrlon/models/hrms/leave/leave-parametres.dart';
import 'package:nandrlon/models/hrms/leave/leave-result.model.dart';
import 'package:nandrlon/models/team-parameter.dart';
import 'package:nandrlon/models/user.model.dart';
import 'package:nandrlon/screens/dashboard/dashboard.screen.dart';
import 'package:nandrlon/screens/task/list.screen.dart';
import 'package:nandrlon/screens/team/screens/attendance/attendance.screen.dart';
import 'package:nandrlon/screens/team/screens/leave-balance/leave-balance.screen.dart';
import 'package:nandrlon/screens/team/screens/leave/leave.screen.dart';
import 'package:nandrlon/screens/team/screens/salary/salary.screen.dart';
import 'package:nandrlon/screens/team/screens/task/task.screen.dart';
import 'package:nandrlon/screens/team/tabs/list.screen.dart';
import 'package:nandrlon/screens/team/widget/button.widget.dart';
import 'package:nandrlon/screens/team/widget/leave.widget.dart';
import 'package:nandrlon/screens/team/widget/team.widget.dart';
import 'package:nandrlon/services/team.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/loading.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeamDashboardScreen extends StatefulWidget {
  TeamDashboardScreen({Key key}) : super(key: key);

  @override
  _TeamDashboardScreenState createState() => _TeamDashboardScreenState();
}

class _TeamDashboardScreenState extends State<TeamDashboardScreen> {
  var searchController = TextEditingController();
  var teamParameters = new TeamParameters();
  var leaveParameters = new LeaveParameters();
  String searchQuery = "Search query";
  List<LeaveResult> _leaves;
  List<Employee> _employees;
  User _user;

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  onLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = User.fromJson(json.decode(prefs.getString("user")));

    var itemList = new ItemList();
    itemList.id = 1;

    teamParameters.reportingTo = user.id;
    leaveParameters.approverId = user.id;
    leaveParameters.leaveStatuses = [itemList];

    setState(() {
      _user = user;
    });

    var employees = await TeamService.getTeam(teamParameters);
    var leaves = await TeamService.getLeavesApprovals(leaveParameters);

    setState(() {
      _employees = employees;
      _leaves = leaves;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "my_team".tr(),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pushNamed(context, "/home"),
        ),
      ),
      body: SafeArea(
        child: _leaves == null || _employees == null ? LoadingWidget() : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Container(
                  height: 110,
                  margin: EdgeInsets.only(top: 25, left: 5),
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      DashboardButton(
                        icon: Icons.exit_to_app_outlined,
                        title: "leave".tr(),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyTeamLeaveScreen()),
                          );
                        },
                      ),
                      DashboardButton(
                        icon: Icons.pie_chart_outline_outlined,
                        title: "balance".tr(),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LeaveBalanceScreen()),
                          );
                        },
                      ),
                      DashboardButton(
                        icon: Icons.calendar_today_outlined,
                        title: "attendance".tr(),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AttendanceScreen()),
                          );
                        },
                      ),
                      DashboardButton(
                        icon: Icons.money,
                        title: "salary".tr(),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyTeamSalaryScreen()),
                          );
                        },
                      ),
                      DashboardButton(
                        icon: Icons.task_alt_outlined,
                        title: "tasks".tr(),
                        isLast: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TaskListScreen()),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TeamWidget(
                employees: _employees,
              ),
              SizedBox(
                height: 20,
              ),
              LeaveWidget(
                leaves: _leaves,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
