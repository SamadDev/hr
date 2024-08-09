import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/models/hrms/item-list.dart';
import 'package:nandrlon/models/hrms/leave/leave-approval-track.model.dart';
import 'package:nandrlon/models/hrms/leave/leave-parametres.dart';
import 'package:nandrlon/models/hrms/leave/leave-result.model.dart';
import 'package:nandrlon/models/user.model.dart';
import 'package:nandrlon/screens/team/screens/leave/leave.screen.dart';
import 'package:nandrlon/screens/team/widget/card.widget.dart';
import 'package:nandrlon/services/team.service.dart';
import 'package:nandrlon/widgets/image.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:nandrlon/widgets/loading.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveWidget extends StatefulWidget {
  LeaveWidget({
    Key key,
    this.leaves,
  }) : super(key: key);
  List<LeaveResult> leaves;

  @override
  _LeaveWidgetState createState() => _LeaveWidgetState();
}

class _LeaveWidgetState extends State<LeaveWidget> {
  var _textFieldController = TextEditingController();
  LeaveResult _leaveResult;
  bool _isRejected = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  approveDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "cancel".tr(),
        style: TextStyle(
          fontFamily: getFontFamily(context),
        ),
      ),
      onPressed: () => _isLoading ? null : Navigator.of(context).pop(),
    );
    Widget continueButton = TextButton(
      child: Text(
        "approve".tr(),
        style: TextStyle(
          fontFamily: getFontFamily(context),
        ),
      ),
      onPressed: () => onApprove(),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "approve".tr(),
        style: TextStyle(
          fontFamily: getFontFamily(context),
        ),
      ),
      content: Text(
        "leave_approve_msg".tr(),
        style: TextStyle(
          fontFamily: getFontFamily(context),
        ),
      ),
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
      child: Text(
        "cancel".tr(),
        style: TextStyle(
          fontFamily: getFontFamily(context),
        ),
      ),
      onPressed: () => Navigator.pop(context),
    );
    Widget continueButton = TextButton(
      child: Text(
        "reject".tr(),
        style: TextStyle(
          fontFamily: getFontFamily(context),
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
      title: Text(
        "reject".tr(),
        style: TextStyle(
          fontFamily: getFontFamily(context),
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "reject_comment_msg".tr(),
            style: TextStyle(
              fontFamily: getFontFamily(context),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFieldWidget(
            controller: _textFieldController,
          ),
          _isRejected && _textFieldController.text.isEmpty
              ? Text(
                  "this_filed_is_required".tr(),
                  style: TextStyle(
                    fontFamily: getFontFamily(context),
                    color: Colors.redAccent,
                    fontSize: 15,
                  ),
                )
              : Container(),
        ],
      ),
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

  onApprove() async {
    Navigator.pop(context);
    if (_isLoading) return;

    setState(() {
      widget.leaves.remove(_leaveResult);
      _isLoading = true;
    });

    TeamService.applyEmployeeLeaveApproval(_leaveResult.id, null).then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  onReject() async {
    Navigator.pop(context);

    if (_isLoading) return;

    if (_textFieldController.text.isEmpty) {
      return;
    }

    Navigator.pop(context);
    setState(() {
      widget.leaves.remove(_leaveResult);
      _isLoading = true;
    });

    TeamService.applyEmployeeLeaveReject(
      _leaveResult.id,
      _textFieldController.text,
    ).then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      title: "requests".tr(),
      titleAction: "see_all".tr(),
      onTapAction: () {
        var itemList = new ItemList();
        itemList.id = 1;

        var leaveParameters = LeaveParameters();
        leaveParameters.leaveStatuses = [itemList];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyTeamLeaveScreen(
              leaveParameters: leaveParameters,
            ),
          ),
        );
      },
      child: Container(
        child: widget.leaves == null
            ? LoadingWidget()
            : Column(
                children: [
                  for (var leave in widget.leaves)
                    LeaveListTile(
                      leave: leave,
                      onApprovePressed: () {
                        setState(() {
                          _leaveResult = leave;
                        });
                        approveDialog(context);
                      },
                      onRejectPressed: () {
                        setState(() {
                          _leaveResult = leave;
                        });
                        rejectDialog(context);
                      },
                    )
                ],
              ),
      ),
    );
  }
}

class LeaveListTile extends StatelessWidget {
  LeaveListTile({
    Key key,
    this.leave,
    this.onApprovePressed,
    this.onRejectPressed,
  }) : super(key: key);

  final LeaveResult leave;

  final VoidCallback onApprovePressed;
  final VoidCallback onRejectPressed;

  @override
  Widget build(BuildContext context) {
    var startDate = DateFormat("MMMM dd", 'en_Us').format(
        new DateFormat("dd/MM/yyyy", 'en_Us')
            .parse(leave.startDate.substring(0, 10)));
    var endDate = DateFormat("MMMM dd yyyy", 'en_Us').format(
        new DateFormat("dd/MM/yyyy", 'en_Us')
            .parse(leave.endDate.substring(0, 10)));

    return Container(
      margin: EdgeInsets.only(
        top: 5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${numberFormat.format(leave.duration)}/${leave.leaveTimeType} - ${leave.leaveType}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: getFontFamily(context),
              color: Color(
                0xff29304D,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "${startDate} - ${endDate}",
            style: TextStyle(
              fontSize: 13,
              fontFamily: getFontFamily(context),
              color: Color(
                0xff29304D,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          fontFamily: getFontFamily(context),
                          color: Color(0xff0F1B2D),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        leave.requestDate.substring(0, 10),
                        style: TextStyle(
                          fontFamily: getFontFamily(context),
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: IconButton(
                      constraints: BoxConstraints(),
                      padding: EdgeInsets.all(5),
                      onPressed: onApprovePressed,
                      icon: Icon(
                        Icons.done,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: IconButton(
                      constraints: BoxConstraints(),
                      padding: EdgeInsets.all(5),
                      onPressed: onRejectPressed,
                      icon: Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
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
    );
  }
}
