class Note {
  int? id;
  String title;
  String description;
  DateTime createdAt;

 
  Note({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });


  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(), 
    };
  }

  
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  
  Note copyWith({int? id, String? title, String? description, DateTime? createdAt}) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, description: $description, createdAt: $createdAt}';
  }
}
