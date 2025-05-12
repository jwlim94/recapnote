import 'package:recapnote/src/features/note/data/note_repository.dart';
import 'package:recapnote/src/features/note/domain/note.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_all_note_controller.g.dart';

@riverpod
class FetchAllNoteController extends _$FetchAllNoteController {
  @override
  FutureOr<List<Note>> build() {
    return ref.read(noteRepositoryProvider).fetchAllNotes();
  }
}
