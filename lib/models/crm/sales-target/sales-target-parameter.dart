import 'package:nandrlon/models/crm/customer/customer.dart';
import 'package:nandrlon/models/crm/shared/city.dart';
import 'package:nandrlon/models/crm/shared/district.dart';

class SalesTargetParameters {
  String searchText;
  int customerId;
  int customerGroupId;
  int genderId;
  int spokenLanguageId;
  int cityId;
  int districtId;
  String sortColumn;
  String sortDirection;
  String pageNumber;
  String pageSize;
  Customer customer;
  City city;
  District district;

  SalesTargetParameters({
    this.searchText,
    this.customerId,
    this.customerGroupId,
    this.genderId,
    this.spokenLanguageId,
    this.cityId,
    this.sortColumn,
    this.sortDirection,
    this.pageNumber,
    this.pageSize,
  });

  SalesTargetParameters.fromJson(Map<String, dynamic> json) {
    searchText = json['searchText'];
    customerId = json['customerId'];
    customerGroupId = json['customerGroupId'];
    genderId = json['genderId'];
    spokenLanguageId = json['spokenLanguageId'];
    cityId = json['cityId'];
    sortColumn = json['sortColumn'];
    sortDirection = json['sortDirection'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['searchText'] = this.searchText;
    data['customerId'] = this.customerId;
    data['customerGroupId'] = this.customerGroupId;
    data['genderId'] = this.genderId;
    data['spokenLanguageId'] = this.spokenLanguageId;
    data['cityId'] = this.cityId;
    data['sortColumn'] = this.sortColumn;
    data['sortDirection'] = this.sortDirection;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    return data;
  }

  String toString() {
    return '?SearchText=${this.searchText ?? ""}&CustomerId=${this.customerId ?? 0}&CustomerGroupId=${this.customerGroupId ?? 0}&GenderId=${this.genderId ?? 0}&SpokenLanguageId=${this.spokenLanguageId ?? 0}&CityId=${this.cityId ?? 0}&SortColumn=${this.sortColumn ?? "Id"}&SortDirection=${this.sortDirection ?? "Desc"}&PageNumber=${this.pageNumber ?? 1}&PageSize=${this.pageSize ?? 25}';
  }

}
