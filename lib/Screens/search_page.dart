//v6 --by nimish -- all working
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gpt/Screens/debate_details.dart';

class DebateSearchPage extends StatefulWidget {
  @override
  _DebateSearchPageState createState() => _DebateSearchPageState();
}

class _DebateSearchPageState extends State<DebateSearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debate Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Debates',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchDebates(_searchController.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text('No results found'),
      );
    } else {
      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            // On larger screens (web), show 4 debate cards in a row
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.75,
              ),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final debate = _searchResults[index];
                return _buildDebateCard(debate);
              },
            );
          } else {
            // On smaller screens (mobile), show 2 debate cards in a row
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.75,
              ),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final debate = _searchResults[index];
                return _buildDebateCard(debate);
              },
            );
          }
        },
      );
    }
  }

  Widget _buildDebateCard(DocumentSnapshot debate) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DebateDetailsPage(
              debateId: debate.id,
              dtitle: '',
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[200],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<String?>(
              future: _getThumbnailUrl(debate.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Icon(Icons.error);
                } else {
                  final thumbnailUrl = snapshot.data;
                  return thumbnailUrl != null
                      ? Image.network(
                          thumbnailUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 150.0,
                        )
                      : Image.asset(
                          'assets/category/debate.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 150.0,
                        );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    debate['title'] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  FutureBuilder(
                    future: _getUserName(debate['userId']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Host: Loading...');
                      } else if (snapshot.hasData) {
                        return Text('Host: ${snapshot.data}');
                      } else {
                        return Text('Host: Unknown');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



/*  old only for mobile not for web
  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text('No results found'),
      );
    } else {
  // 
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.75,
        ),
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final debate = _searchResults[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DebateDetailsPage(
                    debateId: debate.id,
                    dtitle: '',
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[200],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<String?>(
                    future: _getThumbnailUrl(debate.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Icon(Icons.error);
                      } else {
                        final thumbnailUrl = snapshot.data;
                        return thumbnailUrl != null
                            ? Image.network(
                                thumbnailUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 150.0,
                              )
                            : Image.asset(
                                'assets/category/debate.png',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 150.0,
                              );
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          debate['title'] ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        FutureBuilder(
                          future: _getUserName(debate['userId']),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text('Host: Loading...');
                            } else if (snapshot.hasData) {
                              return Text('Host: ${snapshot.data}');
                            } else {
                              return Text('Host: Unknown');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }*/

  Future<String?> _getThumbnailUrl(String debateId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('debates')
          .doc(debateId)
          .get();
      final data = snapshot.data();
      if (data != null && data.containsKey('_thumbnailUrl')) {
        return data['_thumbnailUrl'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching thumbnail URL: $e');
      return null;
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
      // Split the query into individual words
      List<String> keywords = query.split(' ');

      // Search by username if the query matches a username exactly
      QuerySnapshot usernameExactQuerySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('username', isEqualTo: query)
              .get();

      // If the query does not match a username exactly, search by title or category
      QuerySnapshot titleQuerySnapshot = await FirebaseFirestore.instance
          .collection('debates')
          .where('title', arrayContainsAny: keywords)
          .get();

      QuerySnapshot categoryQuerySnapshot = await FirebaseFirestore.instance
          .collection('debates')
          .where('category', arrayContainsAny: keywords)
          .get();

      // Combine all query snapshots
      List<QueryDocumentSnapshot> allResults = [
        ...titleQuerySnapshot.docs,
        ...categoryQuerySnapshot.docs,
      ];

      // Prioritize debates hosted by the user if username matches exactly
      if (usernameExactQuerySnapshot.docs.isNotEmpty) {
        List<QueryDocumentSnapshot> usernameResults = [];
        for (QueryDocumentSnapshot doc in usernameExactQuerySnapshot.docs) {
          QuerySnapshot result = await FirebaseFirestore.instance
              .collection('debates')
              .where('userId', isEqualTo: doc.id)
              .get();
          usernameResults.addAll(result.docs);
        }
        allResults.addAll(usernameResults);
      }

      // Filter out private debates
      List<QueryDocumentSnapshot> publicResults = allResults
          .where((doc) =>
              (doc.data() as Map<String, dynamic>)['privacy'] != 'Private')
          .toList();

      // Remove duplicates
      List<QueryDocumentSnapshot> uniqueResults =
          publicResults.toSet().toList();

      // Sort results based on relevance
      uniqueResults.sort((a, b) {
        String aTitle = (a.data() as Map<String, dynamic>)['title'];
        String bTitle = (b.data() as Map<String, dynamic>)['title'];
        int aScore = _calculateScore(aTitle, keywords);
        int bScore = _calculateScore(bTitle, keywords);
        return bScore.compareTo(aScore);
      });

      setState(() {
        _searchResults = uniqueResults;
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

int _calculateScore(String title, List<String> keywords) {
  // Calculate a score based on the similarity of the title to the query
  int score = 0;
  String lowercaseTitle = title.toLowerCase();
  for (String keyword in keywords) {
    if (lowercaseTitle.contains(keyword.toLowerCase())) {
      // Increase score if the keyword is found in the title
      score += 10;
      // Increase score further if the keyword matches at the beginning of the title
      if (lowercaseTitle.startsWith(keyword.toLowerCase())) {
        score += 5;
      }
    }
  }
  return score;
}


/*  working but unable to find mult word debate and some more like this
  void _searchDebates(String query) async {
  if (query.isNotEmpty) {
    try {
      // Search by username if the query matches a username exactly
      QuerySnapshot usernameExactQuerySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('username', isEqualTo: query)
              .get();

      // If the query does not match a username exactly, search by title or category
      QuerySnapshot titleQuerySnapshot = await FirebaseFirestore.instance
          .collection('debates')
          .where('title', isGreaterThanOrEqualTo: query)
          .get();

      QuerySnapshot categoryQuerySnapshot = await FirebaseFirestore.instance
          .collection('debates')
          .where('category', isGreaterThanOrEqualTo: query)
          .get();

      // Combine all query snapshots
      List<QueryDocumentSnapshot> allResults = [
        ...titleQuerySnapshot.docs,
        ...categoryQuerySnapshot.docs,
      ];

      // Prioritize debates hosted by the user if username matches exactly
      if (usernameExactQuerySnapshot.docs.isNotEmpty) {
  List<QueryDocumentSnapshot> usernameResults = [];
  for (QueryDocumentSnapshot doc in usernameExactQuerySnapshot.docs) {
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection('debates')
        .where('userId', isEqualTo: doc.id)
        .get();
    usernameResults.addAll(result.docs);
  }
  allResults.addAll(usernameResults);
}


      // Filter out private debates
      List<QueryDocumentSnapshot> publicResults = allResults
          .where((doc) => (doc.data() as Map<String, dynamic>)['privacy'] != 'Private')
          .toList();

      // Remove duplicates
      List<QueryDocumentSnapshot> uniqueResults =
          publicResults.toSet().toList();

      // Sort results based on relevance
      uniqueResults.sort((a, b) {
        String aTitle = (a.data() as Map<String, dynamic>)['title'];
        String bTitle = (b.data() as Map<String, dynamic>)['title'];
        int aScore = _calculateScore(aTitle, query);
        int bScore = _calculateScore(bTitle, query);
        return bScore.compareTo(aScore);
      });

      setState(() {
        _searchResults = uniqueResults;
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
int _calculateScore(String title, String query) {
  // Calculate a score based on the similarity of the title to the query
  // You can implement your scoring logic here
  int score = 0;
  if (title.toLowerCase().contains(query.toLowerCase())) {
    score += 10; // Increase score if the title contains the query
  }
  return score;
}*/
}



/*//v5 - nimish code working -- but unable to fetch thumbnail from firebae
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gpt/Screens/debate_details.dart';

class DebateSearchPage extends StatefulWidget {
  @override
  _DebateSearchPageState createState() => _DebateSearchPageState();
}

class _DebateSearchPageState extends State<DebateSearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debate Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Debates',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchDebates(_searchController.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text('No results found'),
      );
    } else {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.75,
        ),
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final debate = _searchResults[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DebateDetailsPage(
                    debateId: debate.id,
                    dtitle: '',
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[200],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<String?>(
  future: _getThumbnailUrl(debate['_thumbnailUrl']),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Icon(Icons.error);
    } else {
      final thumbnailUrl = snapshot.data;
      print('Thumbnail URL: $thumbnailUrl');
      return thumbnailUrl != null
          ? Image.network(
              thumbnailUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150.0,
            )
          : Image.asset(
              'assets/category/debate.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150.0,
            );
    }
  },
),

/*//unable to load any image
                  // FutureBuilder(
                  //   future: _getThumbnailUrl(debate['_thumbnailUrl']),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return CircularProgressIndicator();
                  //     } else if (snapshot.hasError) {
                  //       return Icon(Icons.error);
                  //     } else {
                  //       final thumbnailUrl = snapshot.data;
                  //       return thumbnailUrl != null
                  //           ? Image.network(
                  //               thumbnailUrl,
                  //               fit: BoxFit.cover,
                  //               width: double.infinity,
                  //               height: 150.0,
                  //             )
                  //           : Icon(Icons
                  //               .image); // Placeholder icon if thumbnailUrl is null
                  //     }
                  //   },
                  // ),*/
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          debate['title'] ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        FutureBuilder(
                          future: _getUserName(debate['userId']),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text('Host: Loading...');
                            } else if (snapshot.hasData) {
                              return Text('Host: ${snapshot.data}');
                            } else {
                              return Text('Host: Unknown');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

Future<String?> _getThumbnailUrl(String? thumbnailId) async {
  print(thumbnailId);
  if (thumbnailId == null) return null;
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('debates')
        .doc(thumbnailId)
        .get();
    final data = snapshot.data();
    print('Thumbnail Snapshot Data: $data');
    final thumbnailUrl = data?['_thumbnailUrl'];
    print('Thumbnail URL: $thumbnailUrl');
    return thumbnailUrl;
  } catch (e) {
    print('Error fetching thumbnail URL: $e');
    return null;
  }
}


//unable to load any image
  // Future<String?> _getThumbnailUrl(String? thumbnailId) async {
  //   if (thumbnailId == null) return null;
  //   try {
  //     final snapshot = await FirebaseFirestore.instance
  //         .collection('debates')
  //         .doc(thumbnailId)
  //         .get();
  //     return snapshot['_thumbnailUrl'];
  //   } catch (e) {
  //     print('Error fetching thumbnail URL: $e');
  //     return null;
  //   }
  // }

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
//search queary v2 - nimish
void _searchDebates(String query) async {
  if (query.isNotEmpty) {
    try {
      // Search by username if the query matches a username exactly
      QuerySnapshot usernameExactQuerySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('username', isEqualTo: query)
              .get();

      // If the query does not match a username exactly, search by title or category
      QuerySnapshot titleQuerySnapshot = await FirebaseFirestore.instance
          .collection('debates')
          .where('title', isGreaterThanOrEqualTo: query)
          .get();

      QuerySnapshot categoryQuerySnapshot = await FirebaseFirestore.instance
          .collection('debates')
          .where('category', isGreaterThanOrEqualTo: query)
          .get();

      // Combine all query snapshots
      List<QueryDocumentSnapshot> allResults = [
        ...titleQuerySnapshot.docs,
        ...categoryQuerySnapshot.docs,
      ];

      // Prioritize debates hosted by the user if username matches exactly
      if (usernameExactQuerySnapshot.docs.isNotEmpty) {
  List<QueryDocumentSnapshot> usernameResults = [];
  for (QueryDocumentSnapshot doc in usernameExactQuerySnapshot.docs) {
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection('debates')
        .where('userId', isEqualTo: doc.id)
        .get();
    usernameResults.addAll(result.docs);
  }
  allResults.addAll(usernameResults);
}


      // Filter out private debates
      List<QueryDocumentSnapshot> publicResults = allResults
          .where((doc) => (doc.data() as Map<String, dynamic>)['privacy'] != 'Private')
          .toList();

      // Remove duplicates
      List<QueryDocumentSnapshot> uniqueResults =
          publicResults.toSet().toList();

      // Sort results based on relevance
      uniqueResults.sort((a, b) {
        String aTitle = (a.data() as Map<String, dynamic>)['title'];
        String bTitle = (b.data() as Map<String, dynamic>)['title'];
        int aScore = _calculateScore(aTitle, query);
        int bScore = _calculateScore(bTitle, query);
        return bScore.compareTo(aScore);
      });

      setState(() {
        _searchResults = uniqueResults;
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

int _calculateScore(String title, String query) {
  // Calculate a score based on the similarity of the title to the query
  // You can implement your scoring logic here
  int score = 0;
  if (title.toLowerCase().contains(query.toLowerCase())) {
    score += 10; // Increase score if the title contains the query
  }
  return score;
}



/*//srearch queary new code -- with bing ai  -- nimish\
void _searchDebates(String query) async {
  if (query.isNotEmpty) {
    try {
      // Search by username if the query matches a username exactly
      QuerySnapshot usernameExactQuerySnapshot =
          await FirebaseFirestore.instance
              .collection('debates')
              .where('userId', isEqualTo: query)
              .get();

      // If the query does not match a username exactly, search by title or category
      QuerySnapshot titleQuerySnapshot = await FirebaseFirestore.instance
          .collection('debates')
          .where('title', isGreaterThanOrEqualTo: query)
          .get();

      QuerySnapshot categoryQuerySnapshot = await FirebaseFirestore.instance
          .collection('debates')
          .where('category', isGreaterThanOrEqualTo: query)
          .get();

      List<QueryDocumentSnapshot> allResults = [
        ...titleQuerySnapshot.docs,
        ...categoryQuerySnapshot.docs,
      ];

      // Filter out private debates
      List<QueryDocumentSnapshot> publicResults = allResults.where((doc) => (doc.data() as Map<String, dynamic>)['privacy'] != 'Private').toList();

      // Remove duplicates
      List<QueryDocumentSnapshot> uniqueResults = publicResults.toSet().toList();

      setState(() {
        _searchResults = uniqueResults;
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
*/


/*hiya code -- she says private also showing
  void _searchDebates(String query) async {
    if (query.isNotEmpty) {
      try {
        // Search by username if the query matches a username exactly
        QuerySnapshot usernameExactQuerySnapshot =
            await FirebaseFirestore.instance
                .collection('debates')
                .where('userId', isEqualTo: query)
                .where('privacy', isNotEqualTo: 'Private')
                .get();

        if (usernameExactQuerySnapshot.docs.isNotEmpty) {
          setState(() {
            _searchResults = usernameExactQuerySnapshot.docs;
          });
          return;
        }

        // If the query does not match a username exactly, search by title or category
        QuerySnapshot titleQuerySnapshot = await FirebaseFirestore.instance
            .collection('debates')
            .where('title', isGreaterThanOrEqualTo: query)
            // .where('privacy', isEqualTo: 'Public') // Filter by privacy
            .get();

        QuerySnapshot categoryQuerySnapshot = await FirebaseFirestore.instance
            .collection('debates')
            .where('category', isGreaterThanOrEqualTo: query)
            // .where('privacy', isEqualTo: 'Public') // Filter by privacy
            .get();

        List<QueryDocumentSnapshot> allResults = [
          ...titleQuerySnapshot.docs,
          ...categoryQuerySnapshot.docs,
        ];

        // Remove duplicates
        List<QueryDocumentSnapshot> uniqueResults = allResults.toSet().toList();

        setState(() {
          _searchResults = uniqueResults;
        });
      } catch (e) {
        print('Error searching debates: $e');
      }
    } else {
      setState(() {
        _searchResults.clear();
      });
    }
  }*/

}*/


/*//v4  -- hiya   -- 29april 1:31 am
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                  hintStyle: TextStyle(color: Color.fromARGB(255, 120, 13, 50)),
                ),
                style: TextStyle(color: Color.fromARGB(255, 89, 11, 62)),
                onChanged: (value) {
                  _searchDebates(value);
                },
              )
            : Text('Search Debates'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _searchResults.clear();
                }
              });
            },
          ),
        ],
      ),
      body: _buildSearchResults(),
      backgroundColor: Color.fromARGB(255, 243, 211, 234),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text('No results found',
            style: TextStyle(color: Color.fromARGB(255, 105, 7, 66))),
      );
    } else {
      return ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final debate = _searchResults[index];
          return ListTile(
            title: Text(debate['title'],
                style: TextStyle(color: const Color.fromARGB(255, 4, 0, 0))),
            subtitle: Text('User ID: ${debate['userId']}',
                style: TextStyle(color: Color.fromARGB(255, 100, 5, 70))),
            // Add more details as needed
          );
        },
      );
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
*/

/* v3  Search not working properly
//ev3
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                  hintStyle: TextStyle(color: Color.fromARGB(255, 120, 13, 50)),
                ),
                style: TextStyle(color: Color.fromARGB(255, 89, 11, 62)),
                onChanged: (value) {
                  _searchDebates(value);
                },
              )
            : Text('Search Debates'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _searchResults.clear();
                }
              });
            },
          ),
        ],
      ),
      body: _buildSearchResults(),
      backgroundColor: Color.fromARGB(255, 243, 211, 234),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text('No results found',
            style: TextStyle(color: Color.fromARGB(255, 105, 7, 66))),
      );
    } else {
      return ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final debate = _searchResults[index];
          return ListTile(
            title: Text(debate['title'],
                style: TextStyle(color: const Color.fromARGB(255, 4, 0, 0))),
            subtitle: Text('User ID: ${debate['userId']}',
                style: TextStyle(color: Color.fromARGB(255, 100, 5, 70))),
            // Add more details as needed
          );
        },
      );
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
*/

//hiya v2 - working (all debates coming when search any thing)
/*
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
*/