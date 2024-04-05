import 'package:flutter/material.dart';

class ChangeThemePage extends StatefulWidget {
  @override
  _ChangeThemePageState createState() => _ChangeThemePageState();
}

class _ChangeThemePageState extends State<ChangeThemePage> {
  bool _isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Theme'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Toggle to change theme:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            SwitchListTile(
              title: Text('Dark Mode'),
              value: _isDarkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _isDarkModeEnabled = value;
                  _toggleTheme(value);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toggleTheme(bool isDarkMode) {
    if (isDarkMode) {
      // Set dark theme
      // You can replace the dark theme with your own dark theme
      // or use predefined themes like ThemeData.dark()
      _setTheme(ThemeData.dark());
    } else {
      // Set light theme
      // You can replace the light theme with your own light theme
      // or use predefined themes like ThemeData.light()
      _setTheme(ThemeData.light());
    }
  }

  void _setTheme(ThemeData theme) {
    // Set the theme for the entire app
    // You can also set theme for specific widgets using Theme widget
    // or MaterialApp theme property
    // For example: MaterialApp(theme: theme)
    // or Theme(data: theme, child: childWidget)
    // Here, I'm just setting the theme for the MaterialApp root widget
    // You may need to rebuild your UI after changing the theme
    // using setState() or other methods.
    Navigator.of(context).pop();
  }
}
