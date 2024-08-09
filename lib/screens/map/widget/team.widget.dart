import 'package:flutter/material.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/models/team.model.dart';
import 'package:nandrlon/widgets/image.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapTeamWidget extends StatelessWidget {
  MapTeamWidget({
    Key key,
    this.teams,
    this.onChanged,
  }) : super(key: key);

  final List<Team> teams;
  final ValueChanged<Team> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 90,
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff4F62C0).withOpacity(0.15),
                  spreadRadius: 0,
                  blurRadius: 20,
                  offset: Offset(0, 10), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: teams == null ? 0 : teams.length,
              itemBuilder: (context, index) {
                return TeamButton(
                  team: teams[index],
                  onTap: () {
                    return onChanged(teams[index]);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class TeamButton extends StatelessWidget {
  TeamButton({
    Key key,
    this.onTap,
    this.team,
    this.onChanged,
  }) : super(key: key);

  final Team team;
  final GestureTapCallback onTap;
  final ValueChanged<Team> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageWidget(
                width: 45,
                height: 45,
                imageUrl:
                    "${box.read('api')}/Uploads/HRMS/Employees/${team.employeeImage}",
                errorText: this.team.employeeName[0],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                this.team.employeeName.split(" ")[0],
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xff3A3A3A),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
