import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memocti/notes_overview/notes_overview.dart';

class GlobalInputField extends StatefulWidget {
  const GlobalInputField({super.key});

  @override
  State<GlobalInputField> createState() => _GlobalInputFieldState();
}

class _GlobalInputFieldState extends State<GlobalInputField> {
  final _focusNode = FocusNode();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Force keyboard to open when the state changes
    final noteEditId = context.select(
      (NotesOverviewBloc bloc) => bloc.state.editingNoteId,
    );
    final isEditing = noteEditId != 0;

    if (isEditing) {
      FocusScope.of(context).requestFocus(_focusNode);
      _controller.text = context.read<NotesOverviewBloc>().state.inputField;
    }
    return TextField(
      controller: _controller,
      maxLines: null,
      onChanged: (value) => context.read<NotesOverviewBloc>().add(
            NotesOverviewInputFieldChanged(value),
          ),
      decoration: InputDecoration(
        hintText: 'Enter your note...',
        border: const OutlineInputBorder(),
        prefixIcon: isEditing
            ? IconButton(
                onPressed: () {
                  _controller.clear();
                  context.read<NotesOverviewBloc>().add(
                        const NotesOverviewNoteEditCancel(),
                      );
                },
                icon: const Icon(Icons.cancel_outlined),
              )
            : null,
        suffixIcon: IconButton(
            onPressed: () {
              if (_controller.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Text field is empty.',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    duration: const Duration(milliseconds: 1500),
                    width: 280.0, // Width of the SnackBar.
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, // Inner padding for SnackBar content.
                    ),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                );
              }
              _controller.clear();
              if (isEditing) {
                context.read<NotesOverviewBloc>().add(
                      const NotesOverviewNoteUpdate(),
                    );
              } else {
                context.read<NotesOverviewBloc>().add(
                      const NotesOverviewNoteAdd(),
                    );
              }
            },
            icon: const Icon(Icons.send)),
      ),
    );
  }
}
