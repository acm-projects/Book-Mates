import 'package:bookmates_app/PDF%20Upload/pdf_screen.dart';
import 'package:bookmates_app/User%20Implementation/profile_page.dart';
import 'package:flutter/material.dart';

class Library extends StatelessWidget {
  const Library({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'LeagueSpartan'),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 250, 241, 213),
          foregroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your Library'),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [MySearchBarWidget(), MyCard()],
        ),
        backgroundColor: Color.fromARGB(255, 117, 161, 15),
        bottomNavigationBar: MyBottomAppBar(),
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  final String harryPotterCoverUrl =
      'https://m.media-amazon.com/images/I/81cQZG24I3L._AC_UF1000,1000_QL80_.jpg';
  final String wimpyKidCoverUrl =
      'https://m.media-amazon.com/images/I/51+FksZ2saL._SY445_SX342_.jpg';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          bookWidget(
              harryPotterCoverUrl, "Harry Potter", 4.5), // Example rating
          bookWidget2(wimpyKidCoverUrl, "Diary of a Wimpy Kid: The Long Haul",
              4.0), // Example rating
        ],
      ),
    );
  }

  Widget bookWidget(String coverUrl, String title, double rating) {
    return Container(
      width: 200,
      height: 350, // Increased height to accommodate title and rating
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                coverUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.star, color: Colors.amber),
                  Text("$rating", style: TextStyle(fontFamily: 'Spartan')),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontFamily: 'Spartan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget bookWidget2(String coverUrl, String title, double rating) {
  return Container(
    width: 200,
    height: 350, // Increased height to accommodate title and rating
    child: Card(
      elevation: 5.0,
      margin: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              coverUrl,
              width: 170,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.star, color: Colors.amber),
                Text("$rating", style: TextStyle(fontFamily: 'Spartan')),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(fontFamily: 'Spartan'),
            ),
          ),
        ],
      ),
    ),
  );
}

class homePage extends StatefulWidget {
  @override
  home_page createState() => home_page();
}

class home_page extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'LeagueSpartan'),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 117, 161, 15),
          foregroundColor: Colors.black,
          title: Text('Your Library'),
        ),
        body: Column(
          children: [
            SizedBox(height: 100),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    10,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Column(
                        children: [
                          Card(
                            child: Container(
                              width: 75,
                              height: 200,
                            ),
                          ),
                          SizedBox(height: 8),
                          Icon(Icons.check, color: Colors.green),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Color.fromARGB(255, 117, 161, 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
              onPressed: () {},
              child: Text('Join Group'),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 250, 241, 213),
        bottomNavigationBar: MyBottomAppBar(),
      ),
    );
  }
}

class MySearchBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(),
            ),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Search for your books..',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyBottomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color.fromARGB(255, 250, 241, 213), // Define the beige color
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // IconButton(
          //   icon: Icon(Icons.home),
          //   onPressed: () {
          //     // Add functionality for the homepage button
          //   },
          // ),
          IconButton(
            icon: const Icon(Icons.group),
            // navigates to users profile
            onPressed: () {
              // navigate to the users profile page
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.library_books),
            onPressed: () {
              // navigate to users personal library collection
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => const PDFReaderApp())));
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: ((context) => const Library())));
            },
          ),
        ],
      ),
    );
  }
}
