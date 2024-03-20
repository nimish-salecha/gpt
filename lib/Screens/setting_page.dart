//Setting page

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(Settings_tab());
}

//------------gpt----------
class Settings_tab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSettingsOption('Account', [
            'Change Password',
            'Change Username',
            'Change Email',
          ]),
          _buildSettingsOption('Preference', [
            'Theme',
            'Language',
            'Font Size',
          ]),
          _buildSettingsOption('Notification', [
            'Push Notifications',
            'Email Notifications',
          ]),
          _buildSettingsOption('Recommendation', [
            'Enable Recommendations',
            'Recommended Topics',
          ]),
          _buildSettingsOption('FAQ', []),
          _buildSettingsOption('Legal (T&C)', []),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(String title, List<String> subOptions) {
    return ExpansionTile(
      title: Text(title),
      children: subOptions.map((option) => _buildSubOption(option)).toList(),
    );
  }

  Widget _buildSubOption(String option) {
    return ListTile(
      title: Text(option),
      onTap: () {
        // Handle sub-option tap
        print('Tapped on $option');
      },
    );
  }
}


// ignore: use_key_in_widget_constructors
// class Settings_tab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final dwidth = MediaQuery.of(context).size.width;
//     final dheight = MediaQuery.of(context).size.height;
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.grey[500],
//           title: const Text('Settings'),
//         ),

//         body: Column(),
//       ),
//     );
//   }
// }