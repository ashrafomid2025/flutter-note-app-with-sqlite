import 'package:flutter/material.dart';
import 'package:note_app/db/database-helper.dart';
import 'package:note_app/home_page.dart';
import 'package:note_app/main.dart';
import 'package:note_app/pages/update-note.dart';

class NoteDeatials extends StatefulWidget {
  final Map<String, dynamic> note;
  NoteDeatials({required this.note});

  @override
  State<NoteDeatials> createState() => _NoteDeatialsState();
}

class _NoteDeatialsState extends State<NoteDeatials> {
  final database = DatabaseHelper();
  Future<void> deleteSingleNote() async {
    await database.deleteNote(widget.note["id"]);
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        title: Text(widget.note['title']),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: MaterialButton(
              onPressed: deleteSingleNote,
              child: Icon(Icons.delete_outline),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateNote(note: widget.note),
                  ),
                );
              },
              child: Icon(Icons.edit),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  width: double.infinity,

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [Colors.white, Colors.grey.shade50],
                    ),
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 0,
                        blurRadius: 4,
                        color: Colors.grey.shade200,
                      ),
                      BoxShadow(
                        blurRadius: 4,
                        spreadRadius: 0,
                        color: Colors.grey.shade300,
                      ),
                    ],
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.note["title"].toString().toUpperCase(),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          widget.note['description'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w200,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
