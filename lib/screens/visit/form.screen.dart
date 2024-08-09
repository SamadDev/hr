
import 'package:flutter/material.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/models/crm/shared/entity-mode.dart';
import 'package:nandrlon/models/crm/visit/visit-purpose.dart';
import 'package:nandrlon/models/crm/visit/visit-result.dart';
import 'package:nandrlon/models/crm/visit/visit-status.dart';
import 'package:nandrlon/models/crm/visit/visit.dart';
import 'package:nandrlon/services/visit.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/dropdown.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/loading.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';

class VisitFormScreen extends StatefulWidget {
  VisitFormScreen({
    Key key,
    this.visit,
  }) : super(key: key);

  Visit visit;

  @override
  _VisitFormScreenState createState() => _VisitFormScreenState();
}

class _VisitFormScreenState extends State<VisitFormScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  DateTime selectedDate = DateTime.now();
  List<VisitPurpose> _visitPurposes = [];
  List<VisitResult> _visitResults = [];
  List<VisitStatus> _visitStatuses = [];
  bool _isSubmit = false;
  bool _isLoading = true;
  EntityMode _entityMode = EntityMode.Edit;

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  onLoad() async {
    await getResults();
    await getPurposes();
    await getStatuses();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getStatuses() async {
    final visitStatuses = await VisitService.getStatuses();

    setState(() {
      _visitStatuses = visitStatuses;
    });
  }

  Future<void> getPurposes() async {
    final visitPurposes = await VisitService.getPurposes();

    setState(() {
      _visitPurposes = visitPurposes;
    });
  }

  Future<void> getResults() async {
    final visitResults = await VisitService.getResults();

    setState(() {
      _visitResults = visitResults;
    });
  }

  create() {
    setState(() {
      _isSubmit = true;
    });

    VisitService.create(widget.visit).then((value) {
      showInSnackBar("Visit has been saved successfully");
      setState(() {
        _isSubmit = false;
      });
      Navigator.pop(context, true);
    }).catchError((err) {
      showInSnackBar("Something error please contact support");
    });

    setState(() {
      _isSubmit = false;
    });
  }

  update() {
    setState(() {
      _isSubmit = true;
    });

    VisitService.update(widget.visit).then((value) {
      showInSnackBar("Visit has been saved successfully");

      setState(() {
        _isSubmit = false;
      });
      Navigator.pop(context, true);
    }).catchError((err) {
      // showInSnackBar("Something error please contact support");
      //
      // setState(() {
      //   _isSubmit = false;
      // });
    });
  }

  onSubmit() {
    if (_entityMode == EntityMode.New) {
      create();
    } else {
      update();
    }
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      key: _scaffoldKey,
      appBar: AppBarWidget(
        title: _entityMode == EntityMode.New ? "New Visit" : "Edit Visit",
        actions: [
          IconButton(
            onPressed: onSubmit,
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
                    FormListTile(
                      widget: Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            DropdownButtonWidget(
                              labelText: "Purpose",
                              value: widget.visit.visitPurpose,
                              items: _visitPurposes
                                  .map((VisitPurpose visitPurpose) {
                                return DropdownMenuItem(
                                  value: visitPurpose,
                                  child: Text(
                                    visitPurpose.name,
                                  ),
                                );
                              }).toList(),
                              onChanged: (VisitPurpose visitPurpose) {
                                setState(() {
                                  widget.visit.visitPurpose = visitPurpose;
                                  widget.visit.visitPurposeId = visitPurpose.id;
                                });
                              },
                            ),
                            DropdownButtonWidget(
                              labelText: "Status",
                              value: widget.visit.visitStatus,
                              items:
                                  _visitStatuses.map((VisitStatus visitStatus) {
                                return DropdownMenuItem(
                                  value: visitStatus,
                                  child: Text(
                                    visitStatus.name,
                                  ),
                                );
                              }).toList(),
                              onChanged: (VisitStatus visitStatus) {
                                setState(() {
                                  widget.visit.visitStatus = visitStatus;
                                  widget.visit.visitStatusId = visitStatus.id;
                                });
                              },
                            ),
                            DropdownButtonWidget(
                              labelText: "Result",
                              value: widget.visit.visitResult,
                              items:
                                  _visitResults.map((VisitResult visitResult) {
                                return DropdownMenuItem(
                                  value: visitResult,
                                  child: Text(
                                    visitResult.name,
                                  ),
                                );
                              }).toList(),
                              onChanged: (VisitResult visitResult) {
                                setState(() {
                                  widget.visit.visitResult = visitResult;
                                  widget.visit.visitResultId = visitResult.id;
                                });
                              },
                            ),
                            TextFieldWidget(
                              labelText: "Description",
                              initialValue: widget.visit.description,
                              maxLines: 8,
                              onChanged: (value) {
                                widget.visit.description = value;
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
