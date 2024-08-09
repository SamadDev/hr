import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nandrlon/models/crm/customer-inventory/customer-inventory-result.dart';
import 'package:nandrlon/models/crm/customer/customer-result.dart';
import 'package:nandrlon/screens/customer-inventory/detail.dart';
import 'package:nandrlon/screens/customer-inventory/form.dart';
import 'package:nandrlon/services/customer-inventory.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomerInventoryListScreen extends StatefulWidget {
  CustomerInventoryListScreen({
    Key key,
    this.customer,
    this.isReadOnly,
  }) : super(key: key);
  CustomerResult customer;
  bool isReadOnly;

  @override
  _CustomerInventoryListScreenState createState() =>
      _CustomerInventoryListScreenState();
}

class _CustomerInventoryListScreenState
    extends State<CustomerInventoryListScreen> {
  var searchController = TextEditingController();
  String searchQuery = "Search query";
  List<CustomerInventoryResult> _inventories;
  bool _isSearching = false;
  Timer _debounce;

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  @override
  void dispose() {
    super.dispose();
  }

  onLoad() async {
    var inventories = await CustomerInventoryService.getCustomerInventories();

    setState(() {
      _inventories = inventories;
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
      "Inventories",
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
    _debounce = Timer(const Duration(milliseconds: 100), () {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      floatingActionButton: widget.isReadOnly == true
          ? Container()
          : FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () async {
                var note = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerInventoryFormScreen(
                      customer: widget.customer,
                    ),
                  ),
                );

                if (note != null) {
                  onLoad();
                }
              },
            ),
      appBar: AppBarWidget(
        titleWidget: _isSearching ? _buildSearchField() : _buildTitle(),
        actions: _buildActions(),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15),
        child: ListViewHelper(
          list: _inventories,
          onRefresh: () => onLoad(),
          itemBuilder: (context, index) {
            return CustomerInventoryListTile(
              inventory: _inventories[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerInventoryDetailScreen(
                      id: _inventories[index].id,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class CustomerInventoryListTile extends StatelessWidget {
  CustomerInventoryListTile({
    Key key,
    this.inventory,
    this.onTap,
  }) : super(key: key);

  final CustomerInventoryResult inventory;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
      padding: EdgeInsets.symmetric(vertical: 10),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(5),
      // ),
      child: ListTile(
        onTap: onTap,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              inventory.date,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
