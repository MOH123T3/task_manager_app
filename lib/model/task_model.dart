class Task {
  final int? id;
  final String title;
  final String description;
  final DateTime reminderTime;
  final String category;
  final String status;

  Task(
      {this.id,
      required this.title,
      required this.description,
      required this.reminderTime,
      required this.category,
      required this.status});

  // Convert Task to Map for SQLite operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'reminderTime': reminderTime.toIso8601String(),
      'category': category,
      'status': status
    };
  }

  // Convert Map to Task (for fetching from DB)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        reminderTime: DateTime.parse(map['reminderTime']),
        category: map['category'],
        status: map['status']);
  }
}
