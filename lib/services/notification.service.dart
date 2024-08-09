import 'package:nandrlon/models/crm/shared/result.dart';
import 'package:nandrlon/models/hrms/leave/leave-result.model.dart';
import 'package:nandrlon/models/hrms/leave/leave.mode.dart';
import 'package:nandrlon/models/notification.dart';

import 'data.service.dart';

class NotificationService {


  static Future<List<Notification>> getAll(userId, pageNumber) async {
    var result =
        await DataService.get('App/Notifications/GetNotifications/$userId/$pageNumber');
    return result
        .map<Notification>((json) => Notification.fromJson(json))
        .toList();
  }

  static Future UpdateSeen(id) async {
    return await DataService.get('App/Notifications/UpdateSeen/$id');
  }
}
