import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/helper/formatter.dart';
import 'package:nandrlon/models/crm/shared/city.dart';
import 'package:nandrlon/models/crm/shared/district.dart';
import 'package:nandrlon/models/employee-filter.model.dart';
import 'package:nandrlon/models/hrms/attendance/attendance-parameter.dart';
import 'package:nandrlon/models/hrms/attendance/attendance-status.model.dart';
import 'package:nandrlon/models/hrms/item-list.dart';
import 'package:nandrlon/models/user.model.dart';
import 'package:nandrlon/services/team.service.dart';
import 'package:nandrlon/widgets/alert-dialog-widget.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/dropdown.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceFilterScreen extends StatefulWidget {
  AttendanceFilterScreen({
    Key key,
    this.attendanceStatuses,
    this.attendanceParameters,
  }) : super(key: key);

  List<AttendanceStatus> attendanceStatuses;
  AttendanceParameters attendanceParameters;

  @override
  _AttendanceFilterScreenState createState() => _AttendanceFilterScreenState();
}

class _AttendanceFilterScreenState extends State<AttendanceFilterScreen> {
  var searchTextEditingController = TextEditingController();
  List<City> _filteredCities = [];
  List<District> _filteredDistricts = [];
  List<EmployeeFilter> _employees = [];

  @override
  void initState() {
    super.initState();
  }

  employeeModalBottomSheet(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
          return AlterDialogWidget(
            items: _employees,
            onTap: (index) {
              setState(() {
                widget.attendanceParameters.employee = _employees[index];
                widget.attendanceParameters.employeeId = _employees[index].id;
              });
              Navigator.pop(context);
            },
            onSearch: (value) async {
              var prefs = await SharedPreferences.getInstance();
              var user = User.fromJson(json.decode(prefs.getString("user")));

              var employees =
                  await TeamService.getEmployeesTeamByName(user.id, value);

              mystate(() {
                _employees = employees;
              });
            },
          );
        });
      },
    );
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.day,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme:
                ColorScheme.light(primary: Theme.of(context).primaryColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );

    if (picked != null) return picked;
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "filter".tr(),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                searchTextEditingController.clear();
                widget.attendanceParameters = AttendanceParameters();
                widget.attendanceParameters.statuses = [];
                widget.attendanceParameters.employeeId = 0;
                widget.attendanceParameters.employee = null;
                widget.attendanceParameters.attendanceStatus = null;
              });
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                Navigator.pop(context, widget.attendanceParameters);
              });
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: CardWidget(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => employeeModalBottomSheet(context),
                    child: TextFieldWidget(
                      labelText: "Employee",
                      isDropdown: true,
                      enabled: false,
                      key: Key(widget.attendanceParameters.employee?.name),
                      isRequired: true,
                      initialValue:
                          widget.attendanceParameters.employee?.name ?? "",
                    ),
                  ),
                  DropdownButtonWidget(
                    labelText: "Status",
                    value: widget.attendanceParameters.attendanceStatus,
                    items: widget.attendanceStatuses
                        .map((AttendanceStatus attendanceStatus) {
                      return DropdownMenuItem(
                        value: attendanceStatus,
                        child: Text(
                          attendanceStatus.name ?? "",
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic attendanceStatus) {
                      setState(() {
                        var itemList = new ItemList();
                        itemList.id = attendanceStatus.id;

                        widget.attendanceParameters.statuses = [];
                        widget.attendanceParameters.statuses.add(itemList);
                      });
                    },
                  ),
                  GestureDetector(
                    onTap: () async {
                      var date = await _selectDate(context);
                      if (date != null) {
                        setState(() {
                          widget.attendanceParameters.fromDate =
                              dateFormat.format(date);
                        });
                      }
                    },
                    child: TextFieldWidget(
                      enabled: false,
                      labelText: "From Date",
                      key: Key(widget.attendanceParameters.fromDate),
                      initialValue: widget.attendanceParameters.fromDate,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      var date = await _selectDate(context);
                      if (date != null) {
                        setState(() {
                          widget.attendanceParameters.toDate =
                              dateFormat.format(date);
                        });
                      }
                    },
                    child: TextFieldWidget(
                      enabled: false,
                      labelText: "To Date",
                      key: Key(widget.attendanceParameters.toDate),
                      initialValue: widget.attendanceParameters.toDate,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
