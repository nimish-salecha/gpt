import 'package:flutter/material.dart';

// void main() {
//   runApp(TermsOfUsePage());
// }

class TermsOfUsePage extends StatefulWidget {
  @override
  _TermsOfUsePage createState() => _TermsOfUsePage();
}

class _TermsOfUsePage extends State<TermsOfUsePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms of Use'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Use Agreement',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Use your preferred color
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Welcome to NexoDebate!',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Please read these terms carefully before using our platform. By accessing or using NexoDebate, you agree to be bound by these terms. If you do not agree to all the terms and conditions of this agreement, then you may not access the website or use any services.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'User Conduct',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'You agree not to engage in any of the following prohibited activities: \n'
              '- Violating laws or regulations \n'
              '- Posting harmful content \n'
              '- Impersonating others \n'
              '- Interfering with security \n'
              '...and more.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Intellectual Property',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'The content on NexoDebate, including but not limited to text, graphics, logos, images, and software, is the property of NexoDebate and is protected by copyright laws.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Disclaimer',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'NexoDebate is provided "as is" without any warranties, express or implied. We do not guarantee the accuracy, completeness, or reliability of any content on our platform.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Governing Law',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'These terms shall be governed by and construed in accordance with the laws of [Your Country/State], without regard to its conflict of law provisions.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
