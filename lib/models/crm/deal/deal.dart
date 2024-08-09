import 'package:nandrlon/models/crm/contact/contact-result.dart';
import 'package:nandrlon/models/crm/deal/stage.dart';

class Deal {
  int id;
  int dealTypeId;
  String name;
  String date;
  String closingDate;
  int customerId;
  int currencyId;
  int customerContactId;
  ContactResult customerContact;
  Stage stage;
  int stageId;
  double amount;
  String description;

  Deal(
      {this.id,
        this.dealTypeId,
        this.name,
        this.date,
        this.closingDate,
        this.customerId,
        this.currencyId,
        this.customerContactId,
        this.customerContact,
        this.stage,
        this.stageId,
        this.amount,
        this.description,
      });

  Deal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dealTypeId = json['dealTypeId'];
    name = json['name'];
    date = json['date'];
    closingDate = json['closingDate'];
    customerId = json['customerId'];
    currencyId = json['currencyId'];
    customerContactId = json['customerContactId'];
    stageId = json['stageId'];
    amount = json['amount'] = 0.0;
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dealTypeId'] = this.dealTypeId;
    data['name'] = this.name;
    data['date'] = this.date;
    data['closingDate'] = this.closingDate;
    data['customerId'] = this.customerId;
    data['currencyId'] = this.currencyId;
    data['customerContactId'] = this.customerContactId;
    data['stageId'] = this.stageId;
    data['amount'] = this.amount;
    data['description'] = this.description;
    return data;
  }
}
