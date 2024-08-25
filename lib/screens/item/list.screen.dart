import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/models/crm/Item/Item-group.dart';
import 'package:nandrlon/models/crm/Item/Item-result.dart';
import 'package:nandrlon/models/crm/Item/Item-type.dart';
import 'package:nandrlon/models/crm/Item/Item-unit.dart';
import 'package:nandrlon/models/crm/Item/item-parameter.dart';
import 'package:nandrlon/models/crm/Item/item-photo.dart';
import 'package:nandrlon/screens/item/filter.screen.dart';
import 'package:nandrlon/services/item.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen();

  @override
  ItemListStateScreen createState() => ItemListStateScreen();
}

class ItemListStateScreen extends State<ItemListScreen> {
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
  bool isLoadingPhotos = false;

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

  Future<void> getItemPhotos(int id) async {
    var itemPhotos = await ItemService.photos(id);
    setState(() {
      _itemPhotos = itemPhotos;
      isLoadingPhotos = false;
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

          if (itemParameters != null) {
            setState(() {
              _items =null;
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
      _items =null;
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

  @override
  Widget build(BuildContext context) {
    return Layout(
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
                onTap: isLoadingPhotos ? null : () async {

                  setState(() {
                    isLoadingPhotos = true;
                  });

                  await getItemPhotos(_items[index].id);
                  showDetail(_items[index]);
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
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0xff4F62C0).withOpacity(0.15),
                spreadRadius: 0,
                blurRadius: 1,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
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
                      mainAxisAlignment: MainAxisAlignment.start,
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
                          height: 5,
                        ),
                        Text(
                          item.groupName,
                          style: TextStyle(
                            color: Color(0xff62656B),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Center(
                child: Text(
                  "\$ " + numberFormat.format(item.price),
                  style: TextStyle(
                    color: Color(0xff62656B),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  ActionButton({Key key, this.color, this.iconData, this.url})
      : super(key: key);

  final IconData iconData;
  final Color color;
  final String url;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'call not possible';
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
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
    return Column(
      children: [
        ListTile(
          dense: true,
          title: new Text(
            title,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          trailing: new Text(
            subtitle ?? "",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xff565656),
            ),
          ),
        ),
        Divider(height: 0,)
      ],
    );
  }
}
