import 'package:flutter/material.dart';
import 'package:nandrlon/models/crm/Item/Item-group.dart';
import 'package:nandrlon/models/crm/Item/Item-result.dart';
import 'package:nandrlon/models/crm/Item/item-parameter.dart';
import 'package:nandrlon/models/crm/delivery-note/delivery-note.dart';
import 'package:nandrlon/services/item.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/dropdown.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';
import 'package:easy_localization/easy_localization.dart';

class DeliveryNoteItemListScreen extends StatefulWidget {
  DeliveryNoteItemListScreen({
    Key key,
    this.items,
    this.itemGroups,
    this.deliveryNote,
  }) : super(key: key);
  List<ItemResult> items;
  List<ItemGroup> itemGroups;
  DeliveryNote deliveryNote;

  @override
  _DeliveryNoteItemListScreenState createState() =>
      _DeliveryNoteItemListScreenState();
}

class _DeliveryNoteItemListScreenState extends State<DeliveryNoteItemListScreen> {
  ItemParameters _itemParameters;
  bool _isLoading = false;

  @override
  void initState() {
    _itemParameters = new ItemParameters();
    super.initState();
  }

  Future<void> getItems() async {
    setState(() {
      _isLoading = true;
    });
    var items = await ItemService.getItemResult(_itemParameters);
    setState(() {
      widget.items = items;
      _isLoading = false;
    });
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
          itemBuilder: (context, index) {
            var detail = widget.deliveryNote.details
                .where((element) => element.itemId == widget.items[index].id);

            return detail.isNotEmpty ? Container() : ItemListTile(
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
                      item.groupName,
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
