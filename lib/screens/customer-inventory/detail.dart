import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nandrlon/models/crm/customer-inventory/customer-inventory-item.dart';
import 'package:nandrlon/services/customer-inventory.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';

class CustomerInventoryDetailScreen extends StatefulWidget {
  CustomerInventoryDetailScreen({
    Key key,
    this.id,
  }) : super(key: key);

  int id;

  @override
  _CustomerInventoryDetailScreenState createState() =>
      _CustomerInventoryDetailScreenState();
}

var numberFormat = NumberFormat('#,###.##', 'en_Us');

class _CustomerInventoryDetailScreenState
    extends State<CustomerInventoryDetailScreen> {
  List<CustomerInventoryItem> _customerInventories;

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  onLoad() async {
    var customerInventories =
        await CustomerInventoryService.getCustomerInventoryItems(widget.id);

    setState(() {
      _customerInventories = customerInventories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "Detail",
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15),
        child: ListViewHelper(
          list: _customerInventories,
          onRefresh: () => onLoad(),
          itemBuilder: (context, index) {
            return ItemListTile(
                customerInventoryItem: _customerInventories[index],
                isFirst: index == 0,
                isLast: index == _customerInventories.length - 1,
                length: _customerInventories.length);
          },
        ),
      ),
    );
  }
}

class CustomerInventorListTile extends StatelessWidget {
  CustomerInventorListTile({
    Key key,
    this.customerInventory,
    this.onTap,
  }) : super(key: key);

  final CustomerInventoryItem customerInventory;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        onTap: onTap,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              customerInventory.item.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemListTile extends StatelessWidget {
  ItemListTile({
    Key key,
    this.customerInventoryItem,
    this.onTap,
    this.isFirst,
    this.isLast,
    this.length,
  }) : super(key: key);

  final CustomerInventoryItem customerInventoryItem;
  GestureTapCallback onTap;
  final bool isFirst;
  final bool isLast;
  final int length;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          padding:
              EdgeInsets.fromLTRB(0, isFirst ? 20 : 10, 0, isLast ? 15 : 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isFirst == true ? 8 : 0),
              topRight: Radius.circular(isFirst == true ? 8 : 0),
              bottomLeft: Radius.circular(isLast == true ? 8 : 0),
              bottomRight: Radius.circular(isLast == true ? 8 : 0),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(right: 15, left: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/image/item-1.png",
                      width: 60,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                customerInventoryItem.item.name,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                customerInventoryItem.item.group.name,
                                style: TextStyle(
                                  color: Color(0xff62656B),
                                  fontSize: 14,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 10, 15, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Item(
                                          title: "Quantity",
                                          value:
                                              "${numberFormat.format(customerInventoryItem.quantity)}",
                                          iconColor: Colors.teal,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Item(
                                          title: "Price",
                                          value:
                                              "${numberFormat.format(customerInventoryItem.price)}",
                                          iconColor: Colors.blue,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Item(
                                          title: "Expiry Date",
                                          value:
                                              "${customerInventoryItem.expiryDate ?? ""}",
                                          iconColor: Colors.red,
                                          iconBackgroundColor:
                                              Colors.red.shade50,
                                          icon: Icons.money_outlined,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Item(
                                          title: "Batch No",
                                          value:
                                              "${customerInventoryItem.batchNo ?? ""}",
                                          iconColor: Colors.red,
                                          iconBackgroundColor:
                                              Colors.red.shade50,
                                          icon: Icons.money_outlined,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              length > 1 && !isLast
                  ? Divider(
                      color: Colors.black26,
                    )
                  : Container(),
            ],
          ),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title:",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          SizedBox(
            width: 3,
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
