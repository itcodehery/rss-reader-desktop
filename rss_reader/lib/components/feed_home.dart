import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rss_reader/helpers/html_parser.dart';
import 'package:rss_reader/helpers/misc_functions.dart';
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
    return selectedFeed == null || selectedFeed.link.isEmpty
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
                String imageUrl = '';

                return feedContentBox(item, imageUrl, screenWidth);
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

  StatefulBuilder feedContentBox(item, String imageUrl, double screenWidth) {
    return StatefulBuilder(builder: (context, setState) {
      fetchImageFromFeed(item.link).then((value) {
        setState(() {
          imageUrl = value;
        });
      });
      return Container(
        decoration: BoxDecoration(
          color: Colors.white10,
          image: imageUrl.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(imageUrl),
                  opacity: 0.5,
                  fit: BoxFit.cover,
                )
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: () {
            // open the feed article
            openFeedArticle(context, item, selectedFeed!.type, imageUrl);
          },
          child: Column(
            children: [
              item.categories != null || item.categories.isNotEmpty
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
                            color:
                                const WidgetStatePropertyAll(Colors.deepOrange),
                            label: Text(
                              toSentenceCase(
                                  "${selectedFeed!.type == FeedType.rss ? item.categories.first.value : item.categories.first.term}"),
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
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black,
                      ]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(item.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: screenWidth > 900 ? 2 : 1,
                      style: const TextStyle(color: Colors.white)),
                  subtitle: Text(
                      parseHtmlToPlainText(
                          "${selectedFeed!.type == FeedType.rss ? item.description : ""}"),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(color: Colors.white54)),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<dynamic> openFeedArticle(
      BuildContext context, item, FeedType type, String imageUrl) {
    debugPrint("Open a ${feedTypeToString(type)} type feed...");
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog.fullscreen(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // #1 : Close Button and Tag
                    SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Expanded(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            Chip(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              side: BorderSide.none,
                              elevation: 0,
                              backgroundColor: Colors.deepOrange,
                              label: const Text(
                                "Article",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // #2 : Title, Description and Image
                    Row(
                      children: [
                        SizedBox(
                          width: 480,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                child: Container(
                                  height: 270,
                                  width: 480,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SelectableText(
                                item.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SelectableText(
                                parseHtmlToPlainText(
                                    "${selectedFeed!.type == FeedType.rss ? item.description : ""}"),
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 24,
                                ),
                                maxLines: 5,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        StatefulBuilder(builder: (context, setState) {
                          return Expanded(
                            child: SingleChildScrollView(
                              child: SizedBox(
                                child: SelectableText(
                                  parseHtmlToPlainText(
                                      "${selectedFeed!.type == FeedType.rss ? item.content.value ?? "" : item.content}"),
                                  style: const TextStyle(
                                    color: Colors.white54,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
