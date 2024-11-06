import 'package:flutter/material.dart';
import 'package:rss_reader/components/custom_list_tile.dart';
import 'package:rss_reader/helpers/database_helper.dart';
import 'package:rss_reader/helpers/misc_functions.dart';
import 'package:rss_reader/models/raw_feed.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rss_reader/providers/feed_fetcher.dart';
import 'package:rss_reader/providers/saved_feeds_provider.dart';
import 'package:rss_reader/providers/selected_feed_provider.dart';
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
  void initState() {
    super.initState();
    // ref.read(savedFeedsProvider.notifier).fetchAllFeeds();
    // wrong place to call this function
  }

  @override
  Widget build(BuildContext context) {
    final feeds = ref.watch(savedFeedsProvider);
    // listen to the saved feeds provider

    const buttonStyle = ButtonStyle(
      // width max
      minimumSize: WidgetStatePropertyAll(Size.fromHeight(50)),
      backgroundColor: WidgetStatePropertyAll(Colors.white10),
    );
    return Container(
      height: double.infinity,
      width: getWidth(context),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: Colors.white10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            trailing: IconButton(
                onPressed: () {
                  ref.read(selectedFeedProvider.notifier);
                  showToast("Refreshing feeds...", ToastificationType.info);
                },
                icon: const Icon(Icons.refresh)),
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
          if (feeds.isNotEmpty) ...[
            ListView.builder(
              shrinkWrap: true,
              itemCount: feeds.length,
              itemBuilder: (context, index) {
                return CustomListTile(
                  title: feeds[index].title,
                  index: index,
                );
              },
            ),
            const Spacer(),
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
                    return const TextBox();
                  },
                );
              },
              child: const Text(
                "Add RSS Feed",
                style: TextStyle(
                    color: Colors.deepOrange, fontWeight: FontWeight.w500),
              )),
          const SizedBox(height: 12),
          ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                DatabaseHelper().deleteDB();
              },
              child: const Text("Remove All Feeds",
                  style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}

class TextBox extends ConsumerWidget {
  const TextBox({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController titleController = TextEditingController();
    TextEditingController urlController = TextEditingController();
    final savedFeeds = ref.watch(savedFeedsProvider.notifier);
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return AlertDialog(
      backgroundColor: Colors.grey.shade900,
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(2),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add RSS Feed",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text("Enter the title and the RSS feed URL",
                      style: TextStyle(color: Colors.white54)),
                ],
              ),
            ),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Enter Title",
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a title";
                }
                return null;
              },
              controller: titleController,
            ),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Enter RSS Feed URL",
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
              controller: urlController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a valid URL";
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.transparent),
              foregroundColor: WidgetStatePropertyAll(Colors.white),
              elevation: WidgetStatePropertyAll(0)),
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              RawFeed? feed;
              await getFeedType(urlController.text).then((type) {
                feed = RawFeed(
                  title: titleController.text,
                  link: urlController.text,
                  type: type,
                );
              });

              if (feed != null) {
                savedFeeds.addFeed(feed!);
              }
              if (context.mounted) {
                // you learn something new everyday
                Navigator.pop(context);
              }
              showToast("Adding ${titleController.text} Feed",
                  ToastificationType.info);
              ref.read(savedFeedsProvider.notifier).refresh();
            }
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
