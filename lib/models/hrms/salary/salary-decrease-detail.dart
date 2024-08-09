class SalaryDecreaseDetail {
  String salaryDecreaseType;
  double rate;
  double amount;
  String description;

  SalaryDecreaseDetail(
      {this.salaryDecreaseType, this.rate, this.amount, this.description});

  SalaryDecreaseDetail.fromJson(Map<String, dynamic> json) {
    salaryDecreaseType = json['salaryDecreaseType'];
    rate = json['rate'];
    amount = json['amount'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['salaryDecreaseType'] = this.salaryDecreaseType;
    data['rate'] = this.rate;
    data['amount'] = this.amount;
    data['description'] = this.description;
    return data;
  }
}
