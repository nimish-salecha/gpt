import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How Can I Help You?'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFAQItem(
              question: 'How do I sign up for an account on NexoDebate?',
              answer:
                  'To sign up for an account on NexoDebate, simply navigate to the sign-up page and provide the required information such as email, username, and password. Once registered, you can start using the app to participate in debates.',
            ),
            SizedBox(height: 20),
            _buildFAQItem(
              question:
                  'Can I participate in debates without creating an account?',
              answer:
                  'No, you need to create an account on NexoDebate in order to participate in debates. This ensures that users can maintain a consistent identity during discussions and helps in moderating the platform.',
            ),
            SizedBox(height: 20),
            _buildFAQItem(
              question: 'How can I reset my password if I forget it?',
              answer:
                  'If you forget your password, you can use the "Forgot Password" option on the login page. This will prompt you to enter your email address, and a password reset link will be sent to your email. Follow the link to reset your password.',
            ),
            SizedBox(height: 20),
            _buildFAQItem(
              question:
                  'Is NexoDebate available on both Android and iOS platforms?',
              answer:
                  'Yes, NexoDebate is available on both Android and iOS platforms. You can download the app from the Google Play Store for Android devices and the Apple App Store for iOS devices.',
            ),
            SizedBox(height: 20),
            _buildFAQItem(
              question:
                  'Are the debates moderated to ensure respectful discussions?',
              answer:
                  'Yes, the debates on NexoDebate are moderated to ensure that discussions remain respectful and constructive. Any inappropriate behavior or content is promptly addressed by the moderators.',
            ),
            SizedBox(height: 20),
            _buildFAQItem(
              question: 'Can I host debates on any topic of my choice?',
              answer:
                  'Yes, you can host debates on any topic of your choice on NexoDebate. Simply create a new debate, provide the topic, set the details such as date and time, and invite participants to join.',
            ),
            SizedBox(height: 20),
            _buildFAQItem(
              question:
                  'What are the benefits of joining debates on NexoDebate?',
              answer:
                  'Joining debates on NexoDebate allows you to engage in meaningful discussions, exchange ideas with others, improve your communication skills, and gain insights into various topics and viewpoints.',
            ),
            SizedBox(height: 20),
            _buildFAQItem(
              question:
                  'How can I invite friends to join a debate I\'m hosting?',
              answer:
                  'To invite friends to join a debate you\'re hosting, simply share the debate link with them via email, social media, or any other messaging platform. They can click on the link to join the debate.',
            ),
            SizedBox(height: 20),
            _buildFAQItem(
              question:
                  'Are there any restrictions on the number of debates a user can join?',
              answer:
                  'No, there are no restrictions on the number of debates a user can join on NexoDebate. You can join as many debates as you want, provided that they align with your interests and availability.',
            ),
            SizedBox(height: 20),
            _buildFAQItem(
              question:
                  'Is there a rating system to evaluate participants\' contributions in debates?',
              answer:
                  'Yes, NexoDebate has a rating system to evaluate participants\' contributions in debates. Users can rate each other based on the quality of their arguments, engagement level, and overall conduct during the debate.',
            ),
            SizedBox(height: 20),
            _buildFAQItem(
              question:
                  'Can I report inappropriate behavior or content during a debate?',
              answer:
                  'Yes, you can report inappropriate behavior or content during a debate by using the "Report" feature available in the app. This helps in maintaining a safe and respectful environment for all users.',
            ),
            SizedBox(height: 20),
            _buildFAQItem(
              question: 'How can I change my profile settings and preferences?',
              answer:
                  'To change your profile settings and preferences, navigate to the "Settings" section of the app. From there, you can update your profile information, notification settings, privacy preferences, and more.',
            ),
            SizedBox(height: 20),
            _buildFAQItem(
              question:
                  'Is there a notification system to alert users about upcoming debates?',
              answer:
                  'Yes, NexoDebate has a notification system to alert users about upcoming debates, new replies to their comments, and other relevant updates. You can customize your notification preferences in the app settings.',
            ),
            SizedBox(height: 20),
            _buildFAQItem(
              question: 'Are there any age restrictions for using NexoDebate?',
              answer:
                  'Yes, NexoDebate is intended for users who are at least 13 years old or older. Users below the age of 13 are not allowed to create an account or participate in debates on the platform.',
            ),
            SizedBox(height: 20),
            _buildFAQItem(
              question: 'How often are new debates added to the platform?',
              answer:
                  'New debates are added to the platform regularly, depending on the availability of topics and user demand. You can check the "Upcoming Debates" section of the app to stay updated on the latest debate schedule.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          answer,
          style: TextStyle(fontSize: 16),
        ),
        Divider(),
      ],
    );
  }
}
