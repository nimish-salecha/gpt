//width over in containers
// ABOUT US
// ignore_for_file: prefer_const_constructors, unused_field

import 'package:flutter/material.dart';

void main() {
  runApp(AboutUs());
}

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeTransition(
              opacity: _fadeInAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(_controller),
                child: _buildAboutUsSection(),
              ),
            ),
            SizedBox(height: 20),
            FadeTransition(
              opacity: _fadeInAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(_controller),
                child: _buildFeaturesSection(),
              ),
            ),
            SizedBox(height: 20),
            FadeTransition(
              opacity: _fadeInAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(_controller),
                child: _buildWhyUseUsSection(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutUsSection() {
    return SingleChildScrollView(   //added new
      child: Container(
        padding: EdgeInsets.all(20),
        color: Colors.grey[200],
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'About NexoDeb8',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                Image.network(
                  "https://img.icons8.com/plasticine/100/about.png",
                  height: 100,
                  width: 100,
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'NexoDeb8 is a platform for hosting and participating in online debates. It provides a platform for users to engage in meaningful discussions and exchange ideas on various topics.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.blue[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Features',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildFeatureItem('User Authentication',
              'Secure user authentication system for safe participation.'),
          _buildFeatureItem('Debate Rooms',
              'Create and join debate rooms on various topics.'),
          _buildFeatureItem('Real-time Debates',
              'Engage in real-time debates with other users.'),
          _buildFeatureItem('User Profiles',
              'Customizable user profiles to showcase interests and achievements.'),
          // Add more features as needed
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description) {
    return ListTile(
      title: Text(title),
      subtitle: Text(description),
      leading: Icon(Icons.star), // Placeholder icon
    );
  }

  Widget _buildWhyUseUsSection() {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.green[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why Use NexoDeb8?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'NexoDeb8 provides a platform for users to express their opinions, engage in meaningful discussions, and broaden their perspectives. Whether you want to participate in debates or simply observe and learn, NexoDeb8 has something for everyone.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Image.network(
              "https://img.icons8.com/external-xnimrodx-lineal-color-xnimrodx/64/external-debate-politics-xnimrodx-lineal-color-xnimrodx-2.png")
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}