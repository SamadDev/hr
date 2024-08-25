import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef BoardWidgetBuilder = Widget Function(BuildContext context, int index);

class ListViewHelper extends StatelessWidget {
  ListViewHelper({
    Key key,
    this.list,
    this.onRefresh,
    this.itemBuilder,
    this.padding,
    this.separated,
    this.controller,
    this.physics,
  }) : super(key: key);
  List<dynamic> list;
  final RefreshCallback onRefresh;
  final BoardWidgetBuilder itemBuilder;
  final EdgeInsetsGeometry padding;
  final bool separated;
  ScrollController controller;
  ScrollPhysics physics;

  @override
  Widget build(BuildContext context) {
    return list == null
        ? Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          )
        : list.length == 0
            ? NoDataFound()
            : onRefresh == null
                ? ListView.separated(
                    controller: controller,
                    separatorBuilder: (context, index) => separated == true
                        ? Divider(
                            height: 0,
                          )
                        : SizedBox(
                            height: 0,
                            width: 0,
                          ),
                    shrinkWrap: true,
                    itemCount: list?.length,
                    itemBuilder: (context, index) {
                      return itemBuilder(context, index);
                    },
                  )
                : RefreshIndicator(
                    onRefresh: onRefresh,
                    child: ConstrainedBox(
                      constraints: new BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height,
                      ),
                      child: ListView.separated(
                        controller: controller,
                        physics: physics,
                        separatorBuilder: (context, index) => separated == true
                            ? Divider(
                                height: 0,
                              )
                            : SizedBox(
                                height: 0,
                                width: 0,
                              ),
                        shrinkWrap: true,
                        itemCount: list?.length,
                        itemBuilder: (context, index) {
                          return itemBuilder(context, index);
                        },
                      ),
                    ),
                  );
  }
}

class NoDataFound extends StatelessWidget {
  NoDataFound();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: SvgPicture.asset(
              "assets/svg/no_data.svg",
              color: Colors.grey,
              width: 300,
            ),
          ),
          Text(
            "no_data_found".tr(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
