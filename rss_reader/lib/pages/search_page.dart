import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rss_reader/models/raw_feed.dart';
import 'package:rss_reader/providers/saved_feeds_provider.dart';
import 'package:rss_reader/providers/selected_feed_provider.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  List<RawFeed> feeds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back)),
          Center(
            child: SizedBox(
              width: 300,
              child: TextFormField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Search for RSS Feed",
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                onChanged: (value) {
                  // search for feeds
                  setState(() {
                    feeds = ref
                        .read(savedFeedsProvider.notifier)
                        .searchFeeds(value);
                  });
                },
                style: const TextStyle(color: Colors.white54),
              ),
            ),
          ),
          const SizedBox(height: 20),
          feeds.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: feeds.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.grey.shade900,
                        child: ListTile(
                          title: Text(feeds[index].title,
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Text(feeds[index].link,
                              style: const TextStyle(color: Colors.white54)),
                          trailing: const Icon(
                            Icons.rss_feed_outlined,
                            color: Colors.white54,
                          ),
                          onTap: () {
                            ref
                                .read(selectedFeedProvider.notifier)
                                .selectFeedWithTitle(feeds[index].title);
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  ),
                )
              : const Expanded(
                  child: Center(
                  child: Text(
                    "Start typing to search for feeds",
                    style: TextStyle(color: Colors.white54),
                  ),
                )),
        ],
      ),
    );
  }
}
