import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapWidget extends StatefulWidget {
  MapWidget({
    Key key,
    this.latLng,
  }) : super(key: key);
  LatLng latLng;

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController mapController; //contrller for Google map
  LatLng _latLng;
  final Set<Marker> _markers = new Set(); //markers for google map

  @override
  void initState() {
    onload();
    super.initState();
  }

  onload() async {

    if (widget.latLng == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var longitude = prefs.getDouble("longitude");
      var latitude = prefs.getDouble("latitude");

      setState(() {
        _latLng = LatLng(latitude, longitude);
      });
    } else {
      setState(() {
        _latLng = widget.latLng;
      });
    }
    pin(_latLng);
  }

  pin(LatLng latLng) {
    _markers.clear();

    var marker = Marker(
      markerId: MarkerId(latLng.toString()),
      position: latLng,
    );

    setState(() {
      _markers.add(marker);
      _latLng = latLng;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "Map",
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context, _latLng);
            },
          ),
        ],
      ),
      body: _latLng == null
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : GoogleMap(
              zoomGesturesEnabled: true,
              myLocationEnabled: true,
              markers: _markers,
              onTap: (LatLng latLng) {
                pin(latLng);
              },
              mapToolbarEnabled: true,
              compassEnabled: true,
              initialCameraPosition: CameraPosition(
                target: _latLng,
                zoom: 15.0,
              ),
              mapType: MapType.normal,
              onMapCreated: (controller) {
                mapController = controller;
              },
            ),
    );
  }
}
