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
    final isEditing = context.select(
      (NotesOverviewBloc bloc) => bloc.state.editingNoteId != 0,
    );

    if (isEditing) FocusScope.of(context).requestFocus(_focusNode);
    return Container(
      color: Colors.green[50],
      child: TextField(
        controller: _controller,
        maxLines: null,
        onChanged: (value) => context.read<NotesOverviewBloc>().add(
              NotesOverviewInputFieldChanged(value),
            ),
        decoration: InputDecoration(
          hintText: 'Enter your note...',
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
              onPressed: () {
                if (_controller.text.isEmpty) {
                  //TODO: Show a snackbar
                }
                context.read<NotesOverviewBloc>().add(
                      const NotesOverviewNoteAdd(),
                    );
              },
              icon: const Icon(Icons.send)),
        ),
      ),
    );
  }
}
