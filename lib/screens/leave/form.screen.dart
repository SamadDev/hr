import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/helper/formatter.dart';
import 'package:nandrlon/models/crm/shared/entity-mode.dart';
import 'package:nandrlon/models/employee-filter.model.dart';
import 'package:nandrlon/models/hrms/item-list.dart';
import 'package:nandrlon/models/hrms/leave/leave-parametres.dart';
import 'package:nandrlon/models/hrms/leave/leave-status.model.dart';
import 'package:nandrlon/models/hrms/leave/leave-time-type.model.dart';
import 'package:nandrlon/models/hrms/leave/leave-type.model.dart';
import 'package:nandrlon/models/hrms/leave/leave.mode.dart';
import 'package:nandrlon/models/user.model.dart';
import 'package:nandrlon/screens/leave/leave.screen.dart';
import 'package:nandrlon/services/leave.service.dart';
import 'package:nandrlon/services/team.service.dart';
import 'package:nandrlon/widgets/alert-dialog-widget.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/dropdown.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/loading.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveFormScreen extends StatefulWidget {
  LeaveFormScreen({
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
  _LeaveFormScreenState createState() => _LeaveFormScreenState();
}

class _LeaveFormScreenState extends State<LeaveFormScreen> {
  var searchTextEditingController = TextEditingController();
  List<EmployeeFilter> _employees = [];
  var _employeeLeave = new EmployeeLeave();
  bool _isSubmit = false;
  bool _isLoading = false;
  var formMode = EntityMode.New;

  @override
  void initState() {
    onLoad();
    super.initState();
  }

  void onLoad() {
    setState(() {
      _employeeLeave.startDate = dateFormat.format(DateTime.now());
      _employeeLeave.endDate = dateFormat.format(DateTime.now());
      var leaveTimeType =
          widget.leaveTimeTypes.firstWhere((leaveType) => leaveType.id == 2);
      _employeeLeave.leaveTimeType = leaveTimeType;
      _employeeLeave.leaveTimeTypeId = 2;
    });
  }


  Future<void> _showDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(

          content: Text("You don't have enough balance to submit this request."),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Ok',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                _employeeLeave.delegateeEmployee = _employees[index];
                _employeeLeave.delegateeEmployeeId = _employees[index].id;
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

  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, _) {
          return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: _);
        });

    if (timeOfDay != null) return timeOfDay;
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value),
      ),
    );
  }

  create() async {
    setState(() {
      _isSubmit = true;
      _isLoading = true;
    });

    if (_employeeLeave.leaveType == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    
    

    var prefs = await SharedPreferences.getInstance();
    var user = User.fromJson(json.decode(prefs.getString("user")));
    _employeeLeave.employeeId = user.id;
    _employeeLeave.leaveStatusId = 1;
    _employeeLeave.enableApproval = false;

    _employeeLeave.requestDate = dateFormat.format(DateTime.now());

    if (_employeeLeave.leaveTimeTypeId == 1) {
      _employeeLeave.startDate =
          "${_employeeLeave.startDate.substring(0, 10)} ${_employeeLeave.fromTime.hour}:${_employeeLeave.fromTime.minute}";
      _employeeLeave.endDate =
          "${_employeeLeave.startDate.substring(0, 10)} ${_employeeLeave.toTime.hour}:${_employeeLeave.toTime.minute}";

      _employeeLeave.duration = double.parse((dateFormat
          .parse(
        _employeeLeave.endDate,
      )
          .add(
        Duration(days: 1),
      )
          .difference(
        dateFormat.parse(_employeeLeave.startDate),
      )
          .inDays * 8).toString());

      if (_employeeLeave.duration > _employeeLeave.leaveType.balance) {
        _showDialog(context);
        setState(() {
          _isSubmit = false;
          _isLoading = false;
        });
        return;
      }
    } else {
      _employeeLeave.duration = double.parse((dateFormat
          .parse(
            _employeeLeave.endDate,
          )
          .add(
            Duration(days: 1),
          )
          .difference(
            dateFormat.parse(_employeeLeave.startDate),
          )
          .inDays * 8).toString());

      if (_employeeLeave.duration > _employeeLeave.leaveType.balance) {
        _showDialog(context);
        setState(() {
          _isSubmit = false;
          _isLoading = false;
        });
        return;
      }
    }

    setState(() {
      _isSubmit = false;
      _isLoading = false;
    });


    LeaveService.create(_employeeLeave).then((result) {
      showInSnackBar("Record has been saved successfully");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => LeaveScreen()),
        ModalRoute.withName('/home'),
      );
    }).catchError((err) {
      showInSnackBar("Something error please contact support");
    });

    setState(() {
      _isSubmit = false;
      _isLoading = false;
    });
  }

  update() {
    setState(() {
      _isSubmit = true;
      _isLoading = true;
    });

    LeaveService.update(_employeeLeave).then((value) {
      showInSnackBar("Record has been updated successfully");

      setState(() {
        _isSubmit = false;
        _isLoading = false;
      });
      // Navigator.pop(context, true);
    }).catchError((err) {
      showInSnackBar("Something error please contact support");

      setState(() {
        _isSubmit = false;
      });
    });
  }

  onSubmit() {
    if (formMode == EntityMode.New) {
      create();
    } else {
      update();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "form".tr(),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                searchTextEditingController.clear();
                _employeeLeave = EmployeeLeave();
              });
            },
            icon: Icon(Icons.refresh),
          ),
          _isLoading
              ? Center(
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : IconButton(
                  onPressed: _isLoading ? null : onSubmit,
                  icon: Icon(Icons.check),
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
                    labelText: "type".tr(),
                    isRequired: true,
                    isSubmit: _isSubmit,
                    value: _employeeLeave.leaveType,
                    items: widget.leaveTypes.map((LeaveType leaveType) {
                      return DropdownMenuItem(
                        value: leaveType,
                        child: Row(
                          children: [
                            Text(
                              "${leaveType.leaveType}" ?? "",
                            ),
                            Text(
                              " (${numberFormat.format(leaveType.balance)} / hours)" ??
                                  "",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic leaveType) {
                      setState(() {
                        var itemList = new ItemList();
                        itemList.id = leaveType.id;

                        _employeeLeave.leaveTypeId = leaveType.id;
                        _employeeLeave.leaveType = leaveType;
                      });
                    },
                  ),
                  // GestureDetector(
                  //   onTap: () async {
                  //     var date = await _selectDate(context);
                  //     if (date != null) {
                  //       setState(() {
                  //         _employeeLeave.requestDate = dateFormat.format(date);
                  //       });
                  //     }
                  //   },
                  //   child: TextFieldWidget(
                  //     enabled: false,
                  //     labelText: "Request Date",
                  //     key: Key(_employeeLeave.requestDate),
                  //     initialValue: _employeeLeave.requestDate,
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  DropdownButtonWidget(
                    labelText: "unit".tr(),
                    value: _employeeLeave.leaveTimeType,
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

                        

                        _employeeLeave.leaveTimeTypeId = leaveTimeType.id;
                        _employeeLeave.leaveTimeType = leaveTimeType;
                      });
                    },
                  ),
                  GestureDetector(
                    onTap: () async {
                      var date = await _selectDate(context);
                      if (date != null) {
                        setState(() {
                          _employeeLeave.startDate = dateFormat.format(date);
                        });
                      }
                    },
                    child: TextFieldWidget(
                      enabled: false,
                      labelText: _employeeLeave.leaveTimeTypeId == 1
                          ? "date".tr()
                          : "from_date".tr(),
                      key: Key(_employeeLeave.startDate.substring(0, 10)),
                      initialValue: _employeeLeave.startDate.substring(0, 10),
                    ),
                  ),
                  SizedBox(
                    height: _employeeLeave.leaveTimeTypeId == 1 ? 0 : 10,
                  ),
                  _employeeLeave.leaveTimeTypeId == 1
                      ? Container()
                      : GestureDetector(
                          onTap: () async {
                            var date = await _selectDate(context);
                            if (date != null) {
                              setState(() {
                                _employeeLeave.endDate =
                                    dateFormat.format(date);
                              });
                            }
                          },
                          child: TextFieldWidget(
                            enabled: false,
                            labelText: "to_date".tr(),
                            key: Key(_employeeLeave.endDate),
                            initialValue: _employeeLeave.endDate,
                          ),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      _employeeLeave.leaveTimeTypeId != 1
                          ? Container()
                          : Container(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: GestureDetector(
                                onTap: () async {
                                  var fromTime = await _selectTime(context);
                                  if (fromTime != null) {
                                    setState(() {
                                      _employeeLeave.fromTime = fromTime;
                                      ;
                                    });
                                  }
                                },
                                child: TextFieldWidget(
                                  enabled: false,
                                  labelText: "from_time".tr(),
                                  key: Key(
                                    "${_employeeLeave?.fromTime?.hour}:${_employeeLeave?.fromTime?.minute}",
                                  ),
                                  initialValue: _employeeLeave.fromTime == null
                                      ? ""
                                      : "${_employeeLeave?.fromTime?.hour}:${_employeeLeave?.fromTime?.minute}",
                                ),
                              ),
                            ),
                      SizedBox(
                        width: 10,
                      ),
                      _employeeLeave.leaveTimeTypeId != 1
                          ? Container()
                          : Container(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: GestureDetector(
                                onTap: () async {
                                  var toTime = await _selectTime(context);
                                  if (toTime != null) {
                                    setState(() {
                                      _employeeLeave.toTime = toTime;
                                    });
                                  }
                                },
                                child: TextFieldWidget(
                                  enabled: false,
                                  labelText: "to_time".tr(),
                                  key: Key(
                                    "${_employeeLeave.toTime?.hour}:${_employeeLeave.toTime?.minute}",
                                  ),
                                  initialValue: _employeeLeave.toTime == null
                                      ? ""
                                      : "${_employeeLeave.toTime?.hour}:${_employeeLeave.toTime?.minute}",
                                ),
                              ),
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () => employeeModalBottomSheet(context),
                    child: TextFieldWidget(
                      labelText: "delegate".tr(),
                      isDropdown: true,
                      enabled: false,
                      key: Key(_employeeLeave.delegateeEmployee?.name),
                      isRequired: true,
                      initialValue:
                          _employeeLeave.delegateeEmployee?.name ?? "",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                    labelText: "reason".tr(),
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: 3,
                    initialValue: _employeeLeave.reason,
                    onChanged: (value) {
                      _employeeLeave.reason = value;
                    },
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
