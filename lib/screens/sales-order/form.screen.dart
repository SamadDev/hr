import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:intl/intl.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/helper/formatter.dart';
import 'package:nandrlon/models/crm/Item/Item-group.dart';
import 'package:nandrlon/models/crm/Item/Item-result.dart';
import 'package:nandrlon/models/crm/Item/item-parameter.dart';
import 'package:nandrlon/models/crm/Item/item-photo.dart';
import 'package:nandrlon/models/crm/Item/item.dart';
import 'package:nandrlon/models/crm/customer/customer-result.dart';
import 'package:nandrlon/models/crm/customer/customer.dart';
import 'package:nandrlon/models/crm/sales-order/sales-order-detail.dart';
import 'package:nandrlon/models/crm/sales-order/sales-order.dart';
import 'package:nandrlon/models/crm/shared/entity-mode.dart';
import 'package:nandrlon/screens/sales-order/item.screen.dart';
import 'package:nandrlon/services/customer.service.dart';
import 'package:nandrlon/services/item.service.dart';
import 'package:nandrlon/services/sales-order.service.dart';
import 'package:nandrlon/widgets/alert-dialog-widget.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/button.widget.dart';
import 'package:nandrlon/widgets/form.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/loading.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';

class SalesOrderFormScreen extends StatefulWidget {
  SalesOrderFormScreen({
    Key key,
    this.customer,
    this.salesOrderId,
  }) : super(key: key);
  CustomerResult customer;
  int salesOrderId;

  @override
  _SalesOrderFormScreenState createState() => _SalesOrderFormScreenState();
}

class _SalesOrderFormScreenState extends State<SalesOrderFormScreen> {
  List<Customer> _customers = [];
  var _salesOrder = SalesOrder();
  var _salesOrderDetail = new SalesOrderDetail();
  var numberFormat = NumberFormat('#,###.##', 'en_Us');
  List<Item> _items = [];
  ItemParameters _itemParameters;
  var searchController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  Timer _debounce;
  bool _isLoading = true;
  EntityMode _entityMode = EntityMode.New;
  bool _isSubmit = false;
  List<ItemGroup> _itemGroups;
  List<ItemPhoto> _itemPhotos;

  @override
  void initState() {
    _salesOrder.details = [];
    _itemParameters = new ItemParameters();
    _itemParameters.itemGroup = null;
    _itemParameters.itemUnit = null;
    _itemParameters.itemType = null;
    _salesOrder.deliveryDate = dateFormat.format(DateTime.now());
    _salesOrder.dueDate = dateFormat.format(DateTime.now());
    _salesOrder.orderDate = dateFormat.format(DateTime.now());
    _salesOrder.orderNo = "(new)";
    _salesOrder.total = 0;
    _salesOrder.salesOrderStatusId = 1;
    _salesOrder.discount = 0;
    _salesOrder.subTotal = 0;
    _salesOrder.entityMode = EntityMode.New;
    onLoad();
    super.initState();
  }

