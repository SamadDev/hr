class UndeliveredSalesItem {
  int id;
  int itemId;
  String itemName;
  String groupName;
  double quantity;

  UndeliveredSalesItem(
      {this.id, this.itemId, this.itemName, this.groupName, this.quantity});

  UndeliveredSalesItem.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    itemId = json['ItemId'];
    itemName = json['ItemName'];
    groupName = json['GroupName'];
    quantity = json['Quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['ItemId'] = this.itemId;
    data['ItemName'] = this.itemName;
    data['GroupName'] = this.groupName;
    data['Quantity'] = this.quantity;
    return data;
  }

  static List<UndeliveredSalesItem> toList(parsed) {
    return parsed
        .map<UndeliveredSalesItem>(
            (json) => UndeliveredSalesItem.fromJson(json))
        .toList();
  }
}
