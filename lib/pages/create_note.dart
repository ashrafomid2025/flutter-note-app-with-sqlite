import 'package:flutter/material.dart';
import 'package:note_app/db/database-helper.dart';

class CreateNote extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final database = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    final notes = database.getNotes();
    print(notes);
    super.initState();
  }

  Future<void> submitform() async {
    await database.insertNewNote(
      _titleController.text.trim(),
      _descriptionController.text.trim(),
    );
    _titleController.clear();
    _descriptionController.clear();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("a note inserted successfully")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a note"),
        backgroundColor: Colors.orange.shade400,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              elevation: 2,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,

                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade600),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),

                          hintText: "Title",

                          hintStyle: TextStyle(color: Colors.grey.shade500),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "title required";
                          }
                          if (value.length < 3) {
                            return "title must be at least 3 chars";
                          }
                        },
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: "Note description",
                        ),
                        maxLines: 8,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "description is required";
                          }
                        },
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: submitform,
                        child: Text("Save"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
