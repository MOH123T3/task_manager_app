class TaskModel {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  // Convert a TaskModel object to a map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  // Convert a map to a TaskModel object
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
