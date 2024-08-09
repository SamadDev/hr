class Dashboard {
  String checkIn;
  String checkOut;
  String leave;
  double balance;
  double openBalance;
  double balanceRate;
  String workingHours;
  double totalWorkingHours;
  double workingRate;

  Dashboard(
      {this.checkIn,
        this.checkOut,
        this.leave,
        this.balance,
        this.openBalance,
        this.balanceRate,
        this.workingHours,
        this.totalWorkingHours,
        this.workingRate});

  Dashboard.fromJson(Map<String, dynamic> json) {
    checkIn = json['checkIn'];
    checkOut = json['checkOut'];
    leave = json['leave'];
    balance = json['balance'];
    openBalance = json['openBalance'];
    balanceRate = json['balanceRate'];
    workingHours = json['workingHours'];
    totalWorkingHours = json['totalWorkingHours'];
    workingRate = json['workingRate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['checkIn'] = this.checkIn;
    data['checkOut'] = this.checkOut;
    data['leave'] = this.leave;
    data['balance'] = this.balance;
    data['openBalance'] = this.openBalance;
    data['balanceRate'] = this.balanceRate;
    data['workingHours'] = this.workingHours;
    data['totalWorkingHours'] = this.totalWorkingHours;
    data['workingRate'] = this.workingRate;
    return data;
  }
}
