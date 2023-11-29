// import 'package:bookmates_app/Group%20Operations/group_repo.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class CreateGroupScreen extends StatefulWidget {
//   const CreateGroupScreen({Key? key}) : super(key: key);

//   @override
//   State<CreateGroupScreen> createState() => _CreateGroupState();
// }

// class _CreateGroupState extends State<CreateGroupScreen> {
//   // vars to hold user input
//   final TextEditingController _controllerGroupName = TextEditingController();
//   final TextEditingController _controllerBookName = TextEditingController();

//   // the email of the current user
//   final email = FirebaseAuth.instance.currentUser?.email;

// // resuable entryField where user type in data
//   Widget _entryField(String title, TextEditingController controller) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: TextField(
//         controller: controller,
//         style: const TextStyle(
//           fontFamily: 'LeagueSpartan',
//           fontWeight: FontWeight.w600,
//         ),
//         decoration: InputDecoration(
//           labelText: title,
//           border: const OutlineInputBorder(),
//           contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
//         ),
//       ),
//     );
//   }

//   // where user presses to join a group
//   Widget _submitButton() {
//     return ElevatedButton(
//       onPressed: () async {
//         // prevent group creation if all fields are not filled out
//         if (_controllerBookName.text.isNotEmpty &&
//             // _controllerGroupBio.text.isNotEmpty &&
//             _controllerGroupName.text.isNotEmpty) {
//           showDialog<String>(
//               context: context,
//               builder: (BuildContext context) {
//                 final groupID = generateGroupID();
//                 return AlertDialog(
//                   title: const Text('Your GroupID'),
//                   content: Text(
//                       '$groupID is your unique group ID, only show to potential members!'),
//                   actions: [
//                     TextButton(
//                         onPressed: () {
//                           // create the group in Firestore
//                           createOrUpdate(
//                             _controllerBookName.text,
//                             _controllerGroupName.text,
//                             email,
//                             groupID,
//                           );
//                           //send to the homepage after
//                           // Navigator.of(context).popAndPushNamed('/listGroups');
//                           Navigator.of(context).pop();
//                           Navigator.of(context).pop();
//                         },
//                         child: const Text('Ok')),
//                   ],
//                 );
//               });
//         }
//       },
//       style: ElevatedButton.styleFrom(
//         primary: Color(0xFF75A10F),
//       ),
//       child: const Text(
//         'Create Group',
//         style: TextStyle(
//           fontFamily: 'LeagueSpartan',
//           fontSize: 18,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }

//   // where user fills up information of the group
//   Widget _userForm() {
//     return Column(
//       children: [
//         const SizedBox(height: 100),
//         _entryField('Book Name', _controllerBookName),
//         const SizedBox(height: 16),
//         // _entryField("Group Bio", _controllerGroupBio),
//         const SizedBox(height: 16),
//         _entryField('Group Name', _controllerGroupName),
//         const SizedBox(height: 16),
//         _submitButton(),
//         const SizedBox(height: 16),
//       ],
//     );
//   }

