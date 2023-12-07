import 'note.dart' show Note;

const int itemsPerPage = 20;

class NotePage {
  final List<Note> items;
  final int startingIndex;
  final bool hasNext;

  NotePage({
    required this.items,
    required this.startingIndex,
    required this.hasNext});

  void addNote(Note note) {
    items.add(note);
  }
}