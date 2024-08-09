import 'package:nandrlon/models/crm/contact/contact-result.dart';
import 'package:nandrlon/models/crm/contact/contact.dart';
import 'package:nandrlon/models/crm/shared/result.dart';
import 'package:nandrlon/services/crm.service.dart';

class ContactService {
  static String api = "/api/cim/customers/contacts";

  static Future<List<ContactResult>> getContacts(parameters) async {
    final result = await CRMDataService.get(api + parameters.toString());
    return ContactResult.toList(result);
  }

  static Future<Contact> getContact(int id) async {
    final result = await CRMDataService.get('$api/$id');
    return Contact.fromJson(result);
  }

  static Future<List<ContactResult>> getCustomerContacts(int customerId) async {

    final result = await CRMDataService.get('/api/cim/customers/$customerId/contacts/');
    return ContactResult.toList(result);
  }

  static Future<Result> create(Contact contact) async {
    return  await CRMDataService.post(api, contact);
  }

  static Future<Result> update(Contact contact) async {
    return  await CRMDataService.put("$api", contact);
  }
}
