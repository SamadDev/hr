import 'package:nandrlon/models/crm/sales-target/sales-target-item.dart';

class SalesTargetItemResult extends SalesTargetItem {
  String itemName;
  String groupName;
  double soldQuantity;
  double targetPercent;

  SalesTargetItemResult({
    this.itemName,
    this.groupName,
    this.soldQuantity,
    this.targetPercent,
  });

  SalesTargetItemResult.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    itemName = json['itemName'];
    groupName = json['groupName'];
    soldQuantity = json['soldQuantity'];
    targetPercent = json['targetPercent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemName'] = this.itemName;
    data['groupName'] = this.groupName;
    data['soldQuantity'] = this.soldQuantity;
    data['targetPercent'] = this.targetPercent;

    return data;
  }

  static List<SalesTargetItemResult> toList(parsed) {
    return parsed
        .map<SalesTargetItemResult>(
            (json) => SalesTargetItemResult.fromJson(json))
        .toList();
  }
}
