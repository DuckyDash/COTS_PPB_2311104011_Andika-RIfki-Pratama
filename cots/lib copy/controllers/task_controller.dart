import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TasksController extends ChangeNotifier {
  final _service = TaskService();

  List<Task> tasks = [];
  bool loading = false;

  Future<void> fetch({String? status}) async {
    loading = true;
    notifyListeners();
    tasks = await _service.getTasks(status: status);
    loading = false;
    notifyListeners();
  }

  Future<void> add(Task t) async {
    await _service.addTask(t);
    await fetch();
  }

  Future<void> toggleDone(Task t, bool done) async {
    await _service.updateTask(t.id, {
      'is_done': done,
      'status': done ? 'SELESAI' : 'BERJALAN',
    });
    await fetch();
  }

  Future<void> updateNote(Task t, String note) async {
    await _service.updateTask(t.id, {'note': note});
    await fetch();
  }
}
