import 'package:rss_reader/providers/feed_utility.dart';

class RssToDrsstinyConverter {
  String title;
  String link;
  String imageUrl;
  String description;
  String category;
  FeedType type;

  RssToDrsstinyConverter({
    required this.title,
    required this.link,
    required this.imageUrl,
    required this.description,
    required this.category,
    required this.type,
  });

  factory RssToDrsstinyConverter.fromRssFeed(dynamic feed, FeedType type) {
    if (type == FeedType.rss) {
      return RssToDrsstinyConverter(
        title: feed.title ?? '',
        link: feed.link ?? '',
        imageUrl: feed.image?.url ?? '',
        description: feed.description ?? '',
        category: feed.category ?? '',
        type: type,
      );
    } else if (type == FeedType.atom) {
      return RssToDrsstinyConverter(
        title: feed.title ?? '',
        link: feed.link ?? '',
        imageUrl: feed.icon ?? '',
        description: feed.subtitle ?? '',
        category: feed.categories.isNotEmpty ? feed.categories.first.term : '',
        type: type,
      );
    } else {
      return RssToDrsstinyConverter(
        title: feed.title ?? '',
        link: feed.link ?? '',
        imageUrl: '',
        description: feed.description ?? '',
        category: '',
        type: type,
      );
    }
  }
}
