import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rss_reader/providers/feed_fetcher.dart';
import 'package:rss_reader/providers/selected_feed_provider.dart';

class FeedHome extends ConsumerStatefulWidget {
  const FeedHome({super.key});

  @override
  ConsumerState<FeedHome> createState() => _FeedHomeState();
}

class _FeedHomeState extends ConsumerState<FeedHome> {
  @override
  Widget build(BuildContext context) {
    final selectedFeed = ref.watch(selectedFeedProvider);
    return selectedFeed == null
        ? const Expanded(
            child: Center(
              child: FittedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome to Drsstiny',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white54,
                      ),
                    ),
                    Text('Select a feed to view its content',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white54,
                        )),
                  ],
                ),
              ),
            ),
          )
        : Expanded(
            child: Center(
              child: Text(
                "${selectedFeed.title} selected",
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white54,
                ),
              ),
            ),
          );
  }
}
