import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/dropdown.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';

class DoctorCallFormScreen extends StatefulWidget {
  const DoctorCallFormScreen({Key key}) : super(key: key);

  @override
  _DoctorCallFormScreenState createState() => _DoctorCallFormScreenState();
}

class _DoctorCallFormScreenState extends State<DoctorCallFormScreen> {
  var phoneMask = new MaskTextInputFormatter(mask: "+964 (###) ###-####");

  var nameController = TextEditingController();
  var doctorController = TextEditingController();
  var searchSpecialityController = TextEditingController();
  var searchDoctorController = TextEditingController();
  var purposeController = TextEditingController();
  var resultController = TextEditingController();
  var statusController = TextEditingController();
  var dateController = TextEditingController();
  var descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  List _doctors = [];
  List _purposes = [];
  List _results = [];
  List _statuses = [];

  dynamic _purpose;
  dynamic _result;
  dynamic _status;

  @override
  void initState() {
    super.initState();
    readDoctorJson();
    readResultsJson();
    readStatusJson();
    readPurposesJson();
  }

  Future<void> readDoctorJson() async {
    final String response =
        await rootBundle.loadString('assets/json/doctor.json');
    final data = await json.decode(response);

    setState(() {
      if (searchDoctorController.text.isEmpty) _doctors = data;
      if (searchDoctorController.text.isNotEmpty)
        _doctors = data
            .where((d) => d['name_en']
                .toString()
                .toLowerCase()
                .contains(searchDoctorController.text.toLowerCase()))
            .toList();
    });
  }

  Future<void> readResultsJson() async {
    final String response =
        await rootBundle.loadString('assets/json/doctor-call/result.json');
    final results = await json.decode(response);
    setState(() {
      _results = results;
    });
  }

  Future<void> readStatusJson() async {
    final String response =
        await rootBundle.loadString('assets/json/doctor-call/status.json');
    final statuses = await json.decode(response);
    setState(() {
      _statuses = statuses;
    });
  }

  Future<void> readPurposesJson() async {
    final String response =
        await rootBundle.loadString('assets/json/doctor-call/purpose.json');
    final purposes = await json.decode(response);

    setState(() {
      _purposes = purposes;
    });
  }

  doctorModalBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, mystate) => Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: TextFieldWidget(
                    controller: searchDoctorController,
                    iconData: Icons.search,
                    onChanged: (value) {
                      mystate(() {
                        readDoctorJson();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _doctors.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            title: new Text(_doctors[index]['name_en']),
                            onTap: () {
                              setState(() {
                                doctorController.text =
                                    _doctors[index]['name_en'];
                              });
                              Navigator.pop(context);
                            },
                          ),
                          Divider(
                            height: 0,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
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
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateController.text = picked.toString().substring(0, 10);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "Doctor Call",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormListTile(
                title: "General",
                widget: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: TextFieldWidget(
                          labelText: "Date",
                          enabled: false,
                          controller: dateController,
                          iconData: Icons.date_range_outlined,
                        ),
                      ),
                      GestureDetector(
                        onTap: doctorModalBottomSheet,
                        child: TextFieldWidget(
                          labelText: "Doctor",
                          isDropdown: true,
                          enabled: false,
                          controller: doctorController,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FormListTile(
                title: "Details",
                widget: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      DropdownButtonWidget(
                        labelText: "Purpose",
                        value: _purpose,
                        items: _purposes.map((dynamic items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(
                              items['name'],
                            ),
                          );
                        }).toList(),
                        onChanged: (dynamic purpose) {
                          setState(() {
                            _purpose = purpose;
                            purposeController.text = purpose['name'];
                          });
                        },
                      ),
                      DropdownButtonWidget(
                        labelText: "Status",
                        value: _status,
                        items: _statuses.map((dynamic items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(
                              items['name'],
                            ),
                          );
                        }).toList(),
                        onChanged: (dynamic status) {
                          setState(() {
                            _status = status;
                            statusController.text = status['name'];
                          });
                        },
                      ),
                      DropdownButtonWidget(
                        labelText: "Result",
                        value: _result,
                        items: _results.map((dynamic items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(
                              items['name'],
                            ),
                          );
                        }).toList(),
                        onChanged: (dynamic result) {
                          setState(() {
                            _result = result;
                            resultController.text = result['name'];
                          });
                        },
                      ),
                      TextFieldWidget(
                        labelText: "Description",
                        maxLines: 8,
                        controller: descriptionController,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 50,
                margin: EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: Center(
                  child: Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FormListTile extends StatelessWidget {
  FormListTile({
    Key key,
    this.title,
    this.widget,
  }) : super(key: key);

  final dynamic title;
  final dynamic widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(
            constBorderRadius,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Text(
              this.title,
              style: TextStyle(
                color: Color(0xff29304D),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            height: 0,
          ),
          widget
        ],
      ),
    );
  }
}
