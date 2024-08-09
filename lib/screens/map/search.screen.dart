import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/models/crm/customer/customer-group.dart';
import 'package:nandrlon/models/crm/customer/customer-result.dart';
import 'package:nandrlon/models/crm/customer/customer-search.dart';
import 'package:nandrlon/models/crm/shared/district.dart';
import 'package:nandrlon/services/customer.service.dart';
import 'package:nandrlon/services/shared.service.dart';
import 'package:nandrlon/widgets/image.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/loading.widget.dart';
import 'package:easy_localization/easy_localization.dart';

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({Key key}) : super(key: key);

  @override
  _MapSearchScreenState createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  CustomerParameters _customerParameters;
  List<CustomerGroup> _customerGroups;
  bool _isLoading = true;
  var searchController = TextEditingController();
  List<CustomerResult> _customers;
  List<District> _districts;
  List<District> _filterDistricts;
  SearchType _searchType = SearchType.Customer;

  @override
  void initState() {
    _customerParameters = new CustomerParameters();
    onLoad();
    super.initState();
  }

  onLoad() async {
    await getDistricts();
    await getGroups();
    await getCustomer();
  }

  getCustomer() async {
    setState(() {
      _customers = [];
    });
    _customerParameters.searchText = searchController.text;
    var customers = await CustomerService.customers(_customerParameters);
    setState(() {
      _isLoading = false;
      _customers = customers;
    });
  }

  getGroups() async {
    var groups = await CustomerService.customerGroups();
    setState(() {
      _customerGroups = groups;
    });
  }


  Future<void> loadDistrict() async {
    setState(() {
      _searchType = SearchType.District;
      _districts = [];
    });

    final String response =
    await rootBundle.loadString('assets/json/district.json');
    var districts = await json.decode(response);

    if (searchController.text.isEmpty) {
      setState(() {
        _districts = districts;
      });
    } else {
      districts = districts
          .where((d) => d['name']
          .toString()
          .toLowerCase()
          .contains(searchController.text.toLowerCase()))
          .toList();
      setState(() {
        _districts = districts;
      });
    }
  }

  Future<void> getDistricts() async {
    setState(() {
      _districts = [];
    });

    final districts = await SharedService.getDistricts(9);

    setState(() {
      _districts = districts;
    });
  }

  Future<void> searchDistricts() async {
    setState(() {
      _searchType = SearchType.District;
      _filterDistricts = [];
    });

    var filterDistricts = _districts.where((d) => d.name.toLowerCase().contains(searchController.text.toLowerCase())).toList();

    setState(() {
      _filterDistricts = filterDistricts;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: TextField(
                  controller: searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "search".tr(),
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  style: TextStyle(
                    color: Color(0xff24272A),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (query) {
                    if (_searchType == SearchType.Customer)
                      getCustomer();
                    else if (_searchType == SearchType.District) searchDistricts();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              height: 80,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  PopupMenuButton<CustomerGroup>(
                    child: SearchListTile(
                      title: _customerParameters.customerGroup == null
                          ? "Customer"
                          : _customerParameters.customerGroup.name,
                      icon: Icons.person_outline,
                      isActive: _searchType == SearchType.Customer,
                    ),
                    onSelected: (CustomerGroup customerGroup) {
                      setState(() {
                        _isLoading = true;
                        _customerParameters.customerGroup = customerGroup;
                        _customerParameters.customerGroupId = customerGroup.id;
                        _searchType = SearchType.Customer;
                      });
                      getCustomer();
                    },
                    itemBuilder: (BuildContext context) {
                      return _customerGroups.map((CustomerGroup customerGroup) {
                        return PopupMenuItem<CustomerGroup>(
                          value: customerGroup,
                          child: Text(customerGroup.name),
                        );
                      }).toList();
                    },
                  ),
                  SearchListTile(
                    title: "District",
                    icon: Icons.location_on_outlined,
                    onTap: () {
                      searchDistricts();
                    },
                    isActive: _searchType == SearchType.District,
                  ),
                  SearchListTile(
                    title: "More",
                    icon: Icons.more_horiz,
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 8,
              color: Colors.grey.shade300,
            ),
            _isLoading
                ? Container(
                    height: MediaQuery.of(context).size.height - 200,
                    child: LoadingWidget())
                : Column(
                    children: [
                      if (_searchType == SearchType.Customer)
                        for (var customer in _customers)
                          CustomerListTile(
                            customer: customer,
                            onTap: () {
                              dynamic data = {};
                              data['id'] = customer.id;
                              data['name'] = customer.name;
                              data['type'] = "customer";
                              data['longitude'] = customer.longitude == null
                                  ? 0
                                  : double.tryParse(customer.longitude);
                              data['latitude'] = customer.longitude == null
                                  ? 0
                                  : double.tryParse(customer.latitude);
                              data['group'] = customer.groupName;
                              data['content'] = customer;

                              Navigator.pop(
                                context,
                                data,
                              );
                            },
                          ),
                      if (_searchType == SearchType.District)
                        for (var district in _filterDistricts)
                          DistrictListTile(
                            district: district,
                            onTap: () {
                              dynamic data = {};
                              data['id'] = district.id;
                              data['name'] = district.name;
                              data['type'] = "district";

                              // data['longitude'] = district["longitude"];
                              // data['latitude'] = district["latitude"];
                              data['group'] = "district";

                              Navigator.pop(
                                context,
                                data,
                              );
                            },
                          )
                    ],
                  ),
          ],
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
          leading: Container(
            height: 45,
            width: 45,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0x80839daf),
            ),
            child: Center(
              child: Text(
                customer.name == null
                    ? ""
                    : customer.name[0].toString().toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          title: Text(
            customer.name ?? "",
            style: TextStyle(
              color: Color(0xff24272A),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          subtitle: Text(
            customer.groupName,
            style: TextStyle(
              color: Color(0xff62656B),
              fontSize: 12,
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

class DistrictListTile extends StatelessWidget {
  DistrictListTile({
    Key key,
    this.district,
    this.onTap,
  }) : super(key: key);

  final District district;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Text(
              district.name.toString().toTitleCase(),
              style: TextStyle(
                color: Color(0xff24272A),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
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

class SearchListTile extends StatelessWidget {
  const SearchListTile({
    Key key,
    this.onTap,
    this.icon,
    this.title,
    this.isActive,
  }) : super(key: key);

  final GestureTapCallback onTap;
  final IconData icon;
  final String title;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 20),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).primaryColor.withOpacity(0.2),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 18,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    isActive == true ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum SearchType { Customer, Doctor, District, More }
