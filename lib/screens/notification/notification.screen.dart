import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/models/hrms/employee/profile.model.dart';
import 'package:nandrlon/models/notification.dart' as n;
import 'package:nandrlon/models/user.model.dart';
import 'package:nandrlon/screens/announcement/detail.dart';
import 'package:nandrlon/screens/company-policy/detail.dart';
import 'package:nandrlon/screens/leave/detail.screen.dart';
import 'package:nandrlon/screens/team/screens/leave/approval.screen.dart';
import 'package:nandrlon/services/employee.service.dart';
import 'package:nandrlon/services/notification.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  NotificationStateScreen createState() => NotificationStateScreen();
}

class NotificationStateScreen extends State<NotificationScreen> {
  ScrollController _controller;
  List<n.Notification> _notifications;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  int _pageNumber = 1;

  @override
  void initState() {
    _controller = new ScrollController()..addListener(_loadMore);
    super.initState();
    _firstLoad();
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    final notifications = await getNotifications();
    setState(() {
      _notifications = notifications;
    });

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  Future<List<n.Notification>> getNotifications() async {
    var prefs = await SharedPreferences.getInstance();
    var user = Profile.fromJson(json.decode(prefs.getString("user")));

    return await NotificationService.getAll(user.id, 1);

    // setState(() {
    //   _notifications = notifications;
    // });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _pageNumber += 1; // Increase _page by 1

      final notifications = await getNotifications();

      final fetchedPosts = notifications;
      if (fetchedPosts.length > 0) {
        setState(() {
          _notifications.addAll(fetchedPosts);
        });
      } else {
        setState(() {
          _hasNextPage = false;
        });
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  IconData getIcon(String action) {
    if (action == "leave-detail") {
      return Icons.exit_to_app_outlined;
    } else if (action == "company-policies") {
      return Icons.policy_outlined;
    } else if (action == "announcements") {
      return Icons.announcement_outlined;
    } else if (action == "holidays") {
      return Icons.park_outlined;
    } else {
      return Icons.notifications_active_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "notifications".tr(),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: ListViewHelper(
          onRefresh: getNotifications,
          list: _notifications,
          controller: _controller,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async{
                if (_notifications[index].isSeen == false) {
                  await NotificationService.UpdateSeen(
                      _notifications[index].id);

                  setState(() {
                    _notifications[index].isSeen = true;
                  });
                }

                if (_notifications[index].action != null) {
                  var action = _notifications[index].action;
                  int id = int.parse(_notifications[index].refId);
                  if (action == "leave-approval") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApprovalLeaveScreen(
                          leaveId: id,
                        ),
                      ),
                    );
                  } else if (action == "leave-detail") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailLeaveScreen(
                          leaveId: id,
                        ),
                      ),
                    );
                  } else if (action == "company-policies") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompanyPolicyDetailScreen(
                          id: id,
                        ),
                      ),
                    );
                  } else if (action == "announcements") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnnouncementDetailScreen(
                          id: id,
                        ),
                      ),
                    );
                  }
                }
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: _notifications[index].isSeen == false
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          getIcon(_notifications[index].action),
                          size: 17,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: MediaQuery.of(context).size.width - 105,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 105,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _notifications[index].title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      _notifications[index].date.substring(0, 10),
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(_notifications[index].message),
                          ],
                        ),
                      )
                    ],
                  )),
            );
          },
        ),
      ),
    );
  }
}