  Future<List<Customer>> getCustomers(searchText) async {
    return await CustomerService.filter(searchText);
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
                _salesOrder.customer = _customers[index];
                _salesOrder.customerId = _customers[index].id;
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

  onLoad() async {
    var itemGroups = await ItemService.getItemGroups();
    var items = await ItemService.getItems(_itemParameters);

    if (widget.salesOrderId != null) {
      var salesOrder = await SalesOrderService.get(widget.salesOrderId);

      setState(() {
        _salesOrder = salesOrder;
      });
    }
    setState(() {
      _itemGroups = itemGroups;
      _items = items;
      _isLoading = false;
    });
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

  addDetail() {
    var salesOrder = SalesOrder();

    salesOrder.id = _salesOrder.id ?? 0;
    salesOrder.employeeId = 0;
    salesOrder.customerId = _salesOrder.customerId;
    salesOrder.orderDate = _salesOrder.orderDate;
    salesOrder.orderNo = _salesOrder.orderNo;
    salesOrder.subTotal = _salesOrder.subTotal;
    salesOrder.discount = _salesOrder.discount;
    salesOrder.total = _salesOrder.total;
    salesOrder.dueDate = _salesOrder.dueDate;
    salesOrder.salesOrderStatusId = _salesOrder.salesOrderStatusId;
    salesOrder.description = _salesOrder.description;
    salesOrder.deliveryDate = _salesOrder.deliveryDate;
    salesOrder.entityMode = _salesOrder.entityMode;
    salesOrder.details = [];

    setState(() {
      salesOrder.details.add(_salesOrderDetail);
    });

    if (salesOrder.entityMode == EntityMode.New) {
      create(salesOrder);
    } else {
      update(salesOrder);
    }

    calculate();

    Navigator.pop(context);
  }

  editDetail() {
    var salesOrder = SalesOrder();

    salesOrder.id = _salesOrder.id ?? 0;
    salesOrder.employeeId = 0;
    salesOrder.customerId = _salesOrder.customerId;
    salesOrder.orderDate = _salesOrder.orderDate;
    salesOrder.orderNo = _salesOrder.orderNo;
    salesOrder.subTotal = _salesOrder.subTotal;
    salesOrder.discount = _salesOrder.discount;
    salesOrder.dueDate = _salesOrder.dueDate;
    salesOrder.description = _salesOrder.description;
    salesOrder.deliveryDate = _salesOrder.deliveryDate;
    salesOrder.total = _salesOrder.total;
    salesOrder.entityMode = _salesOrder.entityMode;
    salesOrder.details = [];

    setState(() {
      salesOrder.details.add(_salesOrderDetail);
    });

    if (salesOrder.entityMode == EntityMode.New) {
      create(salesOrder);
    } else {
      update(salesOrder);
    }

    calculate();

    Navigator.pop(context);
  }

  calculate() {
    double total = 0;

    _salesOrder.details.forEach((item) {
      
      

      total += item.total;
    });

    setState(() {
      _salesOrder.subTotal = total;
      _salesOrder.total = total;
    });
  }

  itemModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: StatefulBuilder(
              builder: (BuildContext context, itemState) =>
                  SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/image/item-1.png",
                        width: 70,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Container(
                        child: Text(
                          _salesOrderDetail.item.name,
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
                    Center(
                      child: Text(
                        _salesOrderDetail.item.group.name,
                        style: TextStyle(
                          color: Color(0xff29304D),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width - 50) / 2,
                            child: TextFieldWidget(
                              labelText: "Quantity",
                              keyboardType: TextInputType.text,
                              initialValue: _salesOrderDetail.quantity == 0
                                  ? ""
                                  : _salesOrderDetail.quantity.toString(),
                              onChanged: (quantity) {
                                itemState(() {
                                  _salesOrderDetail.quantity =
                                      double.tryParse(quantity) ?? 0;
                                });

                                itemState(() {
                                  _salesOrderDetail.total =
                                      calcTotal(_salesOrderDetail);
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
                              keyboardType: TextInputType.text,
                              labelText: "Price",
                              initialValue: _salesOrderDetail.price == 0
                                  ? ""
                                  : _salesOrderDetail.price.toString(),
                              onChanged: (price) {
                                itemState(() {
                                  _salesOrderDetail.price =
                                      double.tryParse(price) ?? 0;
                                });

                                var total = calcTotal(_salesOrderDetail);

                                itemState(() {
                                  _salesOrderDetail.total = total;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width - 50) / 2,
                            child: TextFieldWidget(
                              labelText: "Discount",
                              keyboardType: TextInputType.text,
                              initialValue: _salesOrderDetail.discount == 0
                                  ? ""
                                  : _salesOrderDetail.discount.toString(),
                              onChanged: (discount) {
                                itemState(() {
                                  _salesOrderDetail.discount =
                                      double.tryParse(discount) ?? 0;
                                });

                                var total = calcTotal(_salesOrderDetail);

                                itemState(() {
                                  _salesOrderDetail.total = total;
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
                              labelText: "Bonus",
                              keyboardType: TextInputType.text,
                              initialValue: _salesOrderDetail.bonus == 0
                                  ? ""
                                  : _salesOrderDetail.bonus.toString(),
                              onChanged: (bonus) {
                                itemState(() {
                                  _salesOrderDetail.bonus =
                                      double.tryParse(bonus) ?? 0;
                                });

                                var total = calcTotal(_salesOrderDetail);

                                itemState(() {
                                  _salesOrderDetail.total = total;
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
                        labelText: "Description",
                        initialValue: _salesOrderDetail.description,
                        onChanged: (description) {
                          setState(() {
                            _salesOrderDetail.description = description;
                          });
                        },
                        maxLines: 2,
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
                          InkWell(
                            onTap: () =>
                                _salesOrderDetail.entityMode == EntityMode.New
                                    ? addDetail()
                                    : editDetail(),
                            child: Text(
                              _salesOrderDetail.entityMode == EntityMode.New
                                  ? "Add item"
                                  : "Update",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Text(
                            "USD ${_salesOrderDetail.total == null ? "0" : _salesOrderDetail.total}",
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

  showDetail(ItemResult item) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  _itemPhotos == null || _itemPhotos.length == 0
                      ? Container()
                      : ImageSlideshow(
                          width: double.infinity,
                          height: 200,
                          initialPage: 0,
                          indicatorColor: Colors.blue,
                          indicatorBackgroundColor: Colors.grey,
                          onPageChanged: (value) {

                          },
                          autoPlayInterval: 3000,
                          isLoop: false,
                          children: [
                            for (var itemPhoto in _itemPhotos)
                              Image.asset(
                                "assets/image/item-1.png",
                              ),
                          ],
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  ItemDetailListTile(
                    title: "Code",
                    subtitle: item.code,
                  ),
                  ItemDetailListTile(
                    title: "Name",
                    subtitle: item.name,
                  ),
                  ItemDetailListTile(
                    title: "Group",
                    subtitle: item.groupName,
                  ),
                  ItemDetailListTile(
                    title: "Type",
                    subtitle: item.typeName,
                  ),
                  ItemDetailListTile(
                    title: "Unit",
                    subtitle: item.unitName,
                  ),
                  ItemDetailListTile(
                    title: "Price",
                    subtitle: item.price.toString(),
                  ),
                  ItemDetailListTile(
                    title: "Description",
                    subtitle: item.description,
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value),
      ),
    );
  }

  create(SalesOrder salesOrder) {
    SalesOrderService.create(salesOrder).then((result) {
      setState(() {
        var s = (SalesOrder.fromJson(result.data));

        _salesOrder.id = s.id;
        _salesOrder.entityMode = EntityMode.Edit;
        _salesOrderDetail.id = s.details[0].id;
        _salesOrderDetail.entityMode = EntityMode.Edit;
        _salesOrder.details.add(_salesOrderDetail);
      });
      showInSnackBar("Record has been save successfully");
      setState(() {
        _isSubmit = false;
      });
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

  update(SalesOrder salesOrder) {
    setState(() {
      _isSubmit = true;
    });

    salesOrder.salesOrderStatusId = 1;

    SalesOrderService.update(salesOrder).then((value) {
      showInSnackBar("Record has been updated successfully");

      if (salesOrder.details[0].entityMode == EntityMode.New) {
        _salesOrder.details.add(salesOrder.details[0]);
      }

      setState(() {
        _isSubmit = false;
      });
      // Navigator.pop(context, true);
    }).catchError((err) {
      showInSnackBar("Something error please contact support");

      setState(() {
        _isSubmit = false;
      });
    });
  }

  onSubmit() {
    if (_salesOrder.entityMode == EntityMode.New) {
      // create();
    } else {
      // update();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "New Order",
        actions: [
          IconButton(
            onPressed: onSubmit,
            icon: _isSubmit == null && _isLoading
                ? Container()
                : _isSubmit
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
                        color: Colors.white,
                      ),
          ),
        ],
      ),
      body: _isLoading
          ? LoadingWidget()
          : Container(
              padding: EdgeInsets.all(0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FormListTile(
                      title: "General Info",
                      widget: Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: (MediaQuery.of(context).size.width -
                                            40) /
                                        2,
                                    child: TextFieldWidget(
                                      labelText: "Order No",
                                      initialValue: _salesOrder.orderNo ?? "",
                                      keyboardType: TextInputType.text,
                                      onChanged: (value) {
                                        _salesOrder.orderNo = value;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: (MediaQuery.of(context).size.width -
                                            40) /
                                        2,
                                    child: GestureDetector(
                                      onTap: () async {
                                        var date = await _selectDate(context);
                                        if (date != null) {
                                          setState(() {
                                            _salesOrder.orderDate =
                                                dateFormat.format(date);
                                          });
                                        }
                                      },
                                      child: TextFieldWidget(
                                        enabled: false,
                                        labelText: "Order Date",
                                        initialValue: _salesOrder.orderDate,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => customerModalBottomSheet(context),
                              child: TextFieldWidget(
                                labelText: "Customer",
                                isDropdown: true,
                                key: Key(_salesOrder.customer?.name),
                                enabled: false,
                                isRequired: true,
                                initialValue: _salesOrder.customer?.name ?? "",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FormListTile(
                      title: "Items",
                      widget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var detail in _salesOrder.details)
                            ItemListTile(
                              onTap: () {
                                setState(() {
                                  _salesOrderDetail = detail;
                                  _salesOrderDetail.entityMode =
                                      EntityMode.Edit;
                                });

                                itemModalBottomSheet(context);
                              },
                              detail: detail,
                            ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () async {
                                  var item = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SalesOrderItemListScreen(
                                        items: _items,
                                        salesOrder: _salesOrder,
                                        itemGroups: _itemGroups,
                                        itemParameters: _itemParameters,
                                      ),
                                    ),
                                  ) as Item;

                                  if (item != null) {
                                    setState(() {
                                      _salesOrderDetail =
                                          new SalesOrderDetail();
                                      _salesOrderDetail.id = 0;
                                      _salesOrderDetail.discount = 0;
                                      _salesOrderDetail.total = 0;
                                      _salesOrderDetail.bonus = 0;
                                      _salesOrderDetail.quantity = 0;
                                      _salesOrderDetail.price = 0;
                                      _salesOrderDetail.salesOrderId =
                                          _salesOrder.id ?? 0;
                                      _salesOrderDetail.entityMode =
                                          EntityMode.New;
                                      _salesOrderDetail.itemId = item.id;
                                      _salesOrderDetail.item = item;
                                    });

                                    itemModalBottomSheet(context);
                                  }
                                },
                                child: ButtonWidget(
                                  margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
                                  title: "Add Item",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 0,
                          ),
                        ],
                      ),
                    ),
                    FormListTile(
                      widget: Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.only(right: 15, top: 15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Subtotal:",
                                  style: TextStyle(
                                    color: Color(0xff29304D),
                                    fontSize: 15,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "\$ ${_salesOrder.subTotal}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff323232),
                                      ),
                                    ),
                                    Container(
                                      width: 30,
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Divider(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Discount:",
                                  style: TextStyle(
                                    color: Color(0xff29304D),
                                    fontSize: 15,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 35,
                                      height: 25,
                                      child: TextFormField(
                                        initialValue: "0",
                                        maxLength: 3,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            counterStyle: TextStyle(
                                              height: double.minPositive,
                                            ),
                                            counterText: ""),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 20,
                                      child: Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        size: 16,
                                        color: Color(0xff323232),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Divider(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total:",
                                  style: TextStyle(
                                    color: Color(0xff29304D),
                                    fontSize: 15,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "\$ ${_salesOrder.total}",
                                      style: TextStyle(
                                        color: Color(0xff323232),
                                        fontSize: 16,
                                      ),
                                    ),
                                    Container(
                                      width: 30,
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      var date = await _selectDate(context);
                                      if (date != null) {
                                        setState(() {
                                          _salesOrder.deliveryDate =
                                              dateFormat.format(date);
                                        });
                                      }
                                    },
                                    child: Container(
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  40) /
                                              2,
                                      child: TextFieldWidget(
                                        labelText: "Delivery Date",
                                        key: Key(_salesOrder.deliveryDate),
                                        initialValue: _salesOrder.deliveryDate,
                                        hintText: _salesOrder.deliveryDate,
                                        enabled: false,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: (MediaQuery.of(context).size.width -
                                            40) /
                                        2,
                                    child: GestureDetector(
                                      onTap: () async {
                                        var date = await _selectDate(context);
                                        if (date != null) {
                                          setState(() {
                                            _salesOrder.dueDate =
                                                dateFormat.format(date);
                                          });
                                        }
                                      },
                                      child: TextFieldWidget(
                                        key: Key(_salesOrder.dueDate),
                                        enabled: false,
                                        labelText: "Due Date",
                                        initialValue: _salesOrder.dueDate,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextFieldWidget(
                              labelText: "Description",
                              initialValue: _salesOrder.description,
                              onChanged: (description) {
                                setState(() {
                                  _salesOrder.description = description;
                                });
                              },
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

class ItemListTile extends StatelessWidget {
  ItemListTile({
    Key key,
    this.detail,
    this.onTap,
  }) : super(key: key);

  final SalesOrderDetail detail;
  GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/image/item-1.png",
                  width: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 110,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${numberFormat.format(detail?.quantity ?? 0)} x ${detail.item?.name}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 110,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  detail.item?.group?.name,
                                  style: TextStyle(
                                    color: Color(0xff545F7A),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ItemList(
                                        value:
                                            "${numberFormat.format(detail.price)}",
                                      ),
                                      ItemList(
                                        value:
                                            "${detail.total == null ? 0 : numberFormat.format(detail.total)}",
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      1 == 1
                          ? Container()
                          : Center(
                              child: IconButton(
                                constraints: BoxConstraints(),
                                padding: EdgeInsets.zero,
                                onPressed: () {},
                                icon: Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider()
      ],
    );
  }
}

class ItemList extends StatelessWidget {
  ItemList({
    Key key,
    this.title,
    this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ItemDetailListTile extends StatelessWidget {
  ItemDetailListTile({
    Key key,
    this.title,
    this.subtitle,
  }) : super(key: key);
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
      ),
      trailing: Text(subtitle ?? ""),
    );
  }
}
