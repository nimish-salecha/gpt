// ABOUT US

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
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Us',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Image.asset('assets/images/about_us_image.png'), // Placeholder image
        ],
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
          _buildFeatureItem('Feature 1', 'Lorem ipsum dolor sit amet.'),
          _buildFeatureItem('Feature 2', 'Consectetur adipiscing elit.'),
          _buildFeatureItem('Feature 3', 'Praesent libero.'),
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
            'Why Use Us?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Image.asset('assets/images/why_use_us_image.png'), // Placeholder image
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