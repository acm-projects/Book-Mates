import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';

class BookSearchScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              onSubmitted: (query) {
                context.read<BookProvider>().fetchBooks(query);
              },
              decoration: InputDecoration(
                labelText: 'Search for a book',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    context.read<BookProvider>().fetchBooks(_controller.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<BookProvider>(
              builder: (context, bookProvider, _) {
                if (bookProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (bookProvider.error.isNotEmpty) {
                  return Center(child: Text(bookProvider.error));
                }

                return ListView.builder(
                  itemCount: bookProvider.books.length,
                  itemBuilder: (context, index) {
                    final book = bookProvider.books[index];
                    return ListTile(
                      title: Text(book.title),
                      subtitle: Text(book.authors.join(', ')),
                      leading: Image.network(book.thumbnailUrl),
                      onTap: () {
                        // Navigate to book details or any other action
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
