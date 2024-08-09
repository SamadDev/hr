import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nandrlon/models/crm/Item/Item-group.dart';
import 'package:nandrlon/models/crm/Item/Item-result.dart';
import 'package:nandrlon/models/crm/Item/Item-type.dart';
import 'package:nandrlon/models/crm/Item/Item-unit.dart';
import 'package:nandrlon/models/crm/Item/item-parameter.dart';
import 'package:nandrlon/models/crm/Item/item-photo.dart';
import 'package:nandrlon/models/crm/customer-inventory/customer-inventory-item.dart';
import 'package:nandrlon/models/crm/customer-inventory/customer-inventory.dart';
import 'package:nandrlon/models/crm/customer/customer-result.dart';
import 'package:nandrlon/screens/item/filter.screen.dart';
import 'package:nandrlon/services/customer-inventory.service.dart';
import 'package:nandrlon/services/item.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';
import 'package:easy_localization/easy_localization.dart';

var numberFormat = NumberFormat('#,###.##', 'en_Us');

class CustomerInventoryFormScreen extends StatefulWidget {
  CustomerInventoryFormScreen({
    Key key,
    this.customer,
  }) : super(key: key);
  CustomerResult customer;

  @override
  ItemListStateScreen createState() => ItemListStateScreen();
}

class ItemListStateScreen extends State<CustomerInventoryFormScreen> {
  var dateMask = new MaskTextInputFormatter(mask: "##/##/####");
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final dateFormat = DateFormat('dd/MM/yyyy');
  var _customerInventory = CustomerInventory();
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  List<ItemResult> _items;
  ItemParameters _itemParameters;
  var searchController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  Timer _debounce;
  bool _isLoading = true;
  List<ItemGroup> _itemGroups;
  List<ItemType> _itemTypes;
  List<ItemUnit> _itemUnits;
  List<ItemPhoto> _itemPhotos;
  double _total = 0;

  @override
  void initState() {
    _itemParameters = new ItemParameters();
    _itemParameters.itemGroup = null;
    _itemParameters.itemUnit = null;
    _itemParameters.itemType = null;
    onLoad();
    super.initState();
  }

  Future<void> getItems() async {
    setState(() {
      _isLoading = true;
    });
    var items = await ItemService.getItemResult(_itemParameters);
    setState(() {
      _items = items;
      _isLoading = false;
    });
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

  Future<void> getItemPhotos(int id) async {
    var itemPhotos = await ItemService.photos(id);
    setState(() {
      _itemPhotos = itemPhotos;
    });
  }

  onLoad() async {
    var itemGroups = await ItemService.getItemGroups();
    var itemTypes = await ItemService.getItemTypes();
    var itemUnits = await ItemService.getItemUnits();
    await getItems();
    setState(() {
      _itemGroups = itemGroups;
      _itemTypes = itemTypes;
      _itemUnits = itemUnits;
      _isLoading = false;
    });
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      autofocus: true,
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
        fontWeight: FontWeight.bold,
      ),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Items",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  double calcTotal(ItemResult item) {
    double quantity = item.quantity ?? 0;
    double price = item.price ?? 0;
    double discount = item.discount ?? 0;

    double total = (price * quantity);
    total = discount == 0 ? total : total - (total * (discount / 100));

    return total;
  }

  addToBasket(ItemResult item) {
    if (item.quantity == 0) return;

    var _product = _items.where((p) => p.id == item.id).first;
    var index = _items.indexOf(_product);

    _product.price = item.price;
    _product.quantity = item.quantity;
    _product.discount = item.discount;

    setState(() {
      _items[index] = _product;
      item.isAddToBasket = true;
    });

    calcNetPrice();

    Navigator.pop(context);
  }

  calcNetPrice() {
    double total = 0;

    _items.where((product) => product.quantity > 0).forEach((product) {
      total = total + calcTotal(product);
    });

    setState(() {
      _total = total;
    });
  }

