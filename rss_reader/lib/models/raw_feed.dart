class RawFeed {
  final String title;
  final String link;

  RawFeed({
    required this.title,
    required this.link,
  });

  factory RawFeed.fromJson(Map<String, dynamic> json) {
    return RawFeed(
      title: json['title'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'link': link,
    };
  }
}
