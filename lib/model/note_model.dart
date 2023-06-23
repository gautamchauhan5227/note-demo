class Note {
  final String id;
  final String docId;
  String title;
  String description;
  int colorIndex;
  DateTime date;

  Note({
    required this.id,
    required this.docId,
    required this.title,
    required this.description,
    required this.date,
    required this.colorIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'docId': docId,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'colorIndex': colorIndex,
    };
  }

  factory Note.initial() => Note(
        id: '',
        docId: '',
        title: '',
        description: '',
        date: DateTime.now(),
        colorIndex: 0,
      );

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      docId: json['docId'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      colorIndex: int.parse(json['colorIndex'].toString()),
    );
  }
}
