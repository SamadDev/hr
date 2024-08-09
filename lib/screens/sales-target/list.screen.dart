import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/models/crm/sales-target/sales-target-parameter.dart';
import 'package:nandrlon/models/crm/sales-target/sales-target.dart';
import 'package:nandrlon/models/crm/shared/city.dart';
import 'package:nandrlon/screens/sales-target/item.screen.dart';
import 'package:nandrlon/services/sales-target.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SalesTargetScreen extends StatefulWidget {
  const SalesTargetScreen({Key key}) : super(key: key);

  @override
  SalesTargetListStateScreen createState() => SalesTargetListStateScreen();
}

class SalesTargetListStateScreen extends State<SalesTargetScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<SalesTarget> _salesTargets;
  SalesTargetParameters _salesTargetParameters;
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
    _salesTargetParameters = new SalesTargetParameters();
    getSalesTargets();
    super.initState();
  }

  getSalesTargets() async {
    var salesTargets =
        await SalesTargetService.getSalesTargets(_salesTargetParameters);
    setState(() {
      _salesTargets = salesTargets;
      _isLoading = false;
    });
  }

  Widget _buildSearchField() {
    return TextFormField(
      autofocus: true,
      initialValue: _salesTargetParameters.searchText,
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
      "Sales Targets",
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
        onPressed: () async {},
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
        _salesTargets = null;
        _salesTargetParameters.searchText = newQuery;
      });
      getSalesTargets();
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
      getSalesTargets();
    });
  }

  Future<Null> _refresh() async {
    var salesTargets =
        await SalesTargetService.getSalesTargets(_salesTargetParameters);
    setState(() {
      _salesTargets = salesTargets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      key: _scaffoldKey,
      appBar: AppBarWidget(
        titleWidget: _isSearching ? _buildSearchField() : _buildTitle(),
        actions: _buildActions(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: ListViewHelper(
            onRefresh: _refresh,
            list: _salesTargets,
            itemBuilder: (context, index) {
              return SalesTargetListTile(
                  salesTarget: _salesTargets[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SalesTargetItemScreen(
                          salesTargetId: _salesTargets[index].id,
                          name: _salesTargets[index].name,
                        ),
                      ),
                    );
                  });
            },
          ),
        ),
      ),
    );
  }
}

class SalesTargetListTile extends StatelessWidget {
  SalesTargetListTile({
    Key key,
    this.salesTarget,
    this.onTap,
  }) : super(key: key);

  final SalesTarget salesTarget;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(constBorderRadius)),
      child: ListTile(
        onTap: onTap,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Icon(
                    Icons.track_changes_outlined,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  salesTarget.name,
                  style: TextStyle(
                    color: Color(0xff24272A),
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            Text(
              "${salesTarget.noOfItems ?? ""}",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        subtitle: Container(
          margin: EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10),
                child: SizedBox(
                  width: 30,
                  child: new CircularPercentIndicator(
                    radius: 50.0,
                    lineWidth: 4.0,
                    percent: salesTarget.targetPercent / 100,
                    backgroundColor: Color(0xffD8D8D8),
                    center: new Text(
                      "${salesTarget.targetPercent}%",
                      style: TextStyle(
                          fontSize: 9,
                          color: Color(0xff4F62C0),
                          fontWeight: FontWeight.bold),
                    ),
                    progressColor: Color(0xff4F62C0),
                  ),
                ),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "From Date",
                        style: TextStyle(
                          color: Color(0xff62656B),
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        salesTarget.fromDate ?? "",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "To Date",
                        style: TextStyle(
                          color: Color(0xff62656B),
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        salesTarget.fromDate ?? "",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TargetCircleProgressBar extends StatelessWidget {
  TargetCircleProgressBar({
    Key key,
    this.title,
    this.subTitle,
    this.isPrimary,
    this.percentage,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final double percentage;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: (width / 2) - 25,
      height: 100,
      decoration: BoxDecoration(
        color: isPrimary ? Theme.of(context).primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.15),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 10), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: !isPrimary
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  subTitle,
                  style: TextStyle(
                    color: !isPrimary
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
