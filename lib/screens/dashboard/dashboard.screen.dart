import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/main.dart';
import 'package:nandrlon/models/crm/media/media.dart';
import 'package:nandrlon/models/dashboard.dart';
import 'package:nandrlon/models/employee-profile.dart';
import 'package:nandrlon/models/team.model.dart';
import 'package:nandrlon/models/user.model.dart';
import 'package:nandrlon/screens/announcement/detail.dart';
import 'package:nandrlon/screens/company-policy/detail.dart';
import 'package:nandrlon/screens/dashboard/widget/appbar.widget.dart';
import 'package:nandrlon/screens/dashboard/widget/header.widget.dart';
import 'package:nandrlon/screens/dashboard/widget/overview.widget.dart';
import 'package:nandrlon/screens/dashboard/widget/profile.widget.dart';
import 'package:nandrlon/screens/dashboard/widget/representative.widget.dart';
import 'package:nandrlon/screens/dashboard/widget/team.widget.dart';
import 'package:nandrlon/screens/leave/detail.screen.dart';
import 'package:nandrlon/screens/notification/notification.screen.dart';
import 'package:nandrlon/screens/team/screens/leave/approval.screen.dart';
import 'package:nandrlon/services/employee.service.dart';
import 'package:nandrlon/widgets/drawer.widegt.dart';
import 'package:nandrlon/widgets/loading.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    Key key,
    this.scaffoldKey,
  }) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences prefs;

  Location location = new Location();
  final _inactiveColor = Color(0xffFFFFFF);
  final _activeColor = Color(0xffFFFFFF);
  int _currentIndex = 0;
  EmployeeProfile _user;
  List<Team> _teams;
  Dashboard _dashboard;

  @override
  void initState() {


    // box.erase();
    super.initState();
    onLoad();
  }

  onLoad() async {
    prefs = await SharedPreferences.getInstance();
    
    

    var user = EmployeeProfile.fromJson(json.decode(prefs.getString("user")));
    var team = Team.toList(json.decode(prefs.getString("team")));
    var dashboard = Dashboard.fromJson(json.decode(prefs.getString("dashboard")));

    setState(() {
      _user = user;
      _teams = team;
      _dashboard = dashboard;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                //todo uncomment
                // channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_lancher',
              ),
            ));
      }
    });
    //Message for Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && message.data != null) {
        
        
        String action = message.data["action"];
        if (action == "leave-approval") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ApprovalLeaveScreen(
                leaveId: int.parse(message.data["id"]),
              ),
            ),
          );
        } else if (action == "leave-detail") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailLeaveScreen(
                leaveId: int.parse(message.data["id"]),
              ),
            ),
          );
        } else if (action == "company-policies") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CompanyPolicyDetailScreen(
                id: int.parse(message.data["id"]),
              ),
            ),
          );
        }else if (action == "announcements") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AnnouncementDetailScreen(
                id: int.parse(message.data["id"]),
              ),
            ),
          );
        }
      }
    });


  }

  void showNotification() {
    flutterLocalNotificationsPlugin.show(
      0,
      "Testing",
      "This is an Flutter Push Notification",
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          //todo uncomment
          // channel.description,
          importance: Importance.high,
          color: Colors.blue,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
          icon: Icon(
            Icons.menu,
            color: Color(box.read('primaryColor') == null
                ? 0xff124993
                : int.parse(box.read('primaryColor'))),
          ),
        ),
        actions: [
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
        elevation: 0,
      ),
      drawer: DrawerWidget(),
      body: _dashboard == null ? LoadingWidget() : Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 10,
            ),
            child: Column(
              children: [
                HeaderWidget(
                  user: _user,
                  prefs: prefs,
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 200,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      OverviewWidget(
                          dashboard: _dashboard
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ProfileWidget(),
                      SizedBox(
                       height: 30,
                      ),
                      // RepresentativeWidget(),
                      // SizedBox(
                      //   height: 30,
                      // ),
                      TeamWidget(
                        teams: _teams,
                      ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
