import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';

class AlterDialogWidget extends StatelessWidget {
  AlterDialogWidget({
    Key key,
    this.onSearch,
    this.items,
    this.onTap,
  }) : super(key: key);
  ValueChanged<String> onSearch;
  List<dynamic> items;
  final Function(int) onTap;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // passing false
            child: Text('close'.tr()),
          ),
        ],
        contentPadding: EdgeInsets.zero,
        content: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: showModalBottomSheetPadding,
              child: TextFieldWidget(
                  iconData: Icons.search,
                  hintText: "search".tr(),
                  onChanged: onSearch),
            ),
            Container(
              width: 300.0,
              height: MediaQuery.of(context).size.height - 271,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: new Text(items[index].name),
                        onTap: () => onTap(index),
                      ),
                      Divider(
                        height: 0,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
