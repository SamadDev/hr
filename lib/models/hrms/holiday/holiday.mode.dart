class Holiday {
  int id;
  String name;
  String fromDate;
  String toDate;
  int noOfDays;
  String description;
  int totalCount;

  Holiday(
      {this.id,
      this.name,
      this.fromDate,
      this.toDate,
      this.noOfDays,
      this.description,
      this.totalCount});

  Holiday.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    noOfDays = json['noOfDays'];
    description = json['description'];
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['noOfDays'] = this.noOfDays;
    data['description'] = this.description;
    data['totalCount'] = this.totalCount;
    return data;
  }
}
