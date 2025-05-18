import 'dart:async';

import 'package:flutter/material.dart';
import 'package:octimemo/common/selected_builder.dart';
import 'package:octimemo/l10n/l10n.dart';
import 'package:octimemo/notes_overview/notes_overview.dart';
import 'package:octimemo/service_locator/service_locator.dart';

class GlobalInputField extends StatefulWidget {
  const GlobalInputField({super.key});

  @override
  State<GlobalInputField> createState() => _GlobalInputFieldState();
}

class _GlobalInputFieldState extends State<GlobalInputField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  late StreamSubscription<NotesOverviewEffect?> _effect;

  final viewModel = getIt<NotesOverviewViewModel>();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController();
    _effect = viewModel.effect.listen(_processEffect);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    _effect.cancel();
    super.dispose();
  }

  void _openKeyboard() {
    final isKeyboardOpen = View.of(context).viewInsets.bottom > 0;

    // If we're in editing mode and keyboard is NOT open
    if (viewModel.editingState.value.noteId != null && !isKeyboardOpen) {
      // This suggests the user closed the keyboard but the field is still focused
      // So we unfocus and then request focus again to show the keyboard
      _focusNode.unfocus();
      Future.delayed(const Duration(milliseconds: 1), () {
        _focusNode.requestFocus();
      });
    } else if (!isKeyboardOpen) {
      // Normal case - keyboard not open, request focus
      _focusNode.requestFocus();
    }
    // If keyboard is already open, do nothing
  }

  void _processEffect(NotesOverviewEffect? effect) {
    switch (effect) {
      case ClearGlobalInputEffect():
        _controller.clear();
      case FillGlobalInputEffect():
        _controller.text = effect.text;
      case UnFocusGlobalInputEffect():
        _focusNode.unfocus();
      case FocusGlobalInputEffect():
        _openKeyboard();
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SelectedBuilder<EditingState, bool>(
      valueListenable: viewModel.editingState,
      selector: (state) {
        return state.noteId != null;
      },
      builder: (context, isEditing, _) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            maxLines: null,
            onChanged: viewModel.changeInput,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: l10n.overviewGlobalInputHint,
              border: InputBorder.none,
              prefixIcon: isEditing
                  ? IconButton(
                      onPressed: viewModel.clearInput,
                      icon: const Icon(Icons.cancel_outlined),
                    )
                  : null,
              suffixIcon: IconButton(
                onPressed: viewModel.processNote,
                icon: const Icon(Icons.send),
              ),
            ),
          ),
        );
      },
    );
  }
}
