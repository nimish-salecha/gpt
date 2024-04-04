//Search debates and add filter and sort

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
            subtitle: Text('User ID: ${debate['userId']}'),
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



/* most bbasic
import 'package:flutter/material.dart';
void main() {
  runApp(Search());
}

// ignore: use_key_in_widget_constructors
class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dwidth = MediaQuery.of(context).size.width;
    final dheight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[500],
          title: const Text('Search'),
        ),
      
      ),
    );
  }
}
*/