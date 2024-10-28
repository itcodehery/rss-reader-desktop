import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rss_reader/providers/feed_fetcher.dart';
import 'package:rss_reader/providers/selected_feed_provider.dart';

class FeedHome extends ConsumerWidget {
  const FeedHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFeed = ref.watch(selectedFeedProvider);

    return selectedFeed == null
        ? const Center(
            child: Text(
              'Select a feed',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : Center(
            child: Text(
              selectedFeed.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }
}
