part of 'notes_bloc.dart';

@immutable
sealed class NotesEvent {}

class FetchNotes extends NotesEvent {}

class AddNotes extends NotesEvent {
  final String title;
  final String discription;
  AddNotes({required this.title, required this.discription});
}

class EditNotes extends NotesEvent {
  final String id;
  final String title;
  final String discription;
  EditNotes({required this.id, required this.discription, required this.title});
}

class Deletenotes extends NotesEvent {
  final String id;
  Deletenotes({required this.id});
}

class Getdetailedinfo extends NotesEvent {
  final String id;
  Getdetailedinfo({required this.id});
}
