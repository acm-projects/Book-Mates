class Book {
  final String id;
  final String title;
  final String subtitle;
  final String thumbnailUrl;
  final List<String> authors;
  final String previewLink;
  final String infoLink;
  final String isbn;
  final List<String> categories;
  final String description;
  final String publisher;
  final String publishedDate;
  final double averageRating;
  final String webReaderLink;
  final int pageCount;
  final bool isEbook;
  final String saleability;
  final double amount;
  final String currencyCode;
  final String accessViewStatus;

  Book({
    required this.id,
    required this.title,
    this.subtitle = '',
    required this.thumbnailUrl,
    required this.authors,
    required this.previewLink,
    required this.infoLink,
    this.isbn = '',
    required this.categories,
    this.description = '',
    this.publisher = '',
    this.publishedDate = '',
    required this.averageRating,
    required this.webReaderLink,
    required this.pageCount,
    required this.isEbook,
    required this.saleability,
    required this.amount,
    required this.currencyCode,
    required this.accessViewStatus,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? '',
      title: json['volumeInfo']['title'] ?? '',
      subtitle: json['volumeInfo']['subtitle'] ?? '',
      thumbnailUrl: json['volumeInfo']['imageLinks']['thumbnail'] ?? '',
      authors: (json['volumeInfo']['authors'] as List<dynamic>?)
              ?.map((author) => author.toString())
              .toList() ??
          [],
      previewLink: json['volumeInfo']['previewLink'] ?? '',
      infoLink: json['volumeInfo']['infoLink'] ?? '',
      isbn: (json['volumeInfo']['industryIdentifiers'] as List<dynamic>?)
              ?.firstWhere((identifier) => identifier['type'] == 'ISBN_13',
                  orElse: () => {'identifier': ''})['identifier'] ??
          '',
      categories: (json['volumeInfo']['categories'] as List<dynamic>?)
              ?.map((category) => category.toString())
              .toList() ??
          [],
      description: json['volumeInfo']['description'] ?? '',
      publisher: json['volumeInfo']['publisher'] ?? '',
      publishedDate: json['volumeInfo']['publishedDate'] ?? '',
      averageRating: (json['volumeInfo']['averageRating'] ?? 0).toDouble(),
      webReaderLink: json['accessInfo']['webReaderLink'] ?? '',
      pageCount: json['volumeInfo']['pageCount'] ?? 0,
      isEbook: json['saleInfo']['isEbook'] ?? false,
      saleability: json['saleInfo']['saleability'] ?? '',
      amount: json['saleInfo']['listPrice']['amount'] ?? 0.0,
      currencyCode: json['saleInfo']['listPrice']['currencyCode'] ?? '',
      accessViewStatus: json['accessInfo']['accessViewStatus'] ?? '',
    );
  }
}
