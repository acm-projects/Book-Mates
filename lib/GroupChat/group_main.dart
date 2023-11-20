// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

class GroupMainPage extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {}, // This is just a placeholder
        ),
        title: const Text(
          'Group Name',
          style: TextStyle(fontFamily: 'LeagueSpartan'),
        ),
        actions: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey, // Placeholder for user avatar
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey, // Placeholder for user avatar
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            // Segment control / tab bar goes here (if needed)
            Expanded(
              child: ListView(
                children: const <Widget>[
                  ListTile(
                    title: Text(
                      'Book',
                      style: TextStyle(fontFamily: 'LeagueSpartan'),
                    ),
                    subtitle: Text(
                      '-',
                      style: TextStyle(fontFamily: 'LeagueSpartan'),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'ID',
                      style: TextStyle(fontFamily: 'LeagueSpartan'),
                    ),
                    subtitle: Text(
                      '-',
                      style: TextStyle(fontFamily: 'LeagueSpartan'),
                    ),
                  ),
                  // Add more ListTiles or custom widgets as needed
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'ID',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
        ],
        // Bottom navigation bar options
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
