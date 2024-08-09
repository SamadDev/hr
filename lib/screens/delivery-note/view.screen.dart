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
import 'package:nandrlon/models/crm/customer/customer.dart';
import 'package:nandrlon/models/crm/delivery-note/delivery-note-detail.dart';
import 'package:nandrlon/models/crm/delivery-note/delivery-note.dart';
import 'package:nandrlon/models/crm/sales-order/sales-order-result.dart';
import 'package:nandrlon/models/crm/sales-order/sales-order.dart';
import 'package:nandrlon/models/crm/sales-order/undelivered-sales-item.dart';
import 'package:nandrlon/models/crm/shared/entity-mode.dart';
import 'package:nandrlon/models/crm/warehouse/warehouse.dart';
import 'package:nandrlon/services/customer.service.dart';
import 'package:nandrlon/services/delivery-note.service.dart';
import 'package:nandrlon/services/item.service.dart';
import 'package:nandrlon/services/sales-order.service.dart';
import 'package:nandrlon/services/warehouse.service.dart';
import 'package:nandrlon/widgets/alert-dialog-widget.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/form.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/loading.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';

class DeliveryNoteViewScreen extends StatefulWidget {
  DeliveryNoteViewScreen({
    Key key,
    this.customer,
    this.salesOrderId,
    this.deliveryNoteId,
  }) : super(key: key);
  Customer customer;
  int salesOrderId;
  int deliveryNoteId;

  @override
  _DeliveryNoteViewScreenState createState() => _DeliveryNoteViewScreenState();
}

class _DeliveryNoteViewScreenState extends State<DeliveryNoteViewScreen> {
  List<Customer> _customers = [];
  var _deliveryNote = DeliveryNote();
  var _deliveryNoteDetail = new DeliveryNoteDetail();
  var numberFormat = NumberFormat('#,###.##', 'en_Us');
  List<ItemResult> _items = [];
  List<Warehouse> _warehouses = [];
  ItemParameters _itemParameters;
  var searchController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  Timer _debounce;
  bool _isLoading = true;
  bool _isLoadingSalesOrder = false;
  bool _isLoadingItems = false;
  EntityMode _entityMode = EntityMode.New;
  bool _isSubmit = false;
  List<ItemGroup> _itemGroups;
  List<UndeliveredSalesItem> _undeliveredItems;
  List<ItemPhoto> _itemPhotos;
  List<SalesOrder> _salesOrders;

  @override
  void initState() {
    _deliveryNote.details = [];
    _itemParameters = new ItemParameters();
    _itemParameters.itemGroup = null;
    _itemParameters.itemUnit = null;
    _itemParameters.itemType = null;
    _deliveryNote.deliveryDate = dateFormat.format(DateTime.now());
    _deliveryNote.deliveryNo = "(new)";
    _deliveryNote.entityMode = EntityMode.New;
    onLoad();
    super.initState();
  }

  Future<List<Customer>> getCustomers(searchText) async {
    return await CustomerService.filter(searchText);
  }

  Future<List<SalesOrderResult>> getUndeliveredSalesOrders(
      int customerId) async {
    var salesOrders =
        await SalesOrderService.getUndeliveredSalesOrders(customerId);
    setState(() {
      _salesOrders = salesOrders;
    });
  }

