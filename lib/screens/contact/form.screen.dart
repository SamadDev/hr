
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/helper/snackbar.dart';
import 'package:nandrlon/models/crm/contact/contact.dart';
import 'package:nandrlon/models/crm/customer/customer.dart';
import 'package:nandrlon/models/crm/shared/entity-mode.dart';
import 'package:nandrlon/models/crm/shared/gender.dart';
import 'package:nandrlon/models/crm/shared/lookup.dart';
import 'package:nandrlon/models/crm/shared/spoken-language.dart';
import 'package:nandrlon/services/contact.service.dart';
import 'package:nandrlon/services/customer.service.dart';
import 'package:nandrlon/services/shared.service.dart';
import 'package:nandrlon/widgets/alert-dialog-widget.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/dropdown.widget.dart';
import 'package:nandrlon/widgets/form.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/loading.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';

class ContactFormScreen extends StatefulWidget {
  ContactFormScreen({
    Key key,
    this.contactId,
  }) : super(key: key);

  int contactId;

  @override
  _ContactFormScreenState createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  bool _isValidate = false;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _contact = new Contact();
  var phoneMask = new MaskTextInputFormatter(mask: "+964 (###) ###-####");
  var jobTitleController = TextEditingController();
  List<Gender> _genders = [];
  List<Lookup> _jobTitles = [];
  List<SpokenLanguage> _spokenLanguages = [];
  List<Customer> _customers = [];
  Customer _customer;
  bool _isLoading = true;
  bool _isSubmit = false;
  EntityMode _entityMode = EntityMode.New;

  @override
  void initState() {
    super.initState();

    onLoad();
  }

