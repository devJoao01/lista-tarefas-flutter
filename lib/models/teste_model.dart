class Task {
  String? title;
  String? description;
  bool? isDone;
  String? priority;

  Task(
      {required this.title,
      required this.description,
      this.isDone,
      this.priority});

  Map toJson() {
    return {
      'title': title,
      'description': description,
      'isDone': isDone,
      'priority': priority
    };
  }

  Task.fromJson(Map<String, dynamic> Json) {
    title = Json['title'];
    description = Json['description'];
    isDone = Json['isDone'] ?? false;
    priority = Json['priority'];
  }
}
