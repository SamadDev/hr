import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  AppBarWidget(
      {Key key,
      this.title,
      this.bottom,
      this.size,
      this.actions,
      this.titleWidget,
      this.leading,
      this.backgroundColor,
      this.leadingColor,
      this.titleColor
      })
      : super(key: key);

  final String title;
  final PreferredSizeWidget bottom;
  final double size;
  final List<Widget> actions;
  final Widget titleWidget;
  final Widget leading;
  final Color backgroundColor;
  final Color leadingColor;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: actions,
      elevation: 0,
      centerTitle: false,

      backgroundColor: backgroundColor == null
          ? Theme.of(context).primaryColor
          : backgroundColor,
      leading: leading == null
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios,
                  color: leadingColor == null
                      ? Colors.white
                      : Theme.of(context).primaryColor),
              onPressed: () => Navigator.pop(context),
            )
          : leading,
      titleSpacing: 0,
      title: title == null
          ? titleWidget
          : Text(
              title,
              style: TextStyle(
                fontSize: context.locale.languageCode == "en" ? 20 : 17,
                fontFamily: context.locale.languageCode == "en" ? "aileron" : "DroidKufi",
                color: Colors.white,
              ),
            ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(size ?? kToolbarHeight);
}
