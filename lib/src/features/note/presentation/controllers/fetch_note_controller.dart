import 'package:recapnote/src/features/note/data/note_repository.dart';
import 'package:recapnote/src/features/note/domain/note.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_note_controller.g.dart';

@riverpod
class FetchNoteController extends _$FetchNoteController {
  @override
  FutureOr<Note?> build(String id) async {
    return ref.read(noteRepositoryProvider).fetchNote(id);
  }
}
