import 'package:flutter/material.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/screens/order/form.screen.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen();

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var searchController = TextEditingController();
  String searchQuery = "Search query";
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
          title: "Orders",
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderFormScreen(),
              ),
            );
          },
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (context, index) {
              return OrderListTile();
            },
          ),
        ),
      ),
    );
  }
}

class OrderListTile extends StatelessWidget {
  OrderListTile({
    Key key,
    this.doctorCall,
    this.onTap,
  }) : super(key: key);

  final dynamic doctorCall;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      padding: EdgeInsets.symmetric(vertical: 15),

      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Item(
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
          Item(
            title: "Customer",
            value: "Kardo Hussein",
            iconBackgroundColor: Colors.orange.shade50,
            iconColor: Colors.orange,
            icon: Icons.person_outline,
          ),
          Row(
            children: [
              Item(
                title: "Total",
                value: "IQD 1000",
                iconColor: Colors.red,
                iconBackgroundColor: Colors.red.shade50,
                icon: Icons.money_outlined,
              ),
              Item(
                title: "Discount",
                value: "10%",
                iconColor: Colors.blue,
              ),
              Item(
                title: "Net",
                value: "IQD 900",
                iconColor: Colors.teal,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Item extends StatelessWidget {
  Item({
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
      padding: EdgeInsets.only(
        left: 15,
        top: 15,
      ),
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
