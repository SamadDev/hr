import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/models/hrms/leave/leave-parametres.dart';
import 'package:nandrlon/models/hrms/leave/leave-result.model.dart';
import 'package:nandrlon/models/user.model.dart';
import 'package:nandrlon/services/team.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/image.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTeamLeaveScreen extends StatefulWidget {
  const MyTeamLeaveScreen();

  @override
  _MyTeamLeaveScreenState createState() => _MyTeamLeaveScreenState();
}

class _MyTeamLeaveScreenState extends State<MyTeamLeaveScreen> {
  var searchController = TextEditingController();
  var teamParameters = new LeaveParameters();
  String searchQuery = "Search query";
  List<LeaveResult> _leaves;

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> onLoad() async {
    var prefs = await SharedPreferences.getInstance();
    var user = User.fromJson(json.decode(prefs.getString("user")));

    teamParameters.approverId = user.id;

    var leaves = await TeamService.getEmployeeLeaves(teamParameters);
    setState(() {
      _leaves = leaves;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "Leaves",
      ),
      body: ListViewHelper(
        onRefresh: onLoad,
        list: _leaves,
        itemBuilder: (context, index) {
          return LeaveListTile(
            leave: _leaves[index],
          );
        },
      ),
    );
  }
}

class LeaveListTile extends StatelessWidget {
  LeaveListTile({
    Key key,
    this.leave,
    this.onTap,
  }) : super(key: key);

  final LeaveResult leave;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 15,
              top: 0,
              bottom: 10,
              right: 15,
            ),
            margin: EdgeInsets.only(top: 15, bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ImageWidget(
                          imageUrl:
                              "${box.read('api')}/Uploads/HRMS/Employees/${leave.employeeImage}",
                          errorText: leave.employeeName[0],
                          width: 40,
                          height: 40,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        LeaveItem(
                          title: "Employee",
                          value: leave.employeeName,
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
                        color: leave.leaveStatus == "Pending"
                            ? Colors.orange
                            : Colors.red,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        leave.leaveStatus,
                        textAlign: TextAlign.end,
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LeaveItem(
                      title: "Leave Type ",
                      value: leave.leaveType ?? "",
                      iconColor: Colors.red,
                      iconBackgroundColor: Colors.red.shade50,
                      icon: Icons.shopping_bag_outlined,
                    ),
                    LeaveItem(
                      title: "From Date",
                      value: "${leave.startDate.substring(0, 10)}",
                      iconBackgroundColor: Colors.green.shade50,
                      iconColor: Colors.green,
                      icon: Icons.date_range_outlined,
                    ),
                    LeaveItem(
                      title: "To Date",
                      value: "${leave.endDate.substring(0, 10)}",
                      iconBackgroundColor: Colors.green.shade50,
                      iconColor: Colors.green,
                      icon: Icons.date_range_outlined,
                    ),
                  ],
                ),
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

class LeaveItem extends StatelessWidget {
  LeaveItem({
    Key key,
    this.employeeName,
    this.title,
    this.value,
    this.icon,
    this.iconColor,
    this.iconBackgroundColor,
  }) : super(key: key);

  final String employeeName;
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
