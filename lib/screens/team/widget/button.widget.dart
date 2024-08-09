import 'package:flutter/material.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:easy_localization/easy_localization.dart';

class DashboardButton extends StatelessWidget {
  DashboardButton({
    Key key,
    this.icon,
    this.title,
    this.isLast,
    this.isFirst,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final bool isLast;
  final bool isFirst;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
          left: isLTR(context)
              ? (isFirst == true ? 15 : 10)
              : (isLast == true ? 10 : 0),
          right: isLTR(context)
              ? (isLast == true ? 15 : 0)
              : (isFirst == true ? 15 : 15),
        ),
        margin: EdgeInsets.only(bottom: 10),
        child: Container(
          width: 90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: 26,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: getFontFamily(context),
                    fontSize: context.locale.languageCode == "en"
                        ? 14 : 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
