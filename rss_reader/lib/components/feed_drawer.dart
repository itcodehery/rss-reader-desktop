import 'package:flutter/material.dart';
import 'package:rss_reader/components/custom_list_tile.dart';
import 'package:rss_reader/components/text_boxes.dart';
import 'package:rss_reader/helpers/misc_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rss_reader/providers/customization_provider.dart';
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
    // to get the saved feeds
    final feeds = ref.watch(savedFeedsProvider);
    // to get the accent color
    final accentColor = ref.watch(accentColorProvider);
    // to get the theme
    final theme = ref.watch(themeProvider);

    // button Style
    var buttonStyle = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size.fromHeight(50)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStatePropertyAll(
        theme.brightness == Brightness.light
            ? accentColor.shade100
            : accentColor.withOpacity(0.2),
      ),
    );

    // return the drawer
    return Container(
      height: double.infinity,
      width: getWidth(context),
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(width: 1.5, color: accentColor.withOpacity(0.2)),
        color: theme.brightness == Brightness.light
            ? accentColor.withOpacity(0.1)
            : Colors.grey.shade900.withOpacity(0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () {
                    Navigator.pushNamed(context, '/prefs');
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
            leading: Icon(
              Icons.rss_feed_outlined,
              size: 14,
              color: theme.brightness == Brightness.light
                  ? accentColor
                  : Colors.white,
            ),
            title: Text(
              'Drsstiny',
              style: TextStyle(
                color: theme.brightness == Brightness.light
                    ? accentColor
                    : Colors.white,
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
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0),
              filled: true,
              hintText: "Search",
              hintStyle: TextStyle(
                  color: theme.brightness == Brightness.light
                      ? Colors.black54
                      : Colors.white54),
              prefixIcon: Icon(
                Icons.search,
                size: 16,
                color: theme.brightness == Brightness.light
                    ? Colors.black54
                    : Colors.white54,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide.none,
              ),
              fillColor: theme.brightness == Brightness.light
                  ? Colors.black12
                  : Colors.white12,
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
              child: Text(
                "Add RSS Feed",
                style:
                    TextStyle(color: accentColor, fontWeight: FontWeight.w500),
              )),
        ],
      ),
    );
  }
}
