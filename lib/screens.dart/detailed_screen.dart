import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/bloc/notes_bloc.dart';

import 'package:todolist/models/notes_model.dart';
import 'package:todolist/screens.dart/widgets/dialogbox.dart';
import 'package:todolist/services/api_services.dart';

class NoteDetailScreen extends StatelessWidget {
  final String id;

  NoteDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    context.read<NotesBloc>().add(Getdetailedinfo(id: id));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Details'),
        elevation: 4,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<NotesBloc, NotesState>(
          builder: (context, snapshot) {
            if (snapshot is NoteLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot is NotesError) {
              return Center(child: Text(snapshot.error));
            }
            if (snapshot is NoteLoaded) {
              return Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Note Header
                      Row(
                        children: [
                          Icon(
                            Icons.note_alt,
                            color: Colors.deepPurple,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Note Details',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple[800],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 40, color: Colors.grey),

                      
                      Text(
                        'Title',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        snapshot.note.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),

                   
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        snapshot.note.description,
                        style: const TextStyle(fontSize: 18, height: 1.4),
                      ),
                      const SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                            
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.deepPurple,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              TextEditingController titlecontroller =
                                  TextEditingController(
                                    text: snapshot.note.title,
                                  );

                              TextEditingController discriptioncontroller =
                                  TextEditingController(
                                    text: snapshot.note.description,
                                  );
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AddTaskDialog(
                                      title: "Edit Task",
                                      titleController: titlecontroller,
                                      descriptionController:
                                          discriptioncontroller,
                                      onSave: () {
                                        context.read<NotesBloc>().add(
                                          EditNotes(
                                            id: id,
                                            discription:
                                                discriptioncontroller.text,
                                            title: titlecontroller.text,
                                          ),
                                        );

                                        Navigator.pop(context);
                                      },
                                    ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Edit'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
