//Setting page

//v2
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpt/screens/setting_pages/ThemeProvider.dart';
import 'package:gpt/screens/setting_pages/change_pass.dart';
import 'package:gpt/screens/setting_pages/delete_acc.dart';
import 'package:gpt/screens/setting_pages/disbale_acc.dart';
import 'package:gpt/screens/setting_pages/help.dart';
import 'package:gpt/screens/setting_pages/legal.dart';
import 'package:gpt/screens/setting_pages/termsofusepage.dart';
import 'package:gpt/screens/setting_pages/version.dart';

class MainOption {
  final String title;
  final List<SubOption> subOptions;
  final IconData icon;

  MainOption(
      {required this.title, required this.subOptions, required this.icon});
}

class SubOption {
  final String title;
  final Function onTap;
  final IconData? icon;

  SubOption({required this.title, required this.onTap, this.icon});
}

class OptionScreen extends StatelessWidget {
  final MainOption mainOption;

  OptionScreen({required this.mainOption});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
        title: Text(mainOption.title),
      ),
      body: ListView(
        children: mainOption.subOptions.map((subOption) {
          return ListTile(
            title: Text(
              subOption.title,
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(
              subOption.icon ?? Icons.info,
              color: Colors.blue,
            ),
            onTap: () {
              subOption.onTap();
            },
          );
        }).toList(),
      ),
    );
  }
}

void main() {
  runApp(Settings_tab());
}

class Settings_tab extends StatelessWidget {
  final List<MainOption> mainOptions = [
    MainOption(
      title: 'Account',
      subOptions: [
        SubOption(
          title: 'Change Password',
          onTap: () {
            Get.to(() => PasswordResetPage());
          },
          icon: Icons.lock,
        ),
        SubOption(
          title: 'Disable Account',
          onTap: () {
            Get.to(() => DisableAccountPage());
          },
          icon: Icons.block,
        ),
        SubOption(
          title: 'Delete Account',
          onTap: () {
            Get.to(() => DeleteAccountPage());
          },
          icon: Icons.delete,
        ),
      ],
      icon: Icons.account_circle,
    ),
    MainOption(
      title: 'Help',
      subOptions: [
        SubOption(
          title: 'How can I help you?',
          onTap: () {
            Get.to(() => HelpPage());
          },
          icon: Icons.help,
        ),
      ],
      icon: Icons.help,
    ),
    MainOption(
      title: 'Terms of Use',
      subOptions: [
        SubOption(
          title: 'Terms of Use',
          onTap: () {
            Get.to(() => TermsOfUsePage());
          },
          icon: Icons.description,
        ),
      ],
      icon: Icons.description,
    ),
    MainOption(
      title: 'Legal & Version',
      subOptions: [
        SubOption(
          title: 'Legal',
          onTap: () {
            Get.to(() => LegalPage());
          },
          icon: Icons.gavel,
        ),
        SubOption(
          title: 'Version',
          onTap: () {
            Get.to(() => VersionPage());
          },
          icon: Icons.info,
        ),
      ],
      icon: Icons.info,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ListView(
            children: mainOptions.map((mainOption) {
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    mainOption.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(
                      mainOption.icon,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OptionScreen(mainOption: mainOption),
                      ),
                    );
                  },
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}


//  nimish- v1  option under option with (name of inside option in main opt)
/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpt/screens/about_us.dart';

class MainOption {
  final String title;
  final List<SubOption> subOptions;

  MainOption({required this.title, required this.subOptions});
}

class SubOption {
  final String title;
  final Function onTap;

  SubOption({required this.title, required this.onTap});
}

class OptionScreen extends StatelessWidget {
  final MainOption mainOption;

  OptionScreen({required this.mainOption});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
        title: Text(mainOption.title),
      ),
      body: ListView(
        children: mainOption.subOptions.map((subOption) {
          return ListTile(
            title: Text(subOption.title),
            onTap: () {
              subOption.onTap();
            },
          );
        }).toList(),
      ),
    );
  }
}

void main() {
  runApp(Settings_tab());
}

class Settings_tab extends StatelessWidget {
  final List<MainOption> mainOptions = [
    MainOption(
      title: 'Account',
      subOptions: [
        SubOption(
          title: 'Change Password',
          onTap: () {
            // Get.to(() => );
          },
        ),
        SubOption(
          title: 'Email',
          onTap: () {

          },
        ),
      ],
    ),
    MainOption(
      title: 'Preference',
      subOptions: [
        SubOption(
          title: 'Theme',
          onTap: () {
            //will give button to switch between dark and light mode
          },
        ),
        SubOption(
          title: 'Language',
          onTap: () {
            // Perform action for suboption 2.2
          },
        ),
      ],
    ),
    MainOption(
      title: 'Notification',
      subOptions: [
        SubOption(
          title: 'Pause Notifications',
          onTap: () {
            
          },
        ),
        SubOption(
          title: 'Email Notifications',
          onTap: () {
            // Get.to(() => );
          },
        ),
      ],
    ),
    MainOption(
      title: 'Recommendation',
      subOptions: [
        SubOption(
          title: 'Enable Recommendations',
          onTap: () {
            
          },
        ),
        SubOption(
          title: 'Recommended Topics',
          onTap: () {
            // Get.to(() => );
          },
        ),
      ],
    ),
    MainOption(
      title: 'FAQs',
      subOptions: [
        SubOption(
          title: 'Questions 1',
          onTap: () {
            
          },
        ),
        SubOption(
          title: 'Question 2',
          onTap: () {
            // Perform action for suboption 2.2
          },
        ),
      ],
    ),
    MainOption(
      title: 'Legal [T&Cs]',
      subOptions: [
        SubOption(
          title: 'Legal(version, etc)',
          onTap: () {
            Get.to(() => AboutUs());
          },
        ),
        SubOption(
          title: 'T&C (paras)',
          onTap: () {
            // Perform action for suboption 2.2
          },
        ),
      ],
    ),
  ];
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: ListView(
          children: mainOptions.map((mainOption) {
            // Concatenate titles of all sub-options
            String subOptionsText = mainOption.subOptions.isNotEmpty
                ? mainOption.subOptions.map((subOption) => subOption.title).join(', ')
                : 'No sub-options available';

            return ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mainOption.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2), // Add some space between main option title and sub-options text
                  Text(
                    subOptionsText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OptionScreen(mainOption: mainOption),
                  ),
                );
              },
              trailing: Icon(Icons.keyboard_arrow_right), // Icon to the right
            );
          }).toList(),
        ),
      ),
    );
  }
}
*/