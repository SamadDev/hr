import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/helper/formatter.dart';
import 'package:nandrlon/models/crm/shared/city.dart';
import 'package:nandrlon/models/crm/shared/district.dart';
import 'package:nandrlon/models/employee-filter.model.dart';
import 'package:nandrlon/models/hrms/item-list.dart';
import 'package:nandrlon/models/hrms/leave/leave-parametres.dart';
import 'package:nandrlon/models/hrms/leave/leave-status.model.dart';
import 'package:nandrlon/models/hrms/leave/leave-time-type.model.dart';
import 'package:nandrlon/models/hrms/leave/leave-type.model.dart';
import 'package:nandrlon/models/user.model.dart';
import 'package:nandrlon/services/team.service.dart';
import 'package:nandrlon/widgets/alert-dialog-widget.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/dropdown.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveFilterScreen extends StatefulWidget {
  LeaveFilterScreen({
    Key key,
    this.leaveTypes,
    this.leaveTimeTypes,
    this.leaveStatuses,
    this.leaveParameters,
  }) : super(key: key);

  List<LeaveType> leaveTypes;
  List<LeaveTimeType> leaveTimeTypes;
  List<LeaveStatus> leaveStatuses;
  LeaveParameters leaveParameters;

  @override
  _LeaveFilterScreenState createState() => _LeaveFilterScreenState();
}

class _LeaveFilterScreenState extends State<LeaveFilterScreen> {
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
                widget.leaveParameters.employee = _employees[index];
                widget.leaveParameters.employeeId = _employees[index].id;
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
                widget.leaveParameters = LeaveParameters();
              });
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                Navigator.pop(context, widget.leaveParameters);
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
                  DropdownButtonWidget(
                    labelText: "leave_type".tr(),
                    value: widget.leaveParameters.leaveType,
                    items: widget.leaveTypes.map((LeaveType leaveType) {
                      return DropdownMenuItem(
                        value: leaveType,
                        child: Text(
                          leaveType.name ?? "",
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic leaveType) {
                      setState(() {
                        var itemList = new ItemList();
                        itemList.id = leaveType.id;

                        widget.leaveParameters.leaveTypes = [];
                        widget.leaveParameters.leaveType = leaveType;
                        widget.leaveParameters.leaveTypes.add(itemList);
                      });
                    },
                  ),
                  DropdownButtonWidget(
                    labelText: "time_type".tr(),
                    value: widget.leaveParameters.leaveTimeType,
                    items: widget.leaveTimeTypes
                        .map((LeaveTimeType leaveTimeType) {
                      return DropdownMenuItem(
                        value: leaveTimeType,
                        child: Text(
                          leaveTimeType.name ?? "",
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic leaveTimeType) {
                      setState(() {
                        var itemList = new ItemList();
                        itemList.id = leaveTimeType.id;

                        widget.leaveParameters.leaveTimeTypes = [];
                        widget.leaveParameters.leaveType = leaveTimeType;
                        widget.leaveParameters.leaveTimeType = leaveTimeType;
                        widget.leaveParameters.leaveTimeTypes.add(itemList);
                      });
                    },
                  ),
                  DropdownButtonWidget(
                    labelText: "leave_status".tr(),
                    value: widget.leaveParameters.leaveStatus,
                    items: widget.leaveStatuses.map((LeaveStatus leaveStatus) {
                      return DropdownMenuItem(
                        value: leaveStatus,
                        child: Text(
                          leaveStatus.name ?? "",
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic leaveStatus) {
                      setState(() {
                        var itemList = new ItemList();
                        itemList.id = leaveStatus.id;

                        widget.leaveParameters.leaveStatuses = [];
                        widget.leaveParameters.leaveStatus = leaveStatus;
                        widget.leaveParameters.leaveStatus = leaveStatus;
                        widget.leaveParameters.leaveStatuses.add(itemList);
                      });
                    },
                  ),
                  GestureDetector(
                    onTap: () async {
                      var date = await _selectDate(context);
                      if (date != null) {
                        setState(() {
                          widget.leaveParameters.startDate =
                              dateFormat.format(date);
                        });
                      }
                    },
                    child: TextFieldWidget(
                      enabled: false,
                      labelText: "from_date".tr(),
                      key: Key(widget.leaveParameters.startDate),
                      initialValue: widget.leaveParameters.startDate,
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
                          widget.leaveParameters.endDate =
                              dateFormat.format(date);
                        });
                      }
                    },
                    child: TextFieldWidget(
                      enabled: false,
                      labelText: "to_date".tr(),
                      key: Key(widget.leaveParameters.endDate),
                      initialValue: widget.leaveParameters.endDate,
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
