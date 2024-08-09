import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/dropdown.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';

class ProductFilterScreen extends StatefulWidget {
  ProductFilterScreen({
    Key key,
    this.itemGroup,
    this.itemType,
  }) : super(key: key);

  dynamic itemGroup;
  dynamic itemType;

  @override
  _ProductFilterScreenState createState() => _ProductFilterScreenState();
}

class _ProductFilterScreenState extends State<ProductFilterScreen> {
  var specialityController = TextEditingController();
  var cityController = TextEditingController();

  List<dynamic> _itemTypes = [];
  List<dynamic> _itemGroups = [];

  @override
  void initState() {
    super.initState();
    readDepartmentJson();
    readBranchJson();
  }

  Future<void> readDepartmentJson() async {
    final String response =
        await rootBundle.loadString('assets/json/item-type.json');
    final data = await json.decode(response);

    setState(() {
      _itemTypes = data;
    });
  }

  Future<void> readBranchJson() async {
    final String response =
        await rootBundle.loadString('assets/json/item-group.json');
    final data = await json.decode(response);

    setState(() {
      _itemGroups = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      // backgroundColor: backgroundColor,
      bottomSheet: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          height: 50,
          margin: EdgeInsets.only(bottom: 40, left: 15, right: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Center(
            child: Text(
              "filter".tr(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
      appBar: AppBarWidget(
        title: "filter".tr(),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                widget.itemType = null;
                widget.itemGroup = null;
              });
            },
            child: Text(
              "Clear",
              style: TextStyle(
                color: Color(0xff29304D),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: CardWidget(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownButtonWidget(
                    labelText: "Item Group",
                    value: widget.itemGroup,
                    items: _itemGroups.map((dynamic items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items['name'],
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic itemGroup) {
                      setState(() {
                        widget.itemGroup = itemGroup;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButtonWidget(
                    labelText: "Item Type",
                    value: widget.itemType,
                    items: _itemTypes.map((dynamic items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items['name'],
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic itemType) {
                      setState(() {
                        widget.itemType = itemType;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
