import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nandrlon/models/crm/shared/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CRMDataService {
  static String basicUrl = "https://crm-api.dottech.co";

  static Future<dynamic> get(api) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var crmToken = prefs.getString("crmToken");

    
    

    var header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $crmToken',
    };

    final response = await http.get(Uri.parse(basicUrl + api), headers: header);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }

  static Future<Result> getResult(api) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var crmToken = prefs.getString("crmToken");
    var header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $crmToken',
    };

    final response = await http.get(Uri.parse(basicUrl + api), headers: header);
    
    
    if (response.statusCode == 200) {
      return Result.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load');
    }
  }

  static Future<Result> post(api, body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var crmToken = prefs.getString("crmToken");

    final http.Response response = await http.post(
      Uri.parse(basicUrl + api),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $crmToken',
      },
      body: body != null ? json.encode(body) : body,
    );

    if (response.statusCode == 200) {
      return Result.fromJson(json.decode(response.body));
    } else {
      return Future.error(
          "This is the error", StackTrace.fromString("This is its trace"));
    }
  }

  static Future<Result> put(api, body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var crmToken = prefs.getString("crmToken");

    final http.Response response = await http.put(
      Uri.parse(basicUrl + api),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $crmToken',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return Result.fromJson(json.decode(response.body));
    } else {
      return Future.error(
          "This is the error", StackTrace.fromString("This is its trace"));
    }
  }

  static Future<Result> delete(api) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var crmToken = prefs.getString("crmToken");

    final http.Response response = await http.delete(
      Uri.parse(basicUrl + api),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $crmToken',
      },
    );

    if (response.statusCode == 200) {
      return Result.fromJson(json.decode(response.body));
    } else {
      return Future.error(
          "This is the error", StackTrace.fromString("This is its trace"));
    }
  }

  static Future getFirst(api, body) async {
    final http.Response response = await http.post(
      Uri.parse(basicUrl + api),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
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
      Uri.parse(basicUrl + api),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body != null ? json.encode(body) : body,
    );
  }
}
