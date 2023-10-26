import 'package:flutter/foundation.dart';
import '../models/book.dart';
import '../services/google_books_service.dart';

class BookProvider with ChangeNotifier{
  List<Book> _books = [];
  bool _isLoading = false;
  String _error = '';

  List<Book> get books => _books;
  bool get isLoading => _isLoading;
  String get error => _error;
  int _currentPage = 0;
  final int _booksPerPage = 10;

  final GoogleBooksService _googleBooksService = GoogleBooksService();

  Future<void> fetchBooks(String query, {bool nextPage = false}) async {
    final startIndex = _currentPage * _booksPerPage;
      if (nextPage) {
      _currentPage++;
    } else {
      _currentPage = 0;
    }
    try {
      final newBooks = await _googleBooksService.searchBooks(query, startIndex, _booksPerPage);
      if (nextPage) {
        _books.addAll(newBooks);
      } else {
        _books = newBooks;
      }
      _error = '';
    } catch (e) {
      _error = e.toString();
      _books = [];
    }

    notifyListeners();
  }
   
  }