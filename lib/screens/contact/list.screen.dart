import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/models/crm/contact/contact-parameter.dart';
import 'package:nandrlon/models/crm/contact/contact-result.dart';
import 'package:nandrlon/models/crm/shared/city.dart';
import 'package:nandrlon/screens/contact/filter.screen.dart';
import 'package:nandrlon/screens/contact/form.screen.dart';
import 'package:nandrlon/services/city.service.dart';
import 'package:nandrlon/services/contact.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/image.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen();

  @override
  ContactListStateScreen createState() => ContactListStateScreen();
}

class ContactListStateScreen extends State<ContactListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<ContactResult> _contacts;
  ContactParameters _contactParameters;
  var searchController = TextEditingController();
  bool _isSearching = false;
  bool _isLoading = true;
  String searchQuery = "Search query";
  Timer _debounce;
  dynamic _speciality;
  dynamic _city;
  List<City> _cities;

  @override
  void initState() {
    _contactParameters = new ContactParameters();
    getContacts();
    getCities();
    super.initState();
  }

  getCities() async {
    var cities = await CityService.cities();

    setState(() {
      _cities = cities;
    });
  }

  getContacts() async {
    var contacts = await ContactService.getContacts(_contactParameters);
    setState(() {
      _contacts = contacts;
      _isLoading = false;
    });
  }

  showProfile(ContactResult contact) {
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  ImageWidget(
                    width: 80,
                    height: 80,
                    errorText: contact.name[0],
                    errorTextFontSize: 30,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    contact.name ?? "",
                    style: TextStyle(
                      color: Color(0xff29304D),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ActionButton(
                          color: Color(0xff2574FF),
                          iconData: Icons.edit,
                          onTap: () async {
                            Navigator.pop(context);

                            var isSaved = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContactFormScreen(
                                  contactId: contact.id,
                                ),
                              ),
                            );

                            if (isSaved == true) {
                              setState(() {
                                _isLoading = true;
                              });
                              getContacts();
                            }
                          },
                        ),
                        ActionButton(
                          color: Color(0xff12B2B3),
                          iconData: Icons.call_outlined,
                        ),
                        ActionButton(
                          color: Color(0xff1DA1F2),
                          iconData: Icons.mail_outline,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ContactProfileListTile(
                    icon: Icons.location_city_outlined,
                    title: "Customer",
                    subtitle: contact.customerName ?? "",
                  ),
                  ContactProfileListTile(
                    icon: Icons.work_outline,
                    title: "Job Title",
                    subtitle: contact.jobTitle ?? "",
                  ),
                  ContactProfileListTile(
                    icon: Icons.wc,
                    title: "Gender",
                    subtitle: contact.genderName ?? "",
                  ),
                  ContactProfileListTile(
                    icon: Icons.language,
                    title: "Spoken Language",
                    subtitle: contact.languageName ?? "",
                  ),
                  ContactProfileListTile(
                    icon: Icons.phone_outlined,
                    title: "Phone No",
                    subtitle: contact.phoneNo1 ?? "",
                    onTap: () async {
                      if (await canLaunch("tel:+" + contact.phoneNo1)) {
                        await launch("tel:+" + contact.phoneNo1);
                      } else {
                        throw 'call not possible';
                      }
                    },
                  ),
                  ContactProfileListTile(
                    icon: Icons.email_outlined,
                    title: "Email",
                    subtitle: contact.phoneNo1 ?? "",
                    onTap: () async {
                      if (await canLaunch("mailto:" + contact.email)) {
                        await launch("mailto:" + contact.email);
                      } else {
                        throw 'call not possible';
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildSearchField() {
    return TextFormField(
      autofocus: true,
      initialValue: _contactParameters.searchText,
      decoration: InputDecoration(
        hintText: "search".tr(),
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Contacts",
      style: TextStyle(
        color: Colors.white,
      ),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () {
            if (searchController == null || searchController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: Icon(
          Icons.search,
          color: Colors.white,
        ),
        onPressed: _startSearch,
      ),
      IconButton(
        icon: Icon(
          Icons.filter_alt_outlined,
          color: Colors.white,
        ),
        onPressed: () async {
          var contactParameters = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactFilterScreen(
                cities: _cities,
                contactParameters: _contactParameters,
              ),
            ),
          );

          if (contactParameters != null) {
            setState(() {
              _contacts = null;
              _contactParameters = contactParameters;
            });

            getContacts();
          }
        },
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _contacts = null;
        _contactParameters.searchText = newQuery;
      });
      getContacts();
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      searchController.clear();
      updateSearchQuery("");
      getContacts();
    });
  }

  Future<Null> _refresh() async {
    var contacts = await ContactService.getContacts(_contactParameters);
    setState(() {
      _contacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          var isSaved = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactFormScreen(
                contactId: 0,
              ),
            ),
          );

          if (isSaved != null) {
            getContacts();
          }
        },
      ),
      appBar: AppBarWidget(
        titleWidget: _isSearching ? _buildSearchField() : _buildTitle(),
        actions: _buildActions(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: CardWidget(
            padding: const EdgeInsets.only(top: 5),
            child: ListViewHelper(
              onRefresh: _refresh,
              list: _contacts,
              itemBuilder: (context, index) {
                return ContactListTile(
                    contact: _contacts[index],
                    onTap: () {
                      showProfile(_contacts[index]);
                    });
              },
            ),
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

  final ContactResult contact;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        ListTile(
          onTap: onTap,
          leading: Stack(
            children: [
              ImageWidget(
                errorText: contact.name[0].toString().toUpperCase(),
                errorTextFontSize: 16,
                radius: 50,
              ),
              Positioned(
                top: 5,
                right: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: contact.isActive == true ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            contact.name.toTitleCase(),
            style: TextStyle(
              color: Color(0xff24272A),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            contact.customerName,
            style: TextStyle(
              color: Color(0xff62656B),
              fontSize: 13,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 70),
          child: Divider(
            height: 0,
          ),
        ),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  ActionButton({Key key, this.color, this.iconData, this.onTap})
      : super(key: key);

  IconData iconData;
  Color color;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: color,
        ),
        child: Icon(
          iconData,
          size: 15,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ContactProfileListTile extends StatelessWidget {
  ContactProfileListTile({
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
            margin: EdgeInsets.only(top: 10,left: 10),
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