  onSubmit() async {
    setState(() {
      _isLoading = true;
    });

    _customerInventory.id = 0;
    _customerInventory.date = dateFormat.format(DateTime.now());
    _customerInventory.customerId = widget.customer.id;

    _customerInventory.items = [];
    int index = 0;
    _items.where((item) => item.quantity > 0).forEach((item) {
      var customerInventoryItem = new CustomerInventoryItem();
      customerInventoryItem.id = 0;
      customerInventoryItem.customerInventoryId = 0;
      customerInventoryItem.itemId = item.id;
      customerInventoryItem.quantity = item.quantity;
      customerInventoryItem.price = item.price;
      customerInventoryItem.description = item.description;

      setState(() {
        _customerInventory.items.add(customerInventoryItem);
      });

      index++;
    });

    await CustomerInventoryService.create(_customerInventory).then((value) {
      showInSnackBar("record has been save successfully");
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context, _customerInventory);
    }).catchError((err) {
      showInSnackBar("Something error please contact support");
    });
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value),
      ),
    );
  }

  itemModalBottomSheet(BuildContext context, ItemResult item) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.77,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
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
                      child: Text(
                        item.name,
                        style: TextStyle(
                          color: Color(0xff29304D),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        item.groupName,
                        style: TextStyle(
                          color: Color(0xff29304D),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                              initialValue: item.quantity.toString(),
                              onChanged: (quantity) {
                                setState(() {
                                  item.quantity =
                                      double.tryParse(quantity) ?? 0;
                                });

                                var total = calcTotal(item);

                                itemState(() {
                                  item.total = total;
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
                              initialValue: item.price.toString(),
                              onChanged: (price) {
                                setState(() {
                                  item.price = double.tryParse(price) ?? 0;
                                });

                                var total = calcTotal(item);

                                itemState(() {
                                  item.total = total;
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
                              inputFormatters: [dateMask],
                              keyboardType: TextInputType.number,
                              labelText: "Expiry Date",
                              hintText: "dd/mm/yyyy",
                              initialValue: item.expiryDate,
                              onChanged: (expiryDate) {
                                itemState(() {
                                  item.expiryDate = expiryDate;
                                });

                                setState(() {
                                  item.expiryDate = expiryDate;
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
                              labelText: "Batch No",
                              initialValue: item.batchNo,
                              onChanged: (batchNo) {
                                itemState(() {
                                  item.batchNo = batchNo;
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
                        initialValue: item.description,
                        onChanged: (description) {
                          setState(() {
                            item.description = description;
                          });
                        },
                        maxLines: 2,
                      ),
                    ),
                    Divider(
                      color: Colors.grey.withOpacity(0.2),
                      thickness: 5,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () => addToBasket(item),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Add item",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
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
          var itemParameters = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemFilterScreen(
                itemGroups: _itemGroups,
                itemTypes: _itemTypes,
                itemUnits: _itemUnits,
                itemParameters: _itemParameters,
              ),
            ),
          );

          if (itemParameters) {
            setState(() {
              _itemParameters = itemParameters;
            });

            getItems();
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
    _debounce = Timer(const Duration(milliseconds: 100), () {
      _itemParameters.searchText = newQuery;
      getItems();
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      key: _scaffoldKey,
      appBar: AppBarWidget(
        titleWidget: _isSearching ? _buildSearchField() : _buildTitle(),
        actions: _buildActions(),
      ),
      bottomSheet: _items == null
          ? Container(
              width: 0,
              height: 0,
            )
          : GestureDetector(
              onTap: () => onSubmit(),
              child: Container(
                margin: EdgeInsets.fromLTRB(15, 15, 15, 25),
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                ),
              ),
            ),
      body: Container(
        margin: EdgeInsets.only(top: 15),
        child: ListViewHelper(
          list: _items,
          itemBuilder: (context, index) {
            return ItemListTile(
                item: _items[index],
                isFirst: index == 0,
                isLast: index == _items.length - 1,
                onTap: () async {
                  // await getItemPhotos(_items[index].id);
                  itemModalBottomSheet(context, _items[index]);
                });
          },
        ),
      ),
    );
  }
}

class ItemListTile extends StatelessWidget {
  ItemListTile({
    Key key,
    this.item,
    this.onTap,
    this.isFirst,
    this.isLast,
  }) : super(key: key);

  final ItemResult item;
  GestureTapCallback onTap;
  final bool isFirst;
  final bool isLast;

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
                padding: EdgeInsets.only(right: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    item.isAddToBasket != true
                        ? Container()
                        : Container(
                            width: 4,
                            height: 80,
                            child: Center(
                              child: Container(
                                margin: EdgeInsets.only(top: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      width: 15,
                    ),
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
                                item.name,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                item.groupName,
                                style: TextStyle(
                                  color: Color(0xff62656B),
                                  fontSize: 14,
                                ),
                              ),
                              item.isAddToBasket != true
                                  ? Container()
                                  : Container(
                                      margin:
                                          EdgeInsets.fromLTRB(0, 10, 15, 10),
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
                                                    "${numberFormat.format(item.quantity)}",
                                                iconColor: Colors.teal,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Item(
                                                title: "Price",
                                                value:
                                                    "${numberFormat.format(item.price)}",
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
                                                    "${item.expiryDate ?? ""}",
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
                                                value: "${item.batchNo ?? ""}",
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
              Divider(
                color: Colors.black26,
              ),
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
