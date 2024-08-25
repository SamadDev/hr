import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';

class OrderFormScreen extends StatefulWidget {
  const OrderFormScreen();

  @override
  _OrderFormScreenState createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  var phoneMask = new MaskTextInputFormatter(mask: "+964 (###) ###-####");

  var nameController = TextEditingController();
  var customerController = TextEditingController();
  var searchSpecialityController = TextEditingController();
  var searchCustomerController = TextEditingController();
  var searchProductController = TextEditingController();
  var purposeController = TextEditingController();
  var resultController = TextEditingController();
  var statusController = TextEditingController();
  var dateController = TextEditingController();
  var descriptionController = TextEditingController();
  var _netPriceController = TextEditingController();
  var _totalController = TextEditingController();
  var _discountController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  double _total = 0;
  double _discount = 0;
  double _netPrice = 0;
  List _customers = [];
  List _products = [];

  @override
  void initState() {
    super.initState();
    readCustomerJson();
    readProductJson();
  }

  Future<void> readCustomerJson() async {
    final String response =
        await rootBundle.loadString('assets/json/customer.json');
    final data = await json.decode(response);

    setState(() {
      if (searchCustomerController.text.isEmpty) _customers = data;
      if (searchCustomerController.text.isNotEmpty)
        _customers = data
            .where((d) => d['first_name']
                .toString()
                .toLowerCase()
                .contains(searchCustomerController.text.toLowerCase()))
            .toList();
    });
  }

  Future<void> readProductJson() async {
    final String response =
        await rootBundle.loadString('assets/json/product.json');
    final data = await json.decode(response);

    setState(() {
      if (searchProductController.text.isEmpty) _products = data;
      if (searchProductController.text.isNotEmpty)
        _products = data
            .where((d) => d['name']
                .toString()
                .toLowerCase()
                .contains(searchProductController.text.toLowerCase()))
            .toList();
    });
  }

  customerModalBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, mystate) => Column(
              children: [
                Container(
                  padding: showModalBottomSheetPadding,
                  child: TextFieldWidget(
                    controller: searchCustomerController,
                    iconData: Icons.search,
                    onChanged: (value) {
                      mystate(() {
                        readCustomerJson();
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
                            title: new Text(_customers[index]['first_name'] +
                                " " +
                                _customers[index]['last_name']),
                            onTap: () {
                              setState(() {
                                customerController.text = _customers[index]
                                        ['first_name'] +
                                    " " +
                                    _customers[index]['last_name'];
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

  String calcTotal(String price, String quantity) {
    if (price.isEmpty) price = "0";
    if (quantity.isEmpty) quantity = "0";
    String total =
        (double.parse(price) * double.parse(quantity.toString())).toString();

    return total;
  }

  calcNetPrice() {
    double total = 0;
    double discount = _discountController.text.isEmpty
        ? 0
        : (double.tryParse(_discountController.text));

    _products
        .where((product) =>
            product["quantity"] != null &&
            double.tryParse(product["quantity"]) > 0)
        .forEach((product) {
      total = total + double.tryParse(product["total"]);
    });

    setState(() {
      _totalController.text = total.toString();
      _netPriceController.text = discount > 0
          ? (total - (total * (discount / 100))).toString()
          : total.toString();
    });
  }

  productsModalBottomSheet() {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, productState) => Column(
              children: [
                Container(
                  margin: showModalBottomSheetPadding,
                  child: TextFieldWidget(
                    controller: searchProductController,
                    iconData: Icons.search,
                    onChanged: (value) {
                      productState(() {
                        readProductJson();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            title: new Text(
                              _products[index]['name'],
                            ),
                            subtitle: _products[index]['quantity'] == null ||
                                    _products[index]['quantity'] == "0"
                                ? null
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Quantity: ${_products[index]['quantity'].toString()}",
                                      ),
                                      Text(
                                        "Price: ${_products[index]['price'].toString()}",
                                      ),
                                      Text(
                                        "Total: ${_products[index]['total'].toString()}",
                                      ),
                                    ],
                                  ),
                            onTap: () {
                              var product = _products[index];
                              itemModalBottomSheet(
                                  context, product, productState);
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

  itemModalBottomSheet(
      BuildContext context, dynamic product, StateSetter productState) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.37,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: StatefulBuilder(
              builder: (BuildContext context, itemState) => Column(
                children: [
                  TextFieldWidget(
                    labelText: "Quantity",
                    keyboardType: TextInputType.number,
                    initialValue: product['quantity'] == null
                        ? "0"
                        : product['quantity'].toString(),
                    onChanged: (quantity) {
                      if (quantity.toString().isEmpty) quantity = "0";

                      var total =
                          calcTotal(product['price'].toString(), quantity);

                      itemState(() {
                        product['quantity'] = quantity;
                        product['total'] = total;
                      });

                      setState(() {
                        product['quantity'] = quantity;
                        product['total'] = total;
                      });

                      productState(() {
                        product['quantity'] = quantity;
                        product['total'] = total;
                      });

                      calcNetPrice();
                    },
                  ),
                  TextFieldWidget(
                    keyboardType: TextInputType.number,
                    labelText: "Price",
                    initialValue: product['price'] == null
                        ? "0"
                        : product['price'].toString(),
                    onChanged: (price) {
                      if (price.toString().isEmpty) price = "0";

                      var total = calcTotal(
                          price.toString(), product['quantity'].toString());

                      itemState(() {
                        product['price'] = price;
                        product['total'] = total;
                      });

                      setState(() {
                        product['price'] = price;
                        product['total'] = total;
                      });

                      productState(() {
                        product['price'] = price;
                        product['total'] = total;
                      });

                      calcNetPrice();
                    },
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            color: Color(0xff29304D),
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xffF7F7F7),
                          ),
                          child: Text(
                            product['total'] == null
                                ? "0"
                                : product['total'].toString(),
                            style: TextStyle(
                              color: Color(0xff29304D),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
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
        dateController.text = picked.toString().substring(0, 10);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "New Order",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormListTile(
                title: "General",
                widget: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: TextFieldWidget(
                          labelText: "Date",
                          enabled: false,
                          controller: dateController,
                          iconData: Icons.date_range_outlined,
                        ),
                      ),
                      GestureDetector(
                        onTap: customerModalBottomSheet,
                        child: TextFieldWidget(
                          labelText: "Customer",
                          isDropdown: true,
                          enabled: false,
                          controller: customerController,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FormListTile(
                title: "Items",
                actions: [
                  IconButton(
                    onPressed: productsModalBottomSheet,
                    constraints: BoxConstraints(),
                    icon: Icon(
                      Icons.add_outlined,
                    ),
                  ),
                ],
                widget: Container(
                  padding: EdgeInsets.all(15),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      return _products[index]['quantity'] == null ||
                              _products[index]['quantity'] == "0"
                          ? Container()
                          : Column(
                              children: [
                                ListTile(
                                  title: new Text(
                                    _products[index]['name'],
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Quantity: ${_products[index]['quantity'].toString()}",
                                      ),
                                      Text(
                                        "Price: ${_products[index]['price'].toString()}",
                                      ),
                                      Text(
                                        "Total: ${_products[index]['total'].toString()}",
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    itemModalBottomSheet(
                                        context, _products[index], setState);
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
              ),
              FormListTile(
                title: "Details",
                widget: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      TextFieldWidget(
                        labelText: "Total",
                        enabled: false,
                        controller: _totalController,
                      ),
                      TextFieldWidget(
                        labelText: "Discount",
                        controller: _discountController,
                        onChanged: (value) {
                          calcNetPrice();
                        },
                      ),
                      TextFieldWidget(
                        labelText: "Net Price",
                        enabled: false,
                        controller: _netPriceController,
                      ),
                    ],
                  ),
                ),
              ),
              FormListTile(
                title: "Details",
                widget: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      TextFieldWidget(
                        labelText: "Description",
                        maxLines: 8,
                        controller: descriptionController,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 50,
                margin: EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: Center(
                  child: Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              )
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
    this.actions,
  }) : super(key: key);

  final dynamic title;
  final dynamic widget;
  final List<Widget> actions;

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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  this.title,
                  style: TextStyle(
                    color: Color(0xff29304D),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions == null
                    ? Container()
                    : Column(
                        children: actions,
                      )
              ],
            ),
          ),
          Divider(
            height: 0,
          ),
          widget
        ],
      ),
    );
  }
}
