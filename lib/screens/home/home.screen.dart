import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/screens/dashboard/dashboard.screen.dart';
import 'package:nandrlon/screens/employee/employee.screen.dart';
import 'package:nandrlon/screens/profile/profile.screen.dart';
import 'package:nandrlon/screens/setting/setting.screen.dart';
import 'package:nandrlon/screens/team/dashboard.screen.dart';
import 'package:nandrlon/widgets/bottom_navy_bar.dart';
import 'package:nandrlon/widgets/drawer.widegt.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final _inactiveColor = Color(0xffFFFFFF);
  final _activeColor = Color(0xffFFFFFF);
  int _currentIndex = 0;
  int selectedPage = 0;

  List<Widget> _pages;

  @override
  void initState() {
    _pages = <Widget>[
      DashboardScreen(
        scaffoldKey: scaffoldKey,
      ),
      EmployeeScreen(
        automaticallyImplyLeading: false,
      ),
      ProfileScreen(
        automaticallyImplyLeading: false,
      ),
      SettingScreen(
        automaticallyImplyLeading: false,
      )
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        drawer: DrawerWidget(),
        body: _pages[_currentIndex],
        key: scaffoldKey,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.transparent,
            ),
            child: _buildBottomBar(),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21),
        color: Theme.of(context).primaryColor,
      ),
      child: BottomNavyBar(
        backgroundColor: Colors.transparent,
        selectedIndex: _currentIndex,
        showElevation: false,
        containerHeight: 40,
        itemCornerRadius: 10,
        curve: Curves.easeIn,
        onItemSelected: (index) => setState(() => _currentIndex = index),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.dashboard_outlined),
            title: Text(
              'home'.tr(),
              style: TextStyle(
                fontSize: context.locale.languageCode == "en" ? 15 : 11,
                fontFamily: getFontFamily(context),
              ),
            ),
            activeColor: _activeColor,
            inactiveColor: _inactiveColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.people_outlined),
            title: Text(
              'employees'.tr(),
              style: TextStyle(
                fontSize: context.locale.languageCode == "en" ? 10 : 11,
                fontFamily: getFontFamily(context),
              ),
            ),
            activeColor: _activeColor,
            inactiveColor: _inactiveColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person_outlined),
            title: Text(
              'profile'.tr(),
              style: TextStyle(
                fontSize: context.locale.languageCode == "en" ? 15 : 11,
                fontFamily: getFontFamily(context),
              ),
            ),
            activeColor: _activeColor,
            inactiveColor: _inactiveColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.settings_outlined),
            title: Text(
              'setting'.tr(),
              style: TextStyle(
                fontSize: context.locale.languageCode == "en" ? 15 : 11,
                fontFamily: getFontFamily(context),
              ),
            ),
            activeColor: _activeColor,
            inactiveColor: _inactiveColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
