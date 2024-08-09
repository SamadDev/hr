import 'package:flutter/material.dart';
import 'package:nandrlon/config/themes/light.theme.dart';

class Layout extends StatelessWidget {
  Layout({
    Key key,
    this.body,
    this.appBar,
    this.bottomSheet,
    this.floatingActionButton,
    this.layoutBackgroundColor,
    this.resizeToAvoidBottomInset,
    this.floatingActionButtonLocation,
    this.scaffoldKey,
    this.drawer,
  }) : super(key: key);
  final Widget body;
  final PreferredSizeWidget appBar;
  final Widget bottomSheet;
  final Widget floatingActionButton;
  final Color layoutBackgroundColor;
  final bool resizeToAvoidBottomInset;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final Widget drawer;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: scaffoldKey,
        appBar: appBar,

        floatingActionButtonLocation: floatingActionButtonLocation,
        floatingActionButton: floatingActionButton,
        bottomSheet: bottomSheet,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: layoutBackgroundColor == null ? backgroundColor : layoutBackgroundColor,
            // gradient: LinearGradient(
            //   colors: [Color(0xFFf5f8fb), Color(0xFFf6f9fc)],
            //   begin: Alignment.centerLeft,
            //   end: Alignment.centerRight,
            // ),
          ),
          child: body,
        ),
    );
  }
}
