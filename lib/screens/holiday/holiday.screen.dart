import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/models/hrms/holiday/holiday-parametres.dart';
import 'package:nandrlon/models/hrms/holiday/holiday.mode.dart';
import 'package:nandrlon/models/user.model.dart';
import 'package:nandrlon/screens/holiday/filter.screen.dart';
import 'package:nandrlon/services/team.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HolidayScreen extends StatefulWidget {
  HolidayScreen({Key key}) : super(key: key);

  @override
  State<HolidayScreen> createState() => _HolidayScreenState();
}

class _HolidayScreenState extends State<HolidayScreen> {
  bool _isSearching = false;
  var _holidayParameters = new HolidayParameters();
  var searchController = TextEditingController();
  String searchQuery = "Search query";
  List<Holiday> _holidays;
  Timer _debounce;

  @override
  void initState() {
    onLoad();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> onLoad() async {
    var result = await TeamService.getHolidaies(_holidayParameters);

    var holidays = result['holidays']
        .map<Holiday>((json) => Holiday.fromJson(json))
        .toList();

    setState(() {
      _holidays = holidays;
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
          color: Colors.white,
        ),
      ),
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  Widget _buildTitle() {
    return Text(
      "holidays".tr(),
      style: TextStyle(
        fontSize: context.locale.languageCode == "en" ? 20 : 15,
        fontFamily: getFontFamily(context),
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
          var holidayParameters = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HolidayFilterScreen(
                holidayParameters: _holidayParameters,
              ),
            ),
          );

          if (holidayParameters != null) {
            setState(() {
              _holidayParameters = holidayParameters;
            });

            onLoad();
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
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _holidayParameters.name = newQuery;
      onLoad();
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
      onLoad();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        titleWidget: _isSearching ? _buildSearchField() : _buildTitle(),
        actions: _buildActions(),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: ListViewHelper(
          onRefresh: onLoad,
          list: _holidays,
          itemBuilder: (context, index) {
            return HolidayListTile(
              holiday: _holidays[index],
            );
          },
        ),
      ),
    );
  }
}

class HolidayListTile extends StatelessWidget {
  HolidayListTile({
    Key key,
    this.holiday,
    this.onPressed,
    this.onTap,
  }) : super(key: key);

  final Holiday holiday;
  final VoidCallback onPressed;
  GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: EdgeInsets.only(bottom: 10, top: 5),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: isLTR(context) ? 15 : 0,
                    right: isLTR(context) ? 0 : 15,
                    top: 8),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.park_outlined,
                            size: 17,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          holiday.name,
                          style: TextStyle(
                            color: Color(0xff0F1B2D),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "(${holiday.noOfDays.toString()} " +
                              "days".tr() +
                              ")",
                          style: TextStyle(
                            fontFamily: getFontFamily(context),
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 50),
            child: Row(
              children: [
                HolidayItem(
                  title: "from_date".tr(),
                  value: holiday.fromDate.substring(0, 10),
                ),
                HolidayItem(
                  title: "to_date".tr(),
                  value: holiday.toDate.substring(0, 10),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class HolidayItem extends StatelessWidget {
  HolidayItem({
    Key key,
    this.title,
    this.value,
    this.icon,
    this.iconColor,
    this.valueColor,
    this.iconBackgroundColor,
  }) : super(key: key);

  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color valueColor;
  final Color iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width / 2.6),
      padding: EdgeInsets.only(
          left: isLTR(context) ? 15 : 0,
          right: isLTR(context) ? 0 : 15,
          top: 15,
          bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              fontFamily: getFontFamily(context),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor == null ? Color(0xff0F1B2D) : valueColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
