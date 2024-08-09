import 'package:flutter/material.dart';
import 'package:nandrlon/models/hrms/employee/employee.model.dart';
import 'package:nandrlon/models/hrms/employee/profile.model.dart';
import 'package:nandrlon/widgets/card.widget.dart';

import 'list-tile.widget.dart';

class AddressWidget extends StatelessWidget {
  AddressWidget({Key key, this.employee}) : super(key: key);

  final Profile employee;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CardWidget(
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            CustomListTile(
              title: "country",
              trailing: employee.country,
              isFirst: true,
            ),
            CustomListTile(
              title: "city",
              trailing: employee.city,
            ),
            CustomListTile(
              title: "phone_no",
              isLTR: true,
              trailing: employee.phoneNo,
            ),
            CustomListTile(
              title: "email",
              trailing: employee.email,
            ),
            CustomListTile(
              title: "address",
              trailing: employee.address,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}
