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
    await DatabaseHelper().getSavedFeeds().then((feeds) {
      debugPrint("Fetched feeds: ${feeds.length} ${feeds.first.link}");
      state = feeds;
    });
  }

  void addFeed(RawFeed feed) {
    state = [...state, feed];
  }

  void removeFeed(int index) {
    DatabaseHelper().deleteFeed(index);
    state.removeAt(index);
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
