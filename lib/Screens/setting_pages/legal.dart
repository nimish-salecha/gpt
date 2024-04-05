import 'package:flutter/material.dart';

class LegalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Legal Information'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Use',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildParagraph(
                'Welcome to NexoDebate! By accessing or using our platform, you agree to comply with these Terms of Use and our Privacy Policy. If you do not agree with these terms, please do not use our app.'),
            SizedBox(height: 20),
            _buildParagraph(
                '1. User Accounts: You may be required to create an account to access certain features of our app. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.'),
            _buildParagraph(
                '2. Content: Users are solely responsible for the content they post on our platform. We reserve the right to remove any content that violates our Community Guidelines or these Terms of Use.'),
            _buildParagraph(
                '3. Intellectual Property: All content and materials available on NexoDebate, including but not limited to text, graphics, logos, images, and software, are the property of NexoDebate or its licensors and are protected by intellectual property laws.'),
            _buildParagraph(
                '4. Limitation of Liability: NexoDebate shall not be liable for any indirect, incidental, special, consequential, or punitive damages arising out of or in connection with your use of our app.'),
            SizedBox(height: 20),
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildParagraph(
                'Your privacy is important to us. Our Privacy Policy explains how we collect, use, and disclose information about you. By using our app, you consent to the collection and use of your information as described in our Privacy Policy.'),
            SizedBox(height: 20),
            Text(
              'Dispute Resolution',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildParagraph(
                'Any dispute arising out of or relating to these Terms of Use or your use of NexoDebate shall be resolved through binding arbitration conducted by a neutral arbitrator.'),
            SizedBox(height: 20),
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildParagraph(
                'If you have any questions or concerns about our Terms of Use, Privacy Policy, or practices, please contact us at support@nexodebate.com.'),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
