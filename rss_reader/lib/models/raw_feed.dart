import 'package:rss_reader/helpers/database_helper.dart';
import 'package:rss_reader/providers/feed_fetcher.dart';
import 'package:sqflite/sqflite.dart';

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
      type: getFeedTypeFromString(json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'link': link,
      'type': DatabaseHelper().getFeedTypeInString(type),
    };
  }
}

FeedType getFeedTypeFromString(String type) {
  switch (type) {
    case 'RSS 2.0':
      return FeedType.rss;
    case 'Atom':
      return FeedType.atom;
    case 'RSS 1.0':
      return FeedType.rss1;
    default:
      return FeedType.unknown;
  }
}
