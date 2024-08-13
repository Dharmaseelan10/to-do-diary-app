import 'package:flutter/material.dart';

class DiaryEntryWidget extends StatelessWidget {
  const DiaryEntryWidget({super.key}); // Use super.key

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: const Text('Diary Entry'),
    );
  }
}
