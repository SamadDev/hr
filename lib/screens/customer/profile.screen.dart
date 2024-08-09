import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nandrlon/models/crm/contact/contact.dart';
import 'package:nandrlon/models/crm/customer/customer-group.dart';
import 'package:nandrlon/models/crm/customer/customer-result.dart';
import 'package:nandrlon/models/crm/customer/customer.dart';
import 'package:nandrlon/models/crm/shared/city.dart';
import 'package:nandrlon/models/crm/shared/source.dart';
import 'package:nandrlon/screens/customer-inventory/list.dart';
import 'package:nandrlon/screens/customer/form.screen.dart';
import 'package:nandrlon/screens/deal/list.screen.dart';
import 'package:nandrlon/screens/media/media.screen.dart';
import 'package:nandrlon/screens/note/list.dart';
import 'package:nandrlon/screens/sales-order/form.screen.dart';
import 'package:nandrlon/screens/survey/list.dart';
import 'package:nandrlon/screens/task/list.screen.dart';
import 'package:nandrlon/services/customer.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/image.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/loading.widget.dart';

class CustomerProfileScreen extends StatefulWidget {
  CustomerProfileScreen({
    Key key,
    this.customer,
    this.customerGroups,
    this.cities,
    this.sources,
  }) : super(key: key);

  CustomerResult customer;
  List<City> cities = [];
  List<CustomerGroup> customerGroups = [];
  List<Source> sources = [];

  @override
  _CustomerProfileScreenState createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  Customer _customer;
  GoogleMapController mapController; //contrller for Google map
  LatLng _currentPostion;
  final Set<Marker> _markers = new Set();
  bool _isLoading = true;
  bool _isUpdated = false;

  @override
  void initState() {
    onload();
    super.initState();
  }

  onload() async {
    if (widget.customer.id != null && widget.customer.id > 0) {
      CustomerService.getCustomer(widget.customer.id).then((customer) {
        setState(() {
          _customer = customer;
          _isLoading = false;
        });
      }).catchError((err) {
        showInSnackBar("Something error please contact support");
      });
    }
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value),
      ),
    );
  }

  Marker setMarkers(String title, String snippet, LatLng location) {
    return Marker(
      markerId: MarkerId(location.toString()),
      position: location, //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: title,
        snippet: snippet,
      ),
      //Icon for Marker
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "Profile",
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context, _isUpdated),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              var customer = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerFormScreen(
                    customer: _customer,
                    customerGroups: widget.customerGroups,
                    cities: widget.cities,
                    sources: widget.sources,

                  ),
                ),
              );

              if (customer != null) {
                setState(() {
                  _customer = customer;
                  _isUpdated = true;
                });
              }
            },
            icon: Icon(
              Icons.edit_outlined,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? LoadingWidget()
          : Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  CardWidget(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 4, color: Color(0x334F62C0)),
                              ),
                              child: CircleAvatar(
                                radius: 35,
                                backgroundImage: NetworkImage(
                                  "https://i2.wp.com/news.microsoft.com/wp-content/themes/microsoft-news-center-2016/assets/img/default-avatar.png?ssl=1",
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _customer.name,
                                  style: TextStyle(
                                    color: Color(0xff29304D),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _customer.group.name,
                                  style: TextStyle(
                                    color: Colors.grey.withOpacity(0.7),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Icon(
                                Icons.call,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(_customer.phoneNo ?? ""),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Icon(
                                Icons.mail,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(_customer.email ?? ""),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Icon(
                                Icons.place,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(_customer.address ?? ""),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CardWidget(
                    child: Column(
                      children: [
                        ProfileMenuListTile(
                          title: "Surveys",
                          icon: Icons.description_outlined,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SurveysScreen(
                                  customer: widget.customer,
                                  isReadOnly: true,
                                ),
                              ),
                            );
                          },
                        ),
                        ProfileMenuListTile(
                          title: "Deals",
                          icon: Icons.local_offer_outlined,
                          onTap: () {
                            // timerStream == null ? null :
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DealListScreen(
                                  customer: widget.customer,
                                  isReadOnly: true,
                                ),
                              ),
                            );
                          },
                        ),
                        ProfileMenuListTile(
                          title: "Sales Order",
                          icon: Icons.note_add_outlined,
                          onTap: () {
                            // timerStream == null ? null :
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SalesOrderFormScreen(
                                  customer: widget.customer,
                                ),
                              ),
                            );
                          },
                        ),
                        ProfileMenuListTile(
                          title: "Tasks",
                          icon: Icons.event_note_outlined,
                          onTap: () {
                            // timerStream == null ? null :
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskListScreen(
                                  customer: widget.customer,
                                  isReadOnly: true,
                                ),
                              ),
                            );
                          },
                        ),
                        ProfileMenuListTile(
                          title: "Inventory",
                          icon: Icons.inventory_2,
                          onTap: () {
                            // timerStream == null ? null :
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CustomerInventoryListScreen(
                                  customer: widget.customer,
                                  isReadOnly: true,
                                ),
                              ),
                            );
                          },
                        ),
                        ProfileMenuListTile(
                          title: "Payments",
                          icon: Icons.price_check,
                        ),
                        ProfileMenuListTile(
                          title: "Media",
                          icon: Icons.perm_media_outlined,
                          onTap: () {
                            //  timerStream == null ? null :
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MediaScreen(),
                              ),
                            );
                          },
                        ),
                        ProfileMenuListTile(
                          title: "Notes",
                          icon: Icons.note_alt_outlined,
                          onTap: () {
                            // timerStream == null ? null :
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NoteListScreen(
                                  customer: widget.customer,
                                  isReadOnly: true,
                                ),
                              ),
                            );
                          },
                        ),
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

class ContactListTile extends StatelessWidget {
  ContactListTile({
    Key key,
    this.contact,
    this.onTap,
  }) : super(key: key);

  final Contact contact;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        ListTile(
          onTap: onTap,
          leading: ImageWidget(
            errorText: contact.name[0].toString().toUpperCase(),
            errorTextFontSize: 16,
            radius: 50,
          ),
          title: Text(
            contact.name,
            style: TextStyle(
              color: Color(0xff24272A),
              fontWeight: FontWeight.bold,
              fontSize: 14,
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

class ProfileMenuListTile extends StatelessWidget {
  ProfileMenuListTile({
    Key key,
    this.title,
    this.onTap,
    this.icon,
  }) : super(key: key);

  dynamic title;
  final GestureTapCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          onTap: onTap,
        ),
        Divider(
          height: 0,
        )
      ],
    );
  }
}

class ProfileListTile extends StatelessWidget {
  ProfileListTile({Key key, this.subtitle, this.title}) : super(key: key);

  dynamic title;
  dynamic subtitle;

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
