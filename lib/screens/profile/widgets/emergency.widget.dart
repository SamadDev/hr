import 'package:flutter/material.dart';
import 'package:nandrlon/models/hrms/employee/employee.model.dart';
import 'package:nandrlon/models/hrms/employee/profile.model.dart';
import 'package:nandrlon/widgets/card.widget.dart';

import 'list-tile.widget.dart';

class EmergencyWidget extends StatelessWidget {
  EmergencyWidget({Key key, this.employee}) : super(key: key);

  final Profile employee;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CardWidget(
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            CustomListTile(
              title: "relationship",
              trailing: employee.emergencyContactRelativeName,
              isFirst: true,
            ),
            CustomListTile(
              title: "name",
              trailing: employee.emergencyContactName,
            ),
            CustomListTile(
              title: "phone_1",
              isLTR: true,
              trailing: employee.emergencyContactPhone1,
            ),
            CustomListTile(
              title: "phone_2",
              isLTR: true,
              trailing: employee.emergencyContactPhone2,
            ),
            CustomListTile(
              title: "email",
              trailing: employee.emergencyContactEmail,
            ),
            CustomListTile(
              title: "address",
              trailing: employee.emergencyContactAddress1,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}
