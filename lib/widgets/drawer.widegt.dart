import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/models/menu.dart';
import 'package:nandrlon/models/user.model.dart';
import 'package:nandrlon/widgets/image.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  DrawerWidget();

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  User user;
  List<Menu> _menus;
  String _api;

  @override
  void initState() {
    onLoad();
    super.initState();
  }

  onLoad() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        user = User.fromJson(json.decode(prefs.getString("user")));
        _menus = Menu.toList(json.decode(prefs.getString("menus")));
        _api = prefs.getString("api");
      });

      _menus.forEach((element) {
        
        
      });
    });


  }

  int getIcon(Menu menu) {
    if (menu.attributes.length == 0) return 0xe1b1;

    var icon = menu.attributes.where((attribute) => attribute.name == "icon");

    if (icon == null) return 0xe1b1;
    return int.parse(icon.first.value);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color(box.read('primaryColor') == null
                  ? 0xff124993
                  : int.parse(box.read('primaryColor'))),
            ),
            accountName: Text(
              "${user?.fullName}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
              ),
            ),
            accountEmail: Text(
              "${user?.jobTitle}",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            currentAccountPicture: ImageWidget(
              imageUrl: "$_api/Uploads/HRMS/Employees/${user?.image}",
            ),
          ),
          SizedBox(
            height: 15,
          ),
          if (_menus != null)
            for (var menu in _menus)
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/${menu.url}'),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.list_outlined,
                            color: Color(0xffc2c5d2),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            menu.name,
                            // menu.name.toLowerCase().replaceAll(" ", "_").tr(),
                            style: TextStyle(
                              fontFamily: context.locale.languageCode == "en"
                                  ? "aileron"
                                  : "DroidKufi",
                              color: Color(0xff848389),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Color(0xffc2c5d2),
                        size: 16,
                      )
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
