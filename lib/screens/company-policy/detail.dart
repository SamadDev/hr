import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/models/hrms/company-policy/company-policy.mode.dart';
import 'package:nandrlon/services/team.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/card.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:nandrlon/widgets/loading.widget.dart';

class CompanyPolicyDetailScreen extends StatefulWidget {
  CompanyPolicyDetailScreen({
    Key key,
    this.companyPolicy,
    this.id,
  }) : super(key: key);
  CompanyPolicy companyPolicy;
  int id;

  @override
  _CompanyPolicyDetailScreenState createState() =>
      _CompanyPolicyDetailScreenState();
}

class _CompanyPolicyDetailScreenState extends State<CompanyPolicyDetailScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onLoad();
  }

  onLoad() async {
    var result = await TeamService.getCompanyPolicy(widget.id);

    
    

    var companyPolicy = CompanyPolicy.fromJson(result);

    setState(() {
      widget.companyPolicy = companyPolicy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: widget.companyPolicy == null ?  "" : widget.companyPolicy.title,
      ),
      body: widget.companyPolicy == null ? LoadingWidget() : SafeArea(
        child: SingleChildScrollView(
          child: CompanyPolicyTile(
            companyPolicy: widget.companyPolicy,
          ),
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
      margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(5),
      // ),
      child: Column(

        children: [
          Text(
            companyPolicy.title,
            style: TextStyle(
              fontFamily: getFontFamily(context),
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          Text(
            companyPolicy.lastRevision.substring(0, 10) ?? "",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          Html(
            data: companyPolicy.detail,

          ),
        ],
      ),

      // ListTile(
      //   onTap: onTap,
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Text(
      //         companyPolicy.title,
      //         style: TextStyle(
      //           fontWeight: FontWeight.bold,
      //           fontSize: 17,
      //         ),
      //       ),
      //       Text(
      //         companyPolicy.lastRevision.substring(0, 10) ?? "",
      //         style: TextStyle(
      //           fontSize: 13,
      //           color: Colors.grey,
      //         ),
      //       ),
      //     ],
      //   ),
      //   subtitle: Container(
      //     height: 30,
      //     margin: EdgeInsets.only(top: 30),
      //     child: Text(
      //       companyPolicy.detail,
      //       style: TextStyle(
      //         fontSize: 13,
      //         color: Colors.grey,
      //         overflow: TextOverflow.ellipsis,
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
