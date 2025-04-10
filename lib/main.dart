import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/bloc/notes_bloc.dart';
import 'package:todolist/screens.dart/home_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:todolist/services/api_services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesBloc(ApiService())..add(FetchNotes()),
      child: MaterialApp(home: HomeScreen()),
    );
  }
}
