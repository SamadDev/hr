import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/helper/formatter.dart';
import 'package:nandrlon/models/crm/shared/city.dart';
import 'package:nandrlon/models/crm/shared/district.dart';
import 'package:nandrlon/models/employee-filter.model.dart';
import 'package:nandrlon/models/hrms/punishment/punishment-parametres.dart';
import 'package:nandrlon/models/hrms/punishment/punishment-type.model.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/dropdown.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';

class PunishmentFilterScreen extends StatefulWidget {
  PunishmentFilterScreen({
    Key key,
    this.punishmentParameters,
    this.punishmentTypes,
  }) : super(key: key);

  PunishmentParameters punishmentParameters;
  List<PunishmentType> punishmentTypes;

  @override
  _PunishmentFilterScreenState createState() => _PunishmentFilterScreenState();
}

class _PunishmentFilterScreenState extends State<PunishmentFilterScreen> {
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
                widget.punishmentParameters = PunishmentParameters();
              });
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                Navigator.pop(context, widget.punishmentParameters);
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
                    labelText: "type".tr(),
                    value: widget.punishmentParameters.punishmentType,
                    items: widget.punishmentTypes
                        .map((PunishmentType punishmentType) {
                      return DropdownMenuItem(
                        value: punishmentType,
                        child: Text(
                          punishmentType.name ?? "",
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic branch) {
                      setState(() {
                        widget.punishmentParameters.punishmentTypeId =
                            branch.id;
                        widget.punishmentParameters.punishmentType = branch;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      var date = await _selectDate(context);
                      if (date != null) {
                        setState(() {
                          widget.punishmentParameters.fromDate =
                              dateFormat.format(date);
                        });
                      }
                    },
                    child: TextFieldWidget(
                      enabled: false,
                      labelText: "from_date".tr(),
                      key: Key(widget.punishmentParameters.fromDate),
                      initialValue: widget.punishmentParameters.fromDate,
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
                          widget.punishmentParameters.toDate =
                              dateFormat.format(date);
                        });
                      }
                    },
                    child: TextFieldWidget(
                      enabled: false,
                      labelText: "to_date".tr(),
                      key: Key(widget.punishmentParameters.toDate),
                      initialValue: widget.punishmentParameters.toDate,
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
