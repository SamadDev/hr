
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nandrlon/models/crm/customer/customer-group.dart';
import 'package:nandrlon/models/crm/customer/customer.dart';
import 'package:nandrlon/models/crm/shared/city.dart';
import 'package:nandrlon/models/crm/shared/district.dart';
import 'package:nandrlon/models/crm/shared/entity-mode.dart';
import 'package:nandrlon/models/crm/shared/source.dart';
import 'package:nandrlon/services/customer.service.dart';
import 'package:nandrlon/services/shared.service.dart';
import 'package:nandrlon/services/source.service.dart';
import 'package:nandrlon/widgets/alert-dialog-widget.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/dropdown.widget.dart';
import 'package:nandrlon/widgets/form.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/loading.widget.dart';
import 'package:nandrlon/widgets/map.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';

class CustomerFormScreen extends StatefulWidget {
  CustomerFormScreen({
    Key key,
    this.customer,
    this.customerGroup,
    this.customerGroups,
    this.cities,
    this.sources,
  }) : super(key: key);

  Customer customer;
  CustomerGroup customerGroup;
  List<City> cities = [];
  List<CustomerGroup> customerGroups = [];
  List<Source> sources = [];
  List validation = [];

  @override
  _CustomerFormScreenState createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen> {
  FocusNode inputNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var phoneMask = new MaskTextInputFormatter(mask: "+964 (###) ###-####");
  var locationController = TextEditingController();
  LatLng _latLng;
  Customer _customer;
  Location location = new Location();

  List<District> _districts = [];

  List<City> _filteredCities = [];
  List<District> _filteredDistricts = [];
  bool _isSubmit = false;
  bool _isValidate = false;
  bool _isLoading = true;
  EntityMode _entityMode = EntityMode.New;

  @override
  void initState() {
    onLoad();
    super.initState();
  }

  onLoad() async {
    _customer = new Customer();

    if (widget.customer != null) {
      if (widget.customer.cityId != null) {
        final districts =
            await SharedService.getDistricts(widget.customer.cityId);

        setState(() {
          _districts = districts;
        });
      }

      setState(() {
        _customer = widget.customer;

        locationController.text =
            (_customer?.latitude ?? "") + ", " + (_customer?.longitude ?? "");

        var latitude = double.tryParse(_customer?.latitude ?? "0");
        var longitude = double.tryParse(_customer?.longitude ?? "0");

        setState(() {
          _latLng = LatLng(latitude, longitude);
        });

        if (_customer.customerGroupId != null) {
          var customerGroup = widget.customerGroups
              .where((group) => group.id == _customer.customerGroupId);

          if (customerGroup.isNotEmpty) {
            _customer.group = customerGroup.first;
          }
        }

        var city = widget.cities.where((city) => city.id == _customer.cityId);

        if (city.isNotEmpty) {
          _customer.city = city.first;

          var district = _districts
              .where((district) => district.id == _customer.districtId);

          if (district.isNotEmpty) {
            _customer.district = district.first;
          }
        }

        var source =
            widget.sources.where((source) => source.id == _customer.sourceId);

        if (source.isNotEmpty) {
          _customer.source = source.first;
        }

        _isLoading = false;
        _entityMode = EntityMode.Edit;
      });
    } else {
      setState(() {
        if (widget.customerGroup.id != null) {
          var customerGroup = widget.customerGroups
              .where((group) => group.id == widget.customerGroup.id);

          if (customerGroup.isNotEmpty) {
            _customer.group = customerGroup.first;
          }
        }

        _customer.customerGroupId = widget.customerGroup.id;

        _isLoading = false;
      });
    }
  }

  getLocation(LatLng latLng) async {
    setState(() {
      _customer.longitude = latLng?.longitude.toString();
      _customer.latitude = latLng?.latitude.toString();
      locationController.text = (latLng?.latitude.toString() ?? "") +
          ", " +
          (latLng?.longitude.toString() ?? "");

      _latLng = latLng;
    });
  }

  Future<void> getCities() async {
    final cities = await SharedService.getCities();

    setState(() {
      widget.cities = cities;
      _filteredCities = cities;
    });
  }

  Future<void> getCustomerGroups() async {
    final customerGroups = await CustomerService.customerGroups();

    setState(() {
      widget.customerGroups = customerGroups;
    });
  }

  Future<void> getSources() async {
    final sources = await SourceService.getSources();

    setState(() {
      widget.sources = sources;
    });
  }

  Future<void> onCityChanged(City city) async {
    
    

    setState(() {
      _customer.city = city;
      _customer.cityId = city.id;
      _customer.district = null;
      _customer.districtId = null;
    });

    final districts = await SharedService.getDistricts(city.id);

    setState(() {
      _districts = districts;
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
              _customer.district = _filteredDistricts[index];
              _customer.districtId = _filteredDistricts[index].id;
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

  create() {
    setState(() {
      _isSubmit = true;
      _isValidate = _formKey.currentState.validate();
    });

    if (!_formKey.currentState.validate()) {
      showInSnackBar("Please fill all the required fields");
      return;
    }

    _customer.id = 0;
    _customer.customerStatusId = 2;
    _customer.customerStatusId = 1;
    _customer.accountId = 0;
    _customer.sourceId = 2;
    _customer.contacts = [];
    CustomerService.create(_customer).then((result) {
      if (result.success) {
        showInSnackBar("Record has been added successfully");
        setState(() {
          _isSubmit = false;
        });
        Navigator.pop(context, Customer.fromJson(result.data));
      } else {
        showInSnackBar("Something error please contact support");
        setState(() {
          // _isSubmit = false;
        });
      }
    }).catchError((err) {
      showInSnackBar("Something error please contact support");
      setState(() {
        // _isSubmit = false;
      });
    });
  }

  update() {
    setState(() {
      _isSubmit = true;
    });

    CustomerService.update(_customer).then((value) {
      showInSnackBar("Record has been updated successfully");

      setState(() {
        _isSubmit = false;
      });
      Navigator.pop(context, _customer);
    }).catchError((err) {
      showInSnackBar("Something error please contact support");

      setState(() {
        // _isSubmit = false;
      });
    });
  }

  onSubmit() {
    if (_entityMode == EntityMode.New) {
      create();
    } else {
      update();
    }
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: widget.customer == null ? "New" : "Edit",
        actions: [
          IconButton(
            onPressed: onSubmit,
            icon: _isSubmit == null && _isLoading
                ? Container()
                : _isSubmit && _isValidate
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(
                        Icons.check,
                      ),
          ),
        ],
      ),
      body: _isLoading
          ? LoadingWidget()
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormListTile(
                      title: "General Info",
                      widget: Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            TextFieldWidget(
                              labelText: "Name",
                              iconData: Icons.person_outline,
                              initialValue: _customer.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "";
                                }
                                return null;
                              },
                              isRequired: true,
                              isSubmit: _isSubmit,
                              onChanged: (value) {
                                setState(() {
                                  _customer.name = value;
                                });
                              },
                            ),
                            DropdownButtonWidget(
                              labelText: "Group",
                              value: _customer.group,
                              items: widget.customerGroups
                                  .map((CustomerGroup customerGroup) {
                                return DropdownMenuItem(
                                  value: customerGroup,
                                  child: Text(
                                    customerGroup.name,
                                  ),
                                );
                              }).toList(),
                              onChanged: (CustomerGroup customerGroup) {
                                setState(() {
                                  _customer.group = customerGroup;
                                  _customer.customerGroupId = customerGroup.id;
                                });
                              },
                            ),
                            DropdownButtonWidget(
                              labelText: "Source",
                              value: _customer.source,
                              items: widget.sources.map((Source source) {
                                return DropdownMenuItem(
                                  value: source,
                                  child: Text(
                                    source.name,
                                  ),
                                );
                              }).toList(),
                              onChanged: (Source source) {
                                setState(() {
                                  _customer.source = source;
                                  _customer.sourceId = source.id;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    FormListTile(
                      title: "Contact Info",
                      widget: Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            TextFieldWidget(
                              labelText: "Phone",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "";
                                }
                                return null;
                              },
                              isRequired: true,
                              isSubmit: _isSubmit,
                              iconData: Icons.phone_outlined,
                              inputFormatters: [phoneMask],
                              initialValue: _customer.phoneNo,
                              onChanged: (value) {
                                setState(() {
                                  _customer.phoneNo = value;
                                });
                              },
                            ),
                            TextFieldWidget(
                              labelText: "Email",
                              iconData: Icons.email_outlined,
                              initialValue: _customer.email,
                              onChanged: (value) {
                                _customer.email = value;
                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _filteredCities = widget.cities;
                                });
                                FocusScope.of(context).requestFocus(inputNode);
                                cityModalBottomSheet(context);
                              },
                              child: TextFieldWidget(
                                labelText: "City",
                                isDropdown: true,
                                enabled: false,
                                isRequired: true,
                                key: Key(_customer.city?.name),
                                initialValue: _customer.city?.name,
                              ),
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
                                key: Key(_customer.district?.name),
                                isRequired: true,
                                initialValue: _customer.district?.name,
                              ),
                            ),
                            TextFieldWidget(
                              labelText: "Address",
                              iconData: Icons.map,
                              initialValue: _customer.address,
                              onChanged: (value) {
                                _customer.address = value;
                              },
                            ),
                            GestureDetector(
                              onTap: () async {
                                var latLng = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MapWidget(
                                      latLng: _latLng,
                                    ),
                                  ),
                                );

                                getLocation(latLng);
                              },
                              child: TextFieldWidget(
                                labelText: "Location",
                                enabled: false,
                                controller: locationController,
                                iconData: Icons.place_outlined,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FormListTile(
                      title: "Extra Info",
                      widget: Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [

                            TextFieldWidget(
                              labelText: "Description",
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              maxLines: 3,
                              initialValue: _customer.description,
                              onChanged: (value) {
                                _customer.description = value;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

