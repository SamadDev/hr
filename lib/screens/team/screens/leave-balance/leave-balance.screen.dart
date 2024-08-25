import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/models/hrms/leave-balance/leave-balance.dart';
import 'package:nandrlon/models/team-parameter.dart';
import 'package:nandrlon/models/user.model.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/services/team.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/image.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveBalanceScreen extends StatefulWidget {
  LeaveBalanceScreen();

  @override
  LleaveBalanceStateScreen createState() => LleaveBalanceStateScreen();
}

class LleaveBalanceStateScreen extends State<LeaveBalanceScreen> {
  List<LeaveBalance> _leaveBalances;
  var _teamParameters = new TeamParameters();

  @override
  void initState() {
    getLeaveBalances();
    super.initState();
  }

  Future<void> getLeaveBalances() async {
    var prefs = await SharedPreferences.getInstance();
    var user = User.fromJson(json.decode(prefs.getString("user")));

    _teamParameters.reportingToId = user.id;

    var leaveBalances = await TeamService.getLeaveBalances(_teamParameters);

    setState(() {
      _leaveBalances = leaveBalances;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "leave_balance".tr(),
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_alt_outlined,
              color: Colors.white,
            ),
            onPressed: () async {},
          ),
        ],
      ),
      body: ListViewHelper(
        onRefresh: getLeaveBalances,
        list: _leaveBalances,
        itemBuilder: (context, index) {
          return LeaveListTile(
            leave: _leaveBalances[index],
            onPressed: () {
              setState(() {
                _leaveBalances[index].showDetail =
                    !(_leaveBalances[index].showDetail ?? false);
              });
            },
            onTap: () {
              setState(() {
                _leaveBalances[index].showDetail =
                    !(_leaveBalances[index].showDetail ?? false);
              });
            },
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
    this.onPressed,
  }) : super(key: key);

  final LeaveBalance leave;
  final GestureTapCallback onTap;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CardWidget(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 15,
                top: 0,
                bottom: 0,
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                leave.employeeName,
                                style: TextStyle(
                                  color: Color(0xff0F1B2D),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                "${leave.department} / ${leave.branch}",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: onPressed,
                        icon: Icon(leave.showDetail == true
                            ? Icons.expand_less_outlined
                            : Icons.expand_more_outlined),
                      ),
                    ],
                  ),
                  leave.showDetail != true
                      ? Container()
                      : Container(
                          margin: EdgeInsets.only(left: 5, top: 20),
                          child: Column(
                            children: [
                              for (var result in leave.result)
                                Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(bottom: 10),
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                                color: Color(int.parse("0xff" +
                                                    result.leaveTypeColor
                                                        .replaceAll("#", "")))),
                                            child: Center(
                                              child: new Text(
                                                result.leaveTypeCode,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                100,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    new Text(
                                                      result.leaveType,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff0F1B2D),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    new Text(
                                                      "${result.leaveIn}" + " / " + "hour".tr(),
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        new Text(
                                                          "${result.leaveOut}",
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        new Text(
                                                          "taken".tr(),
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 30,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        new Text(
                                                          "${result.balance}",
                                                          style: TextStyle(
                                                            color: Colors.green,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        new Text(
                                                          "available".tr(),
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: Divider(
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                )
                            ],
                          ),
                        ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 2,
              color: Colors.grey.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}

class LeaveItem extends StatelessWidget {
  LeaveItem({
    Key key,
    this.employeeName,
    this.value,
    this.icon,
    this.iconColor,
    this.iconBackgroundColor,
  }) : super(key: key);

  final String employeeName;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
