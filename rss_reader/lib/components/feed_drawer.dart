import 'package:flutter/material.dart';
import 'package:rss_dart/dart_rss.dart';
import 'package:rss_reader/components/custom_list_tile.dart';
import 'package:rss_reader/providers/feed_provider.dart';

class FeedDrawer extends StatelessWidget {
  const FeedDrawer({super.key});

  double getWidth(BuildContext context) {
    const double minSize = 200;
    final double width = MediaQuery.of(context).size.width * 0.2;
    // If the width is less than the minimum size, return the minimum size
    return width < minSize ? minSize : width;
  }

  @override
  Widget build(BuildContext context) {
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
          const CustomListTile(
            title: "verge.com",
          ),
          const CustomListTile(
            title: "techcrunch.com",
          ),
          const CustomListTile(
            title: "wired.com",
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

class TextBox extends StatelessWidget {
  const TextBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(2),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Colors.orange[200]!,
            width: 2,
          )),
      content: TextField(
        decoration: const InputDecoration(
          hintText: "Enter RSS Feed URL",
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        onSubmitted: (value) {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
