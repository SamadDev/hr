import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerProfileScreen extends StatefulWidget {
  CustomerProfileScreen({Key key, this.customer}) : super(key: key);

  final dynamic customer;

  @override
  _CustomerProfileScreenState createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  bool infoWindowVisible = false;
  LatLng markerCoords = LatLng(35.754584, -83.974536);
  double infoWindowOffset = 0.002;
  LatLng infoWindowCoords;
  LatLng _center = LatLng(40.762681, -73.832611);

  @override
  void initState() {
    infoWindowCoords = LatLng(
      markerCoords.latitude + infoWindowOffset,
      markerCoords.longitude,
    );

    super.initState();
  }

  List<Marker> _buildMarkersOnMap() {
    List<Marker> markers = [];
    var marker = new Marker(
      point: _center,
      width: 250.0,
      height: 170.0,
      builder: (context) => GestureDetector(
          onTap: () {
            setState(() {
              infoWindowVisible = !infoWindowVisible;
            });
          },
          child: _buildCustomMarker()),
    );
    markers.add(marker);
    return markers;
  }

  Stack _buildCustomMarker() {
    return Stack(
      children: <Widget>[popup(), marker()],
    );
  }

  Widget popup() {
    return infoWindowVisible
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
                  Container(
                    height: 45,
                    width: 45,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        widget.customer['first_name'][0]
                            .toString()
                            .toUpperCase(),
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
                        "${widget.customer['first_name']} ${widget.customer['last_name']}",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.customer['group'] ?? "",
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

  Widget marker() {
    return Center(
      child: Icon(
        Icons.person_pin_circle,
        size: 30,
        color: Theme.of(context).primaryColor,
      ),
    );
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
                      backgroundImage: NetworkImage(
                        "https://i2.wp.com/news.microsoft.com/wp-content/themes/microsoft-news-center-2016/assets/img/default-avatar.png?ssl=1",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.customer["first_name"],
                        style: TextStyle(
                          color: Color(0xff29304D),
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.customer["last_name"],
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
                        widget.customer["group"],
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
                        color: Color(0xff2574FF),
                        iconData: Icons.location_on_outlined,
                        url:
                            'https://www.google.com/maps/search/?api=1&query=${widget.customer["latlng"]}',
                      ),
                      ActionButton(
                        color: Color(0xff12B2B3),
                        iconData: Icons.call_outlined,
                        url: widget.customer['first_name'],
                      ),
                      ActionButton(
                        color: Color(0xff1DA1F2),
                        iconData: Icons.mail_outline,
                        url: widget.customer['first_name'],
                      ),
                    ],
                  ),
                ),
              ),
              ProfileListTile(
                title: "Phone",
                subtitle: widget.customer['phone'],
              ),
              ProfileListTile(
                title: "Email",
                subtitle: widget.customer['email'],
              ),
              ProfileListTile(
                title: "Address",
                subtitle: widget.customer['address'] ?? "",
              ),
              Text(
                "Map",
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
                    center: _center,
                    zoom: 17.0,
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    new MarkerLayerOptions(markers: _buildMarkersOnMap()),
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
          this.title,
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
