import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/models/crm/media/media.dart';
import 'package:nandrlon/screens/media/files.screen.dart';
import 'package:nandrlon/services/media.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:easy_localization/easy_localization.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({Key key}) : super(key: key);

  @override
  MediaStateScreen createState() => MediaStateScreen();
}

class MediaStateScreen extends State<MediaScreen> {
  var searchController = TextEditingController();
  List<Media> _media;
  bool _isSearching = false;
  String searchQuery = "Search query";
  Timer _debounce;
  bool _isLoading = true;

  @override
  void initState() {
    getMedia();
    super.initState();
  }

  Future<void> getMedia() async {
    setState(() {
      _isLoading = true;
    });
    var media = await MediaService.getMedia();
    setState(() {
      _media = media;
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
      "Media",
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
        layoutBackgroundColor: backgroundColor,
        appBar: AppBarWidget(
          titleWidget: _isSearching ? _buildSearchField() : _buildTitle(),
          actions: _buildActions(),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 15),
          child: ListViewHelper(
            list: _media,
            onRefresh: () => getMedia(),
            itemBuilder: (context, index) {
              return ItemListTile(
                item: _media[index],
                index: index,
                length: _media.length,
                isFirst: index == 0,
                isLast: index == _media.length - 1,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MediaFilesScreen(
                        media: _media[index],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ));
  }
}

class ItemListTile extends StatelessWidget {
  ItemListTile({
    Key key,
    this.item,
    this.onTap,
    this.length,
    this.index,
    this.isFirst,
    this.isLast,
  }) : super(key: key);

  final int length;
  final int index;
  final Media item;
  final bool isFirst;
  final bool isLast;
  GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: new BoxConstraints(
          minHeight: 100,
        ),
        child: CardWidget(
          margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
          padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: BorderRadius.circular(5),
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.name,
                    style: headerTextStyle,
                  ),
                  Text(
                    item.createdDate ?? "",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 13,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 110,
                child: Text(
                  item.summary ?? "",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
