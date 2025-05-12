import 'package:recapnote/src/features/note/domain/note_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'note_data_state_provider.g.dart';

@Riverpod(keepAlive: true)
class NoteDataState extends _$NoteDataState {
  @override
  NoteData build() {
    return NoteData();
  }

  void setId(String id) {
    state = NoteData(
      id: id,
      question: state.question,
      answer: state.answer,
      title: state.title,
    );
  }

  void setQuestion(String question) {
    state = NoteData(
      id: state.id,
      question: question,
      answer: state.answer,
      title: state.title,
    );
  }

  void setAnswer(String answer) {
    state = NoteData(
      id: state.id,
      question: state.question,
      answer: answer,
      title: state.title,
    );
  }

  void setTitle(String title) {
    state = NoteData(
      id: state.id,
      question: state.question,
      answer: state.answer,
      title: title,
    );
  }
}
