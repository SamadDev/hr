import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/models/crm/Item/Item-group.dart';
import 'package:nandrlon/models/crm/Item/item-parameter.dart';
import 'package:nandrlon/models/crm/Item/item.dart';
import 'package:nandrlon/models/crm/sales-order/sales-order.dart';
import 'package:nandrlon/services/item.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/dropdown.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';

class SalesOrderItemListScreen extends StatefulWidget {
  SalesOrderItemListScreen({
    Key key,
    this.items,
    this.itemGroups,
    this.salesOrder,
    this.itemParameters,
  }) : super(key: key);
  List<Item> items;
  List<ItemGroup> itemGroups;
  SalesOrder salesOrder;
  ItemParameters itemParameters;

  @override
  _SalesOrderItemListScreenState createState() =>
      _SalesOrderItemListScreenState();
}

class _SalesOrderItemListScreenState extends State<SalesOrderItemListScreen> {
  ScrollController _controller;
  ItemParameters _itemParameters;
  bool _isLoading = false;

  int _page = 1;
  int _limit = 20;

  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  @override
  void initState() {
    _controller = new ScrollController()..addListener(_loadMore);
    _itemParameters = new ItemParameters();
    super.initState();
  }

  Future<void> getItems() async {
    setState(() {
      _isLoading = true;
    });
    var items = await ItemService.getItems(_itemParameters);
    setState(() {
      widget.items = items;
      _isLoading = false;
    });
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      var items = await ItemService.getItems(_itemParameters);

      setState(() {
        widget.items.addAll(items);
      });
    } catch (err) {
      
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMore() async {
    
    
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter == 0) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });

      
      
      _page += 1; // Increase _page by 1
      _itemParameters.pageNumber = _page;
      try {
        var items = await ItemService.getItems(_itemParameters);

        if (items.length > 0) {
          setState(() {
            widget.items.addAll(items);
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "Items",
        size: 130,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: DropdownButtonWidget(
                    hintText: "Group",
                    value: _itemParameters.itemGroup,
                    items: widget.itemGroups.map((ItemGroup group) {
                      return DropdownMenuItem(
                        value: group,
                        child: Text(
                          group.name,
                        ),
                      );
                    }).toList(),
                    onChanged: (ItemGroup group) {
                      setState(() {
                        _itemParameters.itemGroupId = group.id;
                        _itemParameters.itemGroup = group;
                      });
                      getItems();
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    child: TextFieldWidget(
                      backgroundColor: Colors.white,
                      hintText: "search".tr(),
                      onChanged: (value) {
                        setState(() {
                          _itemParameters.searchText = value;
                        });
                        getItems();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15),
        child: ListViewHelper(
          list: widget.items,
          controller: _controller,
          itemBuilder: (context, index) {
            var detail = widget.salesOrder.details
                .where((element) => element.itemId == widget.items[index].id);

            return detail.isNotEmpty
                ? Container()
                : ItemListTile(
                    onTap: () {
                      Navigator.pop(context, widget.items[index]);
                    },
                    item: widget.items[index],
                  );
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

  final Item item;
  GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      item.group?.name ?? "",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
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
