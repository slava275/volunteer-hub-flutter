enum TaskPriority { high, medium, low }

enum TaskStatus { inProgress, todo, done }

class TaskItem {
  const TaskItem({
    required this.project,
    required this.title,
    required this.priority,
    required this.status,
    required this.dueLabel,
    this.isUrgent = false,
  });

  final String project;
  final String title;
  final TaskPriority priority;
  final TaskStatus status;
  final String dueLabel;

  final bool isUrgent;
}
