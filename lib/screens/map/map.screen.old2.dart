import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nandrlon/models/team.model.dart';
import 'package:nandrlon/models/user.model.dart';
import 'package:nandrlon/screens/map/customer.screen.dart';
import 'package:nandrlon/screens/map/widget/team.widget.dart';
import 'package:nandrlon/services/employee.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List _doctors = [];
  List _customers = [];
  BitmapDescriptor _doctorIcon;
  BitmapDescriptor _customerIcon;
  BitmapDescriptor _employeeIcon;
  GoogleMapController mapController; //contrller for Google map
  final Set<Marker> _markers = new Set(); //markers for google map
  static const LatLng showLocation =
      const LatLng(36.1975667, 44.0000704); //location to show in map
  bool _showCustomers = false;
  bool _showDoctors = false;
  bool _showEmployees = true;
  bool _isFirstRun = true;
  List<Team> _teams;
  List<LatLng> locations = [
    LatLng(36.1964472, 44.0021304),
    LatLng(36.1975567, 44.0000604),
    LatLng(36.1954472, 44.0051304),
  ];

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/image/employee_location.png')
        .then((d) {
      _employeeIcon = d;
    });

    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/image/customer_location.png')
        .then((d) {
      _customerIcon = d;
    });

    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/image/doctor_location.png')
        .then((d) {
      _doctorIcon = d;
    });

    readEmployeeJson();
    readCustomerJson();
    readDoctorJson();

    super.initState();
  }

  readEmployeeJson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = User.fromJson(json.decode(prefs.getString("user")));

    var team = await EmployeeService.getTeam(user.id);
    setState(() {
      _teams = team;
    });

    if (_isFirstRun) {
      addEmployeeMarker();
      setState(() {
        _isFirstRun = false;
      });
    }
  }

  Future<void> readCustomerJson() async {
    final String response =
        await rootBundle.loadString('assets/json/customer.json');
    final data = await json.decode(response);

    setState(() {
      _customers = data.take(5).toList();
    });
  }

  addCustomerMarker() {
    _customers.forEach((customer) {
      var location = LatLng(customer['latitude'], customer['longitude']);
      var name = customer['first_name'] + " " + customer['last_name'];
      var group = customer['group'];
      var marker = getmarkers2(name, group, "customer", location);
      setState(() {
        _markers.add(marker);
      });
    });
  }

  removeCustomerMarker() {
    _customers.forEach((customer) {
      var location = LatLng(customer['latitude'], customer['longitude']);

      var marker =
          _markers.where((c) => c.markerId == MarkerId(location.toString()));

      setState(() {
        _markers.remove(marker.first);
      });
    });
  }

  addEmployeeMarker() {
    int index = 0;
    _teams.forEach((team) {
      var location = locations[index];
      var marker =
          getmarkers2(team.employeeName, team.jobTitle, "team", location);
      setState(() {
        _markers.add(marker);
      });
      index++;
    });
  }

  removeEmployeeMarker() {
    int index = 0;
    _teams.forEach((team) {
      var location = locations[index];

      var marker =
          _markers.where((c) => c.markerId == MarkerId(location.toString()));

      setState(() {
        _markers.remove(marker.first);
      });

      index++;
    });
  }

  addDoctorMarker() {
    _doctors.forEach((doctor) {
      var location = LatLng(doctor['latitude'], doctor['longitude']);
      var name = doctor['name_en'];
      var group = doctor['speciality_names_en'];
      var marker = getmarkers2(name, group, "doctor", location);
      setState(() {
        _markers.add(marker);
      });
    });
  }

  removeDoctorMarker() {
    _doctors.forEach((doctor) {
      var location = LatLng(doctor['latitude'], doctor['longitude']);

      var marker =
          _markers.where((c) => c.markerId == MarkerId(location.toString()));

      setState(() {
        _markers.remove(marker.first);
      });
    });
  }

  Future<void> readDoctorJson() async {
    final String response =
        await rootBundle.loadString('assets/json/doctor.json');
    final data = await json.decode(response);

    setState(() {
      _doctors = data.take(50).toList();
    });
  }

  Marker getmarkers2(
      String title, String snippet, String type, LatLng location) {
    return Marker(
      markerId: MarkerId(location.toString()),
      position: location, //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: title,
        snippet: snippet,
      ),
      icon: type == "doctor"
          ? _doctorIcon
          : type == "customer"
              ? _customerIcon
              : _employeeIcon,
      //Icon for Marker
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "Map",
        actions: [
          PopupMenuButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryColor,
              ), //don't specify ico
              padding: EdgeInsets.zero,
              itemBuilder: (context) => [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text(
                        _showCustomers ? "Hide Customers" : "Show Customers",
                        style: TextStyle(
                          color: Color(0xff29304D),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _showCustomers = !_showCustomers;
                        });

                        if (_showCustomers) {
                          addCustomerMarker();
                        } else {
                          removeCustomerMarker();
                        }
                      },
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Text(
                        _showDoctors ? "Hide Doctors" : "Show Doctors",
                        style: TextStyle(
                          color: Color(0xff29304D),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _showDoctors = !_showDoctors;
                        });

                        if (_showDoctors) {
                          addDoctorMarker();
                        } else {
                          removeDoctorMarker();
                        }
                      },
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Text(
                        _showEmployees ? "Hide Employee" : "Show Employee",
                        style: TextStyle(
                          color: Color(0xff29304D),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _showEmployees = !_showEmployees;
                        });

                        if (_showEmployees) {
                          addEmployeeMarker();
                        } else {
                          removeEmployeeMarker();
                        }
                      },
                    ),
                  ],
              onSelected: (item) => {}),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            //Map widget from google_maps_flutter package
            zoomGesturesEnabled: true,
            //enable Zoom in, out on map
            initialCameraPosition: CameraPosition(
              //innital position in map
              target: showLocation, //initial position
              zoom: 15.0, //initial zoom level
            ),
            markers: _markers,
            //markers to show on map
            mapType: MapType.normal,
            //map type
            onMapCreated: (controller) {
              //method called when map is created
              setState(() {
                mapController = controller;
              });
            },
          ),
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: GestureDetector(
                  onTap: () {
                    showSearch(
                        context: context, delegate: MapCustomerSearchScreen());
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          _teams == null
              ? Container()
              : Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {},
                      child: MapTeamWidget(
                        teams: _teams,
                        onChanged: (team) {
                          setState(() {
                            team.visible =
                                team.visible == null ? true : !team.visible;
                            mapController.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(target: locations[0], zoom: 15),
                              ),
                            );
                          });
                        },
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