  getUndeliveredSalesItems(int salesOrderId) async {
    setState(() {
      _deliveryNote.details = [];
    });

    var undeliveredItems =
        await SalesOrderService.getUndeliveredSalesItems(salesOrderId);

    undeliveredItems.forEach((undeliveredItem) {
      var detail = new DeliveryNoteDetail();
      detail.item = new Item();
      detail.item.group = new ItemGroup();
      detail.item.name = undeliveredItem.itemName;
      detail.item.group.name = undeliveredItem.groupName;
      detail.item.id = undeliveredItem.itemId;
      detail.quantity = undeliveredItem.quantity;

      setState(() {
        _deliveryNote.details.add(detail);
      });
    });

    setState(() {
      _isLoadingItems = false;
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
            onTap: (index) async {
              mystate(() {
                _isLoadingSalesOrder = true;
              });

              var salesOrders =
                  await SalesOrderService.getUndeliveredSalesOrders(
                      _customers[index].id);

              setState(() {
                _salesOrders = salesOrders;
              });

              mystate(() {
                _isLoadingSalesOrder = false;
                _deliveryNote.customer = _customers[index];
                _deliveryNote.customerId = _customers[index].id;
              });

              if (_salesOrders.length > 0) {
                salesOrdersModalBottomSheet(context);
              }
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

  salesOrdersModalBottomSheet(BuildContext context) {
    Navigator.pop(context);
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, mystate) => ListView.builder(
              shrinkWrap: true,
              itemCount: _salesOrders.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: new Text(
                          "${_salesOrders[index].orderNo} - ${_salesOrders[index].orderDate}"),
                      onTap: () {
                        Navigator.pop(context);

                        setState(() {
                          _deliveryNote.refId = _salesOrders[index].id;
                          _deliveryNote.refNo = _salesOrders[index].orderNo;
                          _deliveryNote.refDate = _salesOrders[index].orderDate;
                          _isLoadingItems = true;
                        });
                        getUndeliveredSalesItems(_salesOrders[index].id);
                      },
                    ),
                    Divider(
                      height: 0,
                    ),
                  ],
                );
              },
            ),
          );
        });
  }

  onLoad() async {
    var warehouses = await WarehouseService.getAll();
    var itemGroups = await ItemService.getItemGroups();
    var items = await ItemService.getItemResult(_itemParameters);

    if (widget.salesOrderId != null) {
      getUndeliveredSalesItems(widget.salesOrderId);
      _deliveryNote.customer = widget.customer;
      _deliveryNote.customerId = widget.customer.id;
    }
    if (widget.deliveryNoteId != null) {
      var deliveryNote = await DeliveryNoteService.get(widget.deliveryNoteId);
      
      
      setState(() {
        _deliveryNote = deliveryNote;
      });
    }
    setState(() {
      _warehouses = warehouses;
      _itemGroups = itemGroups;
      _items = items;
      _isLoading = false;
    });
  }

  double calcTotal(DeliveryNoteDetail detail) {
    // double price = detail.price ?? 0;
    // double discount = detail.discount ?? 0;

    // double total = (price * quantity);
    // total = discount == 0 ? total : total - (total * (discount / 100));

    // return total;
    return 0;
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
    var deliveryNote = DeliveryNote();

    _deliveryNoteDetail.deliveryNoteId = 0;
    deliveryNote.id = _deliveryNote.id ?? 0;
    deliveryNote.deliveryNo = "new()";
    deliveryNote.refNo = _deliveryNote.refNo;
    deliveryNote.refDate = _deliveryNote.refDate;
    deliveryNote.refId = _deliveryNote.refId;
    deliveryNote.customerId = _deliveryNote.customerId;
    deliveryNote.deliveryDate = _deliveryNote.deliveryDate;
    deliveryNote.description = _deliveryNote.description;
    deliveryNote.deliveryDate = _deliveryNote.deliveryDate;
    deliveryNote.entityMode = _deliveryNote.entityMode;
    deliveryNote.warehouseId = 1;
    deliveryNote.details = [];

    setState(() {
      deliveryNote.details.add(_deliveryNoteDetail);
    });

    if (deliveryNote.entityMode == EntityMode.New) {
      create(deliveryNote);
    } else {
      update(deliveryNote);
    }

    Navigator.pop(context);
  }

  editDetail() {
    var deliveryNote = DeliveryNote();

    calculate();

    deliveryNote.id = _deliveryNote.id ?? 0;
    deliveryNote.customerId = _deliveryNote.customerId;
    deliveryNote.deliveryDate = _deliveryNote.deliveryDate;
    deliveryNote.deliveryDate = _deliveryNote.deliveryDate;
    deliveryNote.description = _deliveryNote.description;
    deliveryNote.deliveryDate = _deliveryNote.deliveryDate;
    deliveryNote.entityMode = _deliveryNote.entityMode;
    deliveryNote.details = [];

    setState(() {
      deliveryNote.details.add(_deliveryNoteDetail);
    });

    if (deliveryNote.entityMode == EntityMode.New) {
      create(deliveryNote);
    } else {
      update(deliveryNote);
    }

    Navigator.pop(context);
  }

  calculate() {
    double total = 0;

    _deliveryNote.details.forEach((item) {
      // total += item.total;
    });

    setState(() {
      // _deliveryNote.subTotal = total + _deliveryNoteDetail.total;
      // _deliveryNote.total = total + _deliveryNoteDetail.total;
    });
  }

  itemModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
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
                          _deliveryNoteDetail.item.name,
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
                        "_deliveryNoteDetail.item.group.name",
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
                      child: TextFieldWidget(
                        labelText: "Quantity",
                        keyboardType: TextInputType.number,
                        initialValue: _deliveryNoteDetail.quantity == 0
                            ? ""
                            : _deliveryNoteDetail.quantity.toString(),
                        onChanged: (quantity) {
                          itemState(() {
                            _deliveryNoteDetail.quantity =
                                double.tryParse(quantity) ?? 0;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFieldWidget(
                        labelText: "Description",
                        initialValue: _deliveryNoteDetail.description,
                        onChanged: (description) {
                          setState(() {
                            _deliveryNoteDetail.description = description;
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
                                _deliveryNoteDetail.entityMode == EntityMode.New
                                    ? addDetail()
                                    : editDetail(),
                            child: Text(
                              _deliveryNoteDetail.entityMode == EntityMode.New
                                  ? "Add item"
                                  : "Update",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
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

  create(DeliveryNote deliveryNote) {
    DeliveryNoteService.create(deliveryNote).then((result) {
      setState(() {
        var s = (DeliveryNote.fromJson(result.data));

        _deliveryNote.refId = deliveryNote.id;
        _deliveryNote.refNo = deliveryNote.refNo;
        _deliveryNote.refDate = deliveryNote.refDate;
        _deliveryNote.id = s.id;
        _deliveryNote.entityMode = EntityMode.Edit;
        _deliveryNoteDetail.id = s.details[0].id;
        _deliveryNoteDetail.entityMode = EntityMode.Edit;
        _deliveryNote.details.add(_deliveryNoteDetail);
      });
      showInSnackBar("Record has been save successfully");
      setState(() {
        _isSubmit = false;
      });
    }).catchError((err) {
      
      
    });

    setState(() {
      _isSubmit = false;
    });
  }

  update(DeliveryNote deliveryNote) {
    
    

    setState(() {
      _isSubmit = true;
    });

    DeliveryNoteService.update(deliveryNote).then((value) {
      showInSnackBar("Record has been updated successfully");

      if (deliveryNote.details[0].entityMode == EntityMode.New) {
        _deliveryNote.details.add(deliveryNote.details[0]);
      }

      setState(() {
        _isSubmit = false;
      });
      // Navigator.pop(context, true);
    }).catchError((err) {
      // showInSnackBar("Something error please contact support");
      //
      // setState(() {
      //   _isSubmit = false;
      // });
    });
  }

  onSubmit() {
    if (_deliveryNote.entityMode == EntityMode.New) {
      // create();
    } else {
      // update();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: _isLoading ? "" : "#${_deliveryNote.deliveryNo}",
      ),
      body: _isLoading
          ? LoadingWidget()
          : Container(
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
                                            75) /
                                        2,
                                    child: ItemDetailTile(
                                      title: "Delivery No",
                                      value: _deliveryNote.deliveryNo ?? "",
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: (MediaQuery.of(context).size.width -
                                            75) /
                                        2,
                                    child: ItemDetailTile(
                                      title: "Delivery Date",
                                      value: _deliveryNote.deliveryDate,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ItemDetailTile(
                              title: "Customer",
                              value: _deliveryNote.customer?.name ?? "",
                            ),
                            ItemDetailTile(
                              title: "Warehouse",
                              value: _deliveryNote.warehouse?.name ?? "",
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
                          _isLoadingItems
                              ? Container(
                                  height: 100,
                                  child: LoadingWidget(),
                                )
                              : Container(),
                          for (var detail in _deliveryNote.details)
                            DeliveryNoteItemListTile(
                              detail: detail,
                              onSubPressed: detail.quantity == 0
                                  ? null
                                  : () {
                                      setState(() {
                                        if (detail.quantity > 0)
                                          detail.quantity--;
                                      });
                                    },
                              onAddPressed: () {
                                setState(() {
                                  detail.quantity++;
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                    FormListTile(
                      title: "Extra Info",
                      widget: Container(
                        padding: EdgeInsets.all(15),
                        child: ItemDetailTile(
                          title: "Description",
                          value: _deliveryNote.description,
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

class DeliveryNoteItemListTile extends StatelessWidget {
  DeliveryNoteItemListTile({
    Key key,
    this.detail,
    this.onTap,
    this.onAddPressed,
    this.onSubPressed,
  }) : super(key: key);

  final DeliveryNoteDetail detail;
  GestureTapCallback onTap;
  GestureTapCallback onAddPressed;
  GestureTapCallback onSubPressed;

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
                                  detail.item?.group.name ?? "",
                                  style: TextStyle(
                                    color: Color(0xff545F7A),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Container(
                                  width: 150,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: IconButton(
                                          onPressed: onAddPressed,
                                          constraints: BoxConstraints(),
                                          padding: EdgeInsets.zero,
                                          icon: Icon(Icons.add),
                                        ),
                                      ),
                                      Container(
                                        width: 70,
                                        child: TextFieldWidget(
                                          keyboardType: TextInputType.number,
                                          key: Key(detail.quantity.toString()),
                                          initialValue: detail.quantity
                                              .toStringAsFixed(0),
                                          onChanged: (quantity) {
                                            detail.quantity =
                                                double.tryParse(quantity);
                                          },
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: IconButton(
                                          onPressed: onSubPressed,
                                          constraints: BoxConstraints(),
                                          padding: EdgeInsets.zero,
                                          icon: Icon(
                                            Icons.remove,
                                          ),
                                        ),
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

class ItemTile extends StatelessWidget {
  ItemTile({
    Key key,
    this.title,
    this.value,
    this.icon,
    this.iconColor,
    this.iconBackgroundColor,
  }) : super(key: key);

  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;

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
                  fontSize: 14,
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

class ItemDetailTile extends StatelessWidget {
  ItemDetailTile({
    Key key,
    this.title,
    this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          value ?? "",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(
              0xff323232,
            ),
          ),
        ),
      ],
    );
  }
}
