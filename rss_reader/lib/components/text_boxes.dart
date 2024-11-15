import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rss_reader/helpers/misc_functions.dart';
import 'package:rss_reader/models/raw_feed.dart';
import 'package:rss_reader/providers/feed_utility.dart';
import 'package:rss_reader/providers/saved_feeds_provider.dart';
import 'package:toastification/toastification.dart';

class TextBoxRSS extends ConsumerWidget {
  const TextBoxRSS({
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
              await fetchImageFromFeed(urlController.text).then(
                (value) async {
                  await getFeedType(urlController.text).then((type) {
                    feed = RawFeed(
                      title: titleController.text,
                      link: urlController.text,
                      type: type,
                    );
                  });
                },
              );

              if (feed != null) {
                savedFeeds.addFeed(feed!);
              }
              if (context.mounted) {
                // you learn something new everyday
                Navigator.pop(context);
              }
              showToast("Adding ${titleController.text} Feed",
                  ToastificationType.info);
            }
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}