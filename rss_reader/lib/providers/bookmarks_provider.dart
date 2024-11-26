import 'package:flutter/material.dart';
import 'package:rss_reader/helpers/bookmark_db_helper.dart';
import 'package:rss_reader/helpers/database_helper.dart';
import 'package:rss_reader/models/bookmark_article.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookmarksNotifier extends Notifier<List<BookmarkArticle>> {
  @override
  List<BookmarkArticle> build() {
    return [];
  }

  void fetchAllBookmarks() async {
    // Fetch all bookmarks from the database
    try {
      await BookmarkDbHelper().getBookmarks().then((bookmarks) {
        debugPrint("Fetched bookmarks: ${bookmarks.length}");
        state = bookmarks;
      });
    } catch (e) {
      debugPrint("Error fetching bookmarks: $e");
    }
  }

  void addBookmark(BookmarkArticle bookmark) async {
    await BookmarkDbHelper().insertBookmark(bookmark).then((v) {
      debugPrint("${bookmark.title} added! Bookmark saved!");
      state = [...state, bookmark];
    });
  }

  void removeBookmark(int index) async {
    debugPrint("No. of bookmarks before deletion in DB: ${state.length}");
    try {
      await BookmarkDbHelper().deleteBookmark(index);
    } catch (e) {
      debugPrint("Couldn't remove bookmark! ${e.toString()}");
    }
    debugPrint("No. of bookmarks after deletion in DB: ${state.length}");
  }

  void removeBookmarkWithTitle(String title) async {
    debugPrint("No. of bookmarks before deletion in DB: ${state.length}");
    try {
      await BookmarkDbHelper().deleteBookmarkWithTitle(title);
    } catch (e) {
      debugPrint("Couldn't remove bookmark! ${e.toString()}");
    }
    debugPrint("No. of bookmarks after deletion in DB: ${state.length}");
  }

  List<BookmarkArticle> searchBookmarks(String query) {
    return state
        .where((bookmark) =>
            bookmark.title.toLowerCase().contains(query.toLowerCase()) ||
            bookmark.link.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void removeAllBookmarks() {
    state = [];
  }
}

final bookmarksProvider =
    NotifierProvider<BookmarksNotifier, List<BookmarkArticle>>(() {
  return BookmarksNotifier();
});
