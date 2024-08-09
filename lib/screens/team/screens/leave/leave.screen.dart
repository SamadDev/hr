import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/models/hrms/leave/leave-detail.model.dart';
import 'package:nandrlon/models/hrms/leave/leave-parametres.dart';
import 'package:nandrlon/models/hrms/leave/leave-result.model.dart';
import 'package:nandrlon/models/hrms/leave/leave-type.model.dart';
import 'package:nandrlon/models/hrms/leave/leave-time-type.model.dart';
import 'package:nandrlon/models/hrms/leave/leave-status.model.dart';
import 'package:nandrlon/models/user.model.dart';
import 'package:nandrlon/screens/team/dashboard.screen.dart';
import 'package:nandrlon/screens/team/screens/leave/approval.screen.dart';
import 'package:nandrlon/screens/team/screens/leave/filter.screen.dart';
import 'package:nandrlon/services/team.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/image.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTeamLeaveScreen extends StatefulWidget {
  MyTeamLeaveScreen({
    Key key,
    this.leaveParameters,
  }) : super(key: key);

  LeaveParameters leaveParameters;

  @override
  _MyTeamLeaveScreenState createState() => _MyTeamLeaveScreenState();
}

class _MyTeamLeaveScreenState extends State<MyTeamLeaveScreen> {
  ScrollController _controller;
  var searchController = TextEditingController();
  var _leaveParameters = new LeaveParameters();
  String searchQuery = "Search query";
  List<LeaveResult> _leaves;
  List<LeaveType> _leaveTypes;
  List<LeaveTimeType> _leaveTimeTypes;
  List<LeaveStatus> _leaveStatuses;
  bool _isSearching = false;
  Timer _debounce;

  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  @override
  void initState() {
    _controller = new ScrollController()..addListener(_loadMore);
    super.initState();
    onLoad();
    getLeaves();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> onLoad() async {
    var prefs = await SharedPreferences.getInstance();
    var user = User.fromJson(json.decode(prefs.getString("user")));

    setState(() {
      if (widget.leaveParameters != null) {
        _leaveParameters = widget.leaveParameters;
      }
      _leaveParameters.approverId = user.id;
    });

    final leaves = await getLeaves();

    var leaveFormResult = await TeamService.getLeaveFormResult();

    setState(() {
      _leaves = leaves;

      _leaveTypes = leaveFormResult['leaveTypes']
          .map<LeaveType>((json) => LeaveType.fromJson(json))
          .toList();

      _leaveTimeTypes = leaveFormResult['leaveTimeTypes']
          .map<LeaveTimeType>((json) => LeaveTimeType.fromJson(json))
          .toList();

      _leaveStatuses = leaveFormResult['leaveStatuses']
          .map<LeaveStatus>((json) => LeaveStatus.fromJson(json))
          .toList();
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _leaveParameters.pageNumber += 1; // Increase _page by 1

      final employees = await getLeaves();

      final fetchedPosts = employees;
      if (fetchedPosts.length > 0) {
        setState(() {
          _leaves.addAll(fetchedPosts);
        });
      } else {
        setState(() {
          _hasNextPage = false;
        });
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    final leaves = await getLeaves();
    setState(() {
      _leaves = leaves;
    });

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  Future<List<LeaveResult>> getLeaves() async {
    return await TeamService.getLeavesApprovals(_leaveParameters);
  }

  showLeaveDetail(LeaveDetail leaveResult) {
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
                        "${box.read('api')}/Uploads/HRMS/Employees/${leaveResult.employeeImage}",
                    errorText: leaveResult.employeeName[0],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  leaveResult.employeeName,
                  style: TextStyle(
                    color: Color(0xff29304D),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                LeaveDetailListTile(
                  icon: Icons.location_city_outlined,
                  subtitle: leaveResult.leaveType,
                  title: "leave_type",
                ),
                LeaveDetailListTile(
                  icon: Icons.schema_outlined,
                  subtitle:
                      "${numberFormat.format(leaveResult.duration)}/${leaveResult.leaveTimeType}",
                  title: "duration",
                ),
                LeaveDetailListTile(
                  icon: Icons.date_range,
                  subtitle: leaveResult.startDate.split(" ")[0],
                  title: "start_date",
                ),
                LeaveDetailListTile(
                  icon: Icons.date_range,
                  subtitle: leaveResult.endDate.split(" ")[0],
                  title: "end_ate",
                ),
                Row(
                  children: [
                    Container(
                      height: 60,
                      margin:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          "approve".tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: getFontFamily(context),
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 60,
                      margin:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          "reject".tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: getFontFamily(context),
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "leave".tr(),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TeamDashboardScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_alt_outlined,
              color: Colors.white,
            ),
            onPressed: () async {
              var leaveParameters = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LeaveFilterScreen(
                    leaveParameters: _leaveParameters,
                    leaveTypes: _leaveTypes,
                    leaveTimeTypes: _leaveTimeTypes,
                    leaveStatuses: _leaveStatuses,
                  ),
                ),
              );

              if (leaveParameters != null) {
                setState(() {
                  _leaves = null;
                  _leaveParameters = leaveParameters;
                });

                getLeaves();
              }
            },
          ),
        ],
      ),
      body: ListViewHelper(
        onRefresh: onLoad,
        list: _leaves,
        controller: _controller,
        itemBuilder: (context, index) {
          return LeaveListTile(
            leave: _leaves[index],
            onTap: () async {
              // var leaveDetail =
              //     await TeamService.GetEmployeeLeaveResult(_leaves[index].id);
              // // showLeaveDetail(d);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ApprovalLeaveScreen(
                    leaveId: _leaves[index].id,
                  ),
                ),
              );
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
  }) : super(key: key);

  final LeaveResult leave;
  final GestureTapCallback onTap;

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
                          Column(
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
                              SizedBox(
                                height: leave.branch == null ? 0 : 5,
                              ),
                              leave.branch == null
                                  ? Container()
                                  : Text(
                                      leave.branch ?? "",
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
                          color: leave.leaveStatus == "Pending"
                              ? Colors.orange
                              : leave.leaveStatus == "Approved"
                                  ? Colors.green
                                  : Colors.red,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          leave.leaveStatus.toLowerCase().tr(),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontFamily: getFontFamily(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LeaveItem(
                        title: "leave_type".tr(),
                        value: leave.leaveType ?? "",
                        iconColor: Colors.red,
                        iconBackgroundColor: Colors.red.shade50,
                        icon: Icons.shopping_bag_outlined,
                      ),
                      LeaveItem(
                        title: "duration".tr(),
                        value:
                            '${numberFormat.format(leave.duration)} ${leave.leaveTimeType}',
                        iconColor: Colors.red,
                        iconBackgroundColor: Colors.red.shade50,
                        icon: Icons.shopping_bag_outlined,
                      ),
                      LeaveItem(
                        title: "from_date".tr(),
                        value: "${leave.startDate.substring(0, 10)}",
                        iconBackgroundColor: Colors.green.shade50,
                        iconColor: Colors.green,
                        icon: Icons.date_range_outlined,
                      ),
                      LeaveItem(
                        title: "to_date".tr(),
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

class LeaveDetailListTile extends StatelessWidget {
  LeaveDetailListTile({
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
            margin: EdgeInsets.only(top: 10, left: 0),
            child: new Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
          ),
          title: new Text(
            title.tr(),
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
