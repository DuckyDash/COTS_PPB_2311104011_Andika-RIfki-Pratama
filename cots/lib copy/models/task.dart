class Task {
  final int id;
  final String title;
  final String course;
  final DateTime deadline;
  final String status; // BERJALAN | SELESAI | TERLAMBAT
  final String? note;
  final bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.course,
    required this.deadline,
    required this.status,
    required this.isDone,
    this.note,
  });

  factory Task.fromJson(Map<String, dynamic> j) => Task(
    id: j['id'],
    title: j['title'],
    course: j['course'],
    deadline: DateTime.parse(j['deadline']),
    status: j['status'],
    note: j['note'],
    isDone: j['is_done'] ?? false,
  );

  Map<String, dynamic> toAddJson() => {
    'title': title,
    'course': course,
    'deadline': deadline.toIso8601String().split('T').first,
    'status': status,
    'note': note,
    'is_done': isDone,
  };
}
