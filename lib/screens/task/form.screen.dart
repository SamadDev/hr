
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/models/crm/contact/contact-result.dart';
import 'package:nandrlon/models/crm/customer/customer.dart';
import 'package:nandrlon/models/crm/deal/stage.dart';
import 'package:nandrlon/models/crm/shared/entity-mode.dart';
import 'package:nandrlon/models/crm/task/task.dart';
import 'package:nandrlon/models/crm/task/tasks-priority.dart';
import 'package:nandrlon/models/crm/task/tasks-status.dart';
import 'package:nandrlon/services/contact.service.dart';
import 'package:nandrlon/services/customer.service.dart';
import 'package:nandrlon/services/task.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/dropdown.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/loading.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';

class TaskFormScreen extends StatefulWidget {
  TaskFormScreen({
    Key key,
    this.id,
    this.customerId,
    this.date,
  }) : super(key: key);

  int id;
  int customerId;
  String date;

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final DateFormat formatter = DateFormat('dd/MM/yyyy', 'en_Us');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _task = new Task();
  var phoneMask = new MaskTextInputFormatter(mask: "+964 (###) ###-####");
  DateTime selectedDate = DateTime.now();
  List<TaskPriority> _taskPriorities = [];
  List<TaskStatus> _taskStatuses = [];
  List<ContactResult> _contacts = [];
  ContactResult _contact;
  List<Customer> _customers = [];
  Stage _stage;
  bool _isLoading = true;
  bool _isLoadingContact = true;
  bool _isSubmit = false;
  EntityMode _entityMode = EntityMode.New;

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  onLoad() async {
    _task.date = widget.date;
    _task.customerId = widget.customerId;

    if (widget.id > 0) {
      await getTask();
    }

    await getCustomerContacts();
    await getPriorities();
    await getStatuses();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getPriorities() async {
    final taskPriorities = await TaskService.getPriorities();

    var taskPriority =
        taskPriorities.firstWhere((element) => element.isDefault);

    setState(() {
      _task.taskPriority = taskPriority;
      _task.taskPriorityId = taskPriority.id;

      _taskPriorities = taskPriorities;
    });
  }

  Future<void> getStatuses() async {
    final taskStatuses = await TaskService.getStatuses();

    var taskStatus = taskStatuses.firstWhere((element) => element.isDefault);

    setState(() {
      _task.taskStatus = taskStatus;
      _task.taskStatusId = taskStatus.id;

      _taskStatuses = taskStatuses;
    });
  }

  Future<void> getTask() async {
    final task = await TaskService.getTask(widget.id);

    setState(() {
      _task = task;
      _entityMode = EntityMode.Edit;
    });
  }

  Future<List<Customer>> getCustomers(searchText) async {
    return await CustomerService.filter(searchText);
  }

  customerModalBottomSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, mystate) => Column(
              children: [
                Container(
                  padding: showModalBottomSheetPadding,
                  child: TextFieldWidget(
                    iconData: Icons.search,
                    hintText: "search".tr(),
                    onChanged: (value) async {
                      var customers = await getCustomers(value);
                      mystate(() {
                        _customers = customers;
                      });
                    },
                  ),
                ),
                Container(
                  child: Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _customers.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: new Text(_customers[index].name),
                              onTap: () {
                                setState(() {
                                  _isLoadingContact = true;
                                  _task.customer = _customers[index];
                                  _task.customerId = _customers[index].id;
                                  _task.contact = null;
                                  _task.customerContactId = null;
                                  getCustomerContacts();
                                });
                                Navigator.pop(context);
                              },
                            ),
                            Divider(
                              height: 0,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme:
                ColorScheme.light(primary: Theme.of(context).primaryColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      
      
      setState(() {
        selectedDate = picked;
        _task.date = formatter.format(picked);
      });
    }
  }

  Future<List<ContactResult>> getCustomerContacts() async {
    var contacts = await ContactService.getCustomerContacts(_task.customerId);
    setState(() {
      _contacts = contacts;
      _isLoadingContact = false;
    });
  }

  customerContactModalBottomSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, mystate) => Container(
              height: MediaQuery.of(context).copyWith().size.height * 0.75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                color: Colors.white,
              ),
              child: _isLoadingContact
                  ? LoadingWidget()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _contacts.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: new Text(_contacts[index].name),
                              onTap: () {
                                setState(() {
                                  _task.contact = _contacts[index];
                                  _task.customerContactId = _contacts[index].id;
                                });

                                mystate(() {
                                  _task.contact = _contacts[index];
                                  _task.customerContactId = _contacts[index].id;
                                });
                                Navigator.pop(context);
                              },
                            ),
                            Divider(
                              height: 0,
                            ),
                          ],
                        );
                      },
                    ),
            ),
          );
        });
  }

  create() {
    setState(() {
      _isSubmit = true;
    });
    _task.id = 0;

    TaskService.create(_task).then((value) {
      showInSnackBar("task has been save successfully");
      setState(() {
        _isSubmit = false;
      });
      Navigator.pop(context, true);
    }).catchError((err) {
      showInSnackBar("Something error please contact support");
      setState(() {
        _isSubmit = false;
      });
    });

    setState(() {
      _isSubmit = false;
    });
  }

  update() {
    setState(() {
      _isSubmit = true;
    });

    TaskService.update(_task).then((value) {
      showInSnackBar("task has been updated successfully");

      setState(() {
        _isSubmit = false;
      });
      Navigator.pop(context, true);
    }).catchError((err) {
      showInSnackBar("Something error please contact support");

      setState(() {
        _isSubmit = false;
      });
    });
  }

  onSubmit() {
    if (_entityMode == EntityMode.New) {
      create();
    } else {
      update();
    }
  }

  isEmailValid(email) {
    if (email == null) return false;
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value),
      ),
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      key: _scaffoldKey,
      appBar: AppBarWidget(
        title: widget.id == 0 ? "New Task" : "Edit Task",
        actions: [
          _isSubmit
              ? Center(
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : IconButton(
                  onPressed: _isSubmit ? null : onSubmit,
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
        ],
      ),
      body: _isLoading
          ? LoadingWidget()
          : Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardWidget(
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            widget.customerId == null
                                ? Container()
                                : GestureDetector(
                                    onTap: customerModalBottomSheet,
                                    child: TextFieldWidget(
                                      labelText: "Customer",
                                      isDropdown: true,
                                      key: Key(_task.customer?.name),
                                      enabled: false,
                                      isRequired: true,
                                      initialValue: _task.customer?.name ?? "",
                                    ),
                                  ),
                            GestureDetector(
                              onTap: _isLoadingContact
                                  ? null
                                  : customerContactModalBottomSheet,
                              child: TextFieldWidget(
                                key: Key(_task?.contact?.name),
                                labelText: "Contact",
                                isDropdown: true,
                                isLoading: _isLoadingContact,
                                enabled: false,
                                isSubmit: _isSubmit,
                                isRequired: true,
                                initialValue: _task?.contact?.name ?? "",
                              ),
                            ),
                            TextFieldWidget(
                              labelText: "Subject",
                              initialValue: _task.subject,
                              isSubmit: _isSubmit,
                              isRequired: true,
                              onChanged: (value) {
                                _task.subject = value;
                              },
                            ),
                            GestureDetector(
                              onTap: () => _selectDate(context),
                              child: TextFieldWidget(
                                labelText: "Date",
                                key: Key(_task.date),
                                isDropdown: true,
                                enabled: false,
                                isSubmit: _isSubmit,
                                isRequired: true,
                                initialValue:
                                    _task?.date?.toString()?.substring(0, 10) ??
                                        "",
                              ),
                            ),
                            DropdownButtonWidget(
                              labelText: "Status",
                              value: _task.taskStatus,
                              items: _taskStatuses.map((TaskStatus taskStatus) {
                                return DropdownMenuItem(
                                  value: taskStatus,
                                  child: Text(
                                    taskStatus.name,
                                  ),
                                );
                              }).toList(),
                              onChanged: (TaskStatus taskStatus) {
                                setState(() {
                                  _task.taskStatus = taskStatus;
                                  _task.taskStatusId = taskStatus.id;
                                });
                              },
                            ),
                            DropdownButtonWidget(
                              labelText: "Priority",
                              value: _task.taskPriority,
                              items: _taskPriorities
                                  .map((TaskPriority taskPriority) {
                                return DropdownMenuItem(
                                  value: taskPriority,
                                  child: Text(
                                    taskPriority.name,
                                  ),
                                );
                              }).toList(),
                              onChanged: (TaskPriority taskPriority) {
                                setState(() {
                                  _task.taskPriority = taskPriority;
                                  _task.taskPriorityId = taskPriority.id;
                                });
                              },
                            ),
                            TextFieldWidget(
                              labelText: "Description",
                              initialValue: _task.description,
                              maxLines: 8,
                              onChanged: (value) {
                                _task.description = value;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class FormListTile extends StatelessWidget {
  FormListTile({
    Key key,
    this.title,
    this.widget,
  }) : super(key: key);

  final dynamic title;
  final dynamic widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(
            constBorderRadius,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title == null
              ? SizedBox()
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Text(
                    this.title,
                    style: TextStyle(
                      color: Color(0xff29304D),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          title == null
              ? SizedBox()
              : Divider(
                  height: 0,
                ),
          widget
        ],
      ),
    );
  }
}
