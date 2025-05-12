import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recapnote/src/features/note/domain/note.dart';
import 'package:recapnote/src/features/note/presentation/controllers/fetch_all_note_controller.dart';
import 'package:recapnote/src/shared/constants/enums.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Note>> notesAsyncValue = ref.watch(
      fetchAllNoteControllerProvider,
    );

    return notesAsyncValue.when(
      data: (notes) {
        // Zero State
        if (notes.isEmpty) return Container();

        return SafeArea(
          child: ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Card(
                child: ListTile(
                  title: Text(note.title),
                  onTap: () {
                    context.pushNamed(
                      AppRoute.noteDetail.name,
                      pathParameters: {'id': note.id},
                    );
                  },
                ),
              );
            },
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
