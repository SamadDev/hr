class SalesTarget {
  int id;
  String name;
  String fromDate;
  String toDate;
  int noOfItems;
  double targetPercent;

  SalesTarget({
    this.id,
    this.name,
    this.fromDate,
    this.toDate,
    this.targetPercent,
  });

  SalesTarget.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    noOfItems = json['noOfItems'];
    targetPercent = json['targetPercent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['noOfItems'] = this.noOfItems;
    data['targetPercent'] = this.targetPercent;
    return data;
  }

  static List<SalesTarget> toList(parsed) {
    return parsed
        .map<SalesTarget>((json) => SalesTarget.fromJson(json))
        .toList();
  }
}
