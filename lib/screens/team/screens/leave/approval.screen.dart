import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/models/hrms/leave-approval.model.dart';
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

class ApprovalLeaveScreen extends StatefulWidget {
  ApprovalLeaveScreen({
    Key key,
    this.leaveId,
  }) : super(key: key);

  int leaveId;

  @override
  _ApprovalLeaveScreenState createState() => _ApprovalLeaveScreenState();
}

class _ApprovalLeaveScreenState extends State<ApprovalLeaveScreen> {
  var _textFieldController = TextEditingController();
  bool _isRejected = false;
  LeaveDetail _leaveDetail;
  List<LeaveApproval> _leaveApprovalTracks;

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  onLoad() async {
    int leaveId = widget.leaveId;
    // leaveId = 4622;
    var leaveApprovalTracks = await TeamService.getLeaveApprovalTracks(leaveId);

    var leaveDetail = await TeamService.GetEmployeeLeaveResult(leaveId);

    setState(() {
      _leaveDetail = leaveDetail;
      _leaveApprovalTracks = leaveApprovalTracks;
    });
  }

  approveDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("cancel".tr()),
      onPressed: () => Navigator.pop(context),
    );
    Widget continueButton = TextButton(
      child: Text("approve".tr()),
      onPressed: () => onApprove(),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("approve".tr()),
      content: Text("leave_approve_msg"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  rejectDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("cancel".tr()),
      onPressed: () => Navigator.pop(context),
    );
    Widget continueButton = TextButton(
      child: Text(
        "reject".tr(),
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      onPressed: () {
        setState(() {
          _isRejected = true;
        });
        onReject();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("reject".tr()),
      actionsAlignment: MainAxisAlignment.center,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("reject_comment_msg".tr()),
          SizedBox(
            height: 20,
          ),
          TextFieldWidget(
            controller: _textFieldController,
            maxLines: 5,
          ),
          _isRejected && _textFieldController.text.isEmpty
              ? Text(
                  "filed_required".tr(),
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 15,
                  ),
                )
              : Container(),
        ],
      ),
      actions: [
        continueButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  onApprove() async {
    var prefs = await SharedPreferences.getInstance();
    var user = User.fromJson(json.decode(prefs.getString("user")));

    var approvals = {};
    var approval = LeaveApprovalTrack();
    approval.approvalStatusId = 3;
    approval.employeeId = user.id;
    approval.description = "";
    approvals['approvalTrack'] = approval;

    var leaves = await TeamService.applyEmployeeLeaveApproval(
      _leaveDetail.id,
      _textFieldController.text,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => MyTeamLeaveScreen(),
      ),
    );
  }

  onApprove1() async {
    var prefs = await SharedPreferences.getInstance();
    var user = User.fromJson(json.decode(prefs.getString("user")));

    var approvals = {};
    var approval = LeaveApprovalTrack();
    approval.approvalStatusId = 3;
    approval.employeeId = user.id;
    approval.description = "";
    approvals['approvalTrack'] = approval;

    var leaves = await TeamService.applyEmployeeLeaveApproval(
      _leaveDetail.id,
      null,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => MyTeamLeaveScreen(),
      ),
    );
  }

  onReject() async {
    if (_textFieldController.text.isEmpty) {
      return;
    }

    await TeamService.applyEmployeeLeaveReject(
      _leaveDetail.id,
      _textFieldController.text,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => MyTeamLeaveScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      bottomSheet: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            InkWell(
              onTap: () => approveDialog(context),
              child: Container(
                width: (MediaQuery.of(context).size.width / 2) - 20,
                height: 60,
                margin: EdgeInsets.symmetric(vertical: 30),
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
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: (MediaQuery.of(context).size.width / 2) - 20,
              height: 60,
              margin: EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Center(
                child: InkWell(
                  onTap: () => rejectDialog(context),
                  child: Text(
                    "reject".tr(),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBarWidget(
        title: "leave_approval".tr(),
      ),
      body: _leaveDetail == null
          ? LoadingWidget()
          : Column(
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
                        "${box.read('api')}/Uploads/HRMS/Employees/${_leaveDetail.employeeImage}",
                    errorText: _leaveDetail.employeeName[0],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  _leaveDetail.employeeName,
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
                  subtitle: _leaveDetail.leaveType,
                  title: "type".tr(),
                ),
                LeaveDetailListTile(
                  icon: Icons.schema_outlined,
                  subtitle:
                      "${numberFormat.format(_leaveDetail.duration)}/${_leaveDetail.leaveTimeType}",
                  title: "duration".tr(),
                ),
                LeaveDetailListTile(
                  icon: Icons.date_range,
                  subtitle: _leaveDetail.startDate.split(" ")[0],
                  title: "start_date".tr(),
                ),
                LeaveDetailListTile(
                  icon: Icons.date_range,
                  subtitle: _leaveDetail.endDate.split(" ")[0],
                  title: "end_date".tr(),
                ),
                Container(

                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                  color: primaryColor,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "approval".tr(),
                    textAlign : TextAlign.left,
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
                Divider(height: 0,),
                Container(
                  child: Column(
                    children: [
                      if (_leaveApprovalTracks != null)
                        for (var leaveApprovalTrack in _leaveApprovalTracks)
                          EmployeeListTile(
                            leaveApproval: leaveApprovalTrack,
                          )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class EmployeeListTile extends StatelessWidget {
  EmployeeListTile({
    Key key,
    this.leaveApproval,
    this.api,
    this.onTap,
  }) : super(key: key);

  final LeaveApproval leaveApproval;
  final String api;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                ImageWidget(
                  imageUrl:
                      "$api/Uploads/HRMS/Employees/${leaveApproval.employeePhoto}",
                  errorText: leaveApproval.employeeName[0],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 85,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.locale.languageCode == "en"
                                ? leaveApproval.employeeName
                                : leaveApproval.employeeName,
                            style: TextStyle(
                              color: Color(0xff24272A),
                              fontWeight: FontWeight.bold,
                              fontFamily: getFontFamily(context),
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            leaveApproval.date,
                            style: TextStyle(
                              color: Color(0xff24272A),
                              fontFamily: getFontFamily(context),
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: leaveApproval.jobTitle == null ? 0 : 5,
                    ),
                    Container(

                      width: MediaQuery.of(context).size.width- 85,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Text(
                            leaveApproval.jobTitle ?? "",
                            style: TextStyle(
                              color: Color(0xff62656B),
                              fontSize: 12,
                            ),
                          ),
                           Text(
                            leaveApproval.status ?? "",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: leaveApproval.statusClass == "success" ? Colors.green : Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ],
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
