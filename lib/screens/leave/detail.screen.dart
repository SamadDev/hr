import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/models/hrms/leave/leave-approval-track.model.dart';
import 'package:nandrlon/models/hrms/leave/leave-detail.model.dart';
import 'package:nandrlon/models/user.model.dart';
import 'package:nandrlon/screens/team/screens/leave/leave.screen.dart';
import 'package:nandrlon/services/team.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/image.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/loading.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailLeaveScreen extends StatefulWidget {
  DetailLeaveScreen({
    Key key,
    this.leaveId,
  }) : super(key: key);

  int leaveId;

  @override
  _DetailLeaveScreenState createState() => _DetailLeaveScreenState();
}

class _DetailLeaveScreenState extends State<DetailLeaveScreen> {
  var _textFieldController = TextEditingController();
  bool _isRejected = false;
  LeaveDetail _leaveDetail;

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  onLoad() async {
    var leaveDetail = await TeamService.GetEmployeeLeaveResult(widget.leaveId);

    setState(() {
      _leaveDetail = leaveDetail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "Leave Detail",
      ),
      body: _leaveDetail == null
          ? LoadingWidget()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                LeaveDetailListTile(
                  icon: Icons.location_city_outlined,
                  subtitle: _leaveDetail.leaveType,
                  title: "Leave Type",
                ),
                LeaveDetailListTile(
                  icon: Icons.schema_outlined,
                  subtitle:
                      "${numberFormat.format(_leaveDetail.duration)}/${_leaveDetail.leaveTimeType}",
                  title: "Duration",
                ),
                LeaveDetailListTile(
                  icon: Icons.date_range,
                  subtitle: _leaveDetail.startDate.split(" ")[0],
                  title: "Start Date",
                ),
                LeaveDetailListTile(
                  icon: Icons.date_range,
                  subtitle: _leaveDetail.endDate.split(" ")[0],
                  title: "End Date",
                ),
              ],
            ),
    );
  }
}
