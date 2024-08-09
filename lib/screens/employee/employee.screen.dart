import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/models/hrms/branch.model.dart';
import 'package:nandrlon/models/hrms/department.model.dart';
import 'package:nandrlon/models/hrms/employee/employee-parameters.dart';
import 'package:nandrlon/models/hrms/employee/employee.model.dart';
import 'package:nandrlon/screens/employee/filter.screen.dart';
import 'package:nandrlon/services/employee.service.dart';
import 'package:nandrlon/services/hrms/branch.service.dart';
import 'package:nandrlon/services/hrms/department.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/image.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({
    Key key,
    this.automaticallyImplyLeading,
  }) : super(key: key);

  final bool automaticallyImplyLeading;

  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  ScrollController _controller;
  SharedPreferences prefs;
  var _employeeParameters = new EmployeeParameters();
  var searchController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  List<Employee> _employees;
  Timer _debounce;
  dynamic _city;
  dynamic _department;
  dynamic _branch;
  String _api;
  List<Department> _departments;
  List<Branch> _branches = [];
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  @override
  void initState() {
    _controller = new ScrollController()..addListener(_loadMore);
    super.initState();
    getFormResult();
    onLoad();
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  getFormResult() async {
    final branches = await BranchService.get();
    final departments = await DepartmentService.get();

    setState(() {
      _branches = branches;
      _departments = departments;
    });
  }

  Future<void> onLoad() async {
    prefs = await SharedPreferences.getInstance();

    final employees = await getEmployees();

    setState(() {
      _employees = employees;
    });
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    final employees = await getEmployees();
    setState(() {
      _employees = employees;
    });

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  Future<List<Employee>> getEmployees() async {
    return await EmployeeService.getEmployeesList(_employeeParameters);
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _employeeParameters.pageNumber += 1; // Increase _page by 1

      final employees = await getEmployees();

      final fetchedPosts = employees;
      if (fetchedPosts.length > 0) {
        setState(() {
          _employees.addAll(fetchedPosts);
        });
      } else {
        setState(() {
          _hasNextPage = false;
        });
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  showProfile(Employee employee) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45),
                    border: Border.all(width: 2, color: Color(0x334F62C0)),
                  ),
                  child: ImageWidget(
                    width: 80,
                    height: 80,
                    imageUrl:
                        "${box.read('api')}/Uploads/HRMS/Employees/${employee.employeeImage}",
                    errorText: employee.employeeName[0],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  context.locale.languageCode == "en"
                      ? employee.employeeName
                      : employee.employeeNameKu,
                  style: TextStyle(
                    color: Color(0xff29304D),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: getFontFamily(context),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ContactProfileListTile(
                  icon: Icons.location_city_outlined,
                  subtitle: employee.branch,
                  title: "branch",
                ),
                ContactProfileListTile(
                  icon: Icons.schema_outlined,
                  subtitle: employee.department,
                  title: "department",
                ),
                ContactProfileListTile(
                  icon: Icons.badge_outlined,
                  subtitle: employee.jobTitle,
                  title: "job_title",
                ),
                ContactProfileListTile(
                  icon: Icons.work_outlined,
                  subtitle: employee.jobPosition,
                  title: "job_position",
                ),
                ContactProfileListTile(
                  icon: Icons.phone_outlined,
                  subtitle: employee.phoneNo,
                  title: "phone",
                  isPhone: true,
                  onTap: () async {
                    if (await canLaunch("tel:+964" + employee.phoneNo)) {
                      await launch("tel:+964" + employee.phoneNo);
                    } else {
                      throw 'call not possible';
                    }
                  },
                ),
                ContactProfileListTile(
                  icon: Icons.email_outlined,
                  subtitle: employee.email,
                  title: "email",
                  onTap: () async {
                    if (await canLaunch("mailto:" + employee.email)) {
                      await launch("mailto:" + employee.email);
                    } else {
                      throw 'call not possible';
                    }
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "search".tr(),
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Colors.white,
          fontFamily: getFontFamily(context),
        ),
      ),
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  Widget _buildTitle() {
    return Text(
      "employees".tr(),
      style: TextStyle(
        color: Colors.white,
        fontSize: context.locale.languageCode == "en" ? 20 : 17,
        fontFamily: getFontFamily(context),
      ),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () {
            if (searchController == null || searchController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: Icon(
          Icons.search,
          color: Colors.white,
        ),
        onPressed: _startSearch,
      ),
      IconButton(
        icon: Icon(
          Icons.filter_alt_outlined,
          color: Colors.white,
        ),
        onPressed: () async {
          var employeeParameters = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmployeeFilterScreen(
                employeeParameters: _employeeParameters,
                departments: _departments,
                branches: _branches,
              ),
            ),
          );

          if (employeeParameters != null) {
            setState(() {
              _employeeParameters = employeeParameters;
            });

            onLoad();
          }
        },
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _employeeParameters.pageNumber = 1;
      _employeeParameters.employeeName = newQuery;
      onLoad();
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      searchController.clear();
      updateSearchQuery("");
      onLoad();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        titleWidget: _isSearching ? _buildSearchField() : _buildTitle(),
        actions: _buildActions(),
        leading: widget.automaticallyImplyLeading == false
            ? SizedBox()
            : IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
      ),
      body: ListViewHelper(
        controller: _controller,
        onRefresh: onLoad,
        list: _employees,
        itemBuilder: (context, index) {
          return EmployeeListTile(
              employee: _employees[index],
              api: box.read('api'),
              onTap: () {
                showProfile(_employees[index]);
              });
        },
      ),
    );
  }
}

class EmployeeListTile extends StatelessWidget {
  EmployeeListTile({
    Key key,
    this.employee,
    this.api,
    this.onTap,
  }) : super(key: key);

  final Employee employee;
  final String api;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                ImageWidget(
                  imageUrl:
                      "$api/Uploads/HRMS/Employees/${employee.employeeImage}",
                  errorText: employee.employeeName[0],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.locale.languageCode == "en"
                          ? employee.employeeName
                          : employee.employeeNameKu,
                      style: TextStyle(
                        color: Color(0xff24272A),
                        fontWeight: FontWeight.bold,
                        fontFamily: getFontFamily(context),
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: employee.phoneNo == null ? 0 : 5,
                    ),
                    employee.phoneNo == null
                        ? Container()
                        : Directionality(
                            textDirection: ui.TextDirection.ltr,
                            child: Text(
                              employee.phoneNo ?? "",
                              textDirection: ui.TextDirection.ltr,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Color(0xff62656B),
                                fontSize: 12,
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
          ),
        ],
      ),
    );
  }
}

class ContactProfileListTile extends StatelessWidget {
  ContactProfileListTile({
    Key key,
    this.title,
    this.subtitle,
    this.icon,
    this.onTap,
    this.isPhone,
  }) : super(key: key);
  final GestureTapCallback onTap;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isPhone;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            margin: EdgeInsets.only(top: 10, left: 10),
            child: new Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
          ),
          title: new Text(
            title.tr(),
            style: TextStyle(
              fontFamily:
                  context.locale.languageCode == "en" ? "aileron" : "DroidKufi",
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
          subtitle: subtitle == null
              ? Container()
              : Directionality(
                  textDirection: isPhone == true
                      ? ui.TextDirection.ltr
                      : (isLTR(context)
                          ? ui.TextDirection.ltr
                          : ui.TextDirection.rtl),
                  child: Container(
                    padding: EdgeInsets.only(top: 5),
                    child: new Text(
                      subtitle ?? "",
                      textAlign:
                          isLTR(context) ? TextAlign.left : TextAlign.right,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff565656),
                      ),
                    ),
                  ),
                ),
        ),
        Divider(
          height: 0,
        ),
      ],
    );
  }
}
