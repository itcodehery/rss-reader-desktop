import 'package:http/http.dart' as http;
import 'package:rss_dart/dart_rss.dart';
import 'package:xml/xml.dart';
import 'package:rss_dart/domain/rss1_feed.dart';
import 'package:rss_dart/domain/rss1_item.dart';

enum FeedType { rss, atom, rss1 }

Future<List<dynamic>> fetchFeed(String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final document = XmlDocument.parse(response.body);

      // Identify feed type by checking root element and namespaces
      final rootElement = document.rootElement;
      final rootName = rootElement.name.local;

      if (rootName == 'rss' && rootElement.getAttribute('version') == '2.0') {
        // RSS 2.0 feed
        final feed = RssFeed.parse(response.body);
        return feed.items;
      } else if (rootName == 'feed' &&
          rootElement.getAttribute('xmlns') == 'http://www.w3.org/2005/Atom') {
        // Atom feed
        final feed = AtomFeed.parse(response.body);
        return feed.items;
      } else if (rootName == 'RDF' &&
          rootElement.getAttribute('xmlns') == 'http://purl.org/rss/1.0/') {
        // RSS 1.0 feed
        final feed = Rss1Feed.parse(response.body);
        return feed.items;
      } else {
        throw Exception('Unknown feed type');
      }
    } else {
      throw Exception('Failed to load feed');
    }
  } catch (e) {
    throw Exception('Error fetching feed: $e');
  }
}

Future<FeedType> getFeedType(String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final document = XmlDocument.parse(response.body);

      // Identify feed type by checking root element and namespaces
      final rootElement = document.rootElement;
      final rootName = rootElement.name.local;

      if (rootName == 'rss' && rootElement.getAttribute('version') == '2.0') {
        // RSS 2.0 feed
        return FeedType.rss;
      } else if (rootName == 'feed' &&
          rootElement.getAttribute('xmlns') == 'http://www.w3.org/2005/Atom') {
        // Atom feed
        return FeedType.atom;
      } else if (rootName == 'RDF' &&
          rootElement.getAttribute('xmlns') == 'http://purl.org/rss/1.0/') {
        // RSS 1.0 feed
        return FeedType.rss1;
      } else {
        throw Exception('Unknown feed type');
      }
    } else {
      throw Exception('Failed to load feed');
    }
  } catch (e) {
    throw Exception('Error fetching feed: $e');
  }
}

// Function to fetch RSS feed
Future<List<RssItem>> fetchRSSFeed(String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final feed = RssFeed.parse(response.body);
      final List<RssItem> feedItems = feed.items;

      return feedItems;
    } else {
      throw Exception('Failed to load RSS feed');
    }
  } catch (e) {
    throw Exception('Error fetching RSS feed: $e');
  }
}

// Function to fetch Atom feed
Future<List<AtomItem>> fetchAtomFeed(String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final feed = AtomFeed.parse(response.body);
      final List<AtomItem> feedItems = feed.items;

      return feedItems;
    } else {
      throw Exception('Failed to load Atom feed');
    }
  } catch (e) {
    throw Exception('Error fetching Atom feed: $e');
  }
}

// Function to fetch RSS 1.0 feed
Future<List<Rss1Item>> fetchRss1Feed(String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final feed = Rss1Feed.parse(response.body);
      final List<Rss1Item> feedItems = feed.items;

      return feedItems;
    } else {
      throw Exception('Failed to load RSS 1.0 feed');
    }
  } catch (e) {
    throw Exception('Error fetching RSS 1.0 feed: $e');
  }
}
