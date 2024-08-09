import 'package:flutter/material.dart';
import 'package:nandrlon/screens/contact/list.screen.dart';
import 'package:nandrlon/screens/customer/list.screen.dart';
import 'package:nandrlon/screens/delivery-note/list.screen.dart';
import 'package:nandrlon/screens/item/list.screen.dart';
import 'package:nandrlon/screens/map/map.screen.dart';
import 'package:nandrlon/screens/sales-order/list.screen.dart';

class RepresentativeWidget extends StatelessWidget {
  const RepresentativeWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "CRM",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(
                0xff29304D,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              RepresentativeButton(
                title: "Customers",
                icon: Icons.group_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomerListScreen()),
                  );
                },
              ),
              RepresentativeButton(
                title: "Contacts",
                icon: Icons.groups_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactListScreen()),
                  );
                },
              ),
              RepresentativeButton(
                title: "Products",
                icon: Icons.inventory_2_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ItemListScreen()),
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RepresentativeButton(
                title: "Delivery Notes",
                icon: Icons.inventory_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeliveryNoteScreen()),
                  );
                },
              ),
              RepresentativeButton(
                title: "Orders",
                icon: Icons.description_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SalesOrderListScreen()),
                  );
                },
              ),
              RepresentativeButton(
                title: "Map",
                icon: Icons.map_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RepresentativeButton extends StatelessWidget {
  RepresentativeButton({
    Key key,
    this.title,
    this.icon,
    this.onTap,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        width: (width / 3) - 20,
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0xff4F62C0).withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 20,
              offset: Offset(0, 10), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                this.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff3A3A3A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
