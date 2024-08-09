import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/models/crm/Item/Item-group.dart';
import 'package:nandrlon/models/crm/Item/Item-type.dart';
import 'package:nandrlon/models/crm/Item/Item-unit.dart';
import 'package:nandrlon/models/crm/Item/item-parameter.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/dropdown.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';

class ItemFilterScreen extends StatefulWidget {
  ItemFilterScreen({
    Key key,
    this.itemGroups,
    this.itemTypes,
    this.itemUnits,
    this.itemParameters,
  }) : super(key: key);

  ItemParameters itemParameters;
  List<ItemGroup> itemGroups;
  List<ItemType> itemTypes;
  List<ItemUnit> itemUnits;

  @override
  _ItemFilterScreenState createState() => _ItemFilterScreenState();
}

class _ItemFilterScreenState extends State<ItemFilterScreen> {
  var searchTextEditingController = TextEditingController();

  @override
  void initState() {
    searchTextEditingController.text = widget.itemParameters.searchText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "filter".tr(),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                searchTextEditingController.clear();
                widget.itemParameters = ItemParameters();
              });
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                
                
                widget.itemParameters.searchText = searchTextEditingController.text;
                Navigator.pop(context, widget.itemParameters);
              });
            },
            icon: Icon(Icons.search),
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
                  TextFieldWidget(
                    labelText: "Search",
                    controller: searchTextEditingController,
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  DropdownButtonWidget(
                    labelText: "Group",
                    value: widget.itemParameters.itemGroup,
                    items: widget.itemGroups.map((ItemGroup itemGroup) {
                      return DropdownMenuItem(
                        value: itemGroup,
                        child: Text(
                          itemGroup.name,
                        ),
                      );
                    }).toList(),
                    onChanged: (ItemGroup itemGroup) {
                      setState(() {
                        widget.itemParameters.itemGroupId = itemGroup.id;
                        widget.itemParameters.itemGroup = itemGroup;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButtonWidget(
                    labelText: "Type",
                    value: widget.itemParameters.itemType,
                    items: widget.itemTypes.map((ItemType itemType) {
                      return DropdownMenuItem(
                        value: itemType,
                        child: Text(
                          itemType.name,
                        ),
                      );
                    }).toList(),
                    onChanged: (ItemType itemType) {
                      setState(() {
                        widget.itemParameters.itemTypeId = itemType.id;
                        widget.itemParameters.itemType = itemType;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButtonWidget(
                    labelText: "Unit",
                    value: widget.itemParameters.itemUnit,
                    items: widget.itemUnits.map((ItemUnit itemUnit) {
                      return DropdownMenuItem(
                        value: itemUnit,
                        child: Text(
                          itemUnit.name,
                        ),
                      );
                    }).toList(),
                    onChanged: (ItemUnit itemUnit) {
                      setState(() {
                        widget.itemParameters.itemUnitId = itemUnit.id;
                        widget.itemParameters.itemUnit = itemUnit;
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
