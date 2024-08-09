import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/widgets/image.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorProfileScreen extends StatefulWidget {
  DoctorProfileScreen({Key key, this.doctor}) : super(key: key);

  final dynamic doctor;

  @override
  _DoctorProfileScreenState createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF4F62C0),
                        const Color(0xFF4F62C0),
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30.0),
                            topLeft: Radius.circular(30.0),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ImageWidget(
                              width: 88,
                              height: 88,
                              imageUrl: widget.doctor['image_id']
                                      .toString()
                                      .isEmpty
                                  ? ""
                                  : "https://api.dr-online.com/files/${widget.doctor['image_id']}",
                              errorText: widget.doctor['name_en'][0]
                                  .toString()
                                  .toUpperCase(),
                              errorTextFontSize: 30,
                              radius: 15,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 220,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.doctor["name_en"]
                                        .toString()
                                        .toTitleCase(),
                                    style: TextStyle(
                                      color: Color(0xff29304D),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    widget.doctor["speciality_names_en"],
                                    style: TextStyle(
                                      color: Color(0xff8A959E),
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ProfileListTile(
              title: "Bio",
              widget: Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  widget.doctor['bio_en'],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ProfileListTile(
              title: "Clinic",
              widget: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    AdressListTile(
                      value: widget.doctor['clinic_name_en'],
                      icon: Icons.business_outlined,
                    ),
                    AdressListTile(
                      value: widget.doctor['clinic_phone_no'],
                      icon: Icons.phone,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ProfileListTile(
              title: "Contact Info",
              widget: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    AdressListTile(
                      value: widget.doctor['city_name_en'],
                      icon: Icons.location_city,
                    ),
                    AdressListTile(
                      value: widget.doctor['phone_no'],
                      icon: Icons.call,
                    ),
                    AdressListTile(
                      value: widget.doctor['email'],
                      icon: Icons.email,
                    ),
                    AdressListTile(
                      value: widget.doctor['address_title_en'],
                      icon: Icons.map_outlined,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ProfileListTile(
              title: "Map",
              widget: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(constBorderRadius),
                  ),
                ),
                padding: EdgeInsets.all(20),
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(
                      widget.doctor['latitude'],
                      widget.doctor['longitude'],
                    ),
                    zoom: 15.0,
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayerOptions(
                      markers: [
                        Marker(
                          width: 40,
                          height: 40,
                          point: LatLng(
                            widget.doctor['latitude'],
                            widget.doctor['longitude'],
                          ),
                          builder: (ctx) => Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xff4F62C0).withOpacity(0.15),
                                  spreadRadius: 0,
                                  blurRadius: 20,
                                  offset: Offset(
                                      0, 10), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.person_pin_circle,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  ActionButton({Key key, this.color, this.iconData, this.url})
      : super(key: key);

  final IconData iconData;
  final Color color;
  final String url;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'call not possible';
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: color,
        ),
        child: Icon(
          iconData,
          size: 17,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ProfileListTile extends StatelessWidget {
  ProfileListTile({
    Key key,
    this.title,
    this.widget,
  }) : super(key: key);

  final dynamic title;
  final dynamic widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
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
            padding: EdgeInsets.all(15),
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

class AdressListTile extends StatelessWidget {
  AdressListTile({
    Key key,
    this.value,
    this.icon,
  }) : super(key: key);

  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: Color(
              0xff8A959E,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            width: 300,
            child: Text(
              value,
              style: TextStyle(
                color: Color(
                  0xff8A959E,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
