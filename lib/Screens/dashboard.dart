//--------V2---forrmated & (with appbar)-----------------
// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_final_fields, prefer_const_constructors

import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    PastClashes(),
    FutureDebates(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dwidth = MediaQuery.of(context).size.width;
    final dheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text('User Dashboard'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {}, //user profil link
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top: dheight * 0.01,
                left: dwidth * 0.02,
                bottom: dheight * 0.03),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://d2qp0siotla746.cloudfront.net/img/use-cases/profile-picture/template_0.jpg'),
                ),
                Padding(
                  padding: EdgeInsets.only(left: dwidth * 0.08),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 24.0,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent), // Remove background color
                          overlayColor: MaterialStateProperty.all<Color>(
                              Colors.transparent), // Remove overlay color
                        ),
                        child: Text('Edit Profile'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text('Participation: value'),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text('Winner: value'),
              ),
            ],
          ),
            SizedBox(height: dheight*0.02,),
           Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () => _onItemTapped(0),
          child: Row(
            children: [
              Icon(Icons.history),
              SizedBox(width: 6), // Add some spacing between icon and text
              Text('Past Clashes'),
            ],
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => _onItemTapped(0),
          child: Row(
            children: [
              Icon(Icons.history),
              SizedBox(width: 6), // Add some spacing between icon and text
              Text('Future Clashes'),
            ],
          ),
        ),
        ],
      ),
      
          SizedBox(height: dheight*0.02,),
          //ans of floating futton
          _widgetOptions.elementAt(_selectedIndex),
        ],
      ),
    );
  }
}

class PastClashes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Past Clashes'),
    );
  }
}

class FutureDebates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Future Debates'),
    );
  }
}


// //-------------bing(unformated and with bellow button[like home, search, profil, reel of insta])----------------
// // ignore_for_file: prefer_const_constructors, prefer_final_fields, library_private_types_in_public_api

// import 'package:flutter/material.dart';

// class Dashboard extends StatefulWidget {
//   @override
//   _DashboardState createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard> {
//   int _selectedIndex = 0;

//   static List<Widget> _widgetOptions = <Widget>[
//     PastClashes(),
//     FutureDebates(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Dashboard'),
//       ),
//       body: Column(
//         children: <Widget>[
//           CircleAvatar(
//             radius: 50,
//             backgroundImage: NetworkImage('imageUrl'),
//           ),
//           Text('Username'),
//           ElevatedButton(
//             onPressed: () {},
//             child: Text('Edit Profile'),
//           ),
//           ElevatedButton(
//             onPressed: () {},
//             child: Text('Share Profile'),
//           ),
//           Text('Participation: value'),
//           Text('Winner: value'),
//           _widgetOptions.elementAt(_selectedIndex),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.history),
//             label: 'Past Clashes',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.calendar_today),
//             label: 'Future Debates',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.amber[800],
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

// class PastClashes extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text('Past Clashes'),
//     );
//   }
// }

// class FutureDebates extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text('Future Debates'),
//     );
//   }
// }


//---------------------------------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:gpt/screens/header.dart';

// void main() {
//   runApp(Home());
// }

// // ignore: use_key_in_widget_constructors
// class Home extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar:AppBar(
//           title: Header(),
//         ),
        
//         body: Text("jdwnekad"),        
          
//       ),
//     );
//   }
// }


// Hey i am creating a online real time video debate platform of platform using flutter, agora and firebase.(Here user can host a debate and other can participate in it in real time and there are much more featues will i will tell you when needed or you can even ask me for that)
// create a user dashboard containing  profile picture, username, edit profil button, share profile button, 2 boxes which sholes value of participation in and another show value of Winner(number of debates won), after all this we may have 2 button one of Past clashes(past debates in which user had participated) and another button which have Future Debate (Upcoming debates for which i had registerd)  and take care of that this 2 button must not redirect to another page, content of this must be shown on the same page (for example how we see post, reel and taged in our instagaram profile page)  try to make page responsive and use flutter.