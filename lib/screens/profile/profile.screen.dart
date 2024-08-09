import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/models/hrms/employee/profile.model.dart';
import 'package:nandrlon/screens/profile/widgets/address.widget.dart';
import 'package:nandrlon/screens/profile/widgets/emergency.widget.dart';
import 'package:nandrlon/screens/profile/widgets/job.widget.dart';
import 'package:nandrlon/screens/profile/widgets/profile.widget.dart';
import 'package:nandrlon/services/employee.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/loading.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({
    Key key,
    this.id,
    this.automaticallyImplyLeading,
  }) : super(key: key);
  final int id;
  final bool automaticallyImplyLeading;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Profile _employee;
  final TextStyle tabTextStyle = TextStyle(
    fontSize: 11,
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  onLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt("id");

    var employee = await EmployeeService.getEmployee(widget.id ?? userId);
    setState(() {
      _employee = employee;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Layout(
        appBar: AppBarWidget(
          title: "profile".tr(),
          size: 100,
          leading: widget.automaticallyImplyLeading == false ? SizedBox() : IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: Colors.white,),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.5),
            labelStyle: TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(
                child: Text(
                  "profile".tr(),
                  style: TextStyle(
                    fontSize: context.locale.languageCode == "en" ? 15 : 13,
                    fontFamily: getFontFamily(context),
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "contact".tr(),
                  style: TextStyle(
                    fontSize: context.locale.languageCode == "en" ? 15 : 13,
                    fontFamily: getFontFamily(context),
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "job".tr(),
                  style: TextStyle(
                    fontSize: context.locale.languageCode == "en" ? 15 : 13,
                    fontFamily: getFontFamily(context),
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "emergency".tr(),
                  style: TextStyle(
                    fontSize: context.locale.languageCode == "en" ? 15 : 13,
                    fontFamily: getFontFamily(context),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: _employee == null
            ? LoadingWidget()
            : TabBarView(
                children: [
                  ProfileWidget(
                    employee: _employee,
                  ),
                  AddressWidget(
                    employee: _employee,
                  ),
                  JobWidget(
                    employee: _employee,
                  ),
                  EmergencyWidget(
                    employee: _employee,
                  ),
                ],
              ),
      ),
    );
  }
}
