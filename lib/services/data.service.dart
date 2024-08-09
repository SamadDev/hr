import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nandrlon/config/themes/light.theme.dart';

class DataService {
  static String basicUrl = "${box.read('api')}/api/";

  static Future get(api) async {

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Content-Language': box.read('languageCode'),
    };

    print("${box.read('api')}/api/${api}");

    final response = await http.get(
        Uri.parse(
          "${box.read('api')}/api/${api}",
        ),
        headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }

  static Future post(api, body) async {
    print("${box.read('api')}/api/${api}");
    final http.Response response = await http.post(
      Uri.parse("${box.read('api')}/api/${api}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Content-Language': box.read('languageCode'),
      },
      body: body != null ? json.encode(body) : body,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }

  static Future getFirst(api, body) async {
    final http.Response response = await http.post(
      Uri.parse("${box.read('api')}/api/${api}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Content-Language': box.read('languageCode'),
      },
      body: body != null ? json.encode(body) : body,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

  static Future postWithoutReturn(api, body) async {
    await http.post(
      Uri.parse("${box.read('api')}/api/${api}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Content-Language': box.read('languageCode'),
      },
      body: body != null ? json.encode(body) : body,
    );
  }
}
