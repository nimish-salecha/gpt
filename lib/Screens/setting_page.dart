//Setting page
//used list  --  option in option -- at last option redirect to  page if needed
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

        //without sub option place holder          
  // @override       
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     home: Scaffold(
  //       appBar: AppBar(
  //         title: Text('Settings'),
  //       ),
  //       body: ListView(
  //         children: mainOptions.map((mainOption) {
  //           return ListTile(
  //             title: Row(
  //               children: [
  //                 Expanded(
  //                   child: Text(mainOption.title),
  //                 ),
  //                 Icon(Icons.keyboard_arrow_right), // Icon to the right
  //               ],
  //             ),
  //             onTap: () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => OptionScreen(mainOption: mainOption),
  //                 ),
  //               );
  //             },
  //           );
  //         }).toList(),
  //       ),
  //     ),
  //   );
  // }
}

//---------complete code------ List view(Dropdown menu)------need to use new page for every sub option

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// void main() {
//   runApp(Settings_tab());
// }

// //------------gpt----------
// class Settings_tab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Settings'),
//       ),
//       body: ListView(
//         children: [
//           _buildSettingsOption('Account', [
//             'Change Password',
//             'Change Username',
//             'Change Email',
//           ]),
//           _buildSettingsOption('Preference', [
//             'Theme',
//             'Language',
//             'Font Size',
//           ]),
//           _buildSettingsOption('Notification', [
//             'Push Notifications',
//             'Email Notifications',
//           ]),
//           _buildSettingsOption('Recommendation', [
//             'Enable Recommendations',
//             'Recommended Topics',
//           ]),
//           _buildSettingsOption('FAQ', []),
//           _buildSettingsOption('Legal (T&C)', []),
//         ],
//       ),
//     );
//   }

//   Widget _buildSettingsOption(String title, List<String> subOptions) {
//     return ExpansionTile(
//       title: Text(title),
//       children: subOptions.map((option) => _buildSubOption(option)).toList(),
//     );
//   }

//   Widget _buildSubOption(String option) {
//     return ListTile(
//       title: Text(option),
//       onTap: () {
//         // Handle sub-option tap
//         print('Tapped on $option');
//       },
//     );
//   }
// }


// // ignore: use_key_in_widget_constructors
// // class Settings_tab extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     final dwidth = MediaQuery.of(context).size.width;
// //     final dheight = MediaQuery.of(context).size.height;
// //     return SafeArea(
// //       child: Scaffold(
// //         appBar: AppBar(
// //           backgroundColor: Colors.grey[500],
// //           title: const Text('Settings'),
// //         ),

// //         body: Column(),
// //       ),
// //     );
// //   }
// // }