import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:nandrlon/models/note.model.dart';

class NoteService {
  static Future<List<Note>> getAll() async {
    final String response =
        await rootBundle.loadString('assets/json/note.json');
    final data = await json.decode(response);

    return data.map<Note>((json) => Note.fromJson(json)).toList();
  }
}
