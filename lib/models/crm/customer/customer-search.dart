import 'package:nandrlon/models/crm/customer/customer-group.dart';
import 'package:nandrlon/models/crm/customer/customer-status.dart';
import 'package:nandrlon/models/crm/shared/city.dart';
import 'package:nandrlon/models/crm/shared/district.dart';
import 'package:nandrlon/models/crm/shared/source.dart';

class CustomerParameters {
  String searchText;
  int customerGroupId;
  int customerStatusId;
  int sourceId;
  int cityId;
  int districtId;
  String sortColumn;
  String sortDirection;
  String pageNumber;
  String pageSize;
  City city;
  District district;
  CustomerGroup customerGroup;
  CustomerStatus customerStatus;
  Source source;

  CustomerParameters(
      {this.searchText,
      this.customerGroupId,
      this.customerStatusId,
      this.sourceId,
      this.cityId,
      this.districtId,
      this.sortColumn,
      this.sortDirection,
      this.pageNumber,
      this.pageSize});

  CustomerParameters.fromJson(Map<String, dynamic> json) {
    searchText = json['searchText'];
    customerGroupId = json['customerGroupId'];
    customerStatusId = json['customerStatusId'];
    sourceId = json['sourceId'];
    cityId = json['cityId'];
    sortColumn = json['sortColumn'];
    sortDirection = json['sortDirection'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['searchText'] = this.searchText;
    data['customerGroupId'] = this.customerGroupId;
    data['customerStatusId'] = this.customerStatusId;
    data['sourceId'] = this.sourceId;
    data['cityId'] = this.cityId;
    data['sortColumn'] = this.sortColumn;
    data['sortDirection'] = this.sortDirection;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    return data;
  }

  String toString() {
    return '?SearchText=${this.searchText ?? ""}&CustomerGroupId=${this.customerGroupId ?? 0}&CustomerStatusId=${this.customerStatusId ?? 0}&SourceId=${this.sourceId ?? 0}&DistrictId=${this.districtId ?? 0}&CityId=${this.cityId ?? 0}&SortColumn=${this.sortColumn ?? "Id"}&SortDirection=${this.sortDirection ?? "Desc"}&PageNumber=${this.pageNumber ?? 1}&PageSize=${this.pageSize ?? 25}';
  }
}
