import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nandrlon/models/crm/delivery-note/delivery-note-parameter.dart';
import 'package:nandrlon/models/crm/delivery-note/delivery-note-result.dart';
import 'package:nandrlon/models/crm/sales-order/sales-order.dart';
import 'package:nandrlon/models/crm/shared/city.dart';
import 'package:nandrlon/screens/delivery-note/filter.screen.dart';
import 'package:nandrlon/screens/delivery-note/form.screen.dart';
import 'package:nandrlon/screens/delivery-note/view.screen.dart';
import 'package:nandrlon/services/delivery-note.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/bottom-sheet-item.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/image.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:easy_localization/easy_localization.dart';

class DeliveryNoteScreen extends StatefulWidget {
  const DeliveryNoteScreen();

  @override
  ContactListStateScreen createState() => ContactListStateScreen();
}

var numberFormat = NumberFormat('###,###.##', 'en_Us');

class ContactListStateScreen extends State<DeliveryNoteScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<DeliveryNoteResult> _deliveryNotes;
  List<SalesOrder> _salesOrders;
  DeliveryNoteParameters _deliveryNoteParameters;
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
    _deliveryNoteParameters = new DeliveryNoteParameters();
    getDeliveryNotes();
    super.initState();
  }

  getDeliveryNotes() async {
    var deliveryNotes =
        await DeliveryNoteService.getDeliveryNotes(_deliveryNoteParameters);
    setState(() {
      _deliveryNotes = deliveryNotes;
      _isLoading = false;
    });
  }

  void _showBottomSheet(BuildContext context, DeliveryNoteResult deliveryNote) {
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
                initialChildSize: 0.45,
                minChildSize: 0.2,
                maxChildSize: 0.65,
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
                                    deliveryNote.customerName,
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
                                        "#${deliveryNote.deliveryNo}",
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
                                        deliveryNote.deliveryDate ?? "",
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
                            ],
                          ),
                        ),
                        Divider(),
                        BottomSheetItem(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DeliveryNoteViewScreen(
                                  deliveryNoteId: deliveryNote.id,
                                ),
                              ),
                            );
                          },
                          title: "View",
                          icon: Icons.remove_red_eye_outlined,
                        ),
                        BottomSheetItem(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DeliveryNoteFormScreen(),
                              ),
                            );
                          },
                          title: "Edit",
                          icon: Icons.edit_outlined,
                        ),
                        BottomSheetItem(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DeliveryNoteFormScreen(),
                              ),
                            );
                          },
                          title: "Delete",
                          icon: Icons.delete_outline_rounded,
                        ),
                        BottomSheetItem(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DeliveryNoteFormScreen(),
                              ),
                            );
                          },
                          title: "Print",
                          icon: Icons.print_outlined,
                        ),
                        BottomSheetItem(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DeliveryNoteFormScreen(),
                              ),
                            );
                          },
                          title: "Send",
                          icon: Icons.send_outlined,
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

  showProfile(DeliveryNoteResult deliveryNote) {
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
                    errorText: deliveryNote.deliveryNo[0],
                    errorTextFontSize: 30,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    deliveryNote.deliveryNo,
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
                            // Navigator.pop(context);
                            //
                            // var isSaved = await Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => DeliveryNoteFormScreen(),
                            //   ),
                            // );
                            //
                            // if (isSaved == true) {
                            //   setState(() {
                            //     _isLoading = true;
                            //   });
                            //   getDeliveryNotes();
                            // }
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
                      deliveryNote.customerName,
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
      initialValue: _deliveryNoteParameters.deliveryNo,
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
      "Delivery Notes",
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
          var deliveryNoteParameters = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeliveryNoteFilterScreen(
                cities: _cities,
                deliveryNoteParameters: _deliveryNoteParameters,
              ),
            ),
          );

          if (deliveryNoteParameters != null) {
            setState(() {
              _deliveryNotes = null;
              _deliveryNoteParameters = deliveryNoteParameters;
            });

            getDeliveryNotes();
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
        _deliveryNoteParameters.deliveryNo = newQuery;
      });
      getDeliveryNotes();
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
      getDeliveryNotes();
    });
  }

  Future<Null> _refresh() async {
    var deliveryNotes =
        await DeliveryNoteService.getDeliveryNotes(_deliveryNoteParameters);
    setState(() {
      _deliveryNotes = deliveryNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          var isSaved = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeliveryNoteFormScreen(),
            ),
          );

          if (isSaved != null) {
            getDeliveryNotes();
          }
        },
      ),
      appBar: AppBarWidget(
        titleWidget: _isSearching ? _buildSearchField() : _buildTitle(),
        actions: _buildActions(),
      ),
      body: SafeArea(
        child: ListViewHelper(
          onRefresh: _refresh,
          list: _deliveryNotes,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 10),
              child: OrderListTile(
                  deliveryNote: _deliveryNotes[index],
                  onTap: () {
                    _showBottomSheet(context, _deliveryNotes[index]);
                  }),
            );
          },
        ),
      ),
    );
  }
}

class OrderListTile extends StatelessWidget {
  OrderListTile({
    Key key,
    this.deliveryNote,
    this.onTap,
  }) : super(key: key);

  final DeliveryNoteResult deliveryNote;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CardWidget(
        radius: 0,
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deliveryNote.customerName,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                     Text(
                      deliveryNote.customerContactName ?? "",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(
                          0xff8d989f,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Text(
                  deliveryNote.deliveryNo ?? "",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Date",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(
                          0xff8d989f,
                        ),
                      ),
                    ),
                    Text(
                      deliveryNote.deliveryDate ?? "",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order No",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(
                          0xff8d989f,
                        ),
                      ),
                    ),
                    Text(
                      deliveryNote.refNo ?? "",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Source",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(
                          0xff8d989f,
                        ),
                      ),
                    ),
                    Text(
                      deliveryNote.warehouseName ?? "",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
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
