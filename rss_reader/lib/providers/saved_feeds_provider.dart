import 'package:flutter/material.dart';
import 'package:rss_reader/helpers/database_helper.dart';
import 'package:rss_reader/models/raw_feed.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavedFeedsNotifer extends Notifier<List<RawFeed>> {
  @override
  List<RawFeed> build() {
    return [];
  }

  void fetchAllFeeds() async {
    // Fetch all feeds from the database
    try {
      await DatabaseHelper().getSavedFeeds().then((feeds) {
        debugPrint("Fetched feeds: ${feeds.length}");
        state = feeds;
      });
    } catch (e) {
      debugPrint("Error fetching feeds: $e");
    }
  }

  void addFeed(RawFeed feed) async {
    await DatabaseHelper().saveFeed(feed).then((v) {
      debugPrint("${feed.title} added! Feed saved! ");
      state = [...state, feed];
    });
  }

  void removeFeed(int index) async {
    debugPrint("No. of feeds before deletion in DB: ${state.length}");
    try {
      await DatabaseHelper().deleteFeed(index);
    } catch (e) {
      debugPrint("Couldn't remove feed! ${e.toString()}");
    }
    debugPrint("No. of feeds after deletion in DB: ${state.length}");
  }

  void removeFeedWithTitle(String title) async {
    debugPrint("No. of feeds before deletion in DB: ${state.length}");
    try {
      await DatabaseHelper().deleteFeedWithTitle(title);
    } catch (e) {
      debugPrint("Couldn't remove feed! ${e.toString()}");
    }
    debugPrint("No. of feeds after deletion in DB: ${state.length}");
  }

  List<RawFeed> searchFeeds(String query) {
    return state
        .where((feed) =>
            feed.title.toLowerCase().contains(query.toLowerCase()) ||
            feed.link.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void removeAllFeeds() {
    state = [];
  }
}

//
final savedFeedsProvider =
    NotifierProvider<SavedFeedsNotifer, List<RawFeed>>(() {
  return SavedFeedsNotifer();
});
