import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/models/crm/sales-target/sales-target-item-result.dart';
import 'package:nandrlon/models/crm/shared/city.dart';
import 'package:nandrlon/services/sales-target.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SalesTargetItemScreen extends StatefulWidget {
  SalesTargetItemScreen({
    Key key,
    this.salesTargetId,
    this.name,
  }) : super(key: key);

  int salesTargetId;
  String name;

  @override
  SalesTargetItemListStateScreen createState() =>
      SalesTargetItemListStateScreen();
}

class SalesTargetItemListStateScreen extends State<SalesTargetItemScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<SalesTargetItemResult> _salesTargets;
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
    getSalesTargetItems();
    super.initState();
  }

  Future<Null> getSalesTargetItems() async {
    var salesTargets =
        await SalesTargetService.getSalesTargetItems(widget.salesTargetId);
    setState(() {
      _salesTargets = salesTargets;
      _isLoading = false;
    });
  }

  Future<Null> _refresh() async {
    getSalesTargetItems();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      key: _scaffoldKey,
      appBar: AppBarWidget(
        title: widget.name,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: ListViewHelper(
            onRefresh: getSalesTargetItems,
            list: _salesTargets,
            itemBuilder: (context, index) {
              return SalesTargetItemListTile(
                salesTarget: _salesTargets[index],
              );
            },
          ),
        ),
      ),
    );
  }
}

class SalesTargetItemListTile extends StatelessWidget {
  SalesTargetItemListTile({
    Key key,
    this.salesTarget,
    this.onTap,
  }) : super(key: key);

  final SalesTargetItemResult salesTarget;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(constBorderRadius)),
      child: ListTile(
        onTap: onTap,
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  salesTarget.itemName,
                  style: TextStyle(
                    color: Color(0xff24272A),
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Text(
                  salesTarget.groupName,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
        subtitle: Container(
          margin: EdgeInsets.only(top: 15),
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
                          fontSize: 8.8,
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
                        "Target",
                        style: TextStyle(
                          color: Color(0xff62656B),
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        "${numberFormat.format(salesTarget.quantity) ?? ""}",
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
                        "Sold",
                        style: TextStyle(
                          color: Color(0xff62656B),
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        "${numberFormat.format(salesTarget.soldQuantity) ?? ""}",
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
