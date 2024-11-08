import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rss_dart/dart_rss.dart';
import 'package:rss_reader/providers/selected_feed_provider.dart';
import 'package:xml/xml.dart';
import 'package:rss_dart/domain/rss1_feed.dart';

part 'feed_content_provider.g.dart';

@riverpod
Future<List<dynamic>> fetchFeedContents(Ref ref) async {
  final url = ref.watch(selectedFeedProvider);
  try {
    final response = await http.get(Uri.parse(url!.link));

    if (response.statusCode == 200) {
      final document = XmlDocument.parse(response.body);

      // Identify feed type by checking root element and namespaces
      final rootElement = document.rootElement;
      final rootName = rootElement.name.local;

      if (rootName == 'rss' && rootElement.getAttribute('version') == '2.0') {
        // RSS 2.0 feed
        final feed = RssFeed.parse(response.body);

        debugPrint(
            "RssFeed: ${feed.description} , Feed type: ${url.type.toString()}");

        return feed.items;
      } else if (rootName == 'feed' &&
          rootElement.getAttribute('xmlns') == 'http://www.w3.org/2005/Atom') {
        // Atom feed
        final feed = AtomFeed.parse(response.body);
        debugPrint(
            "AtomFeed: ${feed.title} , Feed type: ${url.type.toString()}");
        return feed.items;
      } else if (rootName == 'RDF' &&
          rootElement.getAttribute('xmlns') == 'http://purl.org/rss/1.0/') {
        // RSS 1.0 feed
        final feed = Rss1Feed.parse(response.body);
        debugPrint(
            "Rss1Feed: ${feed.description} , Feed type: ${url.type.toString()}");
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
