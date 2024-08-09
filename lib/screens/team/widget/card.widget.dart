import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/helper/text.helper.dart';

class CardWidget extends StatelessWidget {
  CardWidget({
    Key key,
    this.child,
    this.title,
    this.titleAction,
    this.onTapAction,
  }) : super(key: key);
  final Widget child;
  final String title;
  final String titleAction;
  GestureTapCallback onTapAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(23, 23, 15, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: getFontFamily(context),
                    fontSize: context.locale.languageCode == "en" ? 17 : 15,
                    color: Color(
                      0xff29304D,
                    ),
                  ),
                ),
                titleAction == null
                    ? Container()
                    : InkWell(
                        onTap: onTapAction,
                        child: Text(
                          titleAction,
                          style: TextStyle(
                            fontFamily: getFontFamily(context),
                            fontSize: context.locale.languageCode == "en" ? 15 : 14,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            child,
          ],
        ),
      ),
    );
  }
}
