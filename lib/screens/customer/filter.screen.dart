import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/models/crm/customer/customer-group.dart';
import 'package:nandrlon/models/crm/customer/customer-search.dart';
import 'package:nandrlon/models/crm/customer/customer-status.dart';
import 'package:nandrlon/models/crm/shared/city.dart';
import 'package:nandrlon/models/crm/shared/district.dart';
import 'package:nandrlon/services/shared.service.dart';
import 'package:nandrlon/widgets/alert-dialog-widget.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/dropdown.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';

class CustomerFilterScreen extends StatefulWidget {
  CustomerFilterScreen({
    Key key,
    this.cities,
    this.groups,
    this.customerParameters,
    this.customerStatuses,
    this.districts,
  }) : super(key: key);

  List<City> cities;
  CustomerParameters customerParameters;
  List<CustomerStatus> customerStatuses;
  List<CustomerGroup> groups;
  List<District> districts = [];

  @override
  _CustomerFilterScreenState createState() => _CustomerFilterScreenState();
}

class _CustomerFilterScreenState extends State<CustomerFilterScreen> {
  var searchTextEditingController = TextEditingController();
  List<City> _filteredCities = [];
  List<District> _filteredDistricts = [];

  @override
  void initState() {
    super.initState();
    searchTextEditingController.text = widget.customerParameters.searchText;
  }

  onCityChanged(City city) async {
    setState(() {
      widget.customerParameters.city = city;
      widget.customerParameters.cityId = city.id;
      widget.customerParameters.district = null;
      widget.customerParameters.districtId = null;
    });

    final districts = await SharedService.getDistricts(city.id);

    setState(() {
      widget.districts = districts;
    });
  }

  cityModalBottomSheet(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
          return AlterDialogWidget(
            items: _filteredCities,
            onTap: (index) {
              onCityChanged(_filteredCities[index]);
              Navigator.pop(context);
            },
            onSearch: (value) async {
              mystate(() {
                _filteredCities = widget.cities
                    .where((city) => city.name.toLowerCase().contains(value))
                    .toList();
              });
            },
          );
        });
      },
    );
  }

  districtModalBottomSheet() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
          return AlterDialogWidget(
            items: _filteredDistricts,
            onTap: (index) {
              setState(() {
                widget.customerParameters.district = _filteredDistricts[index];
                widget.customerParameters.districtId =
                    _filteredDistricts[index].id;
              });
              Navigator.pop(context);
            },
            onSearch: (value) async {
              mystate(() {
                _filteredDistricts = widget.districts
                    .where((district) =>
                        district.name.toLowerCase().contains(value))
                    .toList();
              });
            },
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "filter".tr(),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                searchTextEditingController.clear();
                widget.customerParameters = CustomerParameters();
              });
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                widget.customerParameters.searchText =
                    searchTextEditingController.text;
                Navigator.pop(context, widget.customerParameters);
              });
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: CardWidget(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFieldWidget(
                    labelText: "Search",
                    controller: searchTextEditingController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButtonWidget(
                    labelText: "Group",
                    value: widget.customerParameters.customerGroup,
                    items: widget.groups.map((CustomerGroup group) {
                      return DropdownMenuItem(
                        value: group,
                        child: Text(
                          group.name,
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic group) {
                      setState(() {
                        widget.customerParameters.customerGroupId = group.id;
                        widget.customerParameters.customerGroup = group;
                      });
                    },
                  ),
                  DropdownButtonWidget(
                    labelText: "Status",
                    value: widget.customerParameters.customerStatus,
                    items: widget.customerStatuses
                        .map((CustomerStatus customerStatus) {
                      return DropdownMenuItem(
                        value: customerStatus,
                        child: Text(
                          customerStatus.name,
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic customerStatus) {
                      setState(() {
                        widget.customerParameters.customerStatusId =
                            customerStatus.id;
                        widget.customerParameters.customerStatus =
                            customerStatus;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _filteredCities = widget.cities;
                      });
                      cityModalBottomSheet(context);
                    },
                    child: TextFieldWidget(
                      labelText: "City",
                      isDropdown: true,
                      enabled: false,
                      isRequired: true,
                      key: Key(widget.customerParameters.city?.name),
                      initialValue: widget.customerParameters.city?.name,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _filteredDistricts = widget.districts;
                      });

                      districtModalBottomSheet();
                    },
                    child: TextFieldWidget(
                      labelText: "District",
                      isDropdown: true,
                      enabled: false,
                      isRequired: true,
                      key: Key(widget.customerParameters.district?.name),
                      initialValue: widget.customerParameters.district?.name,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
