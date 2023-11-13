import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontFamily: 'LeagueSpartan'),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30), // For spacing
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
            ),
            SizedBox(height: 10), // For spacing
            Text(
              'John Doe',
              style: TextStyle(fontSize: 24, fontFamily: 'LeagueSpartan'),
            ),
            SizedBox(height: 20), // For spacing
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Email',
                        style: TextStyle(fontFamily: 'LeagueSpartan'),
                      ),
                      Text(
                        'johndoe@gmail.com',
                        style: TextStyle(fontFamily: 'LeagueSpartan'),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Password',
                        style: TextStyle(fontFamily: 'LeagueSpartan'),
                      ),
                      Text(
                        '123456Seven',
                        style: TextStyle(fontFamily: 'LeagueSpartan'),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // For spacing
            ElevatedButton(
              onPressed: () {
                // Implement sign-out functionality
                print('Sign Out button pressed');
              },
              child: Text(
                'Sign Out',
                style: TextStyle(fontFamily: 'League Spartan'),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                shape: StadiumBorder(),
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
            icon: Icon(Icons.group_outlined),
            label: 'Groups',
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
        // You can manage the state of BottomNavigationBar as needed
      ),
    );
  }
}
