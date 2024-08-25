import 'package:flutter/material.dart';
import 'package:nandrlon/models/hrms/employee/employee.model.dart';
import 'package:nandrlon/services/employee.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/loading.widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen();

  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  var searchController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  List<Employee> _employees;

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  @override
  void dispose() {
    super.dispose();
  }

  onLoad() async {
    String employeeName = searchController.text;
    var employees = await EmployeeService.getEmployees(employeeName);
    setState(() {
      _employees = employees;
    });
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
                    border: Border.all(width: 4, color: Color(0x334F62C0)),
                  ),
                  child: CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage(
                        "assets/image/default-avatar.png",
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  employee.employeeName,
                  style: TextStyle(
                    color: Color(0xff29304D),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: 300,
                  child: Divider(),
                ),
                ListTile(
                  dense: true,
                  leading: new Icon(Icons.location_city_outlined),
                  title: new Text(
                    employee.branch,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListTile(
                  dense: true,
                  leading: new Icon(Icons.schema_outlined),
                  title: new Text(
                    employee.department,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListTile(
                  dense: true,
                  leading: new Icon(Icons.badge_outlined),
                  title: new Text(
                    employee.jobTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListTile(
                  dense: true,
                  leading: new Icon(Icons.work_outlined),
                  title: new Text(
                    employee.jobPosition,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListTile(
                  dense: true,
                  leading: new Icon(Icons.phone_outlined),
                  title: new Text(
                    employee.phoneNo ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () async {
                    if (await canLaunch("tel:+964" + employee.phoneNo)) {
                      await launch("tel:+964" + employee.phoneNo);
                    } else {
                      throw 'call not possible';
                    }
                  },
                ),
                ListTile(
                  dense: true,
                  leading: new Icon(Icons.email_outlined),
                  title: new Text(
                    employee.email ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
        hintText: "Search Data...",
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Employees",
      style: TextStyle(
        color: Color(0xff29304D),
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: Icon(
            Icons.clear,
            color: Theme.of(context).primaryColor,
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
          color: Theme.of(context).primaryColor,
        ),
        onPressed: _startSearch,
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
    setState(() {
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
      ),
      body: _employees == null
          ? LoadingWidget()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {
                            onLoad();
                          },
                          decoration: InputDecoration(
                            filled: true,
                            isDense: true,
                            contentPadding: EdgeInsets.all(0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 0,
                              ),
                            ),
                            fillColor: Color(0xffF0F0F0),
                            hintText: "search".tr(),
                            hintStyle: TextStyle(
                              color: Colors.green,
                            ),
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Color(0xffE0E0E0),
                            ),
                          ),
                          child: Icon(
                            Icons.filter_alt,
                            color: Color(0xff9393AA),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _employees.length,
                    itemBuilder: (context, index) {
                      return EmployeeListTile(
                          employee: _employees[index],
                          onTap: () {
                            showProfile(_employees[index]);
                          });
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class EmployeeListTile extends StatelessWidget {
  EmployeeListTile({
    Key key,
    this.employee,
    this.onTap,
  }) : super(key: key);

  final Employee employee;
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
                Container(
                  height: 50,
                  width: 50,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0x80839daf),
                  ),
                  child: Center(
                    child: Text(
                      employee.employeeName[0],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // CircleAvatar(
                //   radius: 25,
                //   backgroundImage: AssetImage(
                //     "assets/image/default-avatar.png",
                //   ),
                // ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.employeeName,
                      style: TextStyle(
                        color: Color(0xff24272A),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      employee.phoneNo ?? "",
                      style: TextStyle(
                        color: Color(0xff62656B),
                        fontSize: 12,
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
