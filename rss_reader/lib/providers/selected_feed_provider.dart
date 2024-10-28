import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rss_reader/models/raw_feed.dart';
import 'package:rss_reader/providers/saved_feeds_provider.dart';

class SelectedFeedNotifier extends Notifier<RawFeed?> {
  @override
  RawFeed? build() {
    return null;
  }

  void selectFeed(int index) {
    final feed = ref.read(savedFeedsProvider);
    state = feed[index];
  }

  void deselectFeed() {
    state = null;
  }
}

final selectedFeedProvider =
    NotifierProvider<SelectedFeedNotifier, RawFeed?>(() {
  return SelectedFeedNotifier();
});
