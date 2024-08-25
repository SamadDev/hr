import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/dropdown.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';

class DoctorFormScreen extends StatefulWidget {
  const DoctorFormScreen();

  @override
  _DoctorFormScreenState createState() => _DoctorFormScreenState();
}

class _DoctorFormScreenState extends State<DoctorFormScreen> {
  var phoneMask = new MaskTextInputFormatter(mask: "+964 (###) ###-####");

  var nameController = TextEditingController();
  var searchSpecialityController = TextEditingController();
  var genderController = TextEditingController();
  var specialityController = TextEditingController();
  var cityController = TextEditingController();
  var clinicNameController = TextEditingController();
  var clinicPhoneController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var addressController = TextEditingController();
  var locationController = TextEditingController();
  var descriptionController = TextEditingController();
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  List<dynamic> _specialities;
  List<dynamic> _cities = [];
  List<dynamic> _genders = [];
  dynamic _gender;
  dynamic _city;

  @override
  void initState() {
    super.initState();
    readSpecialityJson();
    readCityJson();
    readGenderJson();
  }

  Future<void> readSpecialityJson() async {
    final String response =
        await rootBundle.loadString('assets/json/speciality.json');
    final data = await json.decode(response);

    setState(() {
      if (searchSpecialityController.text.isNotEmpty) {
        _specialities = data
            .where(
              (s) => s['name_en'].toString().toLowerCase().contains(
                    searchSpecialityController.text,
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

  Future<void> readGenderJson() async {
    final String response =
        await rootBundle.loadString('assets/json/gender.json');
    final data = await json.decode(response);

    setState(() {
      _genders = data;
    });
  }

  specialityModalBottomSheet() {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, mystate) => Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: TextFieldWidget(
                    controller: searchSpecialityController,
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

  getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (_serviceEnabled == false) {
      _serviceEnabled = await location.requestService();
      if (_serviceEnabled == false) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    locationController.text = (_locationData?.latitude.toString() ?? "") +
        ", " +
        (_locationData?.longitude.toString() ?? "");
    location.enableBackgroundMode(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "New Doctor",
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
                title: "Personal Info",
                widget: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      TextFieldWidget(
                        labelText: "Name",
                        controller: nameController,
                        iconData: Icons.person_outline,
                      ),
                      DropdownButtonWidget(
                        labelText: "Gender",
                        value: _gender,
                        icon: Icons.star_outline_outlined,
                        items: _genders.map((dynamic items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(
                              items['name'],
                            ),
                          );
                        }).toList(),
                        onChanged: (dynamic gender) {
                          setState(() {
                            _gender = gender;
                            genderController.text = gender['name'];
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: specialityModalBottomSheet,
                        child: TextFieldWidget(
                          labelText: "Speciality",
                          isDropdown: true,
                          enabled: false,
                          controller: specialityController,
                          iconData: Icons.star_outline_outlined,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FormListTile(
                title: "Clinic Info",
                widget: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      TextFieldWidget(
                          labelText: "Clinic Name",
                          controller: clinicNameController,
                          iconData: Icons.maps_home_work_outlined),
                      TextFieldWidget(
                        labelText: "Phone",
                        controller: clinicPhoneController,
                        iconData: Icons.phone_outlined,
                        inputFormatters: [phoneMask],
                      ),
                    ],
                  ),
                ),
              ),
              FormListTile(
                title: "Contact Info",
                widget: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      TextFieldWidget(
                        labelText: "Phone",
                        controller: phoneController,
                        iconData: Icons.phone_outlined,
                        inputFormatters: [phoneMask],
                      ),
                      TextFieldWidget(
                        labelText: "Email",
                        controller: emailController,
                        iconData: Icons.email_outlined,
                      ),
                      DropdownButtonWidget(
                        labelText: "City",
                        value: _city,
                        icon: Icons.star_outline_outlined,
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
                            _city = city;
                            cityController.text = city['name'];
                          });
                        },
                      ),
                      TextFieldWidget(
                        labelText: "Address",
                        controller: addressController,
                        iconData: Icons.map,
                      ),
                      GestureDetector(
                        onTap: getLocation,
                        child: TextFieldWidget(
                          labelText: "Location",
                          enabled: false,
                          controller: locationController,
                          iconData: Icons.place_outlined,
                        ),
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
