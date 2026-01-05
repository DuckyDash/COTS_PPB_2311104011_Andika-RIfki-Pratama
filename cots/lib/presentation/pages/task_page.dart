import 'package:flutter/material.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import 'task_detail.dart';
import 'task_add.dart';


class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Task> allTasks = [];
  List<Task> filteredTasks = [];

  String selectedFilter = 'SEMUA';
  String keyword = '';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await TaskController.getAllTasks();
    setState(() {
      allTasks = data;
      applyFilter();
    });
  }

  void applyFilter() {
    List<Task> temp = allTasks;

    // Filter status
    if (selectedFilter != 'SEMUA') {
      temp = temp.where((t) => t.status == selectedFilter).toList();
    }

    // Search
    if (keyword.isNotEmpty) {
      temp = temp
          .where(
            (t) =>
                t.title.toLowerCase().contains(keyword.toLowerCase()) ||
                t.course.toLowerCase().contains(keyword.toLowerCase()),
          )
          .toList();
    }

    filteredTasks = temp;
  }

  Color dotColor(String status) {
    switch (status) {
      case 'SELESAI':
        return Colors.green;
      case 'TERLAMBAT':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Widget filterChip(String label, String value) {
    final bool active = selectedFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: active,
      onSelected: (_) {
        setState(() {
          selectedFilter = value;
          applyFilter();
        });
      },
      selectedColor: Colors.blue,
      labelStyle: TextStyle(color: active ? Colors.white : Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Daftar Tugas'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TaskAddPage()),
              );
              loadData();
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Tambah'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// SEARCH
            TextField(
              onChanged: (v) {
                setState(() {
                  keyword = v;
                  applyFilter();
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari tugas atau mata kuliah...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// FILTER
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  filterChip('Semua', 'SEMUA'),
                  const SizedBox(width: 8),
                  filterChip('Berjalan', 'BERJALAN'),
                  const SizedBox(width: 8),
                  filterChip('Selesai', 'SELESAI'),
                  const SizedBox(width: 8),
                  filterChip('Terlambat', 'TERLAMBAT'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// LIST
            Expanded(
              child: filteredTasks.isEmpty
                  ? const Center(child: Text('Tidak ada tugas'))
                  : ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (_, i) {
                        final task = filteredTasks[i];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: CircleAvatar(
                              radius: 6,
                              backgroundColor: dotColor(task.status),
                            ),
                            title: Text(
                              task.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(task.course),
                            trailing: Text(
                              '${task.deadline.day.toString().padLeft(2, '0')}-${task.deadline.month.toString().padLeft(2, '0')}-${task.deadline.year}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TaskDetailPage(task: task),
                                ),
                              );
                              loadData();
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
