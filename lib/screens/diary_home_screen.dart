import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class DiaryHomeScreen extends StatefulWidget {
  const DiaryHomeScreen({super.key});

  @override
  DiaryHomeScreenState createState() => DiaryHomeScreenState();
}

class DiaryHomeScreenState extends State<DiaryHomeScreen> {
  List<dynamic> entries = [];
  bool _isHovering = false; // Track hover state

  // Hardcoded API base URL
  final String apiBaseUrl = 'http://localhost/diary_app/backend.php'; // Update to your backend URL

  @override
  void initState() {
    super.initState();
    fetchEntries();
  }

  Future<void> fetchEntries() async {
    try {
      final response = await http.get(Uri.parse(apiBaseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          entries = jsonResponse;
        });
      } else {
        throw Exception('Failed to load entries');
      }
    } catch (e) {
      // Handle network or parsing errors
      showErrorDialog('Failed to load entries: ${e.toString()}');
    }
  }

  Future<void> addEntry(String text) async {
    final response = await http.post(
      Uri.parse(apiBaseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'text': text,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      fetchEntries();
    } else {
      showErrorDialog('Failed to create entry: ${response.body}');
    }
  }
Future<void> updateEntry(String id, String text) async {
  final response = await http.put(
    Uri.parse('$apiBaseUrl/$id'), // Point to edit_entry.php
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'text': text,
    }),
  );

  if (response.statusCode == 200) {
    fetchEntries();
  } else {
    showErrorDialog('Failed to update entry: ${response.body}');
  }
}


Future<void> deleteEntry(String id) async {
    final response = await http.delete(
        Uri.parse('$apiBaseUrl/$id'),
    );

    if (response.statusCode == 200) {
        fetchEntries();
    } else {
        showErrorDialog('Failed to delete entry: ${response.body}');
    }
}


  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showAddEntryDialog() {
    final TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Entry'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: 'Enter your diary text'),
            maxLines: null,
            keyboardType: TextInputType.multiline,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  addEntry(textController.text);
                  Navigator.of(context).pop();
                } else {
                  showErrorDialog('Text field cannot be empty');
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditEntryDialog(String id, String currentText) {
    final TextEditingController textController = TextEditingController(text: currentText);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Entry'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: 'Edit your diary text'),
            maxLines: null,
            keyboardType: TextInputType.multiline,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  updateEntry(id, textController.text);
                  Navigator.of(context).pop();
                } else {
                  showErrorDialog('Text field cannot be empty');
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this entry?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteEntry(id);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Solid Background Color
          Container(
            color: const Color.fromARGB(255, 3, 4, 79), // Change to your preferred background color
          ),
          Column(
            children: [
              // Headline Bar
              Container(
                padding: const EdgeInsets.all(25.0),
                child: const Text(
                  'Welcome to the Diary App!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255), // Headline text color
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'This app allows you to record your thoughts and experiences. Use this space to keep track of your daily entries. The list below shows all your diary entries, and you can add new ones using the button below.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
              Expanded(
                child: entries.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        itemCount: entries.length,
                        separatorBuilder: (context, index) => const Divider(
                          height: 2,
                          color: Color.fromARGB(255, 255, 255, 255), // line separator
                        ),
                        itemBuilder: (context, index) {
                          final entry = entries[index];
                          final String id = entry['id'].toString();
                          final String text = entry['text'] as String? ?? '';
                          final String date = entry['date'] as String? ?? '';

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          text,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          date,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Color.fromARGB(255, 0, 171, 250)),
                                        onPressed: () {
                                          _showEditEntryDialog(id, text);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Color.fromARGB(160, 255, 0, 0)),
                                        onPressed: () {
                                          _showDeleteConfirmationDialog(id);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          // Bottom App Bar
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Center(
              child: MouseRegion(
                onEnter: (_) {
                  setState(() {
                    _isHovering = true; // Change hover state to true
                  });
                },
                onExit: (_) {
                  setState(() {
                    _isHovering = false; // Change hover state to false
                  });
                },
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Increase padding
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Set background color for filled button
                    elevation: _isHovering ? 8 : 4, // Change elevation on hover
                  ),
                  onPressed: _showAddEntryDialog,
                  child: Text(
                    'Add Entry',
                    style: TextStyle(
                      fontSize: _isHovering ? 18 : 16, // Increase font size on hover
                    ),
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
