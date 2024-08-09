
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/models/crm/contact/contact-result.dart';
import 'package:nandrlon/models/crm/task/task-parameter.dart';
import 'package:nandrlon/models/crm/task/tasks-priority.dart';
import 'package:nandrlon/models/crm/task/tasks-status.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/dropdown.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';

class TaskFilterScreen extends StatefulWidget {
  TaskFilterScreen({
    Key key,
    this.taskPriorities,
    this.taskStatuses,
    this.contacts,
    this.taskParameters,
  }) : super(key: key);

  TaskParameters taskParameters;
  List<TaskPriority> taskPriorities;
  List<TaskStatus> taskStatuses;
  List<ContactResult> contacts;

  @override
  _TaskFilterScreenState createState() => _TaskFilterScreenState();
}

class _TaskFilterScreenState extends State<TaskFilterScreen> {
  @override
  void initState() {
    super.initState();
  }

  customerModalBottomSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, mystate) => Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.contacts.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: new Text(widget.contacts[index].name),
                          onTap: () {
                            setState(() {
                              widget.taskParameters.customerContact =
                                  widget.contacts[index];
                              widget.taskParameters.customerContactId =
                                  widget.contacts[index].id;
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
              ],
            ),
          );
        });
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
                widget.taskParameters = TaskParameters();
              });
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                Navigator.pop(context, widget.taskParameters);
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
                  TextFieldWidget(
                    labelText: "Search",
                    initialValue: widget.taskParameters.searchText,
                    onChanged: (value) {
                      widget.taskParameters.searchText = value;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: customerModalBottomSheet,
                    child: TextFieldWidget(
                      labelText: "Contact",
                      isDropdown: true,
                      enabled: false,
                      initialValue:
                          widget.taskParameters?.customerContact?.name ?? "",
                    ),
                  ),
                  DropdownButtonWidget(
                    labelText: "Status",
                    value: widget.taskParameters.taskStatus,
                    items: widget.taskStatuses.map((TaskStatus taskStatus) {
                      return DropdownMenuItem(
                        value: taskStatus,
                        child: Text(
                          taskStatus.name,
                        ),
                      );
                    }).toList(),
                    onChanged: (TaskStatus taskStatus) {
                      setState(() {
                        widget.taskParameters.taskStatus = taskStatus;
                        widget.taskParameters.taskStatusId = taskStatus.id;
                      });
                    },
                  ),
                  DropdownButtonWidget(
                    labelText: "Priority",
                    value: widget.taskParameters.taskPriority,
                    items:
                        widget.taskPriorities.map((TaskPriority taskPriority) {
                      return DropdownMenuItem(
                        value: taskPriority,
                        child: Text(
                          taskPriority.name,
                        ),
                      );
                    }).toList(),
                    onChanged: (TaskPriority taskPriority) {
                      setState(() {
                        widget.taskParameters.taskPriority = taskPriority;
                        widget.taskParameters.taskPriorityId = taskPriority.id;
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
