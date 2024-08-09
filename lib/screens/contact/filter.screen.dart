import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/models/crm/contact/contact-parameter.dart';
import 'package:nandrlon/models/crm/customer/customer.dart';
import 'package:nandrlon/models/crm/shared/city.dart';
import 'package:nandrlon/models/crm/shared/district.dart';
import 'package:nandrlon/services/customer.service.dart';
import 'package:nandrlon/services/shared.service.dart';
import 'package:nandrlon/widgets/alert-dialog-widget.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';

class ContactFilterScreen extends StatefulWidget {
  ContactFilterScreen({
    Key key,
    this.cities,
    this.contactParameters,
  }) : super(key: key);

  List<City> cities;
  ContactParameters contactParameters;

  @override
  _ContactFilterScreenState createState() => _ContactFilterScreenState();
}

class _ContactFilterScreenState extends State<ContactFilterScreen> {
  var searchTextEditingController = TextEditingController();
  FocusNode focusNode;
  final formKey = GlobalKey<FormState>();
  List<City> _filteredCities = [];
  List<District> _filteredDistricts = [];
  List<District> _districts = [];
  List<Customer> _customers = [];

  @override
  void initState() {
    focusNode = new FocusNode();
    searchTextEditingController.text = widget.contactParameters.searchText;
    super.initState();
  }

  onCityChanged(City city) async {
    final districts = await SharedService.getDistricts(city.id);

    setState(() {
      _districts = districts;
    });

    setState(() {
      widget.contactParameters.city = city;
      widget.contactParameters.cityId = city.id;
      widget.contactParameters.district = null;
      widget.contactParameters.districtId = null;
    });
  }

  Future<List<Customer>> getCustomers(searchText) async {
    return await CustomerService.filter(searchText);
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

  customerModalBottomSheet(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
          return AlterDialogWidget(
            items: _customers,
            onTap: (index) {
              setState(() {
                widget.contactParameters.customer = _customers[index];
                widget.contactParameters.customerId = _customers[index].id;
              });
              Navigator.pop(context);
            },
            onSearch: (value) async {
              var customers = await getCustomers(value);
              mystate(() {
                _customers = customers;
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
                widget.contactParameters.district = _filteredDistricts[index];
                widget.contactParameters.districtId =
                    _filteredDistricts[index].id;
              });
              Navigator.pop(context);
            },
            onSearch: (value) async {
              mystate(() {
                _filteredDistricts = _districts
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

  customerModalBottomSheet1() {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, mystate) => Column(
              children: [
                Container(
                  padding: showModalBottomSheetPadding,
                  child: TextFieldWidget(
                    iconData: Icons.search,
                    hintText: "search".tr(),
                    onChanged: (value) async {
                      var customers = await getCustomers(value);
                      mystate(() {
                        _customers = customers;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _customers.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            title: new Text(_customers[index].name),
                            onTap: () {
                              setState(() {
                                widget.contactParameters.customer =
                                    _customers[index];
                                widget.contactParameters.customerId =
                                    _customers[index].id;
                              });
                              Navigator.pop(context);
                            },
                          ),
                          Divider(
                            height: 0,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
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
                widget.contactParameters.customer = null;
                widget.contactParameters.city = null;
                widget.contactParameters.district = null;
                widget.contactParameters.searchText = null;
                searchTextEditingController.clear();
                widget.contactParameters = ContactParameters();
              });
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                widget.contactParameters.searchText =
                    searchTextEditingController.text;
                Navigator.pop(context, widget.contactParameters);
              });
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: SafeArea(
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
                    GestureDetector(
                      onTap: () => customerModalBottomSheet(context),
                      child: TextFieldWidget(
                        labelText: "Customer",
                        isDropdown: true,
                        enabled: false,
                        key: Key(widget.contactParameters.customer?.name),
                        isRequired: true,
                        initialValue:
                            widget.contactParameters.customer?.name ?? "",
                      ),
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
                        key: Key(widget.contactParameters.city?.name),
                        enabled: false,
                        isRequired: true,
                        initialValue: widget.contactParameters.city?.name,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _filteredDistricts = _districts;
                        });

                        districtModalBottomSheet();
                      },
                      child: TextFieldWidget(
                        labelText: "District",
                        isDropdown: true,
                        enabled: false,
                        key: Key(widget.contactParameters.district?.name),
                        isRequired: true,
                        initialValue: widget.contactParameters.district?.name,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
