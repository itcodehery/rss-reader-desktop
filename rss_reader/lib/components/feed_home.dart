import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rss_reader/models/raw_feed.dart';
import 'package:rss_reader/providers/feed_content_provider.dart';
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
        : FeedContentViewer(selectedFeed: selectedFeed);
  }
}

class FeedContentViewer extends ConsumerWidget {
  const FeedContentViewer({
    super.key,
    required this.selectedFeed,
  });

  final RawFeed? selectedFeed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFeed = ref.watch(fetchFeedContentsProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return switch (currentFeed) {
      AsyncData(:final value) => Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: screenWidth > 900 ? 3 : 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              physics: const BouncingScrollPhysics(),
              itemCount: value.length,
              itemBuilder: (context, index) {
                final item = value[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: Column(
                      children: [
                        item.categories != null
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    Chip(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      side: BorderSide.none,
                                      color: const WidgetStatePropertyAll(
                                          Colors.deepOrange),
                                      label: Text(
                                        "${item.categories.first.value}",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        const Spacer(),
                        ListTile(
                          title: Text(item.title,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Text(item.description,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white54)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      AsyncError(:final error) => Expanded(
          child: Center(
            child: Text(
              'Error fetching feed: $error',
              style: const TextStyle(
                color: Colors.white54,
              ),
            ),
          ),
        ),
      _ => const Expanded(
          child: Center(
            child: CircularProgressIndicator(
              strokeCap: StrokeCap.round,
              strokeWidth: 10,
              color: Colors.deepOrange,
            ),
          ),
        ),
    };
  }
}
