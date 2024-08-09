import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MapCustomerSearchScreen extends SearchDelegate<dynamic>  {
  Future serachdb() async {
    final String response =
        await rootBundle.loadString('assets/json/customer.json');
    final data = await json.decode(response);

    if (query.isEmpty) return data;
    if (query.isNotEmpty)
      return data
          .where(
              (d) => d['first_name'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    return Center(
      child: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {


    return FutureBuilder(
      future: serachdb(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {

          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return EmployeeListTile(
                customer: snapshot.data[index],
                onTap: () => Navigator.pop(context, snapshot.data[index]),
              );
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}


class EmployeeListTile extends StatelessWidget {
  EmployeeListTile({
    Key key,
    this.customer,
    this.onTap,
  }) : super(key: key);

  final dynamic customer;
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
                  height: 45,
                  width: 45,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0x80839daf),
                  ),
                  child: Center(
                    child: Text(
                      customer['first_name'][0].toString().toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${customer['first_name']} ${customer['last_name']}",
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
                      customer['group'] ?? "",
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

