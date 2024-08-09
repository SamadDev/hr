import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nandrlon/models/crm/customer/customer-result.dart';
import 'package:nandrlon/models/crm/deal/deal-parameter.dart';
import 'package:nandrlon/models/crm/deal/deal-result.dart';
import 'package:nandrlon/screens/deal/form.screen.dart';
import 'package:nandrlon/services/deal.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:easy_localization/easy_localization.dart';

var numberFormat = NumberFormat('###,###.##', 'en_Us');

class DealListScreen extends StatefulWidget {
  DealListScreen({
    Key key,
    this.customer,
    this.isReadOnly,
  }) : super(key: key);

  CustomerResult customer;
  bool isReadOnly;

  @override
  MediaStateScreen createState() => MediaStateScreen();
}

class MediaStateScreen extends State<DealListScreen> {
  var searchController = TextEditingController();
  DealParameters _dealParameters;
  List<DealResult> _deals;
  bool _isSearching = false;
  String searchQuery = "Search query";
  Timer _debounce;
  bool _isLoading = true;

  @override
  void initState() {
    _dealParameters = DealParameters();
    _dealParameters.customerId = widget.customer.id;
    getDeal();
    super.initState();
  }

  Future<void> getDeal() async {
    setState(() {
      _isLoading = true;
    });
    var deals = await DealService.getDeals(_dealParameters);
    setState(() {
      _deals = deals;
      _isLoading = false;
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
      "Deals",
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
    _debounce = Timer(const Duration(milliseconds: 100), () {});
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        titleWidget: _isSearching ? _buildSearchField() : _buildTitle(),
        actions: _buildActions(),
      ),
      floatingActionButton: widget.isReadOnly == true
          ? Container()
          : FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () async {
                var isSaved = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DealFormScreen(
                      customerId: widget.customer.id,
                    ),
                  ),
                );

                if (isSaved) {
                  getDeal();
                }
              },
            ),
      body: Container(
        margin: EdgeInsets.only(top: 15),
        child: ListViewHelper(
          list: _deals,
          onRefresh: () => getDeal(),
          itemBuilder: (context, index) {
            return DealListTile(
              deal: _deals[index],
              isFirst: index == 0,
              isLast: index == _deals.length - 1,
            );
          },
        ),
      ),
    );
  }
}

class DealListTile extends StatelessWidget {
  DealListTile({
    Key key,
    this.deal,
    this.onTap,
    this.isFirst,
    this.isLast,
  }) : super(key: key);

  final DealResult deal;
  GestureTapCallback onTap;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  deal.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  deal.stage ?? "",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  deal.date.toString(),
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            Text(
              "${deal.currency} ${numberFormat.format(deal.amount)}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
