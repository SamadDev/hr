import 'package:flutter/material.dart';
import 'package:nandrlon/models/crm/customer/customer-result.dart';
import 'package:nandrlon/models/crm/survey/survey.dart';
import 'package:nandrlon/services/survey.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/dropdown.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/loading.widget.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';

class QuestionsScreen extends StatefulWidget {
  QuestionsScreen({
    Key key,
    this.customer,
    this.survey,
  }) : super(key: key);
  CustomerResult customer;
  Survey survey;

  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  Survey _survey;
  bool _isLoading = true;

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
    var survey = await SurveyService.getSurvey(widget.survey.id);

    setState(() {
      _survey = survey;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: widget.survey.name,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.check,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? LoadingWidget()
          : Container(
              margin: EdgeInsets.only(top: 15),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _survey.questions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _survey.questions[index].surveyQuestionTypeId == 3
                        ? QuestionTile(
                            title: _survey.questions[index].title,
                            collapsed: _survey.questions[index].collapsed,
                            helpText: _survey.questions[index].helpText,
                            onTap: () {
                              setState(() {
                                _survey.questions[index].collapsed =
                                    _survey.questions[index].collapsed == null
                                        ? true
                                        : !_survey.questions[index].collapsed;
                              });
                            },
                            child: TextFieldWidget(),
                          )
                        : _survey.questions[index].surveyQuestionTypeId == 15
                            ? QuestionTile(
                                title: _survey.questions[index].title,
                                collapsed: _survey.questions[index].collapsed,
                                helpText: _survey.questions[index].helpText,
                                onTap: () {
                                  setState(() {
                                    _survey.questions[index].collapsed = _survey
                                                .questions[index].collapsed ==
                                            null
                                        ? true
                                        : !_survey.questions[index].collapsed;
                                  });
                                },
                                child: DropdownButtonWidget(
                                  items: _survey.questions[index].values
                                      .map((Values values) {
                                    return DropdownMenuItem(
                                      value: values,
                                      child: Text(
                                        values.value,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (Values values) {},
                                ),
                              )
                            : _survey.questions[index].surveyQuestionTypeId == 5
                                ? QuestionTile(
                                    title: _survey.questions[index].title,
                                    collapsed:
                                        _survey.questions[index].collapsed,
                                    helpText: _survey.questions[index].helpText,
                                    onTap: () {
                                      setState(() {
                                        _survey.questions[index].collapsed =
                                            _survey.questions[index]
                                                        .collapsed ==
                                                    null
                                                ? true
                                                : !_survey
                                                    .questions[index].collapsed;
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: _survey
                                              .questions[index].values.length,
                                          itemBuilder:
                                              (context, indexQuestion) {
                                            return RadioListTile(
                                              value: index,
                                              groupValue: "value",
                                              onChanged: (value) {},
                                              title: Text(
                                                _survey
                                                    .questions[index]
                                                    .values[indexQuestion]
                                                    .value,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                : _survey.questions[index]
                                            .surveyQuestionTypeId ==
                                        2
                                    ? QuestionTile(
                                        title: _survey.questions[index].title,
                                        collapsed:
                                            _survey.questions[index].collapsed,
                                        helpText:
                                            _survey.questions[index].helpText,
                                        onTap: () {
                                          setState(() {
                                            _survey.questions[index].collapsed =
                                                _survey.questions[index]
                                                            .collapsed ==
                                                        null
                                                    ? true
                                                    : !_survey.questions[index]
                                                        .collapsed;
                                          });
                                        },
                                        child: TextFieldWidget(
                                          maxLines: 5,
                                          onChanged: (value) {},
                                        ),
                                      )
                                    : Container();
                  }),
            ),
    );
  }
}

class QuestionTile extends StatelessWidget {
  QuestionTile({
    Key key,
    this.child,
    this.title,
    this.helpText,
    this.collapsed,
    this.onTap,
  }) : super(key: key);
  final Widget child;
  final String title;
  final String helpText;
  final bool collapsed;
  GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
      padding: EdgeInsets.fromLTRB(15, 15, 15, collapsed == true ? 15 : 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onTap,
                child: Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Icon(
                      collapsed == true
                          ? Icons.keyboard_arrow_right
                          : Icons.keyboard_arrow_down,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: MediaQuery.of(context).size.width - 90,
                  child: Text(
                    title ?? "",
                    style: TextStyle(
                      color: Color(0xff29304D),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
          collapsed == true ? Container() : child,
          collapsed == true || helpText == null
              ? Container()
              : Text(
                  helpText ?? "",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
        ],
      ),
    );
  }
}
