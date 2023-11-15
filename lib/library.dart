import 'package:flutter/material.dart';

void main() {
  runApp(MyHomePage());
}

class Library extends StatelessWidget {
  const Library({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 250, 241, 213),
          title: Text('Your Library',
              style: TextStyle(color: Colors.black87, fontFamily: 'Spartan')),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [MySearchBarWidget(), MyCard()]),
        backgroundColor: Color.fromARGB(255, 117, 161, 15),
        bottomNavigationBar: MyBottomAppBar(),
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          Container(
            width: 200,
            height: 300,
            child: Card(
              elevation: 5.0,
              margin: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox.fromSize(
                    size: Size(48, 48), // button width and height
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Material(
                        color:
                            Color.fromARGB(255, 144, 84, 188), // button color
                        child: InkWell(
                          // splash color
                          onTap: () {}, // button pressed
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.star), // icon
                              Text("4.0",
                                  style:
                                      TextStyle(fontFamily: 'Spartan')), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  home_page createState() => home_page();
}

class home_page extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Color _iconColor = Colors.grey;
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 117, 161, 15),
        title: Text('Your Library',
            style: TextStyle(
              color: Colors.black87,
              fontFamily: 'Spartan',
            )),
      ),
      body: Column(children: [
        Row(children: [
          Container(
              width: 200,
              height: 300,
              child: Card(
                //elevation: 5.0,
                margin: EdgeInsets.all(16.0),
              ))
        ]),
        Row(children: [
          Align(alignment: Alignment(200, 500)),
          IconButton(
              alignment: Alignment.center,
              color: _iconColor,
              iconSize: 30,
              icon: Icon(Icons.check_box),
              onPressed: () {
                setState(() {
                  _iconColor = Colors.green;
                });
              })
        ])
      ]),
      backgroundColor: Color.fromARGB(255, 250, 241, 213),
      bottomNavigationBar: MyBottomAppBar(),
    ));
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
                  borderRadius:
                      BorderRadius.circular(16.0), // Set the corner radius
                  border: Border.all()),
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Search for your books..',
                    prefixIcon: Icon(Icons.search),
                    //border: OutlineInputBorder(),
                    border: InputBorder.none),
              ),
            )),
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
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              // Add functionality for the homepage button
            },
          ),
          IconButton(
            icon: Icon(Icons.group),
            onPressed: () {
              // Add functionality for the group chat button
            },
          ),
          IconButton(
            icon: Icon(Icons.library_books),
            onPressed: () {
              // Add functionality for the library button
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Add functionality for the search button
            },
          ),
        ],
      ),
    );
  }
}
