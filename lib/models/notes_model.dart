class NotesModel {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;

  NotesModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  factory NotesModel.fromJson(Map<String, dynamic> json) {
    return NotesModel(
      id: json["_id"] as String,
      title: json["title"] as String,
      description: json["description"] as String,
      isCompleted: json["is_completed"] as bool,
    );
  }
}
