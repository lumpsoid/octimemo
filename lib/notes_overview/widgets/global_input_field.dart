import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octimemo/notes_overview/notes_overview.dart';

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
    return MultiBlocListener(
      listeners: [
        // clean the input field when the edited note is deleted
        BlocListener<NotesOverviewBloc, NotesOverviewState>(
          listenWhen: (previous, current) =>
              previous != current && current.cleanInputField,
          listener: (context, state) {
            _controller.text = '';
          },
        ),
        // Force keyboard to open when a note is being edited
        BlocListener<NotesOverviewBloc, NotesOverviewState>(
          listenWhen: (previous, current) =>
              previous != current && current.editingNoteId != 0,
          listener: (context, state) async {
            setUpField() {
              _controller.text =
                  context.read<NotesOverviewBloc>().state.inputField;
              FocusScope.of(context).requestFocus(_focusNode);
            }

            if (View.of(context).viewInsets.bottom == 0.0) {
              _focusNode.unfocus();
              debugPrint('unfocus?');
              Future.delayed(
                const Duration(microseconds: 1),
                setUpField,
              );
            } else {
              setUpField();
            }
          },
        ),
      ],
      child: BlocSelector<NotesOverviewBloc, NotesOverviewState, bool>(
        selector: (state) {
          return state.editingNoteId != 0;
        },
        builder: (context, isEditing) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Colors.grey), // Top border
              ),
            ),
            child: TextFormField(
              controller: _controller,
              focusNode: _focusNode,
              maxLines: null,
              onChanged: (value) => context.read<NotesOverviewBloc>().add(
                    NotesOverviewInputFieldChanged(value),
                  ),
              decoration: InputDecoration(
                hintText: 'Enter your note...',
                border: InputBorder.none,
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
                              horizontal:
                                  8.0, // Inner padding for SnackBar content.
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
            ),
          );
        },
      ),
    );
  }
}
