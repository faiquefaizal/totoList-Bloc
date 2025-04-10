import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/bloc/notes_bloc.dart';
import 'package:todolist/services/api_services.dart';

import 'package:todolist/models/notes_model.dart';
import 'package:todolist/screens.dart/detailed_screen.dart';
import 'package:todolist/screens.dart/widgets/dialogbox.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<NotesBloc>().add(FetchNotes());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My To Do List",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, snapshot) {
          if (snapshot is NoteLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot is NotesError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            ); // ✅ Error state
          } else if (snapshot is NotesLoaded) {
            final notes = snapshot.notes;
            if (notes.isEmpty)
              return const Center(child: Text("No tasks found."));
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                log("Note description: '${note.description}'");
                return GestureDetector(
                  onTap: () {
                    context.read<NotesBloc>().add(Getdetailedinfo(id: note.id));
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NoteDetailScreen(id: note.id),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    note.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    note.description,
                                    textAlign: TextAlign.start,
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Created at: ", // Assuming createdAt exists
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Spacer(),
                          IconButton(
                            onPressed:
                                () => showDialog(
                                  context: context,
                                  builder:
                                      (context) => ShowDeleteAlertDialog(
                                        onpressed: () {
                                          context.read<NotesBloc>().add(
                                            Deletenotes(id: note.id),
                                          );
                                        },
                                      ),
                                ),
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        onPressed:
            () => showDialog(
              context: context,
              builder: (context) {
                final TextEditingController titlecontroller =
                    TextEditingController();

                final TextEditingController discriptioncontroller =
                    TextEditingController();
                return AddTaskDialog(
                  title: "Add New Task",
                  titleController: titlecontroller,
                  descriptionController: discriptioncontroller,
                  onSave: () {
                    context.read<NotesBloc>().add(
                      AddNotes(
                        title: titlecontroller.text,
                        discription: discriptioncontroller.text,
                      ),
                    );
                    Navigator.pop(context);
                  },
                );
              },
            ),

        label: const Text("Add Task"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
