class NewsArticle {
  final String title;
  final String description;
  final String content;
  final String url;
  final String imageUrl;
  final DateTime publishedAt;
  final String sourceName;
  final String sourceUrl;

  NewsArticle({
    required this.title,
    required this.description,
    required this.content,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
    required this.sourceName,
    required this.sourceUrl,
  });
}