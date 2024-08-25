import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nandrlon/models/crm/customer/customer-group.dart';
import 'package:nandrlon/models/crm/customer/customer-result.dart';
import 'package:nandrlon/models/crm/customer/customer-search.dart';
import 'package:nandrlon/models/crm/customer/customer-status.dart';
import 'package:nandrlon/models/crm/shared/city.dart';
import 'package:nandrlon/models/crm/shared/district.dart';
import 'package:nandrlon/models/crm/shared/source.dart';
import 'package:nandrlon/screens/customer/filter.screen.dart';
import 'package:nandrlon/screens/customer/form.screen.dart';
import 'package:nandrlon/screens/customer/profile.screen.dart';
import 'package:nandrlon/services/city.service.dart';
import 'package:nandrlon/services/customer.service.dart';
import 'package:nandrlon/services/source.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/image.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:nandrlon/widgets/loading.widget.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen();

  @override
  CustomerListStateScreen createState() => CustomerListStateScreen();
}

class CustomerListStateScreen extends State<CustomerListScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<CustomerResult> _customers;
  var searchController = TextEditingController();
  bool _isSearching = false;
  bool _isLoading = true;
  String searchQuery = "Search query";
  Timer _debounce;
  CustomerParameters _customerParameters;
  List<City> _cities;
  List<Source> _sources = [];
  List<CustomerGroup> _customerGroups;
  CustomerGroup _customerGroup;
  List<CustomerStatus> _customerStatuses;
  List<District> districts = [];

  @override
  void initState() {
    _customerParameters = new CustomerParameters();
    getGroups();
    getCustomer();
    getCustomerStatuses();
    getCities();
    getSources();
    super.initState();
  }

  getCustomer() async {
    var customers = await CustomerService.customers(_customerParameters);
    setState(() {
      _customers = customers;
      _isLoading = false;
    });
  }

  Future<void> getSources() async {
    final sources = await SourceService.getSources();

    setState(() {
      _sources = sources;
    });
  }

  List<CustomerResult> getCustomerByGroup(customerGroupId) {
    return _customers
        .where((element) => element.customerGroupId == customerGroupId)
        .toList();
  }

  getCities() async {
    var cities = await CityService.cities();

    setState(() {
      _cities = cities;
    });
  }

  getCustomerStatuses() async {
    var customerStatuses = await CustomerService.customerStatuses();
    setState(() {
      _customerStatuses = customerStatuses;
    });
  }

  getGroups() async {
    var groups = await CustomerService.customerGroups();
    setState(() {
      _tabController = new TabController(
        length: groups.length,
        vsync: this,
      );
      _customerGroup = groups[0];
      _customerGroups = groups;
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
      ),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Customers",
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
          var customerParameters = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerFilterScreen(
                cities: _cities,
                groups: _customerGroups,
                customerStatuses: _customerStatuses,
                customerParameters: _customerParameters,
                districts: districts,
              ),
            ),
          );

          if (customerParameters != null) {
            setState(() {
              _customers = null;
              _customerParameters = customerParameters;
            });

            getCustomer();
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
    _debounce = Timer(const Duration(milliseconds: 100), () {
      setState(() {
        _customers = null;
        _customerParameters.searchText = newQuery;
      });
      getCustomer();
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
      // readJson();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        size: 105,
        titleWidget: _isSearching ? _buildSearchField() : _buildTitle(),
        actions: _buildActions(),
        bottom: _customers == null || _customerGroups == null
            ? PreferredSize(
                preferredSize: Size.fromHeight(100),
                child: Container(),
              )
            : TabBar(
                isScrollable: true,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                controller: _tabController,
                onTap: (index) {
                  setState(() {
                    _customerGroup = _customerGroups[index];
                  });
                },
                tabs: [
                    if (_customerGroups != null)
                      for (var customerGroup in _customerGroups)
                        Tab(
                          text: customerGroup.name,
                        ),
                  ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () async {
          var customer = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerFormScreen(
                customerGroup: _customerGroup,
                customerGroups: _customerGroups,
                cities: _cities,
                sources: _sources,
              ),
            ),
          );

          if (customer != null) {
            await getCustomer();
          }
        },
      ),
      body: _customers == null || _customerGroups == null
          ? LoadingWidget()
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: CardWidget(
                  child: TabBarView(controller: _tabController, children: [
                    for (var customerGroup in _customerGroups)
                      Container(
                        padding: const EdgeInsets.only(top: 5),
                        child: ListViewHelper(
                          onRefresh: () => getCustomer(),
                          list: getCustomerByGroup(customerGroup.id),
                          itemBuilder: (context, index) {
                            return CustomerListTile(
                              customer:
                                  getCustomerByGroup(customerGroup.id)[index],
                              onTap: () async {
                                var isUpdated = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CustomerProfileScreen(
                                      customerGroups: _customerGroups,
                                      cities: _cities,
                                      sources: _sources,
                                      customer: getCustomerByGroup(
                                          customerGroup.id)[index],
                                    ),
                                  ),
                                );

                                if (isUpdated == true) {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  getCustomer();
                                }
                              },
                            );
                          },
                        ),
                      ),
                  ]),
                ),
              ),
            ),
    );
  }
}

class CustomerListTile extends StatelessWidget {
  CustomerListTile({
    Key key,
    this.customer,
    this.onTap,
  }) : super(key: key);

  final CustomerResult customer;
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
                errorText: customer.name == null
                    ? ""
                    : customer.name[0].toString().toUpperCase(),
                errorTextFontSize: 16,
                radius: 50,
              ),
              Positioned(
                top: 5,
                right: 3,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: customer.statusName == "Active"
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            customer.name ?? "",
            style: TextStyle(
              color: Color(0xff24272A),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            "${customer.cityName == null ? "" : customer.cityName}",
            style: TextStyle(
              color: Color(0xff62656B),
              fontSize: 13,
            ),
          ),
          // trailing: Container(
          //   width: 55,
          //   height: 23,
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(15),
          //       color: changeColor(customer.statusColor)),
          //   child: Center(
          //     child: Text(
          //       customer.status,
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 11,
          //       ),
          //     ),
          //   ),
          // ),
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
