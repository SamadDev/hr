import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/models/hrms/employee/employee.model.dart';
import 'package:nandrlon/models/hrms/employee/profile.model.dart';
import 'package:nandrlon/widgets/card.widget.dart';

import 'list-tile.widget.dart';

class ProfileWidget extends StatelessWidget {
  ProfileWidget({Key key, this.employee}) : super(key: key);

  final Profile employee;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CardWidget(
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            CustomListTile(
              title: "code",
              trailing: employee.code,
              isFirst: true,
            ),
            CustomListTile(
              title: "name",
              trailing: employee.employeeName,
            ),
            CustomListTile(
              title: "name_ku",
              trailing: employee.employeeNameKu,
            ),
            CustomListTile(
              title: "gender",
              trailing: employee.gender,
            ),
            CustomListTile(
              title: "marital_status",
              trailing: employee.maritalStatus,
            ),
            CustomListTile(
              title: "date_of_birth",
              trailing: employee.dateOfBirth.substring(0, 10),
            ),
            CustomListTile(
              title: "place_of_birth",
              trailing: employee.placeOfBirth,
            ),
            CustomListTile(
              title: "nationality",
              trailing: employee.nationality,
            ),
            CustomListTile(
              title: "religion",
              trailing: employee.religion,
            ),
            CustomListTile(
              title: "blood_group",
              trailing: employee.bloodGroup,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}
