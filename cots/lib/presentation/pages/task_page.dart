import 'package:flutter/material.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../../design_system/app_color.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../widgets/status_chip.dart';
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
      temp = temp.where((t) => t.effectiveStatus == selectedFilter).toList();
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
        return AppColors.successText;
      case 'TERLAMBAT':
        return AppColors.danger;
      default:
        return AppColors.primary;
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
      selectedColor: AppColors.primary,
      labelStyle: active ? AppTypography.button : AppTypography.body,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Daftar Tugas', style: AppTypography.title),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.text,
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
            icon: const Icon(Icons.add, size: 18, color: AppColors.primary),
            label: Text('Tambah', style: AppTypography.section.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
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
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            /// FILTER
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  filterChip('Semua', 'SEMUA'),
                  const SizedBox(width: AppSpacing.sm),
                  filterChip('Berjalan', 'BERJALAN'),
                  const SizedBox(width: AppSpacing.sm),
                  filterChip('Selesai', 'SELESAI'),
                  const SizedBox(width: AppSpacing.sm),
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
                          margin: const EdgeInsets.only(bottom: AppSpacing.md),
                          color: AppColors.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(AppSpacing.md),
                            leading: CircleAvatar(
                              radius: 6,
                              backgroundColor: dotColor(task.effectiveStatus),
                            ),
                            title: Text(
                              task.title,
                              style: AppTypography.section,
                            ),
                            subtitle: Text(task.course, style: AppTypography.body),
                            trailing: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${task.deadline.day.toString().padLeft(2, '0')}-${task.deadline.month.toString().padLeft(2, '0')}-${task.deadline.year}',
                                  style: AppTypography.caption,
                                ),
                                if (task.isOverdue)
                                  StatusChip('TERLAMBAT'),
                              ],
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
