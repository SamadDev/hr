import 'package:flutter/material.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/screens/doctor-call/form.screen.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';

class DoctorCallListScreen extends StatefulWidget {
  const DoctorCallListScreen();

  @override
  _DoctorCallListScreenState createState() => _DoctorCallListScreenState();
}

class _DoctorCallListScreenState extends State<DoctorCallListScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  var searchController = TextEditingController();
  String searchQuery = "Search query";
  int _currentIndex = 0;
  final TextStyle selectedStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  final TextStyle unselectedStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: Colors.black.withOpacity(0.2),
  );

  @override
  void initState() {
    _tabController = new TabController(
      length: 3,
      vsync: this,
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Layout(
        layoutBackgroundColor: backgroundColor,
        appBar: AppBarWidget(
          title: "Doctor Calls",
          size: 105,
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            controller: _tabController,
            tabs: [
              Tab(
                child: Text(
                  "Today",
                ),
              ),
              Tab(
                child: Text(
                  "Scheduled",
                ),
              ),
              Tab(
                child: Text(
                  "Completed",
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DoctorCallFormScreen(),
              ),
            );
          },
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return DoctorCallListTile();
              },
            ),
            ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return DoctorCallListTile();
              },
            ),
            ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return DoctorCallListTile();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorCallListTile extends StatelessWidget {
  DoctorCallListTile({
    Key key,
    this.doctorCall,
    this.onTap,
  }) : super(key: key);

  final dynamic doctorCall;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DoctorCallItem(
                title: "Date",
                value: DateTime.now().toString().substring(0, 10),
                iconBackgroundColor: Colors.green.shade50,
                iconColor: Colors.green,
                icon: Icons.date_range_outlined,
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.fromLTRB(15, 6.5, 25, 8),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                  ),
                ),
                child: Text(
                  "Pending",
                  textAlign: TextAlign.end,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          DoctorCallItem(
            title: "Doctor",
            value: "Kardo Hussein",
            iconBackgroundColor: Colors.orange.shade50,
            iconColor: Colors.orange,
            icon: Icons.person_outline,
          ),
          DoctorCallItem(
            title: "Result",
            value: "Interested",
            iconColor: Colors.red,
            iconBackgroundColor: Colors.red.shade50,
            icon: Icons.star_border_outlined,
          ),
        ],
      ),
    );
  }
}

class DoctorCallItem extends StatelessWidget {
  DoctorCallItem({
    Key key,
    this.title,
    this.value,
    this.icon,
    this.iconColor,
    this.iconBackgroundColor,
  }) : super(key: key);

  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, top: 15, bottom: 10),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  icon,
                  size: 17,
                  color: iconColor,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Color(0xff545F7A),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                value,
                style: TextStyle(
                  color: Color(0xff0F1B2D),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
