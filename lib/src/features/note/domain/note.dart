import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  const Note({
    required this.id,
    required this.question,
    required this.answer,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String question;

  final String answer;
  final String title;
  final int createdAt;
  final int updatedAt;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'question': question,
      'answer': answer,
      'title': title,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as String,
      question: map['question'] as String,
      answer: map['answer'] as String,
      title: map['title'] as String,
      createdAt: map['createdAt'] as int,
      updatedAt: map['updatedAt'] as int,
    );
  }

  Note copyWith({
    String? id,
    String? question,
    String? answer,
    String? title,
    int? createdAt,
    int? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Note(id: $id, question: $question, answer: $answer, title: $title, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
