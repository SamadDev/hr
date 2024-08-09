import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonWidget extends StatelessWidget {
  ButtonWidget({
    Key key,
    this.title,
    this.icon,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String icon;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        width: (width / 2) - 25,
        padding: EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0xff4F62C0).withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 20,
              offset: Offset(0, 10), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              this.icon,
              width: 50,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              this.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xff3A3A3A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
