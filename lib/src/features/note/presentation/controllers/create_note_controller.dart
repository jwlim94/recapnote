import 'package:recapnote/src/features/note/data/note_repository.dart';
import 'package:recapnote/src/features/note/presentation/providers/note_data_state_provider.dart';
import 'package:recapnote/src/shared/utils/crypto_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_note_controller.g.dart';

@riverpod
class CreateNoteController extends _$CreateNoteController {
  @override
  FutureOr<void> build() {
    // no op
  }

  Future<void> createNote() async {
    final randomNoteId = CryptoUtils.generateRandomId();
    ref.read(noteDataStateProvider.notifier).setId(randomNoteId);

    final noteRepository = ref.read(noteRepositoryProvider);
    final noteData = ref.read(noteDataStateProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() => noteRepository.createNote(noteData));
  }
}
