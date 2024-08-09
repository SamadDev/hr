import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/models/hrms/leave/leave-parametres.dart';
import 'package:nandrlon/models/hrms/leave/leave-result.model.dart';
import 'package:nandrlon/models/hrms/leave/leave-status.model.dart';
import 'package:nandrlon/models/hrms/leave/leave-time-type.model.dart';
import 'package:nandrlon/models/hrms/leave/leave-type.model.dart';
import 'package:nandrlon/models/user.model.dart';
import 'package:nandrlon/screens/leave/filter.screen.dart';
import 'package:nandrlon/screens/leave/form.screen.dart';
import 'package:nandrlon/services/team.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({Key key}) : super(key: key);

  @override
  _LeaveScreenState createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  var _leaveParameters = new LeaveParameters();
  var searchController = TextEditingController();
  String searchQuery = "Search query";
  List<LeaveResult> _leaves;
  List<LeaveType> _leaveTypes;
  List<LeaveType> _leaveTypesByEmployee;
  List<LeaveTimeType> _leaveTimeTypes;
  List<LeaveStatus> _leaveStatuses;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    onLoad();
    getAll();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getLeaveTypesByEmployee() {}

  Future<void> onLoad() async {
    var leaveFormResult = await TeamService.getLeaveFormResult();

    setState(() {

      _leaveTimeTypes = leaveFormResult['leaveTimeTypes']
          .map<LeaveTimeType>((json) => LeaveTimeType.fromJson(json))
          .toList();

      _leaveTypes = leaveFormResult['leaveTypes']
          .map<LeaveType>((json) => LeaveType.fromJson(json))
          .toList();

      _leaveStatuses = leaveFormResult['leaveStatuses']
          .map<LeaveStatus>((json) => LeaveStatus.fromJson(json))
          .toList();
    });
  }

  Future<void> getAll() async {
    var prefs = await SharedPreferences.getInstance();
    var user = User.fromJson(json.decode(prefs.getString("user")));
    _leaveParameters.employeeId = user.id;

    var leaves = await TeamService.getEmployeeLeaves(_leaveParameters);
    var leaveTypes = await TeamService.getLeaveTypesByEmployee(user.id);

    setState(() {
      _leaves = leaves;
      _leaveTypesByEmployee = leaveTypes;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "leave_requests".tr(),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, "/home"),
        ),
        actions: [
          _isLoading == true
              ? SizedBox()
              : IconButton(
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

                      getAll();
                    }
                  },
                ),
        ],
      ),
      floatingActionButton: _isLoading == true
          ? SizedBox()
          : FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.add),
              onPressed: () async {
                var customer = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LeaveFormScreen(
                      leaveTypes: _leaveTypesByEmployee,
                      leaveTimeTypes: _leaveTimeTypes,
                      leaveStatuses: _leaveStatuses,
                    ),
                  ),
                );

                if (customer != null) {
                  // await getCustomer();
                }
              },
            ),
      body: _leaves == null
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : RefreshIndicator(
        onRefresh: getAll,
        child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 100,
                      child: ListView.builder(
                          itemCount: _leaveTypesByEmployee == null ? 0 : _leaveTypesByEmployee.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return ConstrainedBox(
                              constraints: new BoxConstraints(
                                minWidth: 150,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    right: index == 0
                                        ? isLTR(context)
                                            ? 10
                                            : 15
                                        : 10,
                                    left: index == 0
                                        ? (isLTR(context) ? 15 : 0)
                                        : (_leaveTypesByEmployee.length - 1 == index
                                            ? 15
                                            : 0)),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          numberFormat.format(
                                              _leaveTypesByEmployee[index].balance / 8),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(
                                              int.parse(
                                                "0xff" +
                                                    _leaveTypesByEmployee[index]
                                                        .leaveTypeColor
                                                        .replaceAll("#", ""),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          " / " + "day".tr(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: getFontFamily(context),
                                            color: Color(int.parse("0xff" +
                                                _leaveTypesByEmployee[index]
                                                    .leaveTypeColor
                                                    .replaceAll("#", ""))),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      _leaveTypesByEmployee[index].leaveType,
                                      style: TextStyle(
                                        fontSize: isLTR(context) ? 15 : 13,
                                        fontFamily: getFontFamily(context),
                                        color: Color(int.parse("0xff" +
                                            _leaveTypesByEmployee[index]
                                                .leaveTypeColor
                                                .replaceAll("#", ""))),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: ListViewHelper(
                        physics: NeverScrollableScrollPhysics(),
                        onRefresh: onLoad,
                        list: _leaves,
                        itemBuilder: (context, index) {
                          return LeaveListTile(
                            leave: _leaves[index],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
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
    //

    return CardWidget(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: EdgeInsets.only(bottom: 5, top: 5),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LeaveItem(
                title: "leave_type".tr(),
                value: Text(
                  leave.leaveType ?? "",
                  style: TextStyle(
                    color: Color(0xff0F1B2D),
                    fontWeight: FontWeight.w600,
                    fontSize: isLTR(context) ? 13 : 12,
                    fontFamily: getFontFamily(context),
                  ),
                ),
                iconColor: Colors.red,
                iconBackgroundColor: Colors.red.shade50,
                icon: Icons.account_tree_outlined,
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.fromLTRB(
                    isLTR(context) ? 15 : 25, 6.5, isLTR(context) ? 25 : 15, 8),
                decoration: BoxDecoration(
                  color: leave.leaveStatus.toLowerCase() == "pending"
                      ? Colors.orange
                      : leave.leaveStatus == "Approved"
                          ? Colors.green
                          : Colors.red,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isLTR(context) ? 25 : 0),
                    bottomLeft: Radius.circular(isLTR(context) ? 25 : 0),
                    topRight: Radius.circular(isLTR(context) ? 0 : 25),
                    bottomRight: Radius.circular(isLTR(context) ? 0 : 25),
                  ),
                ),
                child: Text(
                  leave.leaveStatus.toLowerCase().tr(),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isLTR(context)
                        ? 12
                        : 11,
                    fontFamily: getFontFamily(context),
                  ),
                ),
              ),
            ],
          ),
          LeaveItem(
            title: "duration".tr(),
            value: Text(
              "${numberFormat.format(leave.duration)} ${leave.leaveTimeType}",
              style: TextStyle(
                color: Color(0xff0F1B2D),
                fontWeight: FontWeight.w600,
                fontFamily: getFontFamily(context),
                fontSize: isLTR(context) ? 13 : 12,
              ),
            ),
            iconBackgroundColor: Colors.green.shade50,
            iconColor: Colors.green,
            icon: Icons.schedule_outlined,
          ),
          LeaveItem(
            title: "date".tr(),
            value: leave.leaveTimeType == "day"
                ? Row(
                    children: [
                      Text(
                        leave.startDate.substring(0, 10),
                        style: TextStyle(
                          color: Color(0xff0F1B2D),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        " to ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        leave.endDate.substring(0, 10),
                        style: TextStyle(
                          color: Color(0xff0F1B2D),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  )
                : Text(
                    leave.leaveTimeType == "Day"
                        ? "${leave.startDate.substring(0, 10)} to ${leave.endDate.substring(0, 10)}"
                        : "${leave.startDate.substring(0, 10)}",
                    style: TextStyle(
                      color: Color(0xff0F1B2D),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
            iconBackgroundColor: Colors.orange.shade50,
            iconColor: Colors.orange,
            icon: Icons.date_range_outlined,
          ),
        ],
      ),
    );
  }
}

class LeaveItem extends StatelessWidget {
  LeaveItem({
    Key key,
    this.title,
    this.value,
    this.icon,
    this.iconColor,
    this.iconBackgroundColor,
  }) : super(key: key);

  final String title;
  final Widget value;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  color: Colors.grey,
                  fontSize: 14,
                  fontFamily: getFontFamily(context),
                ),
              ),
              SizedBox(
                height: 3,
              ),
              value,
            ],
          ),
        ],
      ),
    );
  }
}
