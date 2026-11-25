import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:note_app/db/database-helper.dart';
import 'package:note_app/pages/create_note.dart';
import 'package:note_app/pages/note-details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final database = DatabaseHelper();
  @override
  void initState() {
    super.initState();
    loadLanguage();
    fetchNotes();
  }

  List<Map<String, dynamic>> allNotes = [];
  List<Map<String, dynamic>> originalNotes = [];
  Future<void> fetchNotes() async {
    final notes = await database.getNotes();
    setState(() {
      allNotes = notes;
      originalNotes = notes;
    });
  }

  Locale _locale = Locale('en');
  //  {} set, object, map, string
  Map<String, dynamic> _localization = {};
  TextEditingController search = TextEditingController();

  Future<void> loadLanguage() async {
    final file = _locale.languageCode == "en"
        ? "assets/l10n/en.json"
        : "assets/l10n/fa.json";

    final rawData = await rootBundle.loadString(file);
    _localization = jsonDecode(rawData);
  }

  Future<void> ChangeLanguage(String newLanguage) async {
    final file = newLanguage == "en"
        ? "assets/l10n/en.json"
        : "assets/l10n/fa.json";

    final rawData = await rootBundle.loadString(file);
    setState(() {
      _locale = Locale(newLanguage);
      _localization = jsonDecode(rawData);
    });
  }

  Future<void> handleSearch() async {
    final filteredNotes = await database.SearchNote(search.text.trim());
    setState(() {
      allNotes = filteredNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: [Locale("en"), Locale("fa")],
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          title: Text(
            "Notes",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateNote()),
            );
          },

          child: Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'All Notes',
                style: TextStyle(
                  fontSize: 38,
                  overflow: TextOverflow.clip,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 9),

              TextField(
                controller: search,
                onChanged: (value) async {
                  await handleSearch();
                },
                decoration: InputDecoration(
                  hintText: "Note title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: allNotes.length,
                  itemBuilder: (context, index) {
                    final dateToString = DateTime.parse(
                      allNotes[index]["created_at"],
                    );
                    final finalDate = DateFormat(
                      'yyyy-MM-dd HH:mm:ss',
                    ).format(dateToString);

                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NoteDeatials(note: allNotes[index]),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: 2,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                allNotes[index]["title"],
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(finalDate.toString()),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
