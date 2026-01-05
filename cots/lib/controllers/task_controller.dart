import '../models/task.dart';
import '../services/task_service.dart';

class TaskController {
  static Future<List<Task>> getAllTasks() async {
    final data = await TaskService.fetchTasks();
    return data.map((e) => Task.fromJson(e)).toList();
  }

  static Future<int> countFinished() async {
    final data = await TaskService.fetchTasks(status: 'SELESAI');
    return data.length;
  }

  static Future<void> createTask({
    required String title,
    required String course,
    required String deadline,
    required String note,
    bool isDone = false,
  }) async {
    await TaskService.addTask({
      'title': title,
      'course': course,
      'deadline': deadline,
      'status': isDone ? 'SELESAI' : 'BERJALAN',
      'note': note,
      'is_done': isDone,
    });
  }

  static Future<void> updateStatus({
    required int id,
    required bool isDone,
    required String note,
  }) async {
    await TaskService.updateTask(id, {
      'is_done': isDone,
      'status': isDone ? 'SELESAI' : 'BERJALAN',
      'note': note,
    });
  }

  static Future<void> updateTask({
    required int id,
    required String title,
    required String course,
    required String deadline,
    required String note,
    required bool isDone,
  }) async {
    await TaskService.updateTask(id, {
      'title': title,
      'course': course,
      'deadline': deadline,
      'note': note,
      'is_done': isDone,
      'status': isDone ? 'SELESAI' : 'BERJALAN',
    });
  }
}
