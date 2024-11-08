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
    await DatabaseHelper().deleteFeed(index).then((v) {
      state.removeAt(index + 1);
      ref.invalidateSelf();
      fetchAllFeeds();
    });
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
