import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todolist/models/notes_model.dart';
import 'package:todolist/services/api_services.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final ApiService apiService;
  NotesBloc(this.apiService) : super(NotesInitial()) {
    on<FetchNotes>(_fetchNotes);
    on<AddNotes>(_addNotes);
    on<EditNotes>(_editNotes);
    on<Deletenotes>(_deleteNotes);
    on<Getdetailedinfo>(_getDetailedInfo);
  }
  void _fetchNotes(FetchNotes event, Emitter<NotesState> emit) async {
    emit(NoteLoading());
    try {
      final notes = await apiService.fetchNotes();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(error: e.toString()));
    }
  }

  Future<void> _addNotes(AddNotes event, Emitter<NotesState> emit) async {
    try {
      await apiService.addNote(event.title, event.discription);
      final notes = await apiService.fetchNotes();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(error: e.toString()));
    }
  }

  Future<void> _editNotes(EditNotes event, Emitter<NotesState> emit) async {
    emit(NoteLoading());

    try {
      await apiService.editNote(event.id, event.title, event.discription);
      final notes = await apiService.getNoteDetails(event.id);
      emit(NoteLoaded(note: notes));
    } catch (e) {
      emit(NotesError(error: e.toString()));
    }
  }

  Future<void> _deleteNotes(Deletenotes event, Emitter<NotesState> emit) async {
    emit(NoteLoading());
    try {
      await apiService.deleteNote(event.id);
      final notes = await apiService.fetchNotes();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(error: e.toString()));
    }
  }

  _getDetailedInfo(Getdetailedinfo event, Emitter<NotesState> emit) async {
    emit(NoteLoading());
    try {
      final note = await apiService.getNoteDetails(event.id);
      emit(NoteLoaded(note: note));
    } catch (e) {
      emit(NotesError(error: e.toString()));
    }
  }
}
