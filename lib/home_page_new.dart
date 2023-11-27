import 'package:flutter/material.dart';
import 'package:bookmates_app/PDF%20Upload/pdf_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'library.dart';
//import 'package:carousel_slider/carousel_slider.dart';

class PDFReaderApp2 extends StatefulWidget {
  const PDFReaderApp2({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PDFReaderAppState createState() => _PDFReaderAppState();
}

class _PDFReaderAppState extends State<PDFReaderApp2> {
  // email of the current user
  final email = FirebaseAuth.instance.currentUser?.email;

  @override
  void initState() {
    super.initState();
  }

  // represents the book widget a user uploaded
  Widget _bookWidget(String displayName, pdfPath) {
    return Dismissible(
      // the key of each widget, needed to swipe to delete
      key: Key(displayName),

      // lets the user delete the book swiping left or right
      onDismissed: (direction) async {
        await FirebaseFirestore.instance
            .collection('users/$email/BookPDFs')
            .doc(displayName)
            .delete();
      },

      child: Container(
        //padding
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        margin: const EdgeInsets.only(bottom: 10),

        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFF75A10F), // Background color
          ),
          child: ListTile(
            // display the docID in Firestore (BookPDFs subcollection)

            title: Text(
              displayName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            // pressing the button takes user to read PDF
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PDFViewer(pdfPath),
              ));
            },
            selectedColor: Colors.lightGreen,
          ),
        ),
      ),
    );
  }

  Widget _displayLibrary() {
    // each individual PDF that the user has read before displayed in a list
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users/$email/BookPDFs')
            .orderBy('timeStamp', descending: true) // newest pdf first
            .snapshots(),
        builder: (context, snapshot) {
          // show loading screen when data hasn't been renedered
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          // get the list of all documents in this snapshot
          var documents = snapshot.data!.docs;

          return ListView.builder(
            // user can only have 5 books at the same time
            itemCount: (documents.length > 5) ? 5 : documents.length,
            itemBuilder: (context, index) {
              final pdfPath = documents[index].data()['filePath'];
              final displayTitle = pdfPath.split('/').join().substring(50);
              final display =
                  displayTitle.substring(0, displayTitle.length - 4);

              // create bookWidget for every document in firestore
              return _bookWidget(display, pdfPath);
            },
          );
        },
      ),
    );
  }

  // the top part of the screen
  Widget _title() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Container(
        padding: const EdgeInsets.only(
          top: 25,
        ),
        child: const Text(
          "Your Library",
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'LeagueSpartan',
            fontWeight: FontWeight.w600,
            color: Colors.white, // Text color
            shadows: [
              BoxShadow(
                color: Color.fromRGBO(70, 70, 70, 0.918),
                blurRadius: 12,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
    );
  }

  // background of screen
  Widget _backgroundContainer() {
    return Container(
      color: const Color(0xFF75A10F),
      height: double.infinity,
    );
  }

  // where all the widgets are oriented
  Widget _home() {
    return Stack(
      children: [
        Column(
          children: [
            _displayLibrary(),
          ],
        ),
        Positioned(
          top: 600,
          right: 0,
          bottom: 0,
          left: -150,
          child: Transform.scale(
            scale: 0.9,
            child: const Image(
              image: AssetImage('icons/worm.png'),
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            margin: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: addPDF,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF75A10F),
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  // main of flutter
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _backgroundContainer(),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 240, 223, 173),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0),
                ),
              ),
              child: _home(),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _title(),
          ),
        ],
      ),
    );
  }
}

late PageController _pageController;
int position = 0;

@override
void initState() {
  initState();
  _pageController = PageController(initialPage: 0, viewportFraction: 0.1);
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    int itemnumber = 2;
    final List<String> items = [
      'Item 1',
      'Item 2',
      'Item 3',
      'Item 4',
      'Item 5'
    ];
    return MaterialApp(
        home: Scaffold(
      body: Container(
        width: 600,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              Color.fromARGB(255, 117, 161, 15),
              Color.fromARGB(255, 168, 215, 58),
              Color.fromARGB(255, 185, 234, 72),
              Color.fromARGB(255, 199, 221, 147),
              Color.fromARGB(255, 240, 223, 173),
              Color.fromARGB(255, 233, 225, 201)
            ],
                stops: [
              0.1,
              0.2,
              0.3,
              0.5,
              0.7,
              1
            ])),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(height: 100, width: 20),
                Text("Read Better\nRead Together",
                    style: TextStyle(
                        fontFamily: 'Spartan',
                        fontWeight: FontWeight.bold,
                        fontSize: 40)),
                SizedBox(height: 200, width: 70),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.account_circle_outlined),
                  iconSize: 55,
                )
              ],
            ),
            SizedBox(height: 30),
            CarouselSliderWidget(items: items),
            SizedBox(height: 10)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
          //height: 50,
          padding: EdgeInsetsDirectional.only(bottom: 60),
          child: ElevatedButton(
            onPressed: () {},
            child: Text("Join Group"),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(240, 50),
              backgroundColor: const Color.fromARGB(255, 117, 161, 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          )),
      bottomNavigationBar: MyBottomAppBar(),
    ));
  }
}

class CarouselSliderWidget extends StatefulWidget {
  final List<String> items;

  CarouselSliderWidget({required this.items});

  @override
  _CarouselSliderWidgetState createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 400,
        child: PageView.builder(
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            return CardWidget(item: widget.items[index]);
          },
        ));
  }

  AnimatedContainer slider(items, position, active) {
    double margin = active ? 10 : 20;
    return AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        margin: EdgeInsets.all(margin),
        child: Container(
          child: CardWidget(item: widget.items[currentIndex]),
        ));
  }
}

class CardWidget extends StatelessWidget {
  final String item;

  CardWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          // Your card content here
          child: Container(
            width: 200, // Set the width of each card as needed
            height: 300, // Set the height of each card as needed
          ),
        ),
        //SizedBox(height: 8), // Adjust the space between card and check icon
        IconButton(
            icon: Icon(Icons.check),
            color: Colors.white,
            onPressed: () {
              color:
              Colors.green;
            }),
        //SizedBox(height: 8),
        Text("group name",
            style: TextStyle(fontFamily: 'Spartan', fontSize: 15)),
        SizedBox(height: 10),
        Text("group book",
            style: TextStyle(fontFamily: 'Spartan', fontSize: 15)),
      ],
    );
  }
}
