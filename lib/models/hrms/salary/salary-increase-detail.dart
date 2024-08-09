class SalaryIncreaseDetail {
  String salaryIncreaseType;
  double rate;
  double amount;
  String description;

  SalaryIncreaseDetail(
      {this.salaryIncreaseType, this.rate, this.amount, this.description});

  SalaryIncreaseDetail.fromJson(Map<String, dynamic> json) {
    salaryIncreaseType = json['salaryIncreaseType'];
    rate = json['rate'];
    amount = json['amount'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['salaryIncreaseType'] = this.salaryIncreaseType;
    data['rate'] = this.rate;
    data['amount'] = this.amount;
    data['description'] = this.description;
    return data;
  }
}
