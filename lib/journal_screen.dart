import 'package:flutter/material.dart';

class JournalPage extends StatefulWidget {
  final String bookTitle; // You can pass more data if needed

  const JournalPage({Key? key, required this.bookTitle}) : super(key: key);

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  double _rating = 0; // Initial rating
  final TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'LeagueSpartan'),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 250, 241, 213),
          foregroundColor: Colors.black,
          title: Text('${widget.bookTitle}'),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Your Rating:', style: TextStyle(fontSize: 20)),
              SizedBox(height: 8),
              _buildStarRating(),
              SizedBox(height: 20),
              TextField(
                controller: _reviewController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Your Thoughts',
                ),
                maxLines: 4,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 250, 241,
                      213), // Set the button color to match AppBar
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: _submitReview,
                child: Text(
                  'Submit Review',
                  style: TextStyle(
                    color: Colors.black, // Set the text color to black
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Color.fromARGB(255, 117, 161, 15),
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            _rating > index ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            setState(() {
              _rating = index + 1.0;
            });
          },
        );
      }),
    );
  }

  void _submitReview() {
    // Handle the submission of the review
    // You can use _rating and _reviewController.text to get the user input
    print('Rating: $_rating, Review: ${_reviewController.text}');
  }
}
