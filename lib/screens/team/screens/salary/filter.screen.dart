import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/models/hrms/salary/salary-parameters.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/dropdown.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';

class SalaryFilterScreen extends StatefulWidget {
  SalaryFilterScreen({
    Key key,
    this.year,
    this.month,
    this.salaryTeamParameters,
  }) : super(key: key);

  int year;
  int month;
  SalaryTeamParameters salaryTeamParameters;

  @override
  _SalaryFilterScreenState createState() => _SalaryFilterScreenState();
}

class _SalaryFilterScreenState extends State<SalaryFilterScreen> {
  List<int> _months = [];
  List<int> _years = [];

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  onLoad() {
    DateTime now = new DateTime.now();

    for (int i = 1; i <= 12; i++) {
      setState(() {
        _months.add(i);
      });
    }
    for (int i = now.year; i >= 2021; i--) {
      setState(() {
        _years.add(i);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "filter".tr(),
        actions: [
          IconButton(
            onPressed: () {
              DateTime now = new DateTime.now();

              setState(() {
                widget.salaryTeamParameters.year = now.year;
                widget.salaryTeamParameters.month = now.month;
              });
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                Navigator.pop(context, widget.salaryTeamParameters);
              });
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: CardWidget(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                children: [

                  DropdownButtonWidget(
                    labelText: "month".tr(),
                    value: widget.salaryTeamParameters.month,
                    items: _months.map((int month) {
                      return DropdownMenuItem(
                        value: month,
                        child: Text(
                          month.toString() ?? "",
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic month) {
                      setState(() {
                        widget.salaryTeamParameters.month = month;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButtonWidget(
                    labelText: "year".tr(),
                    value: widget.salaryTeamParameters.year,
                    items: _years.map((int year) {
                      return DropdownMenuItem(
                        value: year,
                        child: Text(
                          year.toString() ?? "",
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic year) {
                      setState(() {
                        widget.salaryTeamParameters.year = year;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
