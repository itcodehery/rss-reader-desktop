import 'package:flutter/material.dart';
import 'package:rss_reader/components/custom_list_tile.dart';
import 'package:rss_reader/helpers/database_helper.dart';
import 'package:rss_reader/models/raw_feed.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rss_reader/providers/saved_feeds_provider.dart';

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
          const ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Drsstiny',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: Text("Your Feeds"),
          ),
          const SizedBox(height: 12),
          if (feeds.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              itemCount: feeds.length,
              itemBuilder: (context, index) {
                return CustomListTile(
                  title: feeds[index].title,
                );
              },
            ),
          const Spacer(),
          ElevatedButton(
              style: const ButtonStyle(
                // width max
                minimumSize: WidgetStatePropertyAll(Size.fromHeight(50)),
                backgroundColor: WidgetStatePropertyAll(Colors.white10),
              ),
              onPressed: () {
                // var res =
                //     await fetchFeed("https://www.androidauthority.com/feed/");
                // debugPrint(res.first.title);
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

    return AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(2),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Colors.orange[200]!,
            width: 2,
          )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: "Enter Title",
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
            controller: titleController,
          ),
          TextField(
            decoration: const InputDecoration(
              hintText: "Enter RSS Feed URL",
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
            controller: urlController,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            RawFeed feed = RawFeed(
              title: titleController.text,
              link: urlController.text,
            );
            DatabaseHelper().saveFeed(feed);
            savedFeeds.addFeed(feed);
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
