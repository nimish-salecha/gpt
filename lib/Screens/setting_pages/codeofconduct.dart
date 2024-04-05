import 'package:flutter/material.dart';

class CodeOfConductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Code of Conduct'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NexoDeb8 Comprehensive Code of Conduct',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              '1. Introduction',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '1.1 Purpose',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'The purpose of this Code of Conduct is to establish a framework for maintaining a positive, respectful, and welcoming environment on NexoDeb8. These guidelines are designed to ensure that all users can engage in discussions and debates without fear of harassment, discrimination, or hostility.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            Text(
              '1.2 Scope',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'This Code of Conduct applies to all users of NexoDeb8, including registered members, moderators, administrators, and guests. It governs behavior within the platform\'s digital spaces, including forums, chat rooms, private messages, and any other interactive features.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              '2. General Principles',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '2.1 Respect and Civility',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'At the core of NexoDeb8\'s community is a commitment to treating all individuals with respect, dignity, and courtesy. Users are expected to engage in civil discourse, even when expressing disagreement or challenging viewpoints.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              '2.2 Diversity and Inclusion',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'NexoDeb8 embraces diversity and values the contributions of individuals from all backgrounds, cultures, and identities. Discriminatory behavior, including racism, sexism, homophobia, transphobia, ableism, or any form of bigotry, will not be tolerated.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              '2.3 Intellectual Integrity',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Users are encouraged to uphold principles of intellectual honesty and integrity in their contributions to discussions and debates. This includes citing sources, providing evidence to support arguments, and engaging in reasoned and well-informed dialogue.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              '3. User Accounts and Registration',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '3.1 Minimum Age Requirement',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Users must be at least 13 years old to register an account on NexoDeb8. This requirement is in accordance with legal regulations governing online services and ensures compliance with relevant privacy laws.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              '3.2 Account Creation',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'When creating an account on NexoDeb8, users are required to provide accurate and truthful information. Usernames, avatars, and profile information should not contain offensive, obscene, or inappropriate content.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              '3.3 Account Security',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Users are responsible for maintaining the security of their accounts and passwords. Sharing account credentials with others is strictly prohibited, as it may compromise the integrity of the platform and lead to unauthorized access.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              '3.4 Multiple Accounts',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Each user is permitted to have only one active account on NexoDeb8. Creating multiple accounts for deceptive purposes, such as evading bans or artificially inflating support for a particular viewpoint, is strictly prohibited.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              '3.5 Account Suspension and Termination',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'NexoDeb8 reserves the right to suspend or terminate user accounts that violate the terms of this Code of Conduct or engage in prohibited behavior. Suspended or terminated users may appeal their account status by following the established appeals process.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              '4. Content Guidelines',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '4.1 Originality and Attribution',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Users should only post content that they have the legal right to share. Plagiarism, copyright infringement, or unauthorized use of intellectual property is prohibited. Proper attribution should be given when sharing content created by others.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              '4.2 Objectionable Content',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Content that contains hate speech, violence, explicit material, or illegal activities is strictly prohibited on NexoDeb8. Users should exercise discretion and refrain from posting or linking to content that may be considered offensive or inappropriate.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              '4.3 Commercial Advertising',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Spamming or engaging in commercial advertising on NexoDeb8 without prior authorization is prohibited. Users should refrain from promoting products, services, or commercial interests within the platform\'s digital spaces.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              '5. Conduct in Discussions and Debates',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '5.1 Constructive Dialogue',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'NexoDeb8 encourages users to engage in constructive and respectful dialogue, even when expressing differing opinions or viewpoints. Arguments should be supported by evidence, reasoned analysis, and logical reasoning.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              '5.2 Respectful Disagreement',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Disagreement is a natural part of debate, but it should be expressed in a respectful and courteous manner. Personal attacks, insults, or harassment directed at other users are strictly prohibited and may result in disciplinary action.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              '5.3 Moderation of Discussions',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Moderators are responsible for enforcing the Code of Conduct and maintaining order within discussions and debates. They may intervene to address violations, issue warnings, or take disciplinary action as necessary to uphold community standards.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              '6. Reporting Violations',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '6.1 Reporting Mechanism',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Users who encounter behavior that violates the Code of Conduct are encouraged to report it to the moderation team. Reports should include specific details, evidence, and relevant context to facilitate the investigation process.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              '6.2 False Reports',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Submitting false or malicious reports against other users is prohibited and may result in disciplinary action. Users should exercise integrity and discretion when reporting violations and refrain from abusing the reporting system.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              '7. Amendments and Updates',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '7.1 Revision of Guidelines',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'NexoDeb8 reserves the right to revise or update the Code of Conduct as needed to reflect changes in community standards, platform policies, or legal requirements. Users will be notified of any significant updates to the Code of Conduct.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              '7.2 Compliance with Guidelines',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'All users of NexoDeb8 are expected to comply with the terms of this Code of Conduct and uphold the values of our community. Failure to adhere to these guidelines may result in disciplinary action, including warnings, suspensions, or account termination.',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'NexoDeb8 Code of Conduct',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: CodeOfConductPage(),
  ));
}
