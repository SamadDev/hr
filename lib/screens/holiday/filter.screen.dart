import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/helper/formatter.dart';
import 'package:nandrlon/models/crm/shared/city.dart';
import 'package:nandrlon/models/crm/shared/district.dart';
import 'package:nandrlon/models/employee-filter.model.dart';
import 'package:nandrlon/models/hrms/holiday/holiday-parametres.dart';
import 'package:nandrlon/models/hrms/item-list.dart';
import 'package:nandrlon/models/hrms/holiday/holiday-parametres.dart';
import 'package:nandrlon/models/user.model.dart';
import 'package:nandrlon/services/team.service.dart';
import 'package:nandrlon/widgets/alert-dialog-widget.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/dropdown.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HolidayFilterScreen extends StatefulWidget {
  HolidayFilterScreen({
    Key key,
    this.holidayParameters,
  }) : super(key: key);

  HolidayParameters holidayParameters;

  @override
  _HolidayFilterScreenState createState() => _HolidayFilterScreenState();
}

class _HolidayFilterScreenState extends State<HolidayFilterScreen> {
  var searchTextEditingController = TextEditingController();
  List<City> _filteredCities = [];
  List<District> _filteredDistricts = [];
  List<EmployeeFilter> _employees = [];

  @override
  void initState() {
    super.initState();
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
                widget.holidayParameters = HolidayParameters();
              });
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                Navigator.pop(context, widget.holidayParameters);
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
                    onTap: () async {
                      var date = await _selectDate(context);
                      if (date != null) {
                        setState(() {
                          widget.holidayParameters.startDate =
                              dateFormat.format(date);
                        });
                      }
                    },
                    child: TextFieldWidget(
                      enabled: false,
                      labelText: "from_date".tr(),
                      key: Key(widget.holidayParameters.startDate),
                      initialValue: widget.holidayParameters.startDate,
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
                          widget.holidayParameters.endDate =
                              dateFormat.format(date);
                        });
                      }
                    },
                    child: TextFieldWidget(
                      enabled: false,
                      labelText: "to_date".tr(),
                      key: Key(widget.holidayParameters.endDate),
                      initialValue: widget.holidayParameters.endDate,
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
