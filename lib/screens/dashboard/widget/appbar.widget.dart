import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/screens/notification/notification.screen.dart';

class AppbarWidget extends StatelessWidget {
  const AppbarWidget({
    Key key,
    this.scaffoldKey,
  }) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => scaffoldKey.currentState.openDrawer(),
            icon: Icon(
              Icons.menu,
              color: Color(box.read('primaryColor') == null
                  ? 0xff124993
                  : int.parse(box.read('primaryColor'))),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
            icon: SvgPicture.asset(
              "assets/svg/notification.svg",
              width: 20,
              color: Color(box.read('primaryColor') == null
                  ? 0xff124993
                  : int.parse(box.read('primaryColor'))),
            ),
          ),
        ],
      ),
    );
  }
}
