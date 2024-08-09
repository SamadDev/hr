import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  CardWidget({
    Key key,
    this.child,
    this.padding,
    this.margin,
    this.radius,
  }) : super(key: key);
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        // boxShadow: [
        //   BoxShadow(
        //     color: Color(0xff4F62C0).withOpacity(0.15),
        //     spreadRadius: 0,
        //     blurRadius: 2,
        //     offset: Offset(0, 1), // changes position of shadow
        //   ),
        // ],
        borderRadius:
            BorderRadius.all(Radius.circular(radius == null ? 8 : radius)),
      ),
      child: child,
    );
  }
}
