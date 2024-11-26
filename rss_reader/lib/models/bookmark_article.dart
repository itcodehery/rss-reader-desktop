class BookmarkArticle {
  final String title;
  final String description;
  final String content;
  final String link;

  BookmarkArticle({
    required this.title,
    required this.description,
    required this.content,
    required this.link,
  });

  factory BookmarkArticle.fromJson(Map<String, dynamic> json) {
    return BookmarkArticle(
      title: json['title'],
      description: json['description'],
      content: json['content'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'link': link,
    };
  }
}
