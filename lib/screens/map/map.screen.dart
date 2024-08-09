import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart' as a;
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/models/crm/customer/customer-result.dart';
import 'package:nandrlon/models/crm/customer/customer-search.dart';
import 'package:nandrlon/screens/map/profile.screen.dart';
import 'package:nandrlon/screens/map/search.screen.dart';
import 'package:nandrlon/services/customer.service.dart';
import 'package:nandrlon/widgets/image.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  var location = new Location();
  CustomerParameters _customerParameters;
  LatLng _currentPostion;
  LatLng _destination;
  List<CustomerResult> _customers;
  bool _isLoading = true;
  CustomerResult _profile;
  GoogleMapController mapController; //contrller for Google map
  final Set<Marker> _markers = new Set(); //markers for google map
  bool _canStartVisit = true;
  List<LatLng> locations = [
    LatLng(36.1964472, 44.0021304),
    LatLng(36.1975567, 44.0000604),
    LatLng(36.1954472, 44.0051304),
  ];

  @override
  void initState() {
    _customerParameters = new CustomerParameters();
    onload();
    super.initState();
  }

  onload() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var longitude = prefs.getDouble("longitude");
    var latitude = prefs.getDouble("latitude");

    
    

    setState(() {
      _currentPostion = LatLng(latitude, longitude);
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  showProfile(CustomerResult customer) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              color: Colors.white,
            ),
            child: Stack(
              children: <Widget>[
                Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    ImageWidget(
                      width: 80,
                      height: 80,
                      errorText: customer.name[0],
                      errorTextFontSize: 25,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      customer.name,
                      style: TextStyle(
                        color: Color(0xff29304D),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    MapProfileListTile(
                      icon: Icons.groups_outlined,
                      title: "Group",
                      subtitle: customer.groupName,
                    ),
                    MapProfileListTile(
                      icon: Icons.location_on_outlined,
                      title: "Address",
                      subtitle:
                          "${customer.cityName ?? "-"}  ${customer.address == null ? "" : "- "}",
                    ),
                    MapProfileListTile(
                      icon: Icons.phone_outlined,
                      title: "Phone No 1",
                      subtitle: "${customer.phoneNo ?? "-"}",
                    ),
                    MapProfileListTile(
                      icon: Icons.phone_outlined,
                      title: "Phone No 2",
                      subtitle: "${customer.phoneNo2 ?? "-"}",
                    ),
                    MapProfileListTile(
                      icon: Icons.email_outlined,
                      title: "Email",
                      subtitle: customer.email ?? "-",
                    ),
                    MapProfileListTile(
                      icon: Icons.military_tech_outlined,
                      title: "Status",
                      subtitle: customer.statusName ?? "-",
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: Container(
                      color: backgroundColor,
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 30),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 30,
                        height: 50,
                        child: TextButton(
                          onPressed:  () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MapCustomerProfileScreen(
                                        customer: _profile,
                                      ),
                                    ),
                                  );
                                },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ))),
                          child: Text(
                            "Start Visit",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Marker getmarkers2(int id, String title, String snippet, String type,
      LatLng location, CustomerResult customer) {
    return Marker(
      markerId: MarkerId(location.toString()),
      position: location, //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: title,
        snippet: snippet,
      ),
      onTap: () async {
        if (type == "customer") {
          var _distanceInMeters = await Geolocator.distanceBetween(
              location.latitude,
              location.longitude,
              _currentPostion.latitude,
              _currentPostion.longitude);

          setState(() {
            _canStartVisit = _distanceInMeters > 50 ? false : true;
          });

          showProfile(customer);
          setState(() {
            _profile = customer;
          });
        }
      },
      //Icon for Marker
    );
  }

  nearbyCustomer() async {
    setState(() {
      _markers.clear();
    });

    final String response =
        await rootBundle.loadString('assets/json/customer.json');
    final customers = await json.decode(response);

    for (var customer in customers) {
      // double distanceInMeters = await Geolocator.distanceBetween(
      //     _currentPostion.latitude,
      //     _currentPostion.longitude,
      //     customer['latitude'],
      //     customer['longitude']);
      //
      // if (distanceInMeters <= 2000000) {
      //   var name = customer['first_name'] + " " + customer['last_name'];
      //
      //   var group = customer['group'];
      //   var id = customer['id'];
      //
      //   var location = LatLng(customer['latitude'], customer['longitude']);
      //
      //   var marker = getmarkers2(id, name, group, "customer", location);
      //
      //   setState(() {
      //     _markers.add(marker);
      //   });
      //
      //   mapController.moveCamera(
      //     CameraUpdate.newCameraPosition(
      //       CameraPosition(target: location, zoom: 15),
      //     ),
      //   );
      // }
    }
  }

  getCustomer() async {
    setState(() {
      _markers.clear();
      _customers = [];
    });

    var customers = await CustomerService.customers(_customerParameters);

    customers.forEach((customer) async {
      if (customer.longitude == null || customer.latitude == null) return;

      var name = customer.name;

      var group = customer.groupName;
      var id = customer.id;

      var location = LatLng(
          double.parse(customer.latitude), double.parse(customer.longitude));

      var marker = getmarkers2(id, name, group, "customer", location, customer);

      setState(() {
        _markers.add(marker);
      });

      mapController.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: location, zoom: 15),
        ),
      );
    });

    setState(() {
      _isLoading = false;
      _customers = customers;
    });
  }

  onSearch() async {
    setState(() {
      _markers.clear();
    });

    var data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapSearchScreen()),
    );

    if (data != null) {
      if (data['type'] == "district") {
        var districtId = data['id'];

        setState(() {
          _customerParameters.districtId = districtId;
        });

        getCustomer();
      } else {
        var location = LatLng(data['latitude'], data['longitude']);

        setState(() {
          _profile = data['content'];
          _destination = location;
        });

        var name = data['name'];
        var group = data['group'];
        var type = data['type'];
        var id = data['id'];

        var marker = getmarkers2(id, name, group, type, location, _profile);

        setState(() {
          _markers.add(marker);
        });

        mapController.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: location, zoom: 15),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      floatingActionButton: _profile == null
          ? Container()
          : Stack(
              children: <Widget>[
                Positioned(
                  bottom: 60,
                  right: 10,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      heroTag: null,
                      child: Icon(Icons.directions),
                      onPressed: () async {
                        if (await a.MapLauncher.isMapAvailable(
                            a.MapType.google)) {
                          await a.MapLauncher.showDirections(
                            mapType: a.MapType.google,
                            destination: a.Coords(
                                _destination.latitude, _destination.longitude),
                            origin: a.Coords(_currentPostion.latitude,
                                _currentPostion.longitude),
                          );
                        } else {
                          await a.MapLauncher.showDirections(
                            mapType: a.MapType.apple,
                            destination: a.Coords(
                                _destination.latitude, _destination.longitude),
                            origin: a.Coords(_currentPostion.latitude,
                                _currentPostion.longitude),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          _currentPostion != null
              ? GoogleMap(
                  zoomGesturesEnabled: true,
                  myLocationEnabled: true,
                  mapToolbarEnabled: true,
                  compassEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: _currentPostion,
                    zoom: 15.0,
                  ),
                  markers: _markers,
                  mapType: MapType.normal,
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                )
              : Container(),
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: GestureDetector(
                    onTap: () => onSearch(),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Search",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            PopupMenuButton(
                              icon: Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                PopupMenuItem<int>(
                                  value: 0,
                                  child: Text(
                                    "Nearby Customer",
                                  ),
                                ),
                              ],
                              onSelected: (item) {
                                nearbyCustomer();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MapUtils {
  MapUtils._();

  static Future<void> openMap(LatLng origin, LatLng destination) async {
    String googleUrl =
        'https://www.google.com/maps/dir/?api=1&origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&travelmode=driving&dir_action=navigate';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}

class MapProfileListTile extends StatelessWidget {
  MapProfileListTile({
    Key key,
    this.title,
    this.subtitle,
    this.icon,
    this.onTap,
  }) : super(key: key);
  final GestureTapCallback onTap;
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            margin: EdgeInsets.only(top: 10, left: 10),
            child: new Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
          ),
          title: new Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
          subtitle: Container(
            padding: EdgeInsets.only(top: 5),
            child: new Text(
              subtitle,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xff565656),
              ),
            ),
          ),
        ),
        Divider(
          height: 0,
        ),
      ],
    );
  }
}
