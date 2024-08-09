import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  ButtonWidget({
    Key key,
    this.title,
    this.margin,
    this.onPressed,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);
  final String title;
  final EdgeInsetsGeometry margin;
  final VoidCallback onPressed;
  double width;
  double height;
  Color color;

  @override
  Widget build(BuildContext context) {
    color = color == null ? Theme.of(context).primaryColor : color;

    return Container(
      margin: margin,
      child: TextButton(
        style: ButtonStyle(
          minimumSize: width != null && height != null
              ? MaterialStateProperty.all(Size(width, height))
              : null,
          padding:
              MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20)),
          backgroundColor: MaterialStateProperty.all<Color>(color.withOpacity(0.1)),
          foregroundColor:
              MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
          overlayColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered))
                return Colors.blue.withOpacity(0.04);
              if (states.contains(MaterialState.focused) ||
                  states.contains(MaterialState.pressed))
                return Colors.blue.withOpacity(0.12);
              return null; // Defer to the widget's default.
            },
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
