import 'package:nandrlon/models/crm/customer/customer-group.dart';
import 'package:nandrlon/models/crm/customer/customer-note-category.dart';
import 'package:nandrlon/models/crm/customer/customer-note.dart';
import 'package:nandrlon/models/crm/customer/customer-result.dart';
import 'package:nandrlon/models/crm/customer/customer-status.dart';
import 'package:nandrlon/models/crm/customer/customer.dart';
import 'package:nandrlon/models/crm/shared/result.dart';
import 'package:nandrlon/services/crm.service.dart';

class CustomerService {
  static String api = "/api/cim/customers";

  static Future<List<CustomerResult>> customers(search) async {
    final result = await CRMDataService.get(api + search.toString());
    return CustomerResult.toList(result);
  }

  static Future<List<Customer>> filter(search) async {
    final result = await CRMDataService.get("$api/filter?filter=$search");
    return Customer.toList(result);
  }

  static Future<List<CustomerGroup>> customerGroups() async {
    final result = await CRMDataService.get("/api/cim/customer-groups");
    return CustomerGroup.toList(result);
  }
  static Future<List<CustomerNoteCategory>> customerNoteCategories() async {
    final result = await CRMDataService.get("/api/cim/customer-notes/categories");
    return CustomerNoteCategory.toList(result);
  }

  static Future<List<CustomerStatus>> customerStatuses() async {
    final result = await CRMDataService.get("/api/cim/customer-statuses");
    return CustomerStatus.toList(result);
  }

  static Future<List<CustomerNote>> getNotes(search) async {
    final result = await CRMDataService.get("$api/notes" + search.toString());
    return CustomerNote.toList(result);
  }

  static Future<CustomerNote> createCustomerNote(CustomerNote customerNote) async {
    final result = await CRMDataService.post("$api/notes", customerNote);
    return CustomerNote.fromJson(result.data);
  }

  static Future<CustomerNote> updateCustomerNote(CustomerNote customerNote) async {
    final result = await CRMDataService.put("$api/notes", customerNote);
    return CustomerNote.fromJson(result.data);
  }

  static Future<void> deleteCustomerNote(CustomerNote customerNote) async {
    return await CRMDataService.delete("$api/notes/${customerNote.id}");
  }


  static Future<Customer> getCustomer(int id) async {
    final result = await CRMDataService.get('$api/$id');
    return Customer.fromJson(result);
  }

  static Future<Result> create(Customer customer) async {
    return await CRMDataService.post(api, customer);
  }

  static Future<Result> update(Customer customer) async {
    return await CRMDataService.put("$api", customer);
  }

}
