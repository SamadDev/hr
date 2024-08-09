import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/models/hrms/salary/salary-parameters.dart';
import 'package:nandrlon/models/hrms/salary/salary.dart';
import 'package:nandrlon/models/user.model.dart';
import 'package:nandrlon/screens/salary/detail.screen.dart';
import 'package:nandrlon/services/team.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalaryScreen extends StatefulWidget {
  SalaryScreen({Key key}) : super(key: key);

  @override
  State<SalaryScreen> createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {
  var _salaryParameters = new SalaryParameters();
  var searchController = TextEditingController();
  String searchQuery = "Search query";
  List<Salary> _salaries;

  @override
  void initState() {
    _salaryParameters.year = 2022;

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

    _salaryParameters.employeeId = user.id;

    var result = await TeamService.getSalaries(_salaryParameters);

    var salaries = result['employeeSalaries']
        .map<Salary>((json) => Salary.fromJson(json))
        .toList();

    setState(() {
      _salaries = salaries;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "salaries_list".tr(),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: ListViewHelper(
          onRefresh: onLoad,
          list: _salaries,
          itemBuilder: (context, index) {
            return AttendanceListTile(
              salary: _salaries[index],
              onTap: () {
                setState(() {
                  _salaries[index].checked = !_salaries[index].checked;
                });
              },
            );
          },
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
          InkWell(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.only(left: 15, top: 5, bottom: 0, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${salary.month} - ${salary.year}",
                        style: TextStyle(
                          color: Color(0xff0F1B2D),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: onTap,
                    icon: Icon(
                      salary.checked
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                    ),
                  )
                ],
              ),
            ),
          ),
          salary.checked != true ? Container() : Divider(),
          salary.checked != true
              ? Container()
              : InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SalaryDetailScreen(
                          salary: salary,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 25, right: 25, bottom: 10),
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
                fontSize: context.locale.languageCode == "en"
                    ? 14 : 12,
                fontFamily: getFontFamily(context),
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
