import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rss_reader/providers/bookmarks_provider.dart';

class BookmarksPage extends ConsumerWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // get the saved bookmarks
    final bookmarks = ref.watch(bookmarksProvider);

    // return the scaffold
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmarks"),
      ),
      body: ListView.builder(
        itemCount: bookmarks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(bookmarks[index].title),
            subtitle: Text(bookmarks[index].link),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                ref.read(bookmarksProvider.notifier).removeBookmark(index);
              },
            ),
          );
        },
      ),
    );
  }
}
