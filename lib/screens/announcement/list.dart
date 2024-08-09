import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/models/hrms/announcement/announcement.dart';
import 'package:nandrlon/models/hrms/announcement/company-policy-parametres.dart';
import 'package:nandrlon/models/hrms/company-policy/company-policy-parametres.dart';
import 'package:nandrlon/models/hrms/company-policy/company-policy.mode.dart';
import 'package:nandrlon/screens/announcement/detail.dart';
import 'package:nandrlon/screens/company-policy/detail.dart';
import 'package:nandrlon/services/customer.service.dart';
import 'package:nandrlon/services/team.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';

class AnnouncementScreen extends StatefulWidget {
  AnnouncementScreen({
    Key key,
  }) : super(key: key);

  @override
  _AnnouncementScreenState createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  var searchController = TextEditingController();
  String searchQuery = "Search query";
  AnnouncementParameters _announcementParameters;
  List<Announcement> _announcements;
  bool _isSearching = false;
  Timer _debounce;

  @override
  void initState() {
    _announcementParameters = new AnnouncementParameters();

    super.initState();
    onLoad();
  }

  @override
  void dispose() {
    super.dispose();
  }

  onLoad() async {
    var result = await TeamService.getAnnouncements(_announcementParameters);

    var announcements = result['announcements']
        .map<Announcement>((json) => Announcement.fromJson(json))
        .toList();

    setState(() {
      _announcements = announcements;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "announcements".tr(),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15),
        child: ListViewHelper(
          list: _announcements,
          onRefresh: () => onLoad(),
          itemBuilder: (context, index) {
            return AnnouncementTile(
              announcement: _announcements[index],
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnnouncementDetailScreen(
                      announcement: _announcements[index],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class AnnouncementTile extends StatelessWidget {
  AnnouncementTile({
    Key key,
    this.announcement,
    this.onTap,
  }) : super(key: key);

  final Announcement announcement;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        onTap: onTap,
        title: Container(
          width: MediaQuery.of(context).size.width - 100,
          child: Text(
            announcement.subject,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 30,
              padding: EdgeInsets.only(top: 10),
              child: Text(
                announcement.summary,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              announcement.publishDate == null ? "" : announcement.publishDate.substring(0, 10) ?? "",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
