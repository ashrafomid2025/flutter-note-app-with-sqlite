import 'package:flutter/material.dart';

class UpdateNote extends StatefulWidget {
  final Map<String, dynamic> note;
  UpdateNote({required this.note});
  @override
  State<StatefulWidget> createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController(
    text: widget.note["title"],
  );
  final TextEditingController _descriptionController = TextEditingController(
    text: note["desciption"],
  );
  Future<void> submitform() async {
    if (_formKey.currentState!.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
