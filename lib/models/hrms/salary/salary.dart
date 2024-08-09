class Salary {
  int id;
  String startDate;
  String endDate;
  int employeeId;
  String employeeName;
  String employeeNameKu;
  String image;
  String month;
  int year;
  String branch;
  String department;
  String jobTitle;
  String jobPosition;
  String employmentStatus;
  String employmentStatusColor;
  String employmentType;
  double target;
  double sale;
  double netSalary;
  double basicSalary;
  double totalEarnings;
  double totalDeductions;
  double totalSalary;
  String currency;
  String status;
  String statusClass;
  int totalCount;
  bool checked;

  Salary(
      {this.id,
      this.startDate,
      this.endDate,
      this.employeeId,
      this.employeeName,
      this.employeeNameKu,
      this.image,
      this.month,
      this.year,
      this.branch,
      this.department,
      this.jobTitle,
      this.jobPosition,
      this.employmentStatus,
      this.employmentStatusColor,
      this.employmentType,
      this.target,
      this.sale,
      this.netSalary,
      this.basicSalary,
      this.totalEarnings,
      this.totalDeductions,
      this.totalSalary,
      this.currency,
      this.status,
      this.statusClass,
      this.totalCount,
      this.checked});

  Salary.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    employeeId = json['employeeId'];
    employeeName = json['employeeName'];
    employeeNameKu = json['employeeNameKu'];
    image = json['image'];
    month = json['month'];
    year = json['year'];
    branch = json['branch'];
    department = json['department'];
    jobTitle = json['jobTitle'];
    jobPosition = json['jobPosition'];
    employmentStatus = json['employmentStatus'];
    employmentStatusColor = json['employmentStatusColor'];
    employmentType = json['employmentType'];
    target = json['target'];
    sale = json['sale'];
    netSalary = json['netSalary'];
    basicSalary = json['basicSalary'];
    totalEarnings = json['totalEarnings'];
    totalDeductions = json['totalDeductions'];
    totalSalary = json['totalSalary'];
    currency = json['currency'];
    status = json['status'];
    statusClass = json['statusClass'];
    totalCount = json['totalCount'];
    checked = json['checked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['employeeId'] = this.employeeId;
    data['employeeName'] = this.employeeName;
    data['employeeNameKu'] = this.employeeNameKu;
    data['image'] = this.image;
    data['year'] = this.year;
    data['month'] = this.month;
    data['branch'] = this.branch;
    data['department'] = this.department;
    data['jobTitle'] = this.jobTitle;
    data['jobPosition'] = this.jobPosition;
    data['employmentStatus'] = this.employmentStatus;
    data['employmentStatusColor'] = this.employmentStatusColor;
    data['employmentType'] = this.employmentType;
    data['target'] = this.target;
    data['sale'] = this.sale;
    data['netSalary'] = this.netSalary;
    data['basicSalary'] = this.basicSalary;
    data['totalEarnings'] = this.totalEarnings;
    data['totalDeductions'] = this.totalDeductions;
    data['totalSalary'] = this.totalSalary;
    data['currency'] = this.currency;
    data['status'] = this.status;
    data['statusClass'] = this.statusClass;
    data['totalCount'] = this.totalCount;
    data['checked'] = this.checked;
    return data;
  }
}
