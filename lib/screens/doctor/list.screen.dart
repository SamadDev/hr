import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/screens/doctor/filter.screen.dart';
import 'package:nandrlon/screens/doctor/form.screen.dart';
import 'package:nandrlon/screens/doctor/profile.screen.2.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/image.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:easy_localization/easy_localization.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen();

  @override
  DoctorListStateScreen createState() => DoctorListStateScreen();
}

class DoctorListStateScreen extends State<DoctorListScreen> {
  List _doctors = [];
  var searchController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  Timer _debounce;
  dynamic _speciality;
  dynamic _city;

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
        hintStyle: TextStyle(
          color: Color(0x8024272A),
        ),
      ),
      style: TextStyle(
        color: Color(0xff24272A),
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
      IconButton(
        icon: Icon(
          Icons.filter_alt_outlined,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorFilterScreen(
                city: _city,
                speciality: _speciality,
              ),
            ),
          );
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
        backgroundColor: Theme.of(context).primaryColor,
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorProfileScreen(
                    doctor: _doctors[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DoctorListTile extends StatelessWidget {
  DoctorListTile({
    Key key,
    this.doctor,
    this.onTap,
  }) : super(key: key);

  final dynamic doctor;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                ImageWidget(
                  imageUrl: doctor['image_id'].toString().isEmpty
                      ? ""
                      : "https://api.dr-online.com/files/${doctor['image_id']}",
                  errorText: doctor['name_en'][0].toString().toUpperCase(),
                  radius: 50,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor['name_en'].toString().toTitleCase(),
                      style: TextStyle(
                        color: Color(0xff24272A),
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
                        color: Color(0xff62656B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
          ),
        ],
      ),
    );
  }
}
