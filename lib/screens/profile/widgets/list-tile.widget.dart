import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:nandrlon/helper/text.helper.dart';

class CustomListTile extends StatelessWidget {
  CustomListTile({
    Key key,
    this.title,
    this.trailing,
    this.subtitle,
    this.isLTR,
    this.isFirst,
    this.isLast,
  }) : super(key: key);

  final bool isFirst;
  final bool isLast;
  final bool isLTR;
  final String title;
  final String trailing;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: ListTile(
            title: Text(
              title.tr(),
              style: TextStyle(
                color: Color(0xff29304D),
                fontSize: 13,
                fontFamily: getFontFamily(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: trailing == null
                ? null
                : Directionality(
                    textDirection: ui.TextDirection.ltr,
                    child: Text(
                      trailing,
                      style: TextStyle(
                        color: Color(0xff8A959E),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
            subtitle: subtitle == null
                ? null
                : Directionality(
                    textDirection: ui.TextDirection.ltr,
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: Color(0xff8A959E),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
