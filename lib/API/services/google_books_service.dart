// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:bookmates_app/API/models/book.dart';

// class GoogleBooksService {
//   final String bookUrl = 'https://www.googleapis.com/books/v1/volumes';

//   Future<List<Book>> searchBooks(String query, int startIndex,
//       [int maxResults = 15]) async {
//     final response = await http.get(Uri.parse(
//         '$bookUrl?q=$query&startIndex=$startIndex&maxResults=$maxResults'));

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final List<dynamic> items = data['items'] ?? [];
//       return items.map((item) => Book.fromJson(item)).toList();
//     } else {
//       throw Exception('Failed to load books');
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bookmates_app/API/models/book.dart';

class GoogleBooksService {
  final String apiKey =
      'AIzaSyBkxFME7rc2qYpjJcO_nSnEmlyfNBh5jms'; // Replace with your actual API key
  final String bookUrl = 'https://www.googleapis.com/books/v1/volumes';

  Future<List<Book>> searchBooks(String query, int startIndex,
      [int maxResults = 15]) async {
    final url = Uri.parse(
        '$bookUrl?q=$query&startIndex=$startIndex&maxResults=$maxResults&key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> items = data['items'] ?? [];
      return items.map((item) => Book.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }
}
