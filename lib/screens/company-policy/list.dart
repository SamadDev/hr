import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/models/hrms/company-policy/company-policy-parametres.dart';
import 'package:nandrlon/models/hrms/company-policy/company-policy.mode.dart';
import 'package:nandrlon/screens/company-policy/detail.dart';
import 'package:nandrlon/services/customer.service.dart';
import 'package:nandrlon/services/team.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/list.widget.dart';

class CompanyPolicyScreen extends StatefulWidget {
  CompanyPolicyScreen({
    Key key,
  }) : super(key: key);

  @override
  _CompanyPolicyScreenState createState() => _CompanyPolicyScreenState();
}

class _CompanyPolicyScreenState extends State<CompanyPolicyScreen> {
  var searchController = TextEditingController();
  String searchQuery = "Search query";
  CompanyPolicyParameters _companyPolicyParameters;
  List<CompanyPolicy> _companyPolicies;
  bool _isSearching = false;
  Timer _debounce;

  @override
  void initState() {
    _companyPolicyParameters = new CompanyPolicyParameters();

    super.initState();
    onLoad();
  }

  @override
  void dispose() {
    super.dispose();
  }

  onLoad() async {
    var result = await TeamService.getCompanyPolicies(_companyPolicyParameters);

    
    

    var companyPolicies = result['companyPolicies']
        .map<CompanyPolicy>((json) => CompanyPolicy.fromJson(json))
        .toList();

    setState(() {
      _companyPolicies = companyPolicies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "policies".tr(),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15),
        child: ListViewHelper(
          list: _companyPolicies,
          onRefresh: () => onLoad(),
          itemBuilder: (context, index) {
            return CompanyPolicyTile(
              companyPolicy: _companyPolicies[index],
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompanyPolicyDetailScreen(
                      companyPolicy: _companyPolicies[index],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class CompanyPolicyTile extends StatelessWidget {
  CompanyPolicyTile({
    Key key,
    this.companyPolicy,
    this.onTap,
  }) : super(key: key);

  final CompanyPolicy companyPolicy;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        onTap: onTap,
        title: Container(
          width: MediaQuery.of(context).size.width - 100,
          child: Text(
            companyPolicy.title,
            style: TextStyle(
              fontFamily: getFontFamily(context),
              fontWeight: FontWeight.bold,
              fontSize: context.locale.languageCode == "en"
                  ? 16 : 14,
            ),
          ),
        ),
        subtitle: Container(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                companyPolicy.summary,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: getFontFamily(context),
                  color: Colors.grey,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                companyPolicy.lastRevision == null ? "" : companyPolicy.lastRevision.substring(0, 10) ?? "",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
