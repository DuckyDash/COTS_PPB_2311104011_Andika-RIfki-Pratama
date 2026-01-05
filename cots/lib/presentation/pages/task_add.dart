import 'package:flutter/material.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../../design_system/app_color.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';

class TaskAddPage extends StatefulWidget {
  final Task? task; // null = add, ada = edit
  const TaskAddPage({super.key, this.task});

  @override
  State<TaskAddPage> createState() => _TaskAddPageState();
}

class _TaskAddPageState extends State<TaskAddPage> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final deadlineController = TextEditingController();
  final noteController = TextEditingController();

  final List<String> courses = [
    'Pemodelan Perangkat Bergerak',
    'Pemrograman Mobile',
    'Matematika',
    'Fisika',
  ];
  String? selectedCourse;

  bool isDone = false;
  bool isSubmitting = false;

  bool get isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final t = widget.task!;
      titleController.text = t.title;
      selectedCourse = t.course;
      deadlineController.text =
          "${t.deadline.year}-${t.deadline.month.toString().padLeft(2, '0')}-${t.deadline.day.toString().padLeft(2, '0')}";
      noteController.text = t.note ?? '';
      isDone = t.isDone;
    }
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      deadlineController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);

    if (isEditing) {
      await TaskController.updateTask(
        id: widget.task!.id,
        title: titleController.text.trim(),
        course: selectedCourse!,
        deadline: deadlineController.text,
        note: noteController.text.trim(),
        isDone: isDone,
      );
    } else {
      await TaskController.createTask(
        title: titleController.text.trim(),
        course: selectedCourse!,
        deadline: deadlineController.text,
        note: noteController.text.trim(),
        isDone: isDone,
      );
    }

    if (!mounted) return;
    Navigator.pop(context, true); // 🔑 KUNCI
  }

  @override
  void dispose() {
    titleController.dispose();
    deadlineController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Tugas' : 'Tambah Tugas', style: AppTypography.title),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.text,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Judul Tugas'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: titleController,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Wajib diisi' : null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Text('Mata Kuliah'),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedCourse,
                        items: courses
                            .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => selectedCourse = v),
                        validator: (v) =>
                            v == null ? 'Wajib pilih mata kuliah' : null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Text('Deadline'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: deadlineController,
                        readOnly: true,
                        onTap: pickDate,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Wajib diisi' : null,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      CheckboxListTile(
                        value: isDone,
                        onChanged: (v) => setState(() => isDone = v!),
                        title: const Text('Tugas sudah selesai'),
                        contentPadding: EdgeInsets.zero,
                      ),

                      const SizedBox(height: 8),

                      const Text('Catatan'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: noteController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(isEditing ? 'Simpan Perubahan' : 'Simpan', style: AppTypography.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
