import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nandrlon/models/crm/Item/Item-result.dart';
import 'package:nandrlon/models/crm/customer/customer-result.dart';
import 'package:nandrlon/models/crm/sales-order/sales-order-detail.dart';
import 'package:nandrlon/models/crm/sales-order/sales-order.dart';
import 'package:nandrlon/models/product.model.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';

class SalesOrderViewScreen extends StatefulWidget {
  SalesOrderViewScreen({
    Key key,
    this.customer,
    this.products,
    this.total,
    this.salesOrder,
  }) : super(key: key);
  CustomerResult customer;
  List<Product> products;
  double total;
  SalesOrder salesOrder;

  @override
  _SalesOrderViewScreenState createState() => _SalesOrderViewScreenState();
}

class _SalesOrderViewScreenState extends State<SalesOrderViewScreen> {
  var numberFormat = NumberFormat('#,###.##', 'en_Us');
  DateTime selectedDate = DateTime.now();
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  List<Product> _products;
  double _total = 0;
  double _discount = 0;
  double _netAmount = 0;
  var searchController = TextEditingController();

  String searchQuery = "Search query";

  @override
  void initState() {
    onLoad();
    super.initState();
  }

  onLoad() {
    calcNetPrice();
  }

  double calcTotal(SalesOrderDetail detail) {
    double quantity = detail.quantity ?? 0;
    double price = detail.price ?? 0;
    double discount = detail.discount ?? 0;

    double total = (price * quantity);
    total = discount == 0 ? total : total - (total * (discount / 100));

    return total;
  }

  Future<DateTime> _selectDate(BuildContext context) async {
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
    if (picked != null) return picked;
  }

  addToBasket(SalesOrderDetail detail) {
    var _product = _products.where((p) => p.id == detail.id).first;
    var index = _products.indexOf(_product);

    _product.price = detail.price;
    _product.quantity = detail.quantity;
    _product.discount = detail.discount;

    setState(() {
      _products[index] = _product;
    });

    calcNetPrice();

    Navigator.pop(context);
  }

  calcNetPrice() {
    double subTotal = 0;

    widget.salesOrder.details
        .where((detail) => detail.quantity > 0)
        .forEach((detail) {
      subTotal = subTotal + calcTotal(detail);
    });

    setState(() {
      widget.salesOrder.subTotal = subTotal;
      widget.salesOrder.total = (widget.salesOrder.discount ?? 0) > 0
          ? subTotal - (subTotal * (widget.salesOrder.discount / 100))
          : subTotal;
    });
  }

  itemModalBottomSheet(BuildContext context, SalesOrderDetail detail) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.70,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            child: StatefulBuilder(
              builder: (BuildContext context, itemState) =>
                  SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 15,
                        left: 15,
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.close),
                      ),
                    ),
                    Center(
                      child: Image.asset(
                        "assets/image/item-1.png",
                        width: 100,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Container(
                        child: Text(
                          detail.item.name,
                          style: TextStyle(
                            color: Color(0xff29304D),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width - 50) / 2,
                            child: TextFieldWidget(
                              labelText: "Quantity",
                              keyboardType: TextInputType.number,
                              initialValue: detail.quantity.toString(),
                              onChanged: (quantity) {
                                itemState(() {
                                  detail.quantity =
                                      double.tryParse(quantity) ?? 0;
                                });

                                var total = calcTotal(detail);

                                itemState(() {
                                  detail.total = total;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: (MediaQuery.of(context).size.width - 50) / 2,
                            child: TextFieldWidget(
                              keyboardType: TextInputType.number,
                              labelText: "Price",
                              initialValue: detail.price.toString(),
                              onChanged: (price) {
                                itemState(() {
                                  detail.price = double.tryParse(price) ?? 0;
                                });

                                var total = calcTotal(detail);

                                itemState(() {
                                  detail.total = total;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFieldWidget(
                        labelText: "Discount",
                        keyboardType: TextInputType.number,
                        initialValue: detail.discount.toString(),
                        onChanged: (discount) {
                          itemState(() {
                            detail.discount = double.tryParse(discount) ?? 0;
                          });

                          var total = calcTotal(detail);

                          itemState(() {
                            detail.total = total;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(
                      color: Colors.grey.withOpacity(0.2),
                      thickness: 5,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => addToBasket(detail),
                            child: Text(
                              "Add item",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Text(
                            "USD ${detail.total == null ? "0" : detail.total.toStringAsPrecision(3)}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      layoutBackgroundColor: Colors.white,
      appBar: AppBarWidget(
        title: "Basket",
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context, widget.salesOrder),
        ),
      ),
      bottomSheet: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => Navigator.pop(context, widget.salesOrder),
                child: Container(
                  width: (MediaQuery.of(context).size.width / 2) - 20,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 1)),
                  child: Center(
                    child: Text(
                      "Add items",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: (MediaQuery.of(context).size.width / 2) - 20,
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Checkout",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Items",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.salesOrder.details.length,
                itemBuilder: (context, index) {
                  return widget.salesOrder.details[index].quantity == 0
                      ? Container()
                      : ProductListTile(
                          item: widget.salesOrder.details[index].item,
                        );
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Order Info",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Order date",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        var date = await _selectDate(context);
                        if (date != null) {
                          setState(() {
                            widget.salesOrder.orderDate =
                                formatter.format(date);
                          });
                        }
                      },
                      child: Text(
                        widget.salesOrder.orderDate ??
                            formatter.format(DateTime.now()),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Delivery date",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        var date = await _selectDate(context);
                        if (date != null) {
                          setState(() {
                            widget.salesOrder.deliveryDate =
                                formatter.format(date);
                          });
                        }
                      },
                      child: Text(
                        widget.salesOrder.deliveryDate ??
                            formatter.format(DateTime.now()),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Due date",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        var date = await _selectDate(context);
                        if (date != null) {
                          setState(() {
                            widget.salesOrder.dueDate = formatter.format(date);
                          });
                        }
                      },
                      child: Text(
                        widget.salesOrder.dueDate ??
                            formatter.format(DateTime.now()),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Payment Summary",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sub total",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "USD ${widget.salesOrder.subTotal ?? 0}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "Discount",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      child: TextFieldWidget(
                        keyboardType: TextInputType.number,
                        initialValue: widget.salesOrder.discount.toString(),
                        onChanged: (discount) {
                          setState(() {
                            widget.salesOrder.discount =
                                double.tryParse(discount) ?? 0;
                          });

                          calcNetPrice();
                        },
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total amount",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "USD ${widget.salesOrder.total}",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductListTile extends StatelessWidget {
  ProductListTile({Key key, this.item}) : super(key: key);

  final ItemResult item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: new TextSpan(
                            // Note: Styles for TextSpans must be explicitly defined.
                            // Child text spans will inherit styles from parent
                            style: new TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              new TextSpan(
                                text: item.quantity > 0
                                    ? item.quantity.toInt().toString() + 'x '
                                    : "",
                                style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              new TextSpan(
                                text: item.name,
                                style: new TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        item.isAddToBasket != true
                            ? Container()
                            : Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Quantity: ${item.quantity}",
                                      style: TextStyle(
                                        color: Color(0xff62656B),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "Price: ${item.price}",
                                      style: TextStyle(
                                        color: Color(0xff62656B),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "Total: ${item.total}",
                                      style: TextStyle(
                                        color: Color(0xff62656B),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Image.asset(
                    "assets/image/item-1.png",
                    width: 40,
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          child: Divider(
            height: 0,
          ),
        )
      ],
    );
  }
}
