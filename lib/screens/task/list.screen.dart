import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nandrlon/helper/color.helper.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/models/crm/contact/contact-result.dart';
import 'package:nandrlon/models/crm/customer/customer-result.dart';
import 'package:nandrlon/models/crm/task/task-parameter.dart';
import 'package:nandrlon/models/crm/task/task-result.dart';
import 'package:nandrlon/models/crm/task/tasks-priority.dart';
import 'package:nandrlon/models/crm/task/tasks-status.dart';
import 'package:nandrlon/screens/task/filter.screen.dart';
import 'package:nandrlon/screens/task/form.screen.dart';
import 'package:nandrlon/services/contact.service.dart';
import 'package:nandrlon/services/task.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class TaskListScreen extends StatefulWidget {
  TaskListScreen({
    Key key,
    this.customer,
    this.isReadOnly,
  }) : super(key: key);
  CustomerResult customer;
  bool isReadOnly;

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  var searchController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  Timer _debounce;
  final _dateFormat = DateFormat('dd/MM/yyyy', 'en_Us');
  List<TaskResult> _tasks;
  List<TaskPriority> _taskPriorities = [];
  List<TaskStatus> _taskStatuses = [];
  TaskParameters _taskParameters;
  List<ContactResult> _contacts = [];
  final _scrollController = ScrollController();
  DateRangePickerController _controller;
  List<String> _months;
  bool _selected;
  int _selectedIndex;

  @override
  void initState() {
    _taskParameters = new TaskParameters();
    _taskParameters.fromDate = _dateFormat.format(DateTime.now());
    _taskParameters.toDate = _dateFormat.format(DateTime.now());
    _controller = DateRangePickerController();
    _months = <String>[
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER'
    ];
    _selected = true;
    _selectedIndex = DateTime.now().month - 1;
    if (_scrollController.hasClients)
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );

    getTasks();
    getPriorities();
    getStatuses();

    if (widget.customer != null) {
      getCustomerContacts();
    }

    super.initState();
  }

  getTasks() async {
    var tasks = await TaskService.getTasks(_taskParameters);

    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> getPriorities() async {
    final taskPriorities = await TaskService.getPriorities();

    setState(() {
      _taskPriorities = taskPriorities;
    });
  }

  Future<void> getStatuses() async {
    final taskStatuses = await TaskService.getStatuses();

    setState(() {
      _taskStatuses = taskStatuses;
    });
  }

  Future<List<ContactResult>> getCustomerContacts() async {
    var contacts =
        await ContactService.getCustomerContacts(widget.customer?.id);

    setState(() {
      _contacts = contacts;
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
        ),
      ),
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
        fontFamily: getFontFamily(context),
        fontWeight: FontWeight.bold,
      ),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  Widget _buildTitle() {
    return Text(
      "tasks".tr(),
      style: TextStyle(
        color: Colors.white,
        fontFamily: getFontFamily(context),
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
          var taskParameters = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskFilterScreen(
                taskPriorities: _taskPriorities,
                taskStatuses: _taskStatuses,
                taskParameters: _taskParameters,
                contacts: _contacts,
              ),
            ),
          );

          if (taskParameters != null) {
            setState(() {
              _tasks = null;
              _taskParameters = taskParameters;
            });

            getTasks();
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
    _debounce = Timer(const Duration(milliseconds: 100), () {
      _taskParameters.searchText = newQuery;
      getTasks();
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        titleWidget: _isSearching ? _buildSearchField() : _buildTitle(),
        actions: _buildActions(),
      ),
      floatingActionButton: widget.isReadOnly == true
          ? Container()
          : FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () async {
                var note = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskFormScreen(
                      id: 0,
                      customerId:
                          widget.customer == null ? 0 : widget.customer.id,
                      date: _taskParameters.fromDate,
                    ),
                  ),
                );

                if (note != null) {
                  getTasks();
                }
              },
            ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 15, 15, 0),
              height: 55,
              color: Colors.white,
              child: Center(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _months.length,
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selected = true;
                            _selectedIndex = index;
                            _controller.displayDate =
                                DateTime(2021, _selectedIndex, 1, 9, 0, 0);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 15,
                            top: 5,
                          ),
                          height: 2,
                          color: Colors.white,
                          child: Column(
                            children: [
                              Container(
                                child: Text(
                                  _months[index],
                                  style: TextStyle(
                                    color: _selected && _selectedIndex == index
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey,
                                    fontWeight:
                                        _selected && _selectedIndex == index
                                            ? FontWeight.w900
                                            : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1.0,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
              ),
              child: SfDateRangePicker(
                backgroundColor: Colors.white,
                controller: _controller,
                selectionColor: Theme.of(context).primaryColor,
                view: DateRangePickerView.month,
                headerHeight: 0,
                cellBuilder: cellBuilder,
                initialDisplayDate: DateTime.now(),
                initialSelectedDate: DateTime.now(),
                onSelectionChanged: (value) {
                  _taskParameters.fromDate = _dateFormat.format(value.value);
                  _taskParameters.toDate = _dateFormat.format(value.value);

                  setState(() {
                    _tasks = null;
                  });

                  getTasks();
                },
                monthViewSettings: DateRangePickerMonthViewSettings(
                  viewHeaderHeight: 0,
                  numberOfWeeksInView: 1,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 15),
                child: ListViewHelper(
                  list: _tasks,
                  onRefresh: () => getTasks(),
                  itemBuilder: (context, index) {
                    return TaskListTile(
                      task: _tasks[index],
                      onTap: () async {
                        var note = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskFormScreen(
                              id: _tasks[index].id,
                              customerId: widget.customer == null ? 0 : widget.customer.id,
                            ),
                          ),
                        );

                        if (note != null) {
                          getTasks();
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cellBuilder(BuildContext context, DateRangePickerCellDetails details) {
    var IsSelected = _controller.selectedDate != null &&
        details.date.year == _controller.selectedDate.year &&
        details.date.month == _controller.selectedDate.month &&
        details.date.day == _controller.selectedDate.day;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Text(
            details.date.day.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: IsSelected ? Colors.white : Colors.black87,
                fontWeight: IsSelected ? FontWeight.w600 : FontWeight.w500),
          ),
        ),
        Container(
          child: Text(
            DateFormat('EEE', 'en_Us').format((details.date)),
            style: TextStyle(
                color: IsSelected ? Colors.white : Colors.black87,
                fontWeight: IsSelected ? FontWeight.w600 : FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class TaskListTile extends StatelessWidget {
  TaskListTile({
    Key key,
    this.task,
    this.onTap,
  }) : super(key: key);

  final TaskResult task;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  child: SizedBox(
                    width: 20,
                    child: Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      checkColor: Colors.white,
                      value: false,
                      onChanged: (bool value) {},
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      task.subject,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      task.priority,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                  color: changeColor(task.statusColor),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                task.status,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
