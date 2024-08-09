import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nandrlon/config/const.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/helper/text.helper.dart';
import 'package:nandrlon/models/dashboard.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:easy_localization/easy_localization.dart';

class OverviewWidget extends StatelessWidget {
  OverviewWidget({
    Key key,
    this.dashboard,
  }) : super(key: key);
  Dashboard dashboard;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "overview".tr(),
            style: TextStyle(
              fontSize: context.locale.languageCode == "en" ? 17 : 15,
              fontWeight: FontWeight.w600,
              fontFamily: getFontFamily(context),
              color: Color(
                0xff29304D,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                OverviewWidgetButton(
                      title: "leave",
                      percentageText: NumberFormat('#,###', 'en_Us').format(dashboard?.balanceRate * 100),
                      subTitle: dashboard?.balance.toString(),
                      percentage: dashboard?.balanceRate,
                      isPrimary: true,
                    ),
             OverviewWidgetButton(
                title: "attendance",
                percentageText: NumberFormat('#,###', 'en_Us').format(dashboard?.workingRate * 100),
                subTitle: dashboard?.checkIn.toString(),
                percentage: dashboard?.workingRate,
                isPrimary: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OverviewWidgetButton extends StatelessWidget {
  OverviewWidgetButton({
    Key key,
    this.title,
    this.subTitle,
    this.percentageText,
    this.isPrimary,
    this.percentage,
  }) : super(key: key);

  final String title;
  final String percentageText;
  final String subTitle;
  final double percentage;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: (width / 2) - 25,
      height: 100,
      decoration: BoxDecoration(
        color: isPrimary ? Theme.of(context).primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.15),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 10), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: new CircularPercentIndicator(
                radius: 55.0,
                lineWidth: 4.0,
                percent: percentage,
                backgroundColor: isPrimary
                    ? Colors.white.withOpacity(0.2)
                    : Color(0xffD8D8D8),
                center: new Text(
                  (percentageText).toString() + "%",
                  style: TextStyle(
                      fontSize: 13,
                      color: isPrimary
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                progressColor: isPrimary
                    ? Color(0xffA5E8F0)
                    : Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.tr(),
                  style: TextStyle(
                    color: !isPrimary
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: context.locale.languageCode == "en" ? 13 : 12,
                    fontFamily: getFontFamily(context),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  subTitle,
                  style: TextStyle(
                    color: !isPrimary
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
