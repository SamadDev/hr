
import 'package:nandrlon/models/crm/delivery-note/delivery-note-result.dart';
import 'package:nandrlon/models/crm/delivery-note/delivery-note.dart';
import 'package:nandrlon/models/crm/shared/result.dart';
import 'package:nandrlon/services/crm.service.dart';
class DeliveryNoteService {
  static String api = "/api/wms/delivery-notes";

  static Future<List<DeliveryNoteResult>> getDeliveryNotes(search) async {
    final result = await CRMDataService.get(api + search.toString());
    return DeliveryNoteResult.toList(result);
  }

  static Future<DeliveryNote> get(int id) async {
    final result = await CRMDataService.get('$api/$id');
    return DeliveryNote.fromJson(result);
  }

  static Future<Result> create(DeliveryNote deliveryNote) async {
    return await CRMDataService.post(api, deliveryNote);
  }

  static Future<Result> update(DeliveryNote deliveryNote) async {
    return await CRMDataService.put("$api", deliveryNote);
  }

}
