import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nandrlon/helper/snackbar.dart';
import 'package:nandrlon/models/crm/customer/customer.dart';
import 'package:nandrlon/models/crm/sales-order/sales-order-parameter.dart';
import 'package:nandrlon/models/crm/sales-order/sales-order-result.dart';
import 'package:nandrlon/models/crm/sales-order/sales-order-statuses.dart';
import 'package:nandrlon/models/crm/sales-order/sales-order.dart';
import 'package:nandrlon/models/crm/shared/city.dart';
import 'package:nandrlon/models/crm/shared/result.dart';
import 'package:nandrlon/screens/delivery-note/form.screen.dart';
import 'package:nandrlon/screens/sales-order/filter.screen.dart';
import 'package:nandrlon/screens/sales-order/form.screen.dart';
import 'package:nandrlon/screens/sales-order/view.screen.dart';
import 'package:nandrlon/services/sales-order.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/bottom-sheet-item.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/image.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:nandrlon/widgets/loading.widget.dart';
import 'package:nandrlon/widgets/pdf-viewr.dart';

class SalesOrderListScreen extends StatefulWidget {
  const SalesOrderListScreen({Key key}) : super(key: key);

  @override
  ContactListStateScreen createState() => ContactListStateScreen();
}

var numberFormat = NumberFormat('###,###.##', 'en_Us');

class ContactListStateScreen extends State<SalesOrderListScreen> {
  ScrollController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<SalesOrderResult> _salesOrders;
  List<SalesOrderStatus> _salesOrderStatuses;
  SalesOrderParameters _salesOrderParameters;
  var searchController = TextEditingController();
  bool _isSearching = false;
  bool _isLoading = false;
  String searchQuery = "Search query";
  Timer _debounce;
  dynamic _speciality;
  dynamic _city;
  List<City> _cities;

  @override
  void initState() {
    _salesOrderParameters = new SalesOrderParameters();
    getSalesOrders();
    getSalesOrderStatuses();
    super.initState();
  }

  getSalesOrders() async {
    var salesOrders =
        await SalesOrderService.salesOrders(_salesOrderParameters);
    setState(() {
      _salesOrders = salesOrders;
      _isLoading = false;
    });
  }

  getSalesOrderStatuses() async {
    var statuses = await SalesOrderService.statuses();
    setState(() {
      _salesOrderStatuses = statuses;
      _isLoading = false;
    });
  }

  Future<Result> deleteSalesOrder(int id) async {
    return await SalesOrderService.delete(id);
  }

  Future<Result> duplicateSalesOrder(int id) async {
    return await SalesOrderService.duplicate(id);
  }

