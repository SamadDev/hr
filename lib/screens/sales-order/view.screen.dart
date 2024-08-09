import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/models/crm/Item/item-parameter.dart';
import 'package:nandrlon/models/crm/customer/customer-result.dart';
import 'package:nandrlon/models/crm/sales-order/sales-order-detail.dart';
import 'package:nandrlon/models/crm/sales-order/sales-order.dart';
import 'package:nandrlon/models/crm/shared/result.dart';
import 'package:nandrlon/screens/sales-order/form.screen.dart';
import 'package:nandrlon/services/sales-order.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/bottom-sheet-item.dart';
import 'package:nandrlon/widgets/form.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/loading.widget.dart';
import 'package:nandrlon/widgets/pdf-viewr.dart';

class SalesOrderViewScreen extends StatefulWidget {
  SalesOrderViewScreen({
    Key key,
    this.customer,
    this.salesOrderId,
  }) : super(key: key);
  CustomerResult customer;
  int salesOrderId;

  @override
  _SalesOrderViewScreenState createState() => _SalesOrderViewScreenState();
}

class _SalesOrderViewScreenState extends State<SalesOrderViewScreen> {
  var _salesOrder = SalesOrder();
  var numberFormat = NumberFormat('#,###.##', 'en_Us');
  ItemParameters _itemParameters;
  var searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    onLoad();
    super.initState();
  }

  onLoad() async {
    if (widget.salesOrderId != null) {
      var salesOrder = await SalesOrderService.get(widget.salesOrderId);

      setState(() {
        _salesOrder = salesOrder;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }


  Future<Result> duplicateSalesOrder(int id) async {
    return await SalesOrderService.duplicate(id);
  }

  Future<void> _showDuplicateDialog(BuildContext context,SalesOrder salesOrder) async {
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
                if(result.success){

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


  Future<Result> deleteSalesOrder(int id) async {
    return await SalesOrderService.delete(id);
  }

  Future<void> _showDeleteDialog(BuildContext context, SalesOrder salesOrder) async {
    Navigator.pop(context);

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

                deleteSalesOrder(salesOrder.id).then((result) {
                  if (result.success == true) {
                    Navigator.pop(context, true);
                    Navigator.pop(context, true);
                  } else {

                  }
                });
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

  void _showBottomSheet(BuildContext context, SalesOrder salesOrder) {
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
                initialChildSize: 0.4,
                minChildSize: 0.2,
                maxChildSize: 0.8,
                builder: (_, controller) {
                  return Container(
                    padding: EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(15.0),
                        topRight: const Radius.circular(15.0),
                      ),
                    ),
                    child: ListView(
                      children: [
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
                            title: "Edit"
                        ),
                        BottomSheetItem(
                          onTap: () => _showDeleteDialog(context,salesOrder),
                          icon: Icons.delete_outline_outlined,
                          title: "Delete"
                        ),
                        BottomSheetItem(
                            onTap: () => _showDuplicateDialog(context,salesOrder),
                            icon: Icons.copy_outlined,
                            title: "Duplicate"
                        ),
                        BottomSheetItem(
                          icon: Icons.description_outlined,
                          title: "Receive"
                        ),
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
                            title: "Print"
                        ),
                        BottomSheetItem(
                            icon: Icons.send_outlined,
                            title: "Send"
                        ),

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

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: _isLoading ? "" : "#${_salesOrder.orderNo}",
        actions: [
          IconButton(
            onPressed: () => _showBottomSheet(context, _salesOrder),
            icon: Icon(Icons.more_vert),
          )
        ],
      ),
      body: _isLoading
          ? LoadingWidget()
          : Container(
              margin: EdgeInsets.only(top: 5),
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
                                            30) /
                                        2,
                                    child: ItemDetailTile(
                                      title: "Order No",
                                      value: _salesOrder.orderNo,
                                    ),
                                  ),
                                  Container(
                                    width: (MediaQuery.of(context).size.width -
                                            30) /
                                        2,
                                    child: ItemDetailTile(
                                      title: "Order Date",
                                      value: _salesOrder.orderDate,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ItemDetailTile(
                              title: "Customer",
                              value: _salesOrder.customer.name,
                            ),
                          ],
                        ),
                      ),
                    ),
                    FormListTile(
                      title: "Items",
                      widget: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var detail in _salesOrder.details)
                              ItemListTile(
                                  detail: detail,
                                  count: _salesOrder.details.length),
                          ],
                        ),
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
                                Text(
                                  "\$ ${_salesOrder.subTotal}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff323232),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              height: 40,
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
                                Text(
                                  "\$ ${_salesOrder.discount}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff323232),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              height: 40,
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
                                Text(
                                  "\$ ${_salesOrder.total}",
                                  style: TextStyle(
                                    color: Color(0xff323232),
                                    fontSize: 16,
                                  ),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: (MediaQuery.of(context).size.width -
                                            30) /
                                        2,
                                    child: ItemDetailTile(
                                      title: "Delivery Date",
                                      value: _salesOrder.deliveryDate,
                                    ),
                                  ),
                                  Container(
                                    width: (MediaQuery.of(context).size.width -
                                            30) /
                                        2,
                                    child: ItemDetailTile(
                                      title: "Due Date",
                                      value: _salesOrder.dueDate,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ItemDetailTile(
                              title: "Description",
                              value: _salesOrder.description,
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
  ItemListTile({Key key, this.detail, this.onTap, this.count})
      : super(key: key);

  final SalesOrderDetail detail;
  GestureTapCallback onTap;
  int count;

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
                              fontSize: 16,
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
                                      Text(
                                        "${numberFormat.format(detail.price)}",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        "${detail.total == null ? 0 : numberFormat.format(detail.total)}",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
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
        count > 1 ? Divider() : SizedBox()
      ],
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
