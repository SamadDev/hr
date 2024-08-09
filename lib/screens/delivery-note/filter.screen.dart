import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/helper/formatter.dart';
import 'package:nandrlon/models/crm/customer/customer.dart';
import 'package:nandrlon/models/crm/delivery-note/delivery-note-parameter.dart';
import 'package:nandrlon/models/crm/shared/city.dart';
import 'package:nandrlon/services/customer.service.dart';
import 'package:nandrlon/widgets/alert-dialog-widget.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';

class DeliveryNoteFilterScreen extends StatefulWidget {
  DeliveryNoteFilterScreen({
    Key key,
    this.cities,
    this.deliveryNoteParameters,
  }) : super(key: key);

  List<City> cities;
  DeliveryNoteParameters deliveryNoteParameters;

  @override
  _DeliveryNoteFilterScreenState createState() =>
      _DeliveryNoteFilterScreenState();
}

class _DeliveryNoteFilterScreenState extends State<DeliveryNoteFilterScreen> {
  List<Customer> _customers = [];

  @override
  void initState() {
    super.initState();
  }

  Future<List<Customer>> getCustomers(searchText) async {
    return await CustomerService.filter(searchText);
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.day,
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

    if (picked != null) return picked;
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
                widget.deliveryNoteParameters.customer = _customers[index];
                widget.deliveryNoteParameters.customerId = _customers[index].id;
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

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "filter".tr(),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                widget.deliveryNoteParameters = DeliveryNoteParameters();
              });
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                Navigator.pop(context, widget.deliveryNoteParameters);
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
                  Container(
                    child: TextFieldWidget(
                      labelText: "Delivery No",
                      initialValue: widget.deliveryNoteParameters.deliveryNo,
                      onChanged: (value) {
                        widget.deliveryNoteParameters.deliveryNo = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: TextFieldWidget(
                      labelText: "Ref No",
                      initialValue: widget.deliveryNoteParameters.refNo,
                      onChanged: (value) {
                        widget.deliveryNoteParameters.refNo = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: GestureDetector(
                      onTap: () => customerModalBottomSheet(context),
                      child: TextFieldWidget(
                        labelText: "Customer",
                        isDropdown: true,
                        enabled: false,
                        isRequired: true,
                        key: Key(widget.deliveryNoteParameters.customer?.name),
                        initialValue:
                            widget.deliveryNoteParameters.customer?.name ?? "",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      var date = await _selectDate(context);
                      if (date != null) {
                        setState(() {
                          widget.deliveryNoteParameters.fromDate =
                              dateFormat.format(date);
                        });
                      }
                    },
                    child: TextFieldWidget(
                      enabled: false,
                      labelText: "From Date",
                      key: Key(widget.deliveryNoteParameters.fromDate),
                      initialValue: widget.deliveryNoteParameters.fromDate,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      var date = await _selectDate(context);
                      if (date != null) {
                        setState(() {
                          widget.deliveryNoteParameters.toDate =
                              dateFormat.format(date);
                        });
                      }
                    },
                    child: TextFieldWidget(
                      enabled: false,
                      labelText: "To Date",
                      key: Key(widget.deliveryNoteParameters.toDate),
                      initialValue: widget.deliveryNoteParameters.toDate,
                    ),
                  ),
                  SizedBox(
                    height: 10,
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
