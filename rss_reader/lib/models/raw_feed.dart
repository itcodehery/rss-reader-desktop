import 'package:rss_reader/providers/feed_fetcher.dart';

class RawFeed {
  final String title;
  final String link;
  final FeedType type;

  RawFeed({
    required this.title,
    required this.link,
    required this.type,
  });

  factory RawFeed.fromJson(Map<String, dynamic> json) {
    return RawFeed(
      title: json['title'],
      link: json['link'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'link': link,
      'type': type,
    };
  }
}
