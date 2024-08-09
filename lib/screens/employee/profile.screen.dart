import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nandrlon/models/hrms/employee/employee.model.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeeProfileScreen extends StatefulWidget {
  EmployeeProfileScreen({Key key, this.employee}) : super(key: key);

  final Employee employee;

  @override
  _EmployeeProfileScreenState createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  showProfile() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: new Icon(Icons.photo),
                title: new Text('Photo'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.music_note),
                title: new Text('Music'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.videocam),
                title: new Text('Video'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.share),
                title: new Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Profile",
                style: TextStyle(
                  color: Color(0xff29304D),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(width: 4, color: Color(0x334F62C0)),
                    ),
                    child: CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(
                          "assets/image/default-avatar.png",
                        )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.employee.employeeName.split(" ")[0],
                        style: TextStyle(
                          color: Color(0xff29304D),
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${widget.employee.employeeName.split(" ")[1]} ${widget.employee.employeeName.split(" ")[2]}",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.employee.jobTitle,
                        style: TextStyle(
                          color: Color(0xff8A959E),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  width: 180,
                  margin: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ActionButton(
                        color: Color(0xff12B2B3),
                        iconData: Icons.call_outlined,
                        url: widget.employee.employeeName,
                      ),
                      ActionButton(
                        color: Color(0xff1DA1F2),
                        iconData: Icons.mail_outline,
                        url: widget.employee.employeeName,
                      ),
                    ],
                  ),
                ),
              ),
              ProfileListTile(
                title: "phone",
                subtitle: widget.employee.employeeName,
              ),
              ProfileListTile(
                title: "email",
                subtitle: widget.employee.employeeName,
              ),
              ProfileListTile(
                title: "address",
                subtitle: widget.employee.employeeName ?? "",
              ),
              Text(
                "map".tr(),
                style: TextStyle(
                  color: Color(0xff29304D),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width - 30,
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(
                      36.206291,
                      44.008869,
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
                            36.206291,
                            44.008869,
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
            ],
          ),
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
  ProfileListTile({Key key, this.subtitle, this.title}) : super(key: key);

  final dynamic title;
  final dynamic subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          this.title.tr(),
          style: TextStyle(
            color: Color(0xff29304D),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          this.subtitle,
          style: TextStyle(
            color: Color(0xffC5C5C5),
            fontSize: 15,
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
