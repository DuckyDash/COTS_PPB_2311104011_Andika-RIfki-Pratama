import 'package:flutter/material.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';

class TaskAddPage extends StatefulWidget {
  final Task? task;
  const TaskAddPage({super.key, this.task});

  @override
  State<TaskAddPage> createState() => _TaskAddPageState();
}

class _TaskAddPageState extends State<TaskAddPage> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final courseController = TextEditingController();
  final deadlineController = TextEditingController();
  final noteController = TextEditingController();

  // Course list and selection (replace with dynamic source if needed)
  final List<String> courses = [
    'Pemodelan Perangkat Bergerak',
    'Matematika',
    'Fisika',
    'Pemrograman Mobile',
  ];
  String? selectedCourse;

  bool isDone = false;
  bool isSubmitting = false;

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
    try {
      final title = titleController.text.trim();
      final course = (selectedCourse ?? courseController.text).trim();
      final deadline = deadlineController.text.trim();
      final note = noteController.text.trim();

      if (isEditing) {
        await TaskController.updateTask(
          id: widget.task!.id,
          title: title,
          course: course,
          deadline: deadline,
          note: note,
          isDone: isDone,
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perubahan berhasil disimpan')),
        );
        Navigator.pop(context, true);
      } else {
        await TaskController.createTask(
          title: title,
          course: course,
          deadline: deadline,
          note: note,
          isDone: isDone,
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tugas berhasil ditambahkan')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan tugas: $e')),
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  bool get isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final t = widget.task!;
      titleController.text = t.title;
      courseController.text = t.course;
      deadlineController.text = t.deadline.toIso8601String().split('T').first;
      noteController.text = t.note ?? '';
      selectedCourse = t.course;
      isDone = t.isDone;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    courseController.dispose();
    deadlineController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Tugas' : 'Tambah Tugas'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                /// CARD FORM
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// JUDUL TUGAS
                        const Text(
                          'Judul Tugas',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: titleController,
                          decoration: InputDecoration(
                            hintText: 'Masukkan judul tugas',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (v) => v == null || v.isEmpty
                              ? 'Judul tugas wajib diisi'
                              : null,
                        ),

                        const SizedBox(height: 16),

                        /// MATA KULIAH
                        DropdownButtonFormField<String>(
                            value: selectedCourse,
                            items: courses.map((course) {
                              return DropdownMenuItem(
                                value: course,
                                child: Text(course),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCourse = value;
                                courseController.text = value ?? '';
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Pilih mata kuliah',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) => value == null
                                ? 'Mata kuliah wajib diisi'
                                : null,
                          ),


                        const SizedBox(height: 16),

                        /// DEADLINE
                        const Text(
                          'Deadline',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: deadlineController,
                          readOnly: true,
                          onTap: pickDate,
                          decoration: InputDecoration(
                            hintText: 'Pilih tanggal',
                            suffixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (v) => v == null || v.isEmpty
                              ? 'Deadline wajib diisi'
                              : null,
                        ),

                        const SizedBox(height: 16),

                        /// CHECKBOX SELESAI
                        CheckboxListTile(
                          value: isDone,
                          onChanged: (v) => setState(() => isDone = v!),
                          title: const Text('Tugas sudah selesai'),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),

                        const SizedBox(height: 8),

                        /// CATATAN
                        const Text(
                          'Catatan',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: noteController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Catatan tambahan (opsional)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isSubmitting ? null : submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: isSubmitting
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(isEditing ? 'Simpan Perubahan' : 'Simpan'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
