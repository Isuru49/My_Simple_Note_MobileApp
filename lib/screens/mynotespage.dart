import 'package:cw1/model/note.dart';
import 'package:cw1/screens/viewnotepage.dart';
import 'package:flutter/material.dart';
import 'package:cw1/screens/addnotespage.dart';
import '../repository/notes_repository.dart';

class MyNotesScreen extends StatefulWidget {
  const MyNotesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyNotesScreenState createState() => _MyNotesScreenState();
}

class _MyNotesScreenState extends State<MyNotesScreen> {
  final NotesRepository _notesRepository = NotesRepository();
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    _notes = await _notesRepository.getNotes();
    setState(() {});
  }

  void _addNote(String title, String description) async {
    final newNote = Note(
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );
    await _notesRepository.insert(newNote);
    _loadNotes(); 
  }

  void _editNote(int index, String title, String description) async {
    final updatedNote = _notes[index].copyWith(
      title: title,
      description: description,
    );
    await _notesRepository.update(updatedNote);
    _loadNotes(); 
  }

  void _deleteNote(Note note) async {
    await _notesRepository.delete(note);
    _loadNotes(); 
  }

  Future<void> _showDeleteConfirmationDialog(Note note) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                _deleteNote(note); 
                Navigator.of(context).pop(); 
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Notes'),
          backgroundColor: const Color(0xffF1F37B),
        ),
        body: _notes.isEmpty
            ? const Center(child: Text('No notes yet!'))
            : ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewNoteScreen(
                            note: _notes[index],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4.0,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _notes[index].title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              _notes[index].description,
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddNotes(
                                          onSaveNote: (title, description) {
                                            _editNote(index, title, description);
                                          },
                                          existingNote: {
                                            'title': _notes[index].title,
                                            'description': _notes[index].description,
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(_notes[index]);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddNotes(
                  onSaveNote: _addNote,
                  existingNote: {},
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
