import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rss_reader/helpers/database_helper.dart';
import 'package:rss_reader/providers/saved_feeds_provider.dart';
import 'package:rss_reader/providers/selected_feed_provider.dart';

class CustomListTile extends ConsumerWidget {
  const CustomListTile({super.key, required this.title, required this.index});

  final String title;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
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
      ),
      trailing: IconButton(
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
                  title: const Text('Delete Feed'),
                  content:
                      const Text('Are you sure you want to delete this feed?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        ref.read(selectedFeedProvider.notifier).deselectFeed();
                        ref.read(savedFeedsProvider.notifier).removeFeed(index);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('No'),
                    ),
                  ],
                );
              });
        },
      ),
      onTap: () {
        ref.read(selectedFeedProvider.notifier).selectFeed(index);
      },
    );
  }
}
