import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:intl/intl.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/models/crm/Item/Item-group.dart';
import 'package:nandrlon/models/crm/Item/Item-result.dart';
import 'package:nandrlon/models/crm/Item/Item-type.dart';
import 'package:nandrlon/models/crm/Item/Item-unit.dart';
import 'package:nandrlon/models/crm/Item/item-parameter.dart';
import 'package:nandrlon/models/crm/Item/item-photo.dart';
import 'package:nandrlon/models/crm/customer/customer-result.dart';
import 'package:nandrlon/models/crm/sales-order/sales-order-detail.dart';
import 'package:nandrlon/models/crm/sales-order/sales-order.dart';
import 'package:nandrlon/screens/item/filter.screen.dart';
import 'package:nandrlon/screens/sales-order/view.dart';
import 'package:nandrlon/services/item.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';
import 'package:easy_localization/easy_localization.dart';

class SalesOrderFormScreen extends StatefulWidget {
  SalesOrderFormScreen({
    Key key,
    this.customer,
  }) : super(key: key);
  CustomerResult customer;

  @override
  _SalesOrderFormScreenState createState() => _SalesOrderFormScreenState();
}

class _SalesOrderFormScreenState extends State<SalesOrderFormScreen> {
  var _salesOrder = SalesOrder();
  var numberFormat = NumberFormat('#,###.##', 'en_Us');
  List<ItemResult> _items = [];
  ItemParameters _itemParameters;
  var searchController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  Timer _debounce;
  bool _isLoading = false;
  List<ItemGroup> _itemGroups;
  List<ItemType> _itemTypes;
  List<ItemUnit> _itemUnits;
  List<ItemPhoto> _itemPhotos;
  double _total = 0;

