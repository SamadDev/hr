import 'package:flutter/material.dart';
import 'package:nandrlon/models/hrms/announcement/announcement.dart';
import 'package:nandrlon/models/hrms/company-policy/company-policy.mode.dart';
import 'package:nandrlon/services/team.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:nandrlon/widgets/loading.widget.dart';

class AnnouncementDetailScreen extends StatefulWidget {
  AnnouncementDetailScreen({
    Key key,
    this.announcement,
    this.id,
  }) : super(key: key);
  Announcement announcement;
  int id;

  @override
  _AnnouncementDetailScreenState createState() =>
      _AnnouncementDetailScreenState();
}

class _AnnouncementDetailScreenState extends State<AnnouncementDetailScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onLoad();
  }

  onLoad() async {
    var result = await TeamService.getAnnouncement(widget.id);

    var announcement = Announcement.fromJson(result);

    setState(() {
      widget.announcement = announcement;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: widget.announcement == null ?  "" : widget.announcement.subject,
      ),
      body: widget.announcement == null ? LoadingWidget() : SafeArea(
        child: SingleChildScrollView(
          child: AnnouncementTile(
            announcement: widget.announcement,
          ),
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
      margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(

        children: [
          Text(
            announcement.subject,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          Text(
            announcement.publishDate.substring(0, 10) ?? "",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          Html(
            data: announcement.summary,
          ),
        ],
      ),

    );
  }
}