  onLoad() async {
    await getGenders();
    await getJobTitles();
    await getSpokenLanguages();

    if (widget.contactId != null && widget.contactId > 0) {
      ContactService.getContact(widget.contactId).then((contact) {
        setState(() {
          jobTitleController.text = contact.jobTitle;
          _contact = contact;
          _customer = contact.customer;

          _contact.gender =
              _genders.where((gender) => gender.id == contact.genderId).first;
          _contact.spokenLanguage = _spokenLanguages
              .where((spokenLanguage) =>
                  spokenLanguage.id == contact.spokenLanguageId)
              .first;
          _isLoading = false;
          _entityMode = EntityMode.Edit;
        });
      }).catchError((err) {
        showInSnackBar(SnackBarType.Error, context);
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getGenders() async {
    final genders = await SharedService.genders();

    setState(() {
      _genders = genders;
    });
  }

  Future<void> getJobTitles() async {
    final jobTitles = await SharedService.getLookups("job-title");

    setState(() {
      _jobTitles = jobTitles;
    });
  }

  Future<void> getSpokenLanguages() async {
    final spokenLanguages = await SharedService.spokenLanguages();

    setState(() {
      _spokenLanguages = spokenLanguages;
    });
  }

  Future<List<Customer>> getCustomers(searchText) async {
    return await CustomerService.filter(searchText);
  }

  customerModalBottomSheet1() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
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
                                _customer = _customers[index];
                                _contact.customer = _customers[index];
                                _contact.customerId = _customers[index].id;
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
                _customer = _customers[index];
                _contact.customer = _customers[index];
                _contact.customerId = _customers[index].id;
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

  create() {

    setState(() {
      _isSubmit = true;
      _isValidate = _formKey.currentState.validate();
    });

    if (!_formKey.currentState.validate()) {
      showInSnackBar(SnackBarType.Valid, context);
      return;
    }



    _contact.id = 0;

    ContactService.create(_contact).then((result) {
      showInSnackBar(SnackBarType.Saved, context);
      setState(() {
        _isSubmit = false;
      });
      Navigator.pop(context, true);
    }).catchError((err) {
      showInSnackBar(SnackBarType.Error, context);
      setState(() {
        _isSubmit = false;
      });
    });
  }

  update() {
    setState(() {
      _isSubmit = true;
    });

    ContactService.update(_contact).then((value) {
      showInSnackBar(SnackBarType.Updated, context);

      setState(() {
        _isSubmit = false;
      });
      Navigator.pop(context, true);
    }).catchError((err) {
      showInSnackBar(SnackBarType.Error, context);

      setState(() {
        _isSubmit = false;
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

  isEmailValid(email) {
    if (email == null) return false;
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      key: _scaffoldKey,
      layoutBackgroundColor: Colors.white,
      appBar: AppBarWidget(
        title: widget.contactId == 0 ? "New" : "Edit",
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
                      widget: Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => customerModalBottomSheet(context),
                              child: TextFieldWidget(
                                labelText: "Customer",
                                isDropdown: true,
                                key: Key(_contact.customer?.name),
                                enabled: false,
                                isSubmit: _isSubmit,
                                isRequired: true,
                                initialValue: _contact.customer?.name ?? "",
                              ),
                            ),
                            TextFieldWidget(
                              labelText: "Name",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "";
                                }
                                return null;
                              },
                              isSubmit: _isSubmit,
                              isRequired: true,
                              initialValue: _contact.name,
                              onChanged: (value) {
                                setState(() {
                                  _contact.name = value;
                                });
                              },
                            ),
                            Autocomplete<Lookup>(
                              initialValue: jobTitleController.value,
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                setState(() {
                                  jobTitleController.text =
                                      textEditingValue.text;
                                  _contact.jobTitle = textEditingValue.text;
                                });
                                return _jobTitles
                                    .where((Lookup lookup) => lookup.name
                                        .toLowerCase()
                                        .startsWith(textEditingValue.text
                                            .toLowerCase()))
                                    .toList();
                              },
                              displayStringForOption: (Lookup lookup) =>
                                  lookup.name,
                              fieldViewBuilder: (BuildContext context,
                                  TextEditingController
                                      fieldTextEditingController,
                                  FocusNode fieldFocusNode,
                                  VoidCallback onFieldSubmitted) {
                                return TextFieldWidget(
                                  controller: fieldTextEditingController,
                                  focusNode: fieldFocusNode,
                                  labelText: "Job Title",
                                );
                              },
                              onSelected: (Lookup lookup) {
                                setState(() {
                                  jobTitleController.text = lookup.name;
                                  _contact.jobTitle = lookup.name;
                                });
                              },
                              optionsViewBuilder: (BuildContext context,
                                  AutocompleteOnSelected<Lookup> onSelected,
                                  Iterable<Lookup> lookups) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Material(
                                    child: Container(
                                      width: 300,
                                      height: 300,
                                      decoration: BoxDecoration(
                                          color: backgroundColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xff4F62C0)
                                                  .withOpacity(0.15),
                                              spreadRadius: 0,
                                              blurRadius: 3,
                                              offset: Offset(0,
                                                  1), // changes position of shadow
                                            ),
                                          ]),
                                      child: ListView.builder(
                                        padding: EdgeInsets.all(10.0),
                                        itemCount: lookups.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final Lookup option =
                                              lookups.elementAt(index);

                                          return GestureDetector(
                                            onTap: () {
                                              onSelected(option);
                                            },
                                            child: ListTile(
                                              title: Text(
                                                option.name,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            DropdownButtonWidget(
                              labelText: "Gender",
                              value: _contact.gender,
                              items: _genders.map((Gender gender) {
                                return DropdownMenuItem(
                                  value: gender,
                                  child: Text(
                                    gender.name,
                                  ),
                                );
                              }).toList(),
                              onChanged: (Gender gender) {
                                setState(() {
                                  _contact.gender = gender;
                                  _contact.genderId = gender.id;
                                });
                              },
                            ),
                            DropdownButtonWidget(
                              labelText: "Spoken Language",
                              value: _contact.spokenLanguage,
                              items: _spokenLanguages
                                  .map((SpokenLanguage spokenLanguage) {
                                return DropdownMenuItem(
                                  value: spokenLanguage,
                                  child: Text(
                                    spokenLanguage.name,
                                  ),
                                );
                              }).toList(),
                              onChanged: (SpokenLanguage spokenLanguage) {
                                setState(() {
                                  _contact.spokenLanguage = spokenLanguage;
                                  _contact.spokenLanguageId = spokenLanguage.id;
                                });
                              },
                            ),
                            TextFieldWidget(
                              labelText: "Phone 1",
                              inputFormatters: [phoneMask],
                              initialValue: _contact.phoneNo1,
                              onChanged: (value) {
                                setState(() {
                                  _contact.phoneNo1 = value;
                                });
                              },
                            ),
                            TextFieldWidget(
                              labelText: "Phone 2",
                              inputFormatters: [phoneMask],
                              initialValue: _contact.phoneNo2,
                              onChanged: (value) {
                                setState(() {
                                  _contact.phoneNo2 = value;
                                });
                              },
                            ),
                            TextFieldWidget(
                              labelText: "Email",
                              initialValue: _contact.email,
                              errorText: _contact.email != null
                                  ? isEmailValid(_contact.email)
                                      ? null
                                      : "Invalid email address format"
                                  : null,
                              onChanged: (value) {
                                setState(() {
                                  _contact.email = value;
                                });
                              },
                            ),
                            TextFieldWidget(
                              labelText: "Description",
                              maxLines: 4,
                            ),
                            Row(
                              children: [
                                Checkbox(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    value: _contact.isActive == null
                                        ? false
                                        : _contact.isActive,
                                    onChanged: (isActive) {
                                      setState(() {
                                        _contact.isActive = isActive;
                                      });
                                    }),
                                Text(
                                  _contact.isActive == true
                                      ? "Active"
                                      : "Inactive",
                                  style: TextStyle(
                                    color: Color(0xff29304D),
                                    fontSize: 15,
                                  ),
                                ),
                              ],
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

