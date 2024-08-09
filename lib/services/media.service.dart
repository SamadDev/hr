import 'package:nandrlon/models/crm/media/media-file.dart';
import 'package:nandrlon/models/crm/media/media.dart';
import 'package:nandrlon/services/crm.service.dart';

class MediaService {
  static String api = "/api/crm/media";

  static Future<List<Media>> getMedia() async {
    final result = await CRMDataService.get(api);
    return Media.toList(result);
  }

  static Future<List<MediaFile>> getMediaFiles(int id) async {
    final result = await CRMDataService.get("$api/$id/files");
    return MediaFile.toList(result);
  }
}
