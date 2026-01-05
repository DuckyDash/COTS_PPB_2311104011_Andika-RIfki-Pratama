import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/supabase_config.dart';
import '../models/task.dart';

class TaskService {
  Map<String, String> get _headers => {
    'apikey': SupabaseConfig.anonKey,
    'Authorization': 'Bearer ${SupabaseConfig.anonKey}',
    'Content-Type': 'application/json',
  };

  Future<List<Task>> getTasks({String? status}) async {
    final uri = Uri.parse('${SupabaseConfig.rest}/tasks').replace(
      queryParameters: {
        'select': '*',
        if (status != null) 'status': 'eq.$status',
      },
    );

    final res = await http.get(uri, headers: _headers);
    if (res.statusCode != 200) throw Exception('Gagal ambil data');
    final list = jsonDecode(res.body) as List;
    return list.map((e) => Task.fromJson(e)).toList();
  }

  Future<void> addTask(Task task) async {
    final res = await http.post(
      Uri.parse('${SupabaseConfig.rest}/tasks'),
      headers: {..._headers, 'Prefer': 'return=representation'},
      body: jsonEncode(task.toAddJson()),
    );
    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception('Gagal tambah tugas');
    }
  }

  Future<void> updateTask(int id, Map<String, dynamic> body) async {
    final uri = Uri.parse(
      '${SupabaseConfig.rest}/tasks',
    ).replace(queryParameters: {'id': 'eq.$id'});
    final res = await http.patch(
      uri,
      headers: {..._headers, 'Prefer': 'return=representation'},
      body: jsonEncode(body),
    );
    if (res.statusCode != 200) throw Exception('Gagal update');
  }
}
