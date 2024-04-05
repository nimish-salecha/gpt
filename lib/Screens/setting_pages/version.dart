import 'package:flutter/material.dart';

class VersionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Version Info'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Version: 1.0.0',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Release Notes:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildReleaseNoteItem(
              version: '1.0.0',
              note: 'Initial release of NexoDebate app.',
            ),
            SizedBox(height: 20),
            Text(
              'Previous Versions:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildReleaseNoteItem(
              version: '0.1.0',
              note: 'Beta version with basic features.',
            ),
            SizedBox(height: 10),
            _buildReleaseNoteItem(
              version: '0.0.1',
              note: 'Alpha version for internal testing.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReleaseNoteItem(
      {required String version, required String note}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Version: $version',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          note,
          style: TextStyle(fontSize: 16),
        ),
        Divider(),
      ],
    );
  }
}
