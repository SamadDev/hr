import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/dropdown.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';

class DoctorFilterScreen extends StatefulWidget {
  DoctorFilterScreen({
    Key key,
    this.speciality,
    this.city,
  }) : super(key: key);

  dynamic speciality;
  dynamic city;

  @override
  _DoctorFilterScreenState createState() => _DoctorFilterScreenState();
}

class _DoctorFilterScreenState extends State<DoctorFilterScreen> {
  var specialityController = TextEditingController();

  List<dynamic> _specialities;
  List<dynamic> _cities = [];

  @override
  void initState() {
    super.initState();
    readSpecialityJson();
    readCityJson();
  }

  Future<void> readSpecialityJson() async {
    final String response =
        await rootBundle.loadString('assets/json/speciality.json');
    final data = await json.decode(response);

    setState(() {
      if (specialityController.text.isNotEmpty) {
        _specialities = data
            .where(
              (s) => s['name_en'].toString().toLowerCase().contains(
                    specialityController.text,
                  ),
            )
            .toList();
      } else {
        _specialities = data;
      }
    });
  }

  Future<void> readCityJson() async {
    final String response =
        await rootBundle.loadString('assets/json/city.json');
    final data = await json.decode(response);

    setState(() {
      _cities = data;
    });
  }

  specialityModalBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, mystate) => Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: TextFieldWidget(
                    controller: specialityController,
                    iconData: Icons.search,
                    onChanged: (value) {
                      mystate(() {
                        readSpecialityJson();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _specialities.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            title: new Text(_specialities[index]['name_en']),
                            onTap: () {
                              setState(() {
                                widget.speciality = _specialities[index];
                                specialityController.text =
                                    _specialities[index]['name_en'];
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

  @override
  Widget build(BuildContext context) {
    return Layout(
      // backgroundColor: backgroundColor,
      bottomSheet: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          height: 50,
          margin: EdgeInsets.only(bottom: 40, left: 15, right: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Center(
            child: Text(
              "filter".tr(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
      appBar: AppBarWidget(
        title: "filter".tr(),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                widget.speciality = null;
                widget.city = null;
                specialityController.clear();
              });
            },
            child: Text(
              "Clear",
              style: TextStyle(
                color: Color(0xff29304D),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonWidget(
                labelText: "City",
                value: widget.city,
                items: _cities.map((dynamic items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(
                      items['name'],
                    ),
                  );
                }).toList(),
                onChanged: (dynamic city) {
                  setState(() {
                    widget.city = city;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: specialityModalBottomSheet,
                child: TextFieldWidget(
                  labelText: "Speciality",
                  isDropdown: true,
                  enabled: false,
                  controller: specialityController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
