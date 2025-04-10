part of 'notes_bloc.dart';

@immutable
sealed class NotesState {}

final class NotesInitial extends NotesState {}

final class NoteLoading extends NotesState {}

final class NotesLoaded extends NotesState {
  final List<NotesModel> notes;
  NotesLoaded({required this.notes});
}

final class NoteLoaded extends NotesState {
  final NotesModel note;
  NoteLoaded({required this.note});
}

final class NotesError extends NotesState {
  final String error;
  NotesError({required this.error});
}
