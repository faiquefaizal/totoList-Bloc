// lib/services/api_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:todolist/models/notes_model.dart';

class ApiService {
  static const String baseUrl = "https://api.nstack.in/v1/todos";

  Future<List<NotesModel>> fetchNotes() async {
    final response = await http.get(Uri.parse("$baseUrl?page=1&limit=10"));
    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      final results = jsonMap["items"] as List;
      return results.map((result) => NotesModel.fromJson(result)).toList();
    } else {
      throw Exception("Failed to load notes");
    }
  }

  Future<void> addNote(String title, String description) async {
    final data = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    final response = await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 201) {
      throw Exception("Failed to add note");
    }
  }

  Future<void> deleteNote(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete note");
    }
  }

  Future<NotesModel> getNoteDetails(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return NotesModel.fromJson(json["data"]);
    } else {
      throw Exception("Failed to load note details");
    }
  }

  Future<void> editNote(String id, String title, String description) async {
    final data = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to edit note");
    }
  }
}
