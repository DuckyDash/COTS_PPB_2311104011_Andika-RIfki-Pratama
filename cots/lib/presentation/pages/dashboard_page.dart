import 'package:flutter/material.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../../design_system/app_color.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../widgets/status_chip.dart';
import 'task_page.dart';
import 'task_detail.dart';
import 'task_add.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Task> tasks = [];
  int total = 0;
  int selesai = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final allTasks = await TaskController.getAllTasks();
    setState(() {
      tasks = allTasks;
      total = allTasks.length;
      selesai = allTasks.where((t) => t.isDone).length;
    });
  }

  Color statusColor(String status) {
    switch (status) {
      case 'SELESAI':
        return AppColors.successText;
      case 'BERJALAN':
      default:
        return AppColors.primary;
    }
  }

  Widget statusBadge(String status) {
    return StatusChip(status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tugas Besar',
                    style: AppTypography.title,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TaskListPage()),
                      );
                    },
                    child: Text(
                      'Daftar Tugas',
                      style: AppTypography.section.copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// COUNT CARD
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Tugas', style: AppTypography.caption),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              '$total',
                              style: AppTypography.title.copyWith(fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Card(
                      color: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Selesai', style: AppTypography.caption),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              '$selesai',
                              style: AppTypography.title.copyWith(fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              /// NEAREST TASK
              const Text(
                'Tugas Terdekat',
                style: AppTypography.section,
              ),

              const SizedBox(height: AppSpacing.sm),

              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length > 3 ? 3 : tasks.length,
                  itemBuilder: (_, i) {
                    final task = tasks[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      color: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(AppSpacing.md),
                        title: Text(
                          task.title,
                          style: AppTypography.section,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: AppSpacing.xs),
                            Text(task.course, style: AppTypography.body),
                            const SizedBox(height: AppSpacing.xs),
                            Row(
                              children: [
                                Text(
                                  'Deadline: ${task.deadline.toIso8601String().split('T').first}',
                                  style: AppTypography.caption,
                                ),
                                if (task.isOverdue) ...[
                                  const SizedBox(width: AppSpacing.xs),
                                  StatusChip('TERLAMBAT'),
                                ]
                              ],
                            ),
                          ],
                        ),
                        trailing: statusBadge(task.effectiveStatus),
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

              /// ADD BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TaskAddPage()),
                    );
                    loadData();
                  },
                  child: Text(
                    'Tambah Tugas',
                    style: AppTypography.button.copyWith(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