  @override
  void initState() {
    _salesOrder.details = [];
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

  Future<List<ItemResult>> getListItems() async {
    return await ItemService.getItemResult(_itemParameters);
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
   // await getItems();
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
      "Products",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
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

  double calcTotal(ItemResult item) {
    double quantity = item.quantity ?? 0;
    double price = item.price ?? 0;
    double discount = item.discount ?? 0;

    double total = (price * quantity);
    total = discount == 0 ? total : total - (total * (discount / 100));

    return total;
  }

  addToBasket(ItemResult item) {
    var _salesOrderDetail = SalesOrderDetail();

    // var _item = _items.where((p) => p.id == item.id).first;
    // var index = _items.indexOf(_item);

    var exists = _salesOrder.details.firstWhere(
        (salesOrder) => salesOrder.itemId == item.id,
        orElse: () => null);

    int index = -1;
    if (exists != null) {
      index = _salesOrder.details.indexOf(exists);
    }

    setState(() {
      item.isAddToBasket = true;
    });

    _salesOrderDetail.itemId = item.id;
    _salesOrderDetail.price = item.price;
    _salesOrderDetail.quantity = item.quantity;
    _salesOrderDetail.discount = item.discount;
    _salesOrderDetail.total = item.total;
    _salesOrderDetail.item = item;

    setState(() {
      if (index == -1) {
        _salesOrder.details.add(_salesOrderDetail);
      } else {
        _salesOrder.details[index] = _salesOrderDetail;
      }
    });

    calcNetPrice();

    Navigator.pop(context);
  }

  calcNetPrice() {
    double total = 0;

    _items.where((item) => item.isAddToBasket == true).forEach((item) {
      total = total + calcTotal(item);
    });

    setState(() {
      _total = total;
      _salesOrder.subTotal = total;
      _salesOrder.total = total;
    });
  }

  itemModalBottomSheet(BuildContext context, ItemResult item) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.80,
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
                      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: backgroundColor == null
                            ? Color(0xffF7F7F7)
                            : backgroundColor,
                      ),
                      child: Autocomplete<ItemResult>(
                        initialValue: searchController.value,
                        optionsBuilder:
                            (TextEditingValue textEditingValue) async {
                          setState(() {
                            searchController.text = textEditingValue.text;
                            _itemParameters.searchText = textEditingValue.text;
                          });
                          var items = await ItemService.getItemResult(_itemParameters);


                          itemState(() {
                            _items = items;
                            _isLoading = false;
                          });

                          return _items;
                        },
                        displayStringForOption: (ItemResult option) =>
                            option.name,
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController fieldTextEditingController,
                            FocusNode fieldFocusNode,
                            VoidCallback onFieldSubmitted) {
                          return TextFormField(
                            controller: fieldTextEditingController,
                            focusNode: fieldFocusNode,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              counterText: "",
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(10, 10, 5, 15),
                              border: InputBorder.none,
                              hintText: "Item",
                              hintStyle: TextStyle(
                                color: Color(0x8C323232),
                                fontSize: 15,
                              ),
                            ),
                          );
                        },
                        onSelected: (ItemResult selection) {
                          setState(() {
                            searchController.text = selection.name;
                            _itemParameters.searchText = selection.name;
                          });
                        },
                        optionsViewBuilder: (BuildContext context,
                            AutocompleteOnSelected<ItemResult> onSelected,
                            Iterable<ItemResult> options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              child: Container(
                                width: 300,
                                height: 300,
                                decoration: BoxDecoration(
                                    color: backgroundColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color(0xff4F62C0).withOpacity(0.15),
                                        spreadRadius: 0,
                                        blurRadius: 3,
                                        offset: Offset(
                                            0, 1), // changes position of shadow
                                      ),
                                    ]),
                                child: ListView.builder(
                                  padding: EdgeInsets.all(10.0),
                                  itemCount: options.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final ItemResult option =
                                        options.elementAt(index);

                                    return GestureDetector(
                                      onTap: () {
                                        onSelected(option);
                                      },
                                      child: ListTile(
                                        title: Text(
                                          option.name,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
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
                              keyboardType: TextInputType.number,
                              initialValue: item.quantity.toString(),
                              onChanged: (quantity) {
                                itemState(() {
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
                              keyboardType: TextInputType.phone,
                              labelText: "Price",
                              initialValue: item.price.toString(),
                              onChanged: (price) {
                                itemState(() {
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
                              labelText: "Discount",
                              keyboardType: TextInputType.number,
                              initialValue: (numberFormat.format(item.discount))
                                  .toString(),
                              onChanged: (discount) {
                                itemState(() {
                                  item.discount =
                                      double.tryParse(discount) ?? 0;
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
                              labelText: "Bonus",
                              keyboardType: TextInputType.number,
                              initialValue: (numberFormat.format(item.discount))
                                  .toString(),
                              onChanged: (discount) {
                                itemState(() {
                                  item.discount =
                                      double.tryParse(discount) ?? 0;
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
                                item.quantity > 0 ? addToBasket(item) : null,
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
                            "USD ${item.total == null ? "0" : item.total.toStringAsPrecision(3)}",
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
                            debugPrint('Page changed: $value');
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

  @override
  Widget build(BuildContext context) {
    return Layout(
      bottomSheet: GestureDetector(
        onTap: () async {
          var products = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SalesOrderViewScreen(
                customer: widget.customer,
                salesOrder: _salesOrder,
              ),
            ),
          );

          if (products != null) {
            calcNetPrice();
            setState(() {
              _items = products;
            });
          }
        },
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            padding: EdgeInsets.symmetric(horizontal: 15),
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.white,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _items == null
                              ? ""
                              : _items
                                  .where((element) =>
                                      element.isAddToBasket == true)
                                  .length
                                  .toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "USD ${numberFormat.format(_total)}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Continue",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBarWidget(
        titleWidget: _isSearching ? _buildSearchField() : _buildTitle(),
        actions: _buildActions(),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15),
        child: ListViewHelper(
          list: _items,
          onRefresh: getItems,
          itemBuilder: (context, index) {
            return ItemListTile(
                item: _items[index],
                onTap: () async {
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
  }) : super(key: key);

  final ItemResult item;
  GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          height: 110,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0xff4F62C0).withOpacity(0.15),
                spreadRadius: 0,
                blurRadius: 3,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/image/item-1.png",
                width: 40,
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    item.isAddToBasket != true
                        ? Container()
                        : Container(
                            width: MediaQuery.of(context).size.width - 130,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Item(
                                  title: "Quantity",
                                  value:
                                      "${numberFormat.format(item.quantity)}",
                                  iconColor: Colors.red,
                                  iconBackgroundColor: Colors.red.shade50,
                                  icon: Icons.money_outlined,
                                ),
                                Item(
                                  title: "Price",
                                  value: "${numberFormat.format(item.price)}",
                                  iconColor: Colors.blue,
                                ),
                                Item(
                                  title: "Total",
                                  value: "${numberFormat.format(item.total)}",
                                  iconColor: Colors.teal,
                                ),
                              ],
                            ),
                          )
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
        children: [
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
