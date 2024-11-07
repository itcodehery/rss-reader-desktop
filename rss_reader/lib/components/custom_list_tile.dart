import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rss_reader/helpers/misc_functions.dart';
import 'package:rss_reader/providers/feed_fetcher.dart';
import 'package:rss_reader/providers/saved_feeds_provider.dart';
import 'package:rss_reader/providers/selected_feed_provider.dart';
import 'package:toastification/toastification.dart';

class CustomListTile extends ConsumerWidget {
  const CustomListTile({super.key, required this.title, required this.index});

  final String title;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, Function> feedOptions = {
      "View Feed Info": () {
        // show feed info
        final feed = ref.read(savedFeedsProvider)[index];
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Feed Info'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                backgroundColor: Colors.grey.shade900,
                titleTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                contentTextStyle: const TextStyle(color: Colors.white),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Title: ${feed.title}'),
                    Text('Link: ${feed.link}'),
                    Text('Type: ${feedTypeToString(feed.type)}'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ],
              );
            });
      },
      "Delete Feed": () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.grey.shade900,
                title: const Text('Delete Feed',
                    style: TextStyle(color: Colors.white)),
                content: const Text(
                    'Are you sure you want to delete this feed?',
                    style: TextStyle(color: Colors.white)),
                actions: [
                  TextButton(
                    onPressed: () {
                      ref.read(selectedFeedProvider.notifier).deselectFeed();
                      ref.read(savedFeedsProvider.notifier).removeFeed(index);
                      showToast("Removing $title feed...",
                          ToastificationType.warning);
                      Navigator.of(context).pop();
                      // ref.read(savedFeedsProvider.notifier).fetchAllFeeds();
                    },
                    child: const Text('Yes',
                        style: TextStyle(color: Colors.white)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child:
                        const Text('No', style: TextStyle(color: Colors.white)),
                  ),
                ],
              );
            });
      },
      "Share Feed": () {},
    };

    final selectedFeed = ref.watch(selectedFeedProvider);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      // right click to delete feed
      child: GestureDetector(
        onSecondaryTap: () {
          // show menu
          final RenderBox overlay =
              Overlay.of(context).context.findRenderObject() as RenderBox;
          // draw from the cursor position
          final Offset position = (context.findRenderObject() as RenderBox)
              .localToGlobal(Offset.zero, ancestor: overlay);
          final RelativeRect positionMenu = RelativeRect.fromLTRB(
            position.dx,
            position.dy,
            position.dx,
            position.dy,
          );
          showMenu(
            context: context,
            position: positionMenu,
            color: Colors.black87,
            popUpAnimationStyle: AnimationStyle(
              curve: Curves.easeInCubic,
              duration: const Duration(milliseconds: 500),
            ),
            // items: feedOptions
            //     .map((String option) => PopupMenuItem<String>(
            //           value: option,
            //           mouseCursor: SystemMouseCursors.click,
            //           child: Text(option,
            //               style: const TextStyle(color: Colors.white)),
            //         ))
            //     .toList(),
            items: feedOptions.entries
                .map((MapEntry<String, Function> entry) => PopupMenuItem(
                      value: entry.key,
                      mouseCursor: SystemMouseCursors.click,
                      child: Text(entry.key,
                          style: const TextStyle(color: Colors.white)),
                      onTap: () {
                        entry.value();
                      },
                    ))
                .toList(),
          );
        },
        child: Card(
          color: selectedFeed != null && selectedFeed.title == title
              ? Colors.deepOrange.withOpacity(0.2)
              : Colors.grey.shade900,
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: 16, right: 16),
            leading: const CircleAvatar(
              radius: 10,
              backgroundColor: Colors.deepOrange,
              child: FittedBox(
                child: Icon(
                  Icons.rss_feed,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: selectedFeed != null && selectedFeed.title == title
                ? IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 16,
                      color: Colors.white30,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.grey.shade900,
                              title: const Text('Delete Feed',
                                  style: TextStyle(color: Colors.white)),
                              content: const Text(
                                  'Are you sure you want to delete this feed?',
                                  style: TextStyle(color: Colors.white)),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    ref
                                        .read(selectedFeedProvider.notifier)
                                        .deselectFeed(); // works correctly
                                    ref
                                        .read(savedFeedsProvider.notifier)
                                        .removeFeed(index); // works correctly
                                    Navigator.of(context)
                                        .pop(); // works correctly
                                    showToast(
                                        "Removing $title feed...",
                                        ToastificationType
                                            .warning); // works correctly
                                  },
                                  child: const Text('Yes',
                                      style: TextStyle(color: Colors.white)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('No',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            );
                          });
                    },
                  )
                : IconButton(
                    onPressed: () {
                      ref.read(selectedFeedProvider.notifier).selectFeed(index);
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.white30,
                    ),
                  ),
            onTap: () {
              ref.read(selectedFeedProvider.notifier).selectFeed(index);
            },
          ),
        ),
      ),
    );
  }
}
