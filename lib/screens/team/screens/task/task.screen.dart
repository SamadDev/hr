import 'package:flutter/material.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';

class TeamTaskScreen extends StatefulWidget {
  const TeamTaskScreen();

  @override
  _TeamTaskScreenState createState() => _TeamTaskScreenState();
}

class _TeamTaskScreenState extends State<TeamTaskScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "Tasks",
      ),
      body: Center(
        child: Text("No Data Found"),
      ),
    );
  }
}