  Future<void> _showDuplicateDialog(
      BuildContext context, SalesOrderResult salesOrder) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Are you sure you want to duplicate this record?'),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Confirm',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () async {
                var result = await duplicateSalesOrder(salesOrder.id);

                if (result.success) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  var salesOrder = SalesOrder.fromJson(result.data);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SalesOrderFormScreen(
                        salesOrderId: salesOrder.id,
                      ),
                    ),
                  );
                } else {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  showInSnackBar(SnackBarType.Error, context);
                }
              },
            ),
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteDialog(
      BuildContext context, SalesOrderResult salesOrder) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Are you sure you want to delete this record?'),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Confirm',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () async {
                var result = await deleteSalesOrder(salesOrder.id);

                if (result.success) {
                  setState(() {
                    var index = _salesOrders.indexOf(salesOrder);
                    _salesOrders.removeAt(index);
                  });
                } else {
                  showInSnackBar(SnackBarType.Error, context);
                }

                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<SalesOrder> getSalesOrderByStatusId(salesOrderStatusId) {
    return _salesOrders
        .where(
            (salesOrder) => salesOrder.salesOrderStatusId == salesOrderStatusId)
        .toList();
  }

  void _showBottomSheet(BuildContext context, SalesOrderResult salesOrder) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: 0.6,
                minChildSize: 0.2,
                maxChildSize: 0.75,
                builder: (_, controller) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(15.0),
                        topRight: const Radius.circular(15.0),
                      ),
                    ),
                    child: ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    salesOrder.customerName,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "#${salesOrder.orderNo}",
                                        style: TextStyle(
                                          color: Color(
                                            0xff8d989f,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        " | ",
                                        style: TextStyle(
                                          color: Color(
                                            0xff8d989f,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        salesOrder.orderDate,
                                        style: TextStyle(
                                          color: Color(
                                            0xff8d989f,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "\$ ${numberFormat.format(salesOrder.total)}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Delivered",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        BottomSheetItem(
                            onTap: () async {
                              Navigator.of(context).pop();
                              var deleted = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SalesOrderViewScreen(
                                    salesOrderId: salesOrder.id,
                                  ),
                                ),
                              );

                              if (deleted == true) {
                                getSalesOrders();
                              }
                            },
                            icon: Icons.remove_red_eye_outlined,
                            title: "View"),
                        BottomSheetItem(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SalesOrderFormScreen(
                                    salesOrderId: salesOrder.id,
                                  ),
                                ),
                              );
                            },
                            icon: Icons.edit_outlined,
                            title: "Edit"),
                        BottomSheetItem(
                            onTap: () => _showDeleteDialog(context, salesOrder),
                            icon: Icons.delete_outline_outlined,
                            title: "Delete"),
                        BottomSheetItem(
                            onTap: () =>
                                _showDuplicateDialog(context, salesOrder),
                            icon: Icons.copy_outlined,
                            title: "Duplicate"),
                        BottomSheetItem(
                            onTap: () {
                              var customer = new Customer();
                              customer.id = salesOrder.id;
                              customer.name = salesOrder.customerName;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeliveryNoteFormScreen(
                                    customer: customer,
                                    salesOrderId: salesOrder.id,
                                  ),
                                ),
                              );
                            },
                            icon: Icons.description_outlined,
                            title: "Receive"),
                        BottomSheetItem(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PDFViewr(
                                    title: "#${salesOrder.orderNo}",
                                    reportName: "sales-order",
                                    fileName: "sales-order",
                                    parameters: "Id=${salesOrder.id}",
                                  ),
                                ),
                              );
                            },
                            icon: Icons.print_outlined,
                            title: "Print"),
                        BottomSheetItem(
                            icon: Icons.send_outlined, title: "Send"),

                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  showProfile(SalesOrderResult salesOrder) {
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
                  ImageWidget(
                    width: 80,
                    height: 80,
                    errorText: salesOrder.orderNo[0],
                    errorTextFontSize: 30,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    salesOrder.orderNo,
                    style: TextStyle(
                      color: Color(0xff29304D),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ActionButton(
                          color: Color(0xff2574FF),
                          iconData: Icons.edit,
                          onTap: () async {
                            Navigator.pop(context);

                            var isSaved = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SalesOrderFormScreen(),
                              ),
                            );

                            if (isSaved == true) {
                              setState(() {
                                _isLoading = true;
                              });
                              getSalesOrders();
                            }
                          },
                        ),
                        ActionButton(
                          color: Color(0xff12B2B3),
                          iconData: Icons.call_outlined,
                        ),
                        ActionButton(
                          color: Color(0xff1DA1F2),
                          iconData: Icons.mail_outline,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: 300,
                    child: Divider(),
                  ),
                  ListTile(
                    dense: true,
                    leading: new Icon(Icons.location_city_outlined),
                    title: new Text(
                      "Customer",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff565656),
                      ),
                    ),
                    subtitle: new Text(
                      salesOrder.customerName,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildSearchField() {
    return TextFormField(
      autofocus: true,
      initialValue: _salesOrderParameters.orderNo,
      decoration: InputDecoration(
        hintText: "search".tr(),
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Orders",
      style: TextStyle(
        color: Colors.white,
      ),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () {
            if (searchController == null || searchController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: Icon(
          Icons.search,
          color: Colors.white,
        ),
        onPressed: _startSearch,
      ),
      IconButton(
        icon: Icon(
          Icons.filter_alt_outlined,
          color: Colors.white,
        ),
        onPressed: () async {
          var salesOrderParameters = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SalesOrderFilterScreen(
                cities: _cities,
                salesOrderParameters: _salesOrderParameters,
              ),
            ),
          );

          if (salesOrderParameters != null) {
            setState(() {
              _salesOrders = null;
              _salesOrderParameters = salesOrderParameters;
            });

            getSalesOrders();
          }
        },
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _salesOrderParameters.orderNo = newQuery;
      });
      getSalesOrders();
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      searchController.clear();
      updateSearchQuery("");
      getSalesOrders();
    });
  }

  Future<Null> _refresh() async {
    var salesOrders =
        await SalesOrderService.salesOrders(_salesOrderParameters);
    setState(() {
      _salesOrders = salesOrders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _salesOrderStatuses == null || _salesOrders == null
        ? Scaffold(
            body: LoadingWidget(),
          )
        : DefaultTabController(
            length: _salesOrderStatuses.length,
            child: Layout(
              key: _scaffoldKey,
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () async {
                  var isSaved = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SalesOrderFormScreen(),
                    ),
                  );

                  if (isSaved != null) {
                    getSalesOrders();
                  }
                },
              ),
              appBar: AppBarWidget(
                size: 105,
                titleWidget: _isSearching ? _buildSearchField() : _buildTitle(),
                actions: _buildActions(),
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  tabs: [
                    if (_salesOrderStatuses != null)
                      for (var status in _salesOrderStatuses)
                        Tab(
                          text: status.name,
                        ),
                  ],
                ),
              ),
              body: SafeArea(
                child: TabBarView(
                  children: [
                    for (var status in _salesOrderStatuses)
                      ListViewHelper(
                        onRefresh: _refresh,
                        list: getSalesOrderByStatusId(status.id),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: OrderListTile(
                                salesOrder:
                                    getSalesOrderByStatusId(status.id)[index],
                                onTap: () {
                                  _showBottomSheet(
                                      context,
                                      getSalesOrderByStatusId(
                                          status.id)[index]);
                                }),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
  }
}

class OrderListTile extends StatelessWidget {
  OrderListTile({
    Key key,
    this.salesOrder,
    this.onTap,
  }) : super(key: key);

  final SalesOrderResult salesOrder;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CardWidget(
        radius: 0,
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  salesOrder.customerName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      "#${salesOrder.orderNo ?? ""}",
                      style: TextStyle(
                        color: Color(
                          0xff8d989f,
                        ),
                      ),
                    ),
                    Text(
                      " | ",
                      style: TextStyle(
                        color: Color(
                          0xff8d989f,
                        ),
                      ),
                    ),
                    Text(
                      salesOrder.orderDate,
                      style: TextStyle(
                        color: Color(
                          0xff8d989f,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "\$ ${numberFormat.format(salesOrder.total)}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Delivered",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  Item({
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
      padding: EdgeInsets.only(
        left: 15,
        top: 15,
      ),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  icon,
                  size: 17,
                  color: iconColor,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Color(0xff545F7A),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                value,
                style: TextStyle(
                  color: Color(0xff0F1B2D),
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

class ActionButton extends StatelessWidget {
  ActionButton({Key key, this.color, this.iconData, this.onTap})
      : super(key: key);

  IconData iconData;
  Color color;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: color,
        ),
        child: Icon(
          iconData,
          size: 15,
          color: Colors.white,
        ),
      ),
    );
  }
}
