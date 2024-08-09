import 'package:flutter/material.dart';

class BottomSheetItem extends StatelessWidget {
  BottomSheetItem({
    Key key,
    this.onTap,
    this.icon,
    this.title,
  }) : super(key: key);
  final GestureTapCallback onTap;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          dense: true,
          leading: Icon(
            icon,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        Divider(
          height: 0,
        ),
      ],
    );
  }
}
