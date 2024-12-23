import 'package:http/http.dart' as http;
import 'package:rss_reader/helpers/misc_functions.dart';
import 'package:toastification/toastification.dart';

import 'package:xml/xml.dart';

enum FeedType { rss, atom, rss1, unknown }

String feedTypeToString(FeedType feedType) {
  switch (feedType) {
    case FeedType.rss:
      return 'RSS 2.0';
    case FeedType.atom:
      return 'Atom';
    case FeedType.rss1:
      return 'RSS 1.0';
    case FeedType.unknown:
      return 'Unknown';
  }
}

Future<String> getFeedIcon(String url) async {
  // get a favicon from the website
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final document = XmlDocument.parse(response.body);
      final iconLink = document.findAllElements('link').firstWhere(
            (element) => element.getAttribute('rel') == 'icon',
          );

      return iconLink.getAttribute('href') ?? '';
    } else {
      throw Exception('Failed to load page');
    }
  } catch (e) {
    showToast(
        "Error fetching icon! Please check the url!", ToastificationType.error);
    throw Exception('Error fetching icon: $e');
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
    showToast(
        "Error fetching feed! Please check the url!", ToastificationType.error);
    throw Exception('Error fetching feed: $e');
  }
}
