import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/helper/formatter.dart';
import 'package:nandrlon/models/crm/customer/customer.dart';
import 'package:nandrlon/models/crm/sales-order/sales-order-parameter.dart';
import 'package:nandrlon/models/crm/shared/city.dart';
import 'package:nandrlon/services/customer.service.dart';
import 'package:nandrlon/widgets/alert-dialog-widget.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';

class SalesOrderFilterScreen extends StatefulWidget {
  SalesOrderFilterScreen({
    Key key,
    this.cities,
    this.salesOrderParameters,
  }) : super(key: key);

  List<City> cities;
  SalesOrderParameters salesOrderParameters;

  @override
  _SalesOrderFilterScreenState createState() => _SalesOrderFilterScreenState();
}

class _SalesOrderFilterScreenState extends State<SalesOrderFilterScreen> {
  List<Customer> _customers = [];
  var orderNoTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    orderNoTextEditingController.text = widget.salesOrderParameters.orderNo;
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
                widget.salesOrderParameters.customer = _customers[index];
                widget.salesOrderParameters.customerId = _customers[index].id;
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
                orderNoTextEditingController.clear();
                widget.salesOrderParameters = SalesOrderParameters();
              });
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                widget.salesOrderParameters.orderNo =
                    orderNoTextEditingController.text;
                Navigator.pop(context, widget.salesOrderParameters);
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
                      labelText: "Order No",
                      controller: orderNoTextEditingController,
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
                        key: Key(widget.salesOrderParameters.customer?.name),
                        initialValue:
                            widget.salesOrderParameters.customer?.name ?? "",
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
                          widget.salesOrderParameters.fromDate =
                              dateFormat.format(date);
                        });
                      }
                    },
                    child: TextFieldWidget(
                      enabled: false,
                      labelText: "From Date",
                      key: Key(widget.salesOrderParameters.fromDate),
                      initialValue: widget.salesOrderParameters.fromDate,
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
                          widget.salesOrderParameters.toDate =
                              dateFormat.format(date);
                        });
                      }
                    },
                    child: TextFieldWidget(
                      enabled: false,
                      labelText: "To Date",
                      key: Key(widget.salesOrderParameters.toDate),
                      initialValue: widget.salesOrderParameters.toDate,
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
