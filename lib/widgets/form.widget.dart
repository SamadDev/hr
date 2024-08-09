import 'package:flutter/material.dart';

class FormListTile extends StatelessWidget {
  FormListTile({
    Key key,
    this.title,
    this.widget,
    this.actions,
  }) : super(key: key);

  final dynamic title;
  final dynamic widget;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title == null
              ? Container()
              : Container(
            padding: EdgeInsets.fromLTRB(15,20,15,10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  this.title,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions == null
                    ? Container()
                    : Column(
                  children: actions,
                )
              ],
            ),
          ),
          widget
        ],
      ),
    );
  }
}
