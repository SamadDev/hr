import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nandrlon/screens/doctor/form.screen.dart';
import 'package:nandrlon/screens/doctor/profile.screen.2.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({Key key}) : super(key: key);

  @override
  DoctorListStateScreen createState() => DoctorListStateScreen();
}

class DoctorListStateScreen extends State<DoctorListScreen> {
  List _doctors = [];
  var searchController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  Timer _debounce;

  @override
  void initState() {
    readJson();
    super.initState();
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/json/doctor.json');
    final data = await json.decode(response);

    setState(() {
      if (searchController.text.isEmpty) _doctors = data;
      if (searchController.text.isNotEmpty)
        _doctors = data
            .where((d) => d['name_en']
                .toString()
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
    });
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "search".tr(),
        border: InputBorder.none,
        hintStyle: TextStyle(color: Color(0xff545F7A)),
      ),
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Doctors",
      style: TextStyle(
        color: Color(0xff29304D),
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: Icon(
            Icons.clear,
            color: Theme.of(context).primaryColor,
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
          color: Theme.of(context).primaryColor,
        ),
        onPressed: _startSearch,
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
    _debounce = Timer(const Duration(milliseconds: 500), () {
      readJson();
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
      readJson();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        titleWidget: _isSearching ? _buildSearchField() : _buildTitle(),
        actions: _buildActions(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorFormScreen(),
            ),
          );
        },
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: _doctors.length,
        itemBuilder: (context, index) {
          return DoctorListTile(
            doctor: _doctors[index],
          );
        },
      ),
    );
  }
}

class DoctorListTile extends StatelessWidget {
  DoctorListTile({Key key, this.doctor}) : super(key: key);

  final dynamic doctor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorProfileScreen(
              doctor: doctor,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0xff4F62C0).withOpacity(0.15),
                spreadRadius: 0,
                blurRadius: 3,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    50,
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: doctor['image_id'].toString().isNotEmpty
                        ? NetworkImage(
                            "https://api.dr-online.com/files/${doctor['image_id']}",
                          )
                        : NetworkImage(
                            "https://i2.wp.com/news.microsoft.com/wp-content/themes/microsoft-news-center-2016/assets/img/default-avatar.png?ssl=1",
                          ),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 135,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      doctor['name_en'],
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
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
                        color: Color(0xff9393AA),
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    // Container(
                    //   width: MediaQuery.of(context).size.width - 135,
                    //   child: Text(
                    //     doctor['address_title_en'],
                    //     style: TextStyle(
                    //       color: Color(0xff62656B),
                    //       fontSize: 12,
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 15,
                    // ),
                    1 == 2
                        ? Row(
                            children: [
                              ActionButton(
                                color: Color(0xff2574FF),
                                iconData: Icons.location_on_outlined,
                                url:
                                    'https://www.google.com/maps/search/?api=1&query=${doctor["latlng"]}',
                              ),
                              ActionButton(
                                color: Color(0xff12B2B3),
                                iconData: Icons.call_outlined,
                                url: doctor['phone_no'],
                              ),
                              ActionButton(
                                color: Color(0xff1DA1F2),
                                iconData: Icons.mail_outline,
                                url: doctor['email'],
                              ),
                            ],
                          )
                        : Container()
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
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
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
