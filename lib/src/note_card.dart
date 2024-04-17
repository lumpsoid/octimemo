import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_sqflite_api/local_sqflite_api.dart';
import 'package:provider/provider.dart';

import 'note_manager.dart';

class NoteCard extends StatefulWidget {
  final int index;
  final Note note;

  const NoteCard({required this.note, required this.index, super.key});

  @override
  NoteCardState createState() => NoteCardState();
}

class NoteCardState extends State<NoteCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // _animationController.repeat(reverse: true);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onLongPress: () async {
          _startShakeAnimation();
          var body = widget.note.body;
          if (body != null) {
            await Clipboard.setData(ClipboardData(text: body));
          }
        },
        child: Dismissible(
            // drag to the right (edit)
            background: Container(
              color: Colors.blue[50],
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 30.0),
              child: const Icon(Icons.edit_outlined),
            ),
            // drag to the left (delete)
            secondaryBackground: Container(
              color: Colors.red[50],
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 30.0),
              child: const Icon(Icons.delete_outline),
            ),
            confirmDismiss: (DismissDirection direction) async {
              if (direction == DismissDirection.startToEnd) {
                NoteManager manager = context.read<NoteManager>();
                if (manager.editingIndex != null) {
                  return false;
                }
                manager.startEditing(widget.index);
                return false;
              }
              // delete
              if (direction == DismissDirection.endToStart) {
                return true;
              }
              return false;
            },
            onDismissed: (DismissDirection direction) async {
              String message = '';
              NoteManager manager =
                  Provider.of<NoteManager>(context, listen: false);
              // edit
              // if (direction == DismissDirection.startToEnd) {
              //   action = 'edited';
              //   await manager.editNote(index, 'ITSWORKED');
              // }
              // delete
              if (direction == DismissDirection.endToStart) {
                await manager.deleteNote(widget.note);
                message = 'Memo was deleted';
              }
              _showSnackBar(manager, context, message);
            },
            key: Key(widget.note.id.toString()),
            child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.rotate(
                      angle: _shakeAnimation.value,
                      child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 16.0),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          child: Text(widget.note.body!,
                              style: const TextStyle(fontSize: 16.0))));
                })));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startShakeAnimation() {
    _animationController.forward(from: 0.0);
  }

  Future<void> _showSnackBar(
      NoteManager manager, BuildContext context, String message) async {
    if (manager.isSnackbarVisible) {
      return;
    }
    manager.isSnackbarVisible = true;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: Text(message, style: const TextStyle(fontSize: 16.0)),
          duration: const Duration(seconds: 2),
        ))
        .closed
        .then((value) => manager.isSnackbarVisible = false);
  }
}

class NoteCardLoading extends StatelessWidget {
  const NoteCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: const Text('...', style: TextStyle(fontSize: 16.0)));
  }
}
