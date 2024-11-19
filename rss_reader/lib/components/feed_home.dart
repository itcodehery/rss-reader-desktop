import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rss_reader/helpers/html_parser.dart';
import 'package:rss_reader/helpers/misc_functions.dart';
import 'package:rss_reader/models/raw_feed.dart';
import 'package:rss_reader/providers/customization_provider.dart';
import 'package:rss_reader/providers/feed_content_provider.dart';
import 'package:rss_reader/providers/feed_utility.dart';
import 'package:rss_reader/providers/selected_feed_provider.dart';
import 'package:rss_reader/providers/theme_provider.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class FeedHome extends ConsumerStatefulWidget {
  const FeedHome({super.key});

  @override
  ConsumerState<FeedHome> createState() => _FeedHomeState();
}

class _FeedHomeState extends ConsumerState<FeedHome> {
  @override
  Widget build(BuildContext context) {
    // to get the selected feed
    final selectedFeed = ref.watch(selectedFeedProvider);
    // to get the theme
    final theme = ref.watch(themeProvider);

    // building the UI
    return selectedFeed == null || selectedFeed.link.isEmpty
        ? Expanded(
            child: Center(
              child: FittedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome to Drsstiny',
                      style: TextStyle(
                        fontSize: 22,
                        color: theme.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white70,
                      ),
                    ),
                    Text('Select a feed to view its content',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.brightness == Brightness.light
                              ? Colors.black54
                              : Colors.white54,
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
    // gets the current feed
    final currentFeed = ref.watch(fetchFeedContentsProvider);
    // gets the screen width
    final screenWidth = MediaQuery.of(context).size.width;
    // gets the theme
    final theme = ref.watch(themeProvider);
    // gets the accent color
    final accentColor = ref.watch(accentColorProvider);

    // building the UI
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

                return feedContentBox(
                    item, imageUrl, screenWidth, theme, accentColor);
              },
            ),
          ),
        ),
      AsyncError(:final error) => Expanded(
          child: Center(
            child: Text(
              'Error fetching feed: $error',
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ),
      _ => Expanded(
          child: Center(
            child: CircularProgressIndicator(
              strokeCap: StrokeCap.round,
              strokeWidth: 10,
              color: accentColor,
            ),
          ),
        ),
    };
  }

  StatefulBuilder feedContentBox(dynamic item, String imageUrl,
      double screenWidth, ThemeData theme, MaterialColor accentColor) {
    return StatefulBuilder(
      builder: (context, setState) {
        // Fetch the image if not already available
        if (imageUrl.isEmpty) {
          String? link = selectedFeed!.type == FeedType.rss
              ? item.link
              : selectedFeed!.type == FeedType.atom
                  ? (item.links?.isNotEmpty == true
                      ? item.links.first.href
                      : null)
                  : null;

          if (link != null) {
            fetchImageFromFeed(link).then((value) {
              if (context.mounted) {
                setState(() {
                  imageUrl = value;
                });
              }
            });
          }
        }

        // Safely extract category
        String? category = selectedFeed!.type == FeedType.rss
            ? (item.categories != null && item.categories.isNotEmpty
                ? item.categories.first.value
                : null)
            : selectedFeed!.type == FeedType.atom
                ? (item.categories != null && item.categories.isNotEmpty
                    ? item.categories.first.term
                    : null)
                : null;

        // Extract description dynamically
        String description = selectedFeed!.type == FeedType.rss
            ? parseHtmlToPlainText(item.description ?? "")
            : selectedFeed!.type == FeedType.atom
                ? parseHtmlToPlainText(item.summary ?? "")
                : "";

        return Container(
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.light
                ? Colors.white12
                : Colors.black12,
            image: imageUrl.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  )
                : null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () {
              // Open the feed article
              String? link = selectedFeed!.type == FeedType.rss
                  ? item.link
                  : selectedFeed!.type == FeedType.atom
                      ? (item.links?.isNotEmpty == true
                          ? item.links.first.href
                          : null)
                      : null;

              if (link != null) {
                openFeedArticle(context, item, selectedFeed!.type, imageUrl);
              } else {
                debugPrint("No link available for this feed item.");
              }
            },
            child: Column(
              children: [
                // Display category if available
                if (category != null && category.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Spacer(),
                        Chip(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: BorderSide.none,
                          backgroundColor: accentColor,
                          label: Text(
                            toSentenceCase(category),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                const Spacer(),
                // Display title and description
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      item.title ?? "No Title Available",
                      overflow: TextOverflow.ellipsis,
                      maxLines: screenWidth > 900 ? 2 : 1,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// Updated function
  Future<dynamic> openFeedArticle(
    BuildContext context,
    dynamic item,
    FeedType type,
    String imageUrl,
  ) {
    debugPrint("Open a ${feedTypeToString(type)} type feed...");

    // Function to launch URLs in a browser
    Future<void> launchInBrowser(String url) async {
      if (await UrlLauncherPlatform.instance.canLaunch(url)) {
        await UrlLauncherPlatform.instance.launch(
          url,
          useSafariVC: false,
          useWebView: false,
          enableJavaScript: false,
          enableDomStorage: false,
          universalLinksOnly: false,
          headers: <String, String>{},
        );
      } else {
        throw Exception('Could not launch $url');
      }
    }

    String parseContent(FeedType type, dynamic item) {
      switch (type) {
        case FeedType.rss:
          return parseHtmlToPlainText((item.content is String
                      ? item.content
                      : item.content?.value) ??
                  item.description ??
                  "")
              .trim();
        case FeedType.atom:
          return parseHtmlToPlainText((item.content is String
                      ? item.content
                      : item.content?.value) ??
                  item.summary ??
                  "")
              .trim();
        default:
          return parseHtmlToPlainText((item.content is String
                      ? item.content
                      : item.content?.value) ??
                  item.description ??
                  "")
              .trim();
      }
    }

    String parseDescription(FeedType type, dynamic item) {
      switch (type) {
        case FeedType.rss:
          return parseHtmlToPlainText(item.description ?? "");
        case FeedType.atom:
          return parseHtmlToPlainText(item.summary ?? "");
        default:
          return parseHtmlToPlainText(item.description ?? "");
      }
    }

    String? extractLink(FeedType type, dynamic item) {
      switch (type) {
        case FeedType.rss:
          return item.link; // RSS feeds often have `link` as a direct property.
        case FeedType.atom:
          return (item.links != null && item.links.isNotEmpty)
              ? item.links.first.href
              : null; // Atom feeds store links in a list.
        default:
          return item.link; // Default case for unknown feed types.
      }
    }

    return showDialog(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Close Button and Tag
                    Row(
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
                          label: Text(
                            feedTypeToString(type),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Title, Description, and Image
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 480,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (imageUrl.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    launchInBrowser(extractLink(type, item)!);
                                  },
                                  onSecondaryTap: () {
                                    showMenu(
                                        context: context,
                                        position: const RelativeRect.fromLTRB(
                                          0,
                                          60,
                                          20,
                                          0,
                                        ),
                                        color: Colors.black,
                                        items: [
                                          PopupMenuItem(
                                            child: ListTile(
                                              title:
                                                  const Text("Open in Browser"),
                                              onTap: () {
                                                launchInBrowser(
                                                    extractLink(type, item)!);
                                              },
                                            ),
                                          ),
                                          PopupMenuItem(
                                            child: ListTile(
                                              title: const Text("Copy Link"),
                                              onTap: () {
                                                Clipboard.setData(ClipboardData(
                                                    text: extractLink(
                                                        type, item)!));
                                                showToast(
                                                    "Link copied to clipboard!",
                                                    ToastificationType.info);
                                              },
                                            ),
                                          ),
                                        ]);
                                  },
                                  child: FittedBox(
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
                                ),
                              const SizedBox(height: 10),
                              SelectableText(
                                item.title ?? "No Title Available",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SelectableText(
                                parseDescription(type, item),
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 20,
                                ),
                                maxLines: 5,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),

                        // Content Section
                        Expanded(
                          child: SizedBox(
                            child: SelectableText(
                              parseContent(type, item),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Read More Button
                    if (extractLink(type, item) != null)
                      Row(
                        children: [
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              final url = extractLink(type, item);
                              if (url != null) {
                                launchInBrowser(url);
                              }
                            },
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.deepOrange),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Read More",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(Icons.arrow_outward,
                                    color: Colors.white, size: 16),
                              ],
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
