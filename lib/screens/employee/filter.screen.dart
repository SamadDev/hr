import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/models/hrms/branch.model.dart';
import 'package:nandrlon/models/hrms/department.model.dart';
import 'package:nandrlon/models/hrms/employee/employee-parameters.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/dropdown.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';

class EmployeeFilterScreen extends StatefulWidget {
  EmployeeFilterScreen({
    Key key,
    this.employeeParameters,
    this.departments,
    this.branches,
  }) : super(key: key);

  EmployeeParameters employeeParameters;
  List<Department> departments;
  List<Branch> branches;

  @override
  _EmployeeFilterScreenState createState() => _EmployeeFilterScreenState();
}

class _EmployeeFilterScreenState extends State<EmployeeFilterScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "filter".tr(),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                widget.employeeParameters = new EmployeeParameters();
              });
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                Navigator.pop(context, widget.employeeParameters);
              });
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: CardWidget(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonWidget(
                  labelText: "branch".tr(),
                  value: widget.employeeParameters.branch,
                  items: widget.branches.map((Branch branch) {
                    return DropdownMenuItem(
                      value: branch,
                      child: Text(
                        branch.name ?? "",
                      ),
                    );
                  }).toList(),
                  onChanged: (dynamic branch) {
                    setState(() {
                      widget.employeeParameters.branchId = branch.id;
                      widget.employeeParameters.branch = branch;
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButtonWidget(
                  labelText: "department".tr(),
                  value: widget.employeeParameters.department,
                  items: widget.departments.map((Department department) {
                    return DropdownMenuItem(
                      value: department,
                      child: Text(
                        department.name,
                      ),
                    );
                  }).toList(),
                  onChanged: (dynamic department) {
                    setState(() {
                      widget.employeeParameters.departmentId = department.id;
                      widget.employeeParameters.department = department;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
