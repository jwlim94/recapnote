import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:recapnote/src/features/note/presentation/controllers/fetch_note_controller.dart';

class NoteDetailScreen extends ConsumerWidget {
  const NoteDetailScreen(this.id, {super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteAsyncValue = ref.watch(fetchNoteControllerProvider(id));

    return noteAsyncValue.when(
      data: (note) {
        // Zero State
        if (note == null) return Container();

        return Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: GptMarkdown(note.answer),
            ),
          ),
        );
      },
      loading: () {
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      error: (error, stackTrace) {
        return Scaffold(body: Center(child: Text(error.toString())));
      },
    );
  }
}
