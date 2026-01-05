import 'package:flutter/material.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../../design_system/app_color.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
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
        return AppColors.successText;
      case 'TERLAMBAT':
        return AppColors.danger;
      default:
        return AppColors.primary;
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
        status == 'SELESAI' ? 'Selesai' : status == 'TERLAMBAT' ? 'Terlambat' : 'Berjalan',
        style: AppTypography.caption.copyWith(
          color: statusColor(status),
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detail Tugas', style: AppTypography.title),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.text,
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
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            /// DETAIL CARD
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Judul Tugas',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      currentTask.title,
                      style: AppTypography.section,
                    ),

                    const SizedBox(height: AppSpacing.md),

                    const Text(
                      'Mata Kuliah',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(currentTask.course, style: AppTypography.body),

                    const SizedBox(height: AppSpacing.md),

                    const Text(
                      'Deadline',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Text(
                          "${currentTask.deadline.day.toString().padLeft(2, '0')}-${currentTask.deadline.month.toString().padLeft(2, '0')}-${currentTask.deadline.year}",
                          style: AppTypography.body,
                        ),
                        if (currentTask.isOverdue) ...[
                          const SizedBox(width: AppSpacing.xs),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.lateBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text('Terlambat', style: AppTypography.caption.copyWith(color: AppColors.danger)),
                          ),
                        ]
                      ],
                    ),

                    const SizedBox(height: AppSpacing.md),

                    const Text(
                      'Status',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    statusBadge(currentTask.effectiveStatus),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// CHECKBOX
            Card(
                color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: CheckboxListTile(
                  value: isDone,
                  onChanged: (v) => toggleDone(v!),
                  title: const Text('Tugas sudah selesai', style: AppTypography.section),
                  subtitle: const Text(
                    'Centang jika tugas sudah final.',
                    style: AppTypography.caption,
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// CATATAN (VIEW ONLY)
            Card(
                color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Catatan',
                      style: AppTypography.section,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextField(
                      controller: noteController,
                      maxLines: 3,
                      readOnly: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.background,
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
