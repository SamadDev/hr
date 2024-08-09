import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nandrlon/models/crm/customer/customer-note-parameter.dart';
import 'package:nandrlon/models/crm/customer/customer-note.dart';
import 'package:nandrlon/models/crm/customer/customer-result.dart';
import 'package:nandrlon/screens/note/form.dart';
import 'package:nandrlon/services/customer.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:easy_localization/easy_localization.dart';

class NoteListScreen extends StatefulWidget {
  NoteListScreen({
    Key key,
    this.customer,
    this.isReadOnly,
  }) : super(key: key);

  CustomerResult customer;
  bool isReadOnly;

  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  var searchController = TextEditingController();
  String searchQuery = "Search query";
  CustomerNoteParameters customerNoteParameters;
  List<CustomerNote> _notes;
  bool _isSearching = false;
  Timer _debounce;

  @override
  void initState() {
    customerNoteParameters = CustomerNoteParameters();
    customerNoteParameters.customerId = widget.customer.id;
    super.initState();
    onLoad();
  }

  @override
  void dispose() {
    super.dispose();
  }

  onLoad() async {
    var notes = await CustomerService.getNotes(customerNoteParameters);

    setState(() {
      _notes = notes;
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
      "Notes",
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
      customerNoteParameters.searchText = newQuery;
      onLoad();
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
      floatingActionButton: widget.isReadOnly == true
          ? Container()
          : FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () async {
                var note = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteFormScreen(
                      customer: widget.customer,
                    ),
                  ),
                );

                if (note != null) {
                  setState(() {
                    var _note = note as CustomerNote;
                    _notes.insert(0, _note);
                  });
                }
              },
            ),
      appBar: AppBarWidget(
        titleWidget: _isSearching ? _buildSearchField() : _buildTitle(),
        actions: _buildActions(),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15),
        child: ListViewHelper(
          list: _notes,
          onRefresh: () => onLoad(),
          itemBuilder: (context, index) {
            return NoteListTile(
              note: _notes[index],
              onTap: () async {
                var note = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteFormScreen(
                      customerNote: _notes[index],
                    ),
                  ),
                );
                if (note != null) {
                  setState(() {
                    var _note = note as CustomerNote;
                    _notes[index] = _note;
                  });

                  // onLoad();
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class NoteListTile extends StatelessWidget {
  NoteListTile({
    Key key,
    this.note,
    this.onTap,
  }) : super(key: key);

  final CustomerNote note;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
      padding: EdgeInsets.symmetric(vertical: 10),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(5),
      // ),
      child: ListTile(
        onTap: onTap,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              note.subject,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            Text(
              note.createdDate ?? "",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        subtitle: Container(
          height: 30,
          padding: EdgeInsets.only(top: 10),
          child: Text(
            note.note,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
