// //Search debates and add filter and sort

//hiya v2
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DebateSearchPage extends StatefulWidget {
  @override
  _DebateSearchPageState createState() => _DebateSearchPageState();
}

class _DebateSearchPageState extends State<DebateSearchPage> {
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<QueryDocumentSnapshot> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search debates',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  _searchDebates(value);
                },
              )
            : Text('Search Debates'),
        actions: [
          IconButton(
            icon: _isSearching ? Icon(Icons.close) : Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                _searchController.clear();
                _searchResults.clear();
              });
            },
          ),
        ],
      ),
      body: _isSearching
          ? _buildSearchResults()
          : Center(
              child: Text('Start searching by tapping the search icon'),
            ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text('No results found'),
      );
    } else {
      return ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final debate = _searchResults[index];
          return ListTile(
            title: Text(debate['title']),
            subtitle: FutureBuilder(
              future: _getUserName(debate['userId']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Host: Loading...');
                } else {
                  return Text('Host: ${snapshot.data}');
                }
              },
            ),
            trailing: ElevatedButton(
              onPressed: () {
                // Implement join functionality
              },
              child: Text('Join'),
            ),
            // Add more details as needed
          );
        },
      );
    }
  }

  Future<String> _getUserName(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      return userSnapshot['username'];
    } catch (e) {
      print('Error fetching username: $e');
      return 'Unknown';
    }
  }

  void _searchDebates(String query) async {
    if (query.isNotEmpty) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('debates')
            .where('title', isGreaterThanOrEqualTo: query)
            .get();

        setState(() {
          _searchResults = querySnapshot.docs;
        });
      } catch (e) {
        print('Error searching debates: $e');
      }
    } else {
      setState(() {
        _searchResults.clear();
      });
    }
  }
}


//hiyu v1
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class DebateSearchPage extends StatefulWidget {
//   @override
//   _DebateSearchPageState createState() => _DebateSearchPageState();
// }

// class _DebateSearchPageState extends State<DebateSearchPage> {
//   TextEditingController _searchController = TextEditingController();
//   bool _isSearching = false;
//   List<QueryDocumentSnapshot> _searchResults = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: _isSearching
//             ? TextField(
//                 controller: _searchController,
//                 decoration: InputDecoration(
//                   hintText: 'Search debates',
//                   border: InputBorder.none,
//                 ),
//                 onChanged: (value) {
//                   _searchDebates(value);
//                 },
//               )
//             : Text('Search Debates'),
//         actions: [
//           IconButton(
//             icon: _isSearching ? Icon(Icons.close) : Icon(Icons.search),
//             onPressed: () {
//               setState(() {
//                 _isSearching = !_isSearching;
//                 _searchController.clear();
//                 _searchResults.clear();
//               });
//             },
//           ),
//         ],
//       ),
//       body: _isSearching
//           ? _buildSearchResults()
//           : Center(
//               child: Text('Start searching by tapping the search icon'),
//             ),
//     );
//   }

//   Widget _buildSearchResults() {
//     if (_searchResults.isEmpty) {
//       return Center(
//         child: Text('No results found'),
//       );
//     } else {
//       return ListView.builder(
//         itemCount: _searchResults.length,
//         itemBuilder: (context, index) {
//           final debate = _searchResults[index];
//           return ListTile(
//             title: Text(debate['title']),
//             subtitle: Text('User ID: ${debate['userId']}'),
//             // Add more details as needed
//           );
//         },
//       );
//     }
//   }

//   void _searchDebates(String query) async {
//     if (query.isNotEmpty) {
//       try {
//         QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//             .collection('debates')
//             .where('title', isGreaterThanOrEqualTo: query)
//             .get();

//         setState(() {
//           _searchResults = querySnapshot.docs;
//         });
//       } catch (e) {
//         print('Error searching debates: $e');
//       }
//     } else {
//       setState(() {
//         _searchResults.clear();
//       });
//     }
//   }
// }