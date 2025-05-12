import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recapnote/src/features/note/domain/note.dart';
import 'package:recapnote/src/features/note/domain/note_data.dart';
import 'package:recapnote/src/shared/constants/strings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'note_repository.g.dart';

class NoteRepository {
  NoteRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Future<Note?> fetchNote(String id) async {
    final reference = _firestore
        .collection(Strings.noteCollection)
        .doc(id)
        .withConverter(
          fromFirestore: (doc, _) => Note.fromMap(doc.data()!),
          toFirestore: (Note note, _) => note.toMap(),
        );
    final snapshot = await reference.get();
    return snapshot.data();
  }

  Future<List<Note>> fetchAllNotes() async {
    final snapshot =
        await _firestore
            .collection(Strings.noteCollection)
            .orderBy('updatedAt', descending: true)
            .get();

    return snapshot.docs
        .map((doc) => Note.fromJson(doc.data()).copyWith(id: doc.id))
        .toList();
  }

  Future<void> createNote(NoteData noteData) async {
    final String noteId = noteData.id!;

    final note = Note(
      id: noteId,
      question: noteData.question!,
      answer: noteData.answer!,
      title: noteData.title!,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _firestore
        .collection(Strings.noteCollection)
        .doc(noteId)
        .withConverter(
          fromFirestore: (doc, _) => Note.fromMap(doc.data()!),
          toFirestore: (Note car, _) => car.toMap(),
        )
        .set(note);
  }
}

@Riverpod(keepAlive: true)
NoteRepository noteRepository(Ref ref) {
  return NoteRepository(FirebaseFirestore.instance);
}
