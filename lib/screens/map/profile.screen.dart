import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nandrlon/models/crm/customer/customer-result.dart';
import 'package:nandrlon/models/crm/visit/visit.dart';
import 'package:nandrlon/screens/customer-inventory/list.dart';
import 'package:nandrlon/screens/deal/list.screen.dart';
import 'package:nandrlon/screens/media/media.screen.dart';
import 'package:nandrlon/screens/note/list.dart';
import 'package:nandrlon/screens/sales-order/form.screen.dart';
import 'package:nandrlon/screens/survey/list.dart';
import 'package:nandrlon/screens/task/list.screen.dart';
import 'package:nandrlon/screens/visit/form.screen.dart';
import 'package:nandrlon/services/visit.service.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MapCustomerProfileScreen extends StatefulWidget {
  MapCustomerProfileScreen({Key key, this.customer}) : super(key: key);

  CustomerResult customer;

  @override
  _MapCustomerProfileScreenState createState() =>
      _MapCustomerProfileScreenState();
}

class _MapCustomerProfileScreenState extends State<MapCustomerProfileScreen> {
  final dateFormat = DateFormat('dd/MM/yyyy');
  final timeFormat = DateFormat('HH:mm:ss');
  Visit _visit = new Visit();
  bool flag = true;
  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';

  @override
  void initState() {
    _visit = new Visit();
    _visit.id = 0;
    _visit.customerId = widget.customer.id;
    _visit.visitStatusId = 2;

    _visit.date = dateFormat.format(DateTime.now());
    super.initState();
  }

  Stream<int> stopWatchStream() {
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void stopTimer() async {
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        streamController.close();

        var visit = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VisitFormScreen(
              visit: _visit,
            ),
          ),
        );

        if (visit != null) {
          setState(() {
            _visit = new Visit();
            _visit.id = 0;
            _visit.customerId = widget.customer.id;
            _visit.visitStatusId = 2;
            _visit.date = dateFormat.format(DateTime.now());
          });
        }
      }
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
      if (!flag) {
        stopTimer();
      }
    }

    void showInSnackBar(String value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(value),
        ),
      );
    }

    void startTimer() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      timer = Timer.periodic(timerInterval, tick);

      setState(() {
        _visit.startTime = timeFormat.format(DateTime.now());
        _visit.endTime = timeFormat.format(DateTime.now());
      });

      _visit.longitude = prefs.getDouble("longitude").toString();
      _visit.latitude = prefs.getDouble("latitude").toString();

      VisitService.create(_visit).then((visit) {
        setState(() {
          _visit = visit;
        });
      }).catchError((err) {
        
        
      });
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }

  @override
  void dispose() async {
    super.dispose();

    if (timerSubscription != null) timerSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      // appBar: AppBarWidget(
      //   backgroundColor: Colors.transparent,
      //   leadingColor: Theme.of(context).primaryColor,
      //   title: "",
      // ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 20),
            height: 220,
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(width: 4, color: Color(0x334F62C0)),
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      "https://i2.wp.com/news.microsoft.com/wp-content/themes/microsoft-news-center-2016/assets/img/default-avatar.png?ssl=1",
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.customer.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.customer.groupName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 170,
            child: Container(
              height: 120,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 15),
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff4F62C0).withOpacity(0.15),
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: Offset(0, 0), // changes position of shadow
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (timerStream == null) {
                        timerStream = stopWatchStream();
                        timerSubscription = timerStream.listen((int newTick) {
                          setState(() {
                            hoursStr = ((newTick / (60 * 60)) % 60)
                                .floor()
                                .toString()
                                .padLeft(2, '0');
                            minutesStr = ((newTick / 60) % 60)
                                .floor()
                                .toString()
                                .padLeft(2, '0');
                            secondsStr = (newTick % 60)
                                .floor()
                                .toString()
                                .padLeft(2, '0');
                          });
                        });
                      } else {
                        timerSubscription.cancel();
                        timerStream = null;
                        setState(() {
                          hoursStr = '00';
                          minutesStr = '00';
                          secondsStr = '00';
                        });
                      }
                    },
                    child: Icon(
                      timerStream == null
                          ? Icons.play_circle_outline
                          : Icons.pause_circle_outline,
                      size: 70,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "$hoursStr:$minutesStr:$secondsStr",
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          1 == 1
              ? Container()
              : Center(
                  child: Container(
                    width: 180,
                    margin: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ActionButton(
                          color: Color(0xff2574FF),
                          iconData: Icons.location_on_outlined,
                          url:
                              'https://www.google.com/maps/search/?api=1&query=${widget.customer.latitude},${widget.customer.longitude}',
                        ),
                        ActionButton(
                          color: Color(0xff12B2B3),
                          iconData: Icons.call_outlined,
                          url: widget.customer.name.split(" ")[0],
                        ),
                        ActionButton(
                          color: Color(0xff1DA1F2),
                          iconData: Icons.mail_outline,
                          url: widget.customer.name.split(" ")[1],
                        ),
                      ],
                    ),
                  ),
                ),
          Positioned.fill(
            top: 300,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ProfileListTile(
                    title: "Surveys",
                    icon: Icons.description_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SurveysScreen(
                            customer: widget.customer,
                          ),
                        ),
                      );
                    },
                  ),
                  ProfileListTile(
                    title: "Deals",
                    icon: Icons.local_offer_outlined,
                    onTap: () {
                      // timerStream == null ? null :
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DealListScreen(
                            customer: widget.customer,
                          ),
                        ),
                      );
                    },
                  ),
                  ProfileListTile(
                    title: "Sales Order",
                    icon: Icons.note_add_outlined,
                    onTap: () {
                      // timerStream == null ? null :
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SalesOrderFormScreen(
                            customer: widget.customer,
                          ),
                        ),
                      );
                    },
                  ),
                  ProfileListTile(
                    title: "Tasks",
                    icon: Icons.event_note_outlined,
                    onTap: () {
                      // timerStream == null ? null :
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskListScreen(
                            customer: widget.customer,
                          ),
                        ),
                      );
                    },
                  ),
                  ProfileListTile(
                    title: "Inventory",
                    icon: Icons.inventory_2,
                    onTap: () {
                      // timerStream == null ? null :
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerInventoryListScreen(
                            customer: widget.customer,
                          ),
                        ),
                      );
                    },
                  ),
                  ProfileListTile(
                    title: "Payments",
                    icon: Icons.price_check,
                  ),
                  ProfileListTile(
                    title: "Media",
                    icon: Icons.perm_media_outlined,
                    onTap: () {
                      //  timerStream == null ? null :
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MediaScreen(),
                        ),
                      );
                    },
                  ),
                  ProfileListTile(
                    title: "Notes",
                    icon: Icons.note_alt_outlined,
                    onTap: () {
                      // timerStream == null ? null :
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteListScreen(
                            customer: widget.customer,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  ActionButton({Key key, this.color, this.iconData, this.url})
      : super(key: key);

  IconData iconData;
  Color color;
  String url;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'call not possible';
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: color,
        ),
        child: Icon(
          iconData,
          size: 17,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ProfileListTile extends StatelessWidget {
  ProfileListTile({
    Key key,
    this.title,
    this.onTap,
    this.icon,
  }) : super(key: key);

  dynamic title;
  final GestureTapCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          onTap: onTap,
        ),
        Divider(
          height: 0,
        )
      ],
    );
  }
}
