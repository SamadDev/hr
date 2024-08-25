import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/models/team.model.dart';
import 'package:nandrlon/models/user.model.dart';
import 'package:nandrlon/screens/map/widget/team.widget.dart';
import 'package:nandrlon/services/employee.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/image.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  MapScreen();

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  SharedPreferences prefs;
  List<Marker> _markers = [];
  List _doctors = [];
  List _customers = [];
  MapController _mapController;
  bool _infoWindowVisible = false;
  bool _showCustomers = false;
  bool _showDoctors = false;
  LatLng markerCoords = LatLng(35.754584, -83.974536);
  double _infoWindowOffset = 0.002;
  LatLng _infoWindowCoords;
  LatLng _center = LatLng(36.19670, 44.00247);
  List<Color> _colors = [Colors.red, Colors.green, Colors.amber];
  List<LatLng> _latLng = [
    LatLng(36.19750, 44.00258),
    LatLng(36.19870, 44.00247),
    LatLng(36.19970, 44.00447)
  ];
  List<Team> _teams;

  @override
  void initState() {
    _mapController = new MapController();
    _infoWindowCoords = LatLng(
      markerCoords.latitude + _infoWindowOffset,
      markerCoords.longitude,
    );

    onLoad();
    readDoctorJson();
    readCustomerJson();

    super.initState();
  }

  onLoad() async {
    prefs = await SharedPreferences.getInstance();
    var user = User.fromJson(json.decode(prefs.getString("user")));

    var team = await EmployeeService.getTeam(user.id);
    setState(() {
      _teams = team;
    });

    _buildTeamMarkersOnMap();
    _buildCustomerMarkersOnMap();
  }

  Future<void> readDoctorJson() async {
    final String response =
        await rootBundle.loadString('assets/json/doctor.json');
    final data = await json.decode(response);

    setState(() {
      _doctors = data;
    });
  }

  Future<void> readCustomerJson() async {
    final String response =
        await rootBundle.loadString('assets/json/customer.json');
    final data = await json.decode(response);

    setState(() {
      _customers = data.take(5).toList();
    });
  }

  Widget popup(
    bool visible,
    String title,
    String subtitle,
    String image,
  ) {
    return visible == true
        ? Container(
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).primaryColor,
            ),
            width: 279.0,
            height: 65.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  ImageWidget(
                    width: 40,
                    height: 40,
                    imageUrl: image,
                    // "https://nandrlonhr.com/Uploads/HRMS/Employees/${team.employeeImage}",
                    errorText: title[0],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 165,
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : SizedBox(
            width: 0,
            height: 0,
          );
  }

  Widget marker(String type, String image, String title) {
    return type != "team"
        ? Icon(
            Icons.location_on_sharp,
            size: 30,
          )
        : Center(
            child: Stack(
              children: [
                Image.asset(
                  "assets/image/user_location.png",
                  width: 40,
                  color: type == "team" ? Colors.white : Colors.red,
                ),
                Positioned(
                  left: 0,
                  child: ImageWidget(
                    width: 40,
                    height: 40,
                    imageUrl: image,
                    errorText: title[0],
                  ),
                ),
              ],
            ),
          );
  }

  _buildTeamMarkersOnMap() async {
    List<Marker> markers = [];
    if (_teams != null) {
      int index = 0;
      for (Team team in _teams) {
        var newMarker = new Marker(
          point: _latLng[index],
          width: 250.0,
          height: 190.0,
          builder: (context) => GestureDetector(
            onTap: () {
              setState(() {
                team.visible = team.visible == null ? true : !team.visible;
                // _mapController.move(_latLng[index], 17);
              });
            },
            child: Stack(
              children: <Widget>[
                popup(
                  team.visible,
                  team.employeeName,
                  team.jobTitle,
                  "${box.read('api')}/Uploads/HRMS/Employees/${team.employeeImage}",
                ),
                marker(
                    "team",
                    "${box.read('api')}/Uploads/HRMS/Employees/${team.employeeImage}",
                    team.employeeName),
              ],
            ),
          ),
        );

        markers.add(newMarker);

        index++;
      }
    }

    setState(() {
      _markers.addAll(markers);
    });
  }

  List<Marker> _buildDoctorMarkersOnMap() {
    List<Marker> markers = [];

    if (_teams != null) {
      int index = 0;
      for (Team team in _teams) {
        var newMarker = new Marker(
          point: _latLng[index],
          width: 250.0,
          height: 190.0,
          builder: (context) => GestureDetector(
            onTap: () {
              setState(() {
                team.visible = team.visible == null ? true : !team.visible;
                // _mapController.move(_latLng[index], 17);
              });
            },
            child: Stack(
              children: <Widget>[
                popup(
                  team.visible,
                  team.employeeName,
                  team.jobTitle,
                  "${box.read('api')}/Uploads/HRMS/Employees/${team.employeeImage}",
                ),
                marker(
                    "doctor",
                    "${box.read('api')}/Uploads/HRMS/Employees/${team.employeeImage}",
                    team.employeeName),
              ],
            ),
          ),
        );
        markers.add(newMarker);
        index++;
      }
    }
    return markers;
  }

  _buildCustomerMarkersOnMap() {
    List<Marker> markers = [];

    if (_customers != null) {
      for (var customer in _customers) {
        var newMarker = new Marker(
          point: LatLng(customer['latitude'], customer['longitude']),
          width: 250.0,
          height: 190.0,
          builder: (context) => GestureDetector(
            onTap: () {
              setState(() {
                customer['visible'] =
                    customer['visible'] == null ? true : !customer['visible'];
                // _mapController.move(_latLng[index], 17);
              });
            },
            child: Column(
              children: <Widget>[
                popup(
                  customer['visible'],
                  "${customer['first_name']} ${customer['last_name']}",
                  customer['group'],
                  null,
                ),
                marker("customer", null,
                    "${customer['first_name']} ${customer['last_name']}"),
              ],
            ),
          ),
        );
        markers.add(newMarker);
      }
    }
    setState(() {
      _markers.addAll(markers);
    });
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
                      },
                    ),
                  ],
              onSelected: (item) => {}),
        ],
      ),
      body: _markers.length == 0
          ? Container()
          : SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            center: _center,
                            zoom: 15.0,
                          ),
                          layers: [
                            TileLayerOptions(
                              urlTemplate:
                                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                              subdomains: ['a', 'b', 'c'],
                            ),
                            new MarkerLayerOptions(
                              markers: _markers,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  _teams == null
                      ? Container()
                      : Positioned(
                          bottom: 130,
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
                                    team.visible = team.visible == null
                                        ? true
                                        : !team.visible;
                                  });
                                },
                              ),
                            ),
                          ),
                        )
                ],
              ),
            ),
    );
  }
}
