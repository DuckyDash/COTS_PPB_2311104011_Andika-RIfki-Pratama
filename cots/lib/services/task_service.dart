import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/supabase_config.dart';

class TaskService {
  static final String _url = '${SupabaseConfig.baseUrl}/tasks';

  static Future<List<dynamic>> fetchTasks({String? status}) async {
    final endpoint = status == null
        ? '$_url?select=*'
        : '$_url?select=*&status=eq.$status';

    final res = await http.get(
      Uri.parse(endpoint),
      headers: SupabaseConfig.headers(),
    );

    return jsonDecode(res.body);
  }

  static Future<void> addTask(Map<String, dynamic> body) async {
    await http.post(
      Uri.parse(_url),
      headers: {...SupabaseConfig.headers(), 'Prefer': 'return=representation'},
      body: jsonEncode(body),
    );
  }

  static Future<void> updateTask(int id, Map<String, dynamic> body) async {
    await http.patch(
      Uri.parse('$_url?id=eq.$id'),
      headers: {...SupabaseConfig.headers(), 'Prefer': 'return=representation'},
      body: jsonEncode(body),
    );
  }
}
