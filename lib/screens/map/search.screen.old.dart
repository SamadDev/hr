import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/widgets/image.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:easy_localization/easy_localization.dart';

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen();

  @override
  _MapSearchScreenState createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  var searchController = TextEditingController();
  bool _showCustomer = true;
  bool _showDoctor = false;
  bool _showDistrict = false;
  List<dynamic> _customers;
  List<dynamic> _districts;
  List<dynamic> _doctors;

  @override
  void initState() {
    loadCustomer();
    super.initState();
  }

  Future loadCustomer() async {
    setState(() {
      _customers = [];
      _doctors = [];
      _districts = [];
      _showDoctor = false;
      _showCustomer = true;
    });

    final String response =
        await rootBundle.loadString('assets/json/customer.json');
    var customers = await json.decode(response);

    if (searchController.text.isEmpty) {
      setState(() {
        _customers = customers;
      });
    } else {
      customers = customers
          .where((d) => d['first_name']
              .toString()
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
      setState(() {
        _customers = customers;
      });
    }
  }

  Future<void> loadDoctor() async {
    setState(() {
      _customers = [];
      _doctors = [];
      _districts = [];
      _showCustomer = false;
      _showDoctor = true;
    });

    final String response =
        await rootBundle.loadString('assets/json/doctor.json');
    var doctors = await json.decode(response);

    if (searchController.text.isEmpty) {
      setState(() {
        _doctors = doctors;
      });
    } else {
      doctors = doctors
          .where((d) => d['name_en']
              .toString()
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
      setState(() {
        _doctors = doctors;
      });
    }
  }

  Future<void> loadDistrict() async {
    setState(() {
      _customers = [];
      _doctors = [];
      _districts = [];
      _showCustomer = false;
      _showDoctor = false;
      _showDistrict = true;
    });

    final String response =
        await rootBundle.loadString('assets/json/district.json');
    var districts = await json.decode(response);

    if (searchController.text.isEmpty) {
      setState(() {
        _districts = districts;
      });
    } else {
      districts = districts
          .where((d) => d['name']
              .toString()
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
      setState(() {
        _districts = districts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: TextField(
                  controller: searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "search".tr(),
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  style: TextStyle(
                    color: Color(0xff24272A),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (query) {
                    if (_showCustomer)
                      loadCustomer();
                    else if (_showDoctor)
                      loadDoctor();
                    else if (_showDistrict) loadDistrict();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: _customers == null
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    height: 80,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        SearchListTile(
                          title: "Customer",
                          icon: Icons.person_outline,
                          onTap: () {
                            loadCustomer();
                          },
                        ),
                        SearchListTile(
                          title: "Doctor",
                          icon: Icons.supervisor_account_outlined,
                          onTap: () {
                            loadDoctor();
                          },
                        ),
                        SearchListTile(
                          title: "District",
                          icon: Icons.location_on_outlined,
                          onTap: () {
                            loadDistrict();
                          },
                        ),
                        SearchListTile(
                          title: "More",
                          icon: Icons.more_horiz,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 8,
                    color: Colors.grey.shade300,
                  ),
                  if (_showCustomer)
                    for (var customer in _customers)
                      CustomerListTile(
                        customer: customer,
                        onTap: () {
                          dynamic data = {};
                          data['id'] = customer["id"];
                          data['name'] = customer['first_name'] +
                              " " +
                              customer['last_name'];
                          data['type'] = "customer";
                          data['longitude'] = customer["longitude"];
                          data['latitude'] = customer["latitude"];
                          data['group'] = customer['group'];
                          data['content'] = customer;

                          Navigator.pop(
                            context,
                            data,
                          );
                        },
                      ),
                  if (_showDoctor)
                    for (var doctor in _doctors)
                      DoctorListTile(
                        doctor: doctor,
                        onTap: () {
                          dynamic data = {};
                          data['id'] = doctor["id"];
                          data['name'] = doctor['name_en'];
                          data['group'] = doctor['speciality_names_en'];
                          data['type'] = "doctor";
                          data['longitude'] = doctor["longitude"];
                          data['latitude'] = doctor["latitude"];

                          Navigator.pop(
                            context,
                            data,
                          );
                        },
                      ),
                  if (_showDistrict)
                    for (var district in _districts)
                      DistrictListTile(
                        district: district,
                        onTap: () {
                          dynamic data = {};
                          data['id'] = district["id"];
                          data['name'] = district['name'];
                          data['type'] = "district";
                          data['longitude'] = district["longitude"];
                          data['latitude'] = district["latitude"];
                          data['group'] = "district";

                          Navigator.pop(
                            context,
                            data,
                          );
                        },
                      )
                ],
              ),
            ),
    );
  }
}

class CustomerListTile extends StatelessWidget {
  CustomerListTile({
    Key key,
    this.customer,
    this.onTap,
  }) : super(key: key);

  final dynamic customer;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Container(
                  height: 45,
                  width: 45,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0x80839daf),
                  ),
                  child: Center(
                    child: Text(
                      customer['first_name'][0].toString().toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${customer['first_name']} ${customer['last_name']}",
                      style: TextStyle(
                        color: Color(0xff24272A),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      customer['group'] ?? "",
                      style: TextStyle(
                        color: Color(0xff62656B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
          ),
        ],
      ),
    );
  }
}

class DoctorListTile extends StatelessWidget {
  DoctorListTile({
    Key key,
    this.doctor,
    this.onTap,
  }) : super(key: key);

  final dynamic doctor;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                ImageWidget(
                  imageUrl: doctor['image_id'].toString().isEmpty
                      ? ""
                      : "https://api.dr-online.com/files/${doctor['image_id']}",
                  errorText: doctor['name_en'][0].toString().toUpperCase(),
                  radius: 50,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor['name_en'].toString().toTitleCase(),
                      style: TextStyle(
                        color: Color(0xff24272A),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      doctor['speciality_names_en'],
                      style: TextStyle(
                        color: Color(0xff62656B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
          ),
        ],
      ),
    );
  }
}

class DistrictListTile extends StatelessWidget {
  DistrictListTile({
    Key key,
    this.district,
    this.onTap,
  }) : super(key: key);

  final dynamic district;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Text(
              district['name'].toString().toTitleCase(),
              style: TextStyle(
                color: Color(0xff24272A),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          Divider(
            height: 0,
          ),
        ],
      ),
    );
  }
}

class SearchListTile extends StatelessWidget {
  const SearchListTile({
    Key key,
    this.onTap,
    this.icon,
    this.title,
  }) : super(key: key);

  final GestureTapCallback onTap;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 20),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).primaryColor.withOpacity(0.2),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 18,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
