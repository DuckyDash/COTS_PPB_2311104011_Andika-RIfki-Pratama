import 'package:flutter/material.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import 'task_add.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;
  const TaskDetailPage({super.key, required this.task});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late Task currentTask;
  late bool isDone;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    currentTask = widget.task;
    isDone = currentTask.isDone;
    noteController = TextEditingController(text: currentTask.note ?? '');
  }

  Color statusColor(String status) {
    switch (status) {
      case 'SELESAI':
        return Colors.green;
      case 'TERLAMBAT':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Widget statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor(status).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status == 'SELESAI'
            ? 'Selesai'
            : status == 'TERLAMBAT'
            ? 'Terlambat'
            : 'Berjalan',
        style: TextStyle(
          color: statusColor(status),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> toggleDone(bool value) async {
    setState(() => isDone = value);

    await TaskController.updateStatus(
      id: currentTask.id,
      isDone: value,
      note: noteController.text,
    );

    final all = await TaskController.getAllTasks();
    final updated = all.firstWhere(
      (t) => t.id == currentTask.id,
      orElse: () => currentTask,
    );

    setState(() {
      currentTask = updated;
    });
  }

  Future<void> openEdit() async {
    final changed = await Navigator.push<bool?>(
      context,
      MaterialPageRoute(builder: (_) => TaskAddPage(task: currentTask)),
    );

    if (changed == true) {
      final all = await TaskController.getAllTasks();
      final updated = all.firstWhere(
        (t) => t.id == currentTask.id,
        orElse: () => currentTask,
      );

      setState(() {
        currentTask = updated;
        isDone = updated.isDone;
        noteController.text = updated.note ?? '';
      });
    }
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Detail Tugas'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: openEdit,
            child: const Text(
              'Edit',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// DETAIL CARD
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Judul Tugas',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentTask.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Mata Kuliah',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(currentTask.course),

                    const SizedBox(height: 12),

                    const Text(
                      'Deadline',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${currentTask.deadline.day.toString().padLeft(2, '0')}-"
                      "${currentTask.deadline.month.toString().padLeft(2, '0')}-"
                      "${currentTask.deadline.year}",
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Status',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    statusBadge(currentTask.status),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// CHECKBOX (TIDAK DIUBAH SESUAI MAU KAMU)
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: CheckboxListTile(
                value: isDone,
                onChanged: (v) => toggleDone(v!),
                title: const Text('Tugas sudah selesai'),
                subtitle: const Text(
                  'Centang jika tugas sudah final.',
                  style: TextStyle(fontSize: 12),
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),

            const SizedBox(height: 16),

            /// CATATAN (VIEW ONLY)
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Catatan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: noteController,
                      maxLines: 3,
                      readOnly: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
