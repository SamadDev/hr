import 'package:flutter/material.dart';
import 'package:nandrlon/screens/announcement/list.dart';
import 'package:nandrlon/screens/company-policy/list.dart';
import 'package:nandrlon/screens/holiday/holiday.screen.dart';
import 'package:nandrlon/screens/home/home.screen.dart';
import 'package:nandrlon/screens/media/media.screen.dart';
import 'package:nandrlon/screens/punishment/punishment.screen.dart';
import 'package:nandrlon/screens/report/report.screen.dart';
import 'package:nandrlon/screens/sales-target/list.screen.dart';
import 'package:nandrlon/screens/setting/setting.screen.dart';
import 'package:nandrlon/screens/task/list.screen.dart';

var routes = <String, WidgetBuilder>{
  '/home': (context) => HomeScreen(),
  '/punishments': (context) => PunishmentScreen(),
  '/company-policies': (context) => CompanyPolicyScreen(),
  '/holidays': (context) => HolidayScreen(),
  '/tasks': (context) => TaskListScreen(),
  '/media': (context) => MediaScreen(),
  '/reports': (context) => ReportScreen(),
  '/announcements': (context) => AnnouncementScreen(),
  '/sales-target': (context) => SalesTargetScreen(),
  '/settings': (context) => SettingScreen(),
};
