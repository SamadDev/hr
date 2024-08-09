import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/models/crm/contact/contact-result.dart';
import 'package:nandrlon/models/crm/deal/deal.dart';
import 'package:nandrlon/models/crm/deal/stage.dart';
import 'package:nandrlon/models/crm/shared/entity-mode.dart';
import 'package:nandrlon/services/contact.service.dart';
import 'package:nandrlon/services/deal.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/dropdown.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';

class DealFormScreen extends StatefulWidget {
  DealFormScreen({
    Key key,
    this.customerId,
  }) : super(key: key);

  int customerId;

  @override
  _DealFormScreenState createState() => _DealFormScreenState();
}

class _DealFormScreenState extends State<DealFormScreen> {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _deal = new Deal();
  var phoneMask = new MaskTextInputFormatter(mask: "+964 (###) ###-####");
  DateTime selectedDate = DateTime.now();
  List<Stage> _stages = [];
  List<ContactResult> _contacts = [];
  bool _isSubmit = false;
  EntityMode _entityMode = EntityMode.New;

  @override
  void initState() {
    super.initState();
    getCustomerContacts();
    onLoad();
    _deal.amount = 0;
  }

  onLoad() async {
    await getStages();
  }

  Future<void> getStages() async {
    final stages = await DealService.getStages();

    setState(() {
      _stages = stages;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme:
                ColorScheme.light(primary: Theme.of(context).primaryColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _deal.date = formatter.format(picked);
      });
  }

  Future<List<ContactResult>> getCustomerContacts() async {
    var contacts = await ContactService.getCustomerContacts(widget.customerId);
    setState(() {
      _contacts = contacts;
    });
  }

  customerModalBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, mystate) => Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: new Text(_contacts[index].name),
                          onTap: () {
                            setState(() {
                              _deal.customerContact = _contacts[index];
                              _deal.customerContactId = _contacts[index].id;
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
              ],
            ),
          );
        });
  }

  create() {
    setState(() {
      _isSubmit = true;
    });
    _deal.id = 0;
    _deal.dealTypeId = 1;
    _deal.customerId = widget.customerId;
    _deal.currencyId = 2;
    _deal.closingDate = formatter.format(DateTime.now());
    DealService.create(_deal).then((value) {
      showInSnackBar("Deal has been save successfully");
      setState(() {
        _isSubmit = false;
      });
      Navigator.pop(context, true);
    }).catchError((err) {
      // showInSnackBar("Something error please contact support");
      // setState(() {
      //   _isSubmit = false;
      // });
    });

    setState(() {
      _isSubmit = false;
    });
  }

  update() {
    setState(() {
      _isSubmit = true;
    });

    DealService.update(_deal).then((value) {
      showInSnackBar("Deal has been save successfully");

      setState(() {
        _isSubmit = false;
      });
      Navigator.pop(context, true);
    }).catchError((err) {
      // showInSnackBar("Something error please contact support");
      //
      // setState(() {
      //   _isSubmit = false;
      // });
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

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value),
      ),
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      key: _scaffoldKey,
      appBar: AppBarWidget(
        title: _entityMode == EntityMode.New ? "New Deal" : "Edit Deal",
        actions: [
          IconButton(
            onPressed: onSubmit,
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormListTile(
                widget: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      TextFieldWidget(
                        labelText: "Name",
                        initialValue: _deal.name,
                        isSubmit: _isSubmit,
                        isRequired: true,
                        onChanged: (value) {
                          _deal.name = value;
                        },
                      ),
                      GestureDetector(
                        onTap: customerModalBottomSheet,
                        child: TextFieldWidget(
                          labelText: "Contact",
                          isDropdown: true,
                          enabled: false,
                          isSubmit: _isSubmit,
                          isRequired: true,
                          initialValue: _deal?.customerContact?.name ?? "",
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: TextFieldWidget(
                          labelText: "Date",
                          isDropdown: true,
                          enabled: false,
                          isSubmit: _isSubmit,
                          isRequired: true,
                          initialValue:
                              _deal?.date?.toString()?.substring(0, 10) ?? "",
                        ),
                      ),
                      DropdownButtonWidget(
                        labelText: "Stage",
                        value: _deal.stage,
                        items: _stages.map((Stage stage) {
                          return DropdownMenuItem(
                            value: stage,
                            child: Text(
                              stage.name,
                            ),
                          );
                        }).toList(),
                        onChanged: (Stage stage) {
                          setState(() {
                            _deal.stage = stage;
                            _deal.stageId = stage.id;
                          });
                        },
                      ),
                      TextFieldWidget(
                        labelText: "Amount",
                        initialValue: _deal.amount.toString(),
                        isSubmit: _isSubmit,
                        isRequired: true,
                        onChanged: (value) {
                          if (isNumeric(value))
                            _deal.amount = double.tryParse(value);
                        },
                      ),
                      TextFieldWidget(
                        labelText: "Description",
                        initialValue: _deal.description,
                        maxLines: 8,
                        onChanged: (value) {
                          _deal.description = value;
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

class FormListTile extends StatelessWidget {
  FormListTile({
    Key key,
    this.title,
    this.widget,
  }) : super(key: key);

  final dynamic title;
  final dynamic widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(
            constBorderRadius,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title == null
              ? SizedBox()
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Text(
                    this.title,
                    style: TextStyle(
                      color: Color(0xff29304D),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          title == null
              ? SizedBox()
              : Divider(
                  height: 0,
                ),
          widget
        ],
      ),
    );
  }
}
