import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/models/crm/media/media-file.dart';
import 'package:nandrlon/models/crm/media/media.dart';
import 'package:nandrlon/services/media.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:nandrlon/widgets/loading.widget.dart';
import 'package:url_launcher/url_launcher.dart';

class MediaFilesScreen extends StatefulWidget {
  MediaFilesScreen({
    Key key,
    this.media,
  }) : super(key: key);
  Media media;

  @override
  MediaStateScreen createState() => MediaStateScreen();
}

class MediaStateScreen extends State<MediaFilesScreen> {
  var searchController = TextEditingController();
  List<MediaFile> _mediaFiles = [];
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
    var mediaFiles = await MediaService.getMediaFiles(widget.media.id);
    setState(() {
      _mediaFiles = mediaFiles;
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
      widget.media.name ?? "",
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
    _debounce = Timer(const Duration(milliseconds: 100), () {});
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
      appBar: AppBarWidget(
        titleWidget: _isSearching ? _buildSearchField() : _buildTitle(),
        actions: _buildActions(),
      ),
      body: _isLoading
          ? LoadingWidget()
          : CardWidget(
              margin: EdgeInsets.all( 15),
              child: ListViewHelper(
                list: _mediaFiles,
                onRefresh: getMedia,
                itemBuilder: (context, index) {
                  return ItemListTile(
                    item: _mediaFiles[index],
                    index: index,
                    length: _mediaFiles.length,
                    onTap: () async {
                      var url = _mediaFiles[index].fileUrl;
                      if (await canLaunch(url))
                        await launch(url);
                      else
                        // can't launch url, there is some error
                        throw "Could not launch $url";
                    },
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
    this.length,
    this.index,
  }) : super(key: key);

  final int length;
  final int index;
  final MediaFile item;
  GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(0, index == 0 ? 20 : 10, 0, 10),
        margin: EdgeInsets.symmetric(horizontal: 15),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.only(
        //     topRight: Radius.circular(index == 0 ? 10 : 0),
        //     topLeft: Radius.circular(index == 0 ? 10 : 0),
        //     bottomRight: Radius.circular(index == length - 1 ? 10 : 0),
        //     bottomLeft: Radius.circular(index == length - 1 ? 10 : 0),
        //   ),
        //   color: Colors.white,
        // ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        child: Image.asset(
                          "assets/image/file/${getFileType(item.fileUrl)}.png",
                          width: 40,
                          height: 40,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            item.fileName,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            item.fileType.name ?? "",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: index == length - 1 ? 5 : 15,
            ),
            index == length - 1
                ? Container()
                : Divider(
                    height: 0,
                  ),
          ],
        ),
      ),
    );
  }

  getFileType(fileUrl) {
    return fileUrl == null ? "file" : fileUrl.split('.').last;
  }
}
