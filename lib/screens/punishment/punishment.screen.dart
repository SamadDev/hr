import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/models/hrms/punishment/punishment-parametres.dart';
import 'package:nandrlon/models/hrms/punishment/punishment-type.model.dart';
import 'package:nandrlon/models/hrms/punishment/punishment.mode.dart';
import 'package:nandrlon/screens/punishment/filter.screen.dart';
import 'package:nandrlon/services/team.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:easy_localization/easy_localization.dart';

class PunishmentScreen extends StatefulWidget {
  PunishmentScreen({Key key}) : super(key: key);

  @override
  State<PunishmentScreen> createState() => _PunishmentScreenState();
}

class _PunishmentScreenState extends State<PunishmentScreen> {
  bool _isSearching = false;
  var _punishmentParameters = new PunishmentParameters();
  var searchController = TextEditingController();
  String searchQuery = "Search query";
  List<Punishment> _punishments;
  List<PunishmentType> _punishmentTypes;
  Timer _debounce;

  @override
  void initState() {
    getPunishmentFormResult();
    onLoad();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getPunishmentFormResult() async {
    var result = await TeamService.getPunishmentFormResult();

    var punishmentTypes = result['punishmentTypes']
        .map<PunishmentType>((json) => PunishmentType.fromJson(json))
        .toList();

    setState(() {
      _punishmentTypes = punishmentTypes;
    });
  }

  Future<void> onLoad() async {
    var result = await TeamService.getPunishments(_punishmentParameters);

    var punishments = result['employeePunishments']
        .map<Punishment>((json) => Punishment.fromJson(json))
        .toList();

    setState(() {
      _punishments = punishments;
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
      "punishments".tr(),
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
          var punishmentParameters = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PunishmentFilterScreen(
                punishmentParameters: _punishmentParameters,
                punishmentTypes: _punishmentTypes,
              ),
            ),
          );

          if (punishmentParameters != null) {
            setState(() {
              _punishmentParameters = punishmentParameters;
            });

            onLoad();
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
    _debounce = Timer(const Duration(milliseconds: 500), () {
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
      onLoad();
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
        margin: EdgeInsets.only(top: 10),
        child: ListViewHelper(
          onRefresh: onLoad,
          list: _punishments,
          itemBuilder: (context, index) {
            return PunishmentListTile(
              punishment: _punishments[index],
            );
          },
        ),
      ),
    );
  }
}

class PunishmentListTile extends StatelessWidget {
  PunishmentListTile({
    Key key,
    this.punishment,
    this.onPressed,
    this.onTap,
  }) : super(key: key);

  final Punishment punishment;
  final VoidCallback onPressed;
  GestureTapCallback onTap;
  @override
  Widget build(BuildContext context) {
    return CardWidget(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: EdgeInsets.only(bottom: 10, top: 5),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 15, top: 8),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.warning_amber_outlined,
                            size: 17,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      punishment.punishmentType,
                      style: TextStyle(
                        color: Color(0xff0F1B2D),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 50),
            child: Row(
              children: [
                PunishmentItem(
                  title: "Start Date",
                  value: punishment.fromDate.substring(0, 10),
                ),
                PunishmentItem(
                  title: "End Date",
                  value: punishment.toDate.substring(0, 10),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 50),
            child: Row(
              children: [
                PunishmentItem(
                  title: "Fine Amount",
                  value: numberFormat.format(punishment.fineAmount),
                ),
                PunishmentItem(
                  title: "Deduct From",
                  value: punishment.deductFrom.substring(0, 10),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PunishmentItem extends StatelessWidget {
  PunishmentItem({
    Key key,
    this.title,
    this.value,
    this.icon,
    this.iconColor,
    this.valueColor,
    this.iconBackgroundColor,
  }) : super(key: key);

  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color valueColor;
  final Color iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width / 2.6),
      padding: EdgeInsets.only(left: 15, top: 15, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor == null ? Color(0xff0F1B2D) : valueColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
