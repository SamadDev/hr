import 'package:flutter/material.dart';
import 'package:nandrlon/models/crm/customer/customer-result.dart';
import 'package:nandrlon/models/crm/survey/survey.dart';
import 'package:nandrlon/screens/survey/questions.dart';
import 'package:nandrlon/services/survey.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';

class SurveysScreen extends StatefulWidget {
  SurveysScreen({
    Key key,
    this.customer,
    this.isReadOnly,
  }) : super(key: key);

  CustomerResult customer;
  bool isReadOnly;

  @override
  _SurveysScreenState createState() => _SurveysScreenState();
}

class _SurveysScreenState extends State<SurveysScreen> {
  List<Survey> _surveys;

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
    var surveys = await SurveyService.getSurveys();

    setState(() {
      _surveys = surveys;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "Surveys",
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: ListViewHelper(
          list: _surveys,
          onRefresh: () => onLoad(),
          itemBuilder: (context, index) {
            return SurveyListTile(
              survey: _surveys[index],
              onTap: () async {
                var note = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionsScreen(
                      customer: widget.customer,
                      survey: _surveys[index],
                    ),
                  ),
                );
                if (note != null) {
                  onLoad();
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class SurveyListTile extends StatelessWidget {
  SurveyListTile({
    Key key,
    this.survey,
    this.onTap,
  }) : super(key: key);

  final Survey survey;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          survey.name,
        ),
        subtitle: survey.description == null
            ? null
            : Text(
                survey.description ?? "",
              ),
        trailing: survey.noOfQuestions == null
            ? null
            : Text(
                survey.noOfQuestions.toString(),
              ),
      ),
    );
  }
}