//   // the title of the create group screen
//   Widget _title() {
//     return Container(
//       padding: const EdgeInsets.only(
//         top: 8,
//       ),
//       child: const Text(
//         "Create Your Group",
//         style: TextStyle(
//           fontSize: 24,
//           fontFamily: 'LeagueSpartan',
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//           shadows: [
//             BoxShadow(
//               color: Color.fromRGBO(70, 70, 70, 0.918),
//               blurRadius: 12,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Stack(
//           children: [
//             Container(
//               color: const Color(0xFF75A10F),
//               height: double.infinity,
//             ),
//             Positioned(
//               top: 100,
//               left: 0,
//               right: 0,
//               bottom: 0,
//               child: Container(
//                 decoration: const BoxDecoration(
//                   color: Color.fromARGB(255, 240, 223, 173),
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(35.0),
//                     topRight: Radius.circular(35.0),
//                   ),
//                 ),
//                 // where user puts the info of the group prior to creation
//                 child: Column(
//                   children: [
//                     _userForm(),
//                     // TextButton(
//                     //     onPressed: () =>
//                     //         Navigator.of(context).pushNamed('/joinGroup'),
//                     //     child: const Text('Join a Group Instead?'))
//                   ],
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 0,
//               left: 0,
//               right: 0,
//               child: AppBar(
//                 automaticallyImplyLeading: false,
//                 title: _title(),
//                 backgroundColor: Colors.transparent,
//                 centerTitle: true,
//                 elevation: 0,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookmates_app/API/services/google_books_service.dart';
import 'package:bookmates_app/Group Operations/group_repo.dart';
import 'package:bookmates_app/API/models/book.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroupScreen> {
  final TextEditingController _controllerGroupName = TextEditingController();
  final TextEditingController _controllerBookName = TextEditingController();
  final email = FirebaseAuth.instance.currentUser?.email;

  bool _isLoading = false;

  List<Map<String, String>> _bookSuggestions = [];

  Future<void> fetchBookSuggestions(String bookName) async {
    GoogleBooksService googleBooksService = GoogleBooksService();
    setState(() {
      _isLoading = true; // Start loading animation
    });

    try {
      List<Book> bookResults = await googleBooksService.searchBooks(
          bookName, 0, 10); // Adjust the number of results as needed

      setState(() {
        _bookSuggestions = bookResults.map((book) {
          String title = book.title;
          String coverUrl =
              book.thumbnailUrl ?? ''; // Using null-aware operator
          return {'title': title, 'coverUrl': coverUrl};
        }).toList();
      });
    } catch (e) {
      print('Error fetching book data: $e');
    } finally {
      setState(() {
        _isLoading = false; // Stop loading animation
      });
    }
  }

  Widget _entryField(String title, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontFamily: 'LeagueSpartan',
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: title,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              fetchBookSuggestions(controller.text);
            },
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            fetchBookSuggestions(value);
          }
        },
      ),
    );
  }

  String _selectedBookTitle = '';
  String _selectedBookCoverUrl = '';

  Widget _bookSuggestionsDropdown() {
    return Visibility(
      visible: _bookSuggestions.isNotEmpty,
      child: DropdownButton<Map<String, String>>(
        items: _bookSuggestions.map((book) {
          return DropdownMenuItem<Map<String, String>>(
            value: book,
            child: Text(book['title'] ?? ''),
          );
        }).toList(),
        onChanged: (selectedBook) {
          setState(() {
            _selectedBookTitle = selectedBook?['title'] ?? '';
            _selectedBookCoverUrl = selectedBook?['coverUrl'] ?? '';
          });
        },
      ),
    );
  }

  Widget _loadingAnimation() {
    return Visibility(
      visible: _isLoading,
      child: const CircularProgressIndicator(),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_controllerBookName.text.isNotEmpty &&
            _controllerGroupName.text.isNotEmpty) {
          final groupID = generateGroupID();
          showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Your GroupID'),
                  content: Text(
                      '$groupID is your unique group ID, only show to potential members!'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          createOrUpdate(
                            _controllerBookName.text,
                            _controllerGroupName.text,
                            email ?? 'default@email.com',
                            groupID,
                            _selectedBookCoverUrl, // Pass the book cover URL here
                          );
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Ok')),
                  ],
                );
              });
        }
      },
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF75A10F),
      ),
      child: const Text(
        'Create Group',
        style: TextStyle(
          fontFamily: 'Spartan',
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _userForm() {
    return Column(
      children: [
        const SizedBox(height: 100),
        _entryField('Book Name', _controllerBookName),
        _bookSuggestionsDropdown(),
        _loadingAnimation(),
        const SizedBox(height: 16),
        _entryField('Group Name', _controllerGroupName),
        const SizedBox(height: 16),
        _submitButton(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _title() {
    return Container(
      padding: const EdgeInsets.only(
        top: 25,
      ),
      child: const Text(
        "Create your group",
        style: TextStyle(
          fontSize: 24,
          fontFamily: 'Spartan',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            BoxShadow(
              color: Color.fromRGBO(70, 70, 70, 0.918),
              blurRadius: 12,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              color: const Color(0xFF75A10F),
              height: double.infinity,
            ),
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
                child: Column(
                  children: [
                    _userForm(),
                    TextButton(
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/joinGroup'),
                        child: const Text('Join a Group Instead?'))
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                automaticallyImplyLeading: false,
                title: _title(),
                backgroundColor: Colors.transparent,
                centerTitle: true,
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
