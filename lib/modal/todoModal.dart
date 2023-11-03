// ignore_for_file: file_names

class TodoModal {
  String? id;
  String? title;
  String? description;
  String? isDone;
  DateTime? date;

  TodoModal({
    this.id,
    this.title,
    this.description,
    this.isDone,
    this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
      'date': date?.toIso8601String()
    };
  }

  // Create a Todo object from a Map
  factory TodoModal.fromMap(Map<String, dynamic> map) {
    return TodoModal(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isDone: map['isDone'],
      date: map['date'] != null ? DateTime.parse(map['date'].toString()) : null,
    );
  }
}
