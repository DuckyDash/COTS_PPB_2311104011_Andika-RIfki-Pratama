// lib/presentation/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/task_controller.dart';
import '../../design_system/app_typography.dart';
import '../widgets/app_card.dart';
import '../widgets/app_button.dart';
// import 'tasks_list_page.dart';
// import 'add_task_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<TasksController>().fetch());
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<TasksController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas Besar'),
        actions: [
          // TextButton(
          //   onPressed: () => Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (_) => const TasksListPage()),
          //   ),
          //   child: const Text('Daftar Tugas'),
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: c.loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Tugas: ${c.tasks.length}',
                    style: AppTypography.section,
                  ),
                  const SizedBox(height: 16),
                  // PrimaryButton(
                  //   text: 'Tambah Tugas',
                  //   onTap: () => Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (_) => const AddTaskPage()),
                  //   ),
                  // ),
                ],
              ),
      ),
    );
  }
}
