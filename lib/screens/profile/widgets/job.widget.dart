import 'package:flutter/material.dart';
import 'package:nandrlon/models/hrms/employee/employee.model.dart';
import 'package:nandrlon/models/hrms/employee/profile.model.dart';
import 'package:nandrlon/widgets/card.widget.dart';

import 'list-tile.widget.dart';

class JobWidget extends StatelessWidget {
  JobWidget({Key key, this.employee}) : super(key: key);

  final Profile employee;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CardWidget(
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            CustomListTile(
              title: "branch",
              trailing: employee.branch,
              isFirst: true,
            ),
            CustomListTile(
              title: "department",
              trailing: employee.department,
            ),
            CustomListTile(
              title: "job_position",
              trailing: employee.jobPosition,
            ),
            CustomListTile(
              title: "job_title",
              trailing: employee.jobTitle,
            ),
            CustomListTile(
              title: "employment_type",
              trailing: employee.employmentType.trim(),
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}
