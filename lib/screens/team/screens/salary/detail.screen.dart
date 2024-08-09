import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/models/hrms/salary/salary-decrease-detail.dart';
import 'package:nandrlon/models/hrms/salary/salary-increase-detail.dart';
import 'package:nandrlon/models/hrms/salary/salary-parameters.dart';
import 'package:nandrlon/models/hrms/salary/salary.dart';
import 'package:nandrlon/models/user.model.dart';
import 'package:nandrlon/services/team.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:nandrlon/widgets/loading.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalaryDetailScreen extends StatefulWidget {
  SalaryDetailScreen({
    Key key,
    this.id,
    this.salary,
  }) : super(key: key);

  int id;
  Salary salary;

  @override
  State<SalaryDetailScreen> createState() => _SalaryDetailScreenState();
}

class _SalaryDetailScreenState extends State<SalaryDetailScreen> {
  List<SalaryDecreaseDetail> _salaryDecreaseDetails;
  List<SalaryIncreaseDetail> _salaryIncreaseDetails;
  bool _isLoading = true;

  @override
  void initState() {
    onLoad();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> onLoad() async {
    var result = await TeamService.getEmployeeSalaryDetails(widget.salary.id);

    var salaryDecreaseDetails = result['salaryDecreaseDetails']
        .map<SalaryDecreaseDetail>(
            (json) => SalaryDecreaseDetail.fromJson(json))
        .toList();

    var salaryIncreaseDetails = result['salaryIncreaseDetails']
        .map<SalaryIncreaseDetail>(
            (json) => SalaryIncreaseDetail.fromJson(json))
        .toList();


    setState(() {
      _salaryDecreaseDetails = salaryDecreaseDetails;
      _salaryIncreaseDetails = salaryIncreaseDetails;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "${widget.salary.month} - ${widget.salary.year}",
      ),
      body: _isLoading
          ? LoadingWidget()
          : Container(
              margin: EdgeInsets.only(top: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AttendanceListTile(
                      salary: widget.salary,
                    ),
                    _salaryDecreaseDetails.length == 0
                        ? Container()
                        : DecreaseListTile(
                            salaryDecreaseDetails: _salaryDecreaseDetails,
                          ),
                    _salaryIncreaseDetails.length == 0
                        ? Container()
                        :   IncreaseListTile(
                            salaryIncreaseDetails: _salaryIncreaseDetails,
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
    this.salary,
    this.onPressed,
    this.onTap,
  }) : super(key: key);

  final Salary salary;
  final VoidCallback onPressed;
  GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: EdgeInsets.only(bottom: 10, top: 5),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 15, top: 10, bottom: 10, right: 100),
            child: Text(
              "general".tr(),
              style: TextStyle(
                color: Color(0xff0F1B2D),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.only(left: 15, right: 25, bottom: 10),
            child: Column(
              children: [
                SalaryItem(
                  title: "from_date".tr(),
                  value: salary.startDate.substring(0, 10),
                ),
                SalaryItem(
                  title: "to_date".tr(),
                  value: salary.endDate.substring(0, 10),
                ),
                SalaryItem(
                  title: "basic_salary".tr(),
                  value: numberFormat.format(salary.netSalary),
                ),
                SalaryItem(
                  title: "calculated_salary".tr(),
                  value: numberFormat.format(salary.basicSalary),
                ),
                SalaryItem(
                  title: "sum_earnings".tr(),
                  value: numberFormat.format(salary.totalEarnings),
                  color: Colors.green,
                ),
                SalaryItem(
                  title: "sum_deductions".tr(),
                  value: numberFormat.format(salary.totalDeductions),
                  color: Colors.red,
                ),
                SalaryItem(
                  title: "net_salary".tr(),
                  value: numberFormat.format(salary.totalSalary),
                ),
                SalaryItem(
                  title: "currency".tr(),
                  value: salary.currency,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DecreaseListTile extends StatelessWidget {
  DecreaseListTile({
    Key key,
    this.salaryDecreaseDetails,
    this.onPressed,
    this.onTap,
  }) : super(key: key);

  final List<SalaryDecreaseDetail> salaryDecreaseDetails;
  final VoidCallback onPressed;
  GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: EdgeInsets.only(bottom: 10, top: 5),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 15, top: 10, bottom: 10, right: 10),
            child: Text(
              "Deductions",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.only(left: 15, right: 25, bottom: 10),
            child: Column(
              children: [
                for (var salaryDecreaseDetail in salaryDecreaseDetails)
                  Column(
                    children: [
                      SalaryItem(
                        title: "Type:",
                        value: salaryDecreaseDetail.salaryDecreaseType,
                      ),
                      SalaryItem(
                        title: "Rate:",
                        value: numberFormat.format(salaryDecreaseDetail.rate),
                      ),
                      SalaryItem(
                        title: "Amount:",
                        value: numberFormat.format(salaryDecreaseDetail.amount),
                      ),
                      SalaryItem(
                        title: "Description:",
                        value: salaryDecreaseDetail.description,
                      ),
                    ],
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class IncreaseListTile extends StatelessWidget {
  IncreaseListTile({
    Key key,
    this.salaryIncreaseDetails,
    this.onPressed,
    this.onTap,
  }) : super(key: key);

  final List<SalaryIncreaseDetail> salaryIncreaseDetails;
  final VoidCallback onPressed;
  GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: EdgeInsets.only(bottom: 10, top: 5),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 15, top: 10, bottom: 10, right: 10),
            child: Text(
              "Earnings",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.only(left: 15, right: 25, bottom: 10),
            child: Column(
              children: [
                for (var salaryIncreaseDetail in salaryIncreaseDetails)
                  Column(
                    children: [
                      SalaryItem(
                        title: "Type:",
                        value: salaryIncreaseDetail.salaryIncreaseType,
                      ),
                      SalaryItem(
                        title: "Rate:",
                        value: numberFormat.format(salaryIncreaseDetail.rate),
                      ),
                      SalaryItem(
                        title: "Amount:",
                        value: numberFormat.format(salaryIncreaseDetail.amount),
                      ),
                      SalaryItem(
                        title: "Description:",
                        value: salaryIncreaseDetail.description,
                      ),
                    ],
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SalaryItem extends StatelessWidget {
  SalaryItem({
    Key key,
    this.title,
    this.value,
    this.color,
  }) : super(key: key);

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: color,
              ),
            )
          ],
        ),
      ],
    );
  }
}
