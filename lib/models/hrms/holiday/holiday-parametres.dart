class HolidayParameters {
  int pageNumber;
  int pageSize;
  String name;
  String startDate;
  String endDate;

  HolidayParameters({
    this.pageNumber = 1,
    this.pageSize = 25,
    this.name,
    this.startDate,
    this.endDate,
  });

  HolidayParameters.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    name = json['name'];
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['name'] = this.name;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    return data;
  }
}
