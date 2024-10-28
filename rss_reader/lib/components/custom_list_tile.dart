import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        icon: const Icon(Icons.menu),
        onPressed: () {},
      ),
      onTap: () {
        ref.read(selectedFeedProvider.notifier).selectFeed(index);
      },
    );
  }
}
