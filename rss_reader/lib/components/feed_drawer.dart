import 'package:flutter/material.dart';
import 'package:rss_reader/components/custom_list_tile.dart';
import 'package:rss_reader/components/text_boxes.dart';
import 'package:rss_reader/helpers/misc_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rss_reader/providers/saved_feeds_provider.dart';
import 'package:rss_reader/providers/selected_feed_provider.dart';
import 'package:rss_reader/providers/theme_provider.dart';
import 'package:toastification/toastification.dart';

class FeedDrawer extends ConsumerStatefulWidget {
  const FeedDrawer({super.key});

  @override
  ConsumerState<FeedDrawer> createState() => _FeedDrawerState();
}

class _FeedDrawerState extends ConsumerState<FeedDrawer> {
  double getWidth(BuildContext context) {
    const double minSize = 200;
    final double width = MediaQuery.of(context).size.width * 0.2;
    // If the width is less than the minimum size, return the minimum size
    return width < minSize ? minSize : width;
  }

  @override
  Widget build(BuildContext context) {
    final feeds = ref.watch(savedFeedsProvider);
    const buttonStyle = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size.fromHeight(50)),
      backgroundColor: WidgetStatePropertyAll(Colors.white10),
    );
    return Container(
      height: double.infinity,
      width: getWidth(context),
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: Colors.white10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.brightness_4_outlined),
                  onPressed: () {
                    ref.read(themeProvider.notifier).toggleTheme();
                  },
                ),
                IconButton(
                    onPressed: () {
                      ref.invalidate(selectedFeedProvider);
                      Future.delayed(const Duration(seconds: 1), () {
                        ref.read(savedFeedsProvider.notifier).fetchAllFeeds();
                      });
                      showToast("Refreshing feeds...", ToastificationType.info);
                    },
                    icon: const Icon(Icons.refresh)),
              ],
            ),
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(
              Icons.rss_feed_outlined,
              size: 14,
              color: Colors.white,
            ),
            title: const Text(
              'Drsstiny',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: const Text("Your Feeds"),
          ),
          const SizedBox(height: 12),
          // FOCUS : search bar
          TextField(
            focusNode: FocusNode(),
            enabled: true,
            onTap: () {
              // unfocus
              FocusScope.of(context).unfocus();
              Navigator.pushNamed(context, '/search');
            },
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(0),
              filled: true,
              hintText: "Search",
              hintStyle: TextStyle(color: Colors.white54),
              prefixIcon: Icon(
                Icons.search,
                size: 16,
                color: Colors.white54,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide.none,
              ),
              fillColor: Colors.white10,
            ),
          ),
          const SizedBox(height: 12),
          if (feeds.isNotEmpty) ...[
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: feeds.length,
                itemBuilder: (context, index) {
                  return CustomListTile(
                    title: feeds[index].title,
                    index: index,
                  );
                },
              ),
            ),
          ] else
            const Expanded(
              child: Center(
                child: Text(
                  "No feeds added",
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ),
          ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const TextBoxRSS();
                  },
                );
              },
              child: const Text(
                "Add RSS Feed",
                style: TextStyle(
                    color: Colors.deepOrange, fontWeight: FontWeight.w500),
              )),
        ],
      ),
    );
  }
}
