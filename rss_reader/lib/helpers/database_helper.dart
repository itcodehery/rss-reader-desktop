import 'package:flutter/material.dart';
import 'package:rss_reader/models/raw_feed.dart';
import 'package:rss_reader/providers/feed_utility.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Future<List<RawFeed>> getSavedFeeds() async {
    List<RawFeed> savedFeeds = [];

    var db = await openDatabase('saved_feeds.db', onCreate: (db, version) {
      debugPrint("Creating database");
      return db.execute(
        'CREATE TABLE saved_feeds(id INTEGER PRIMARY KEY, title TEXT, link TEXT, type TEXT)',
      );
    }, version: 1);

    var feeds = await db.query('saved_feeds');
    if (feeds.isNotEmpty) {
      for (var feed in feeds) {
        savedFeeds.add(RawFeed.fromJson(feed));
      }
    } else {
      debugPrint("No feeds found");
    }

    return savedFeeds;
  }

  Future<void> deleteFeed(int index) async {
    var db = await openDatabase('saved_feeds.db', version: 1);

    try {
      await db
          .delete('saved_feeds', where: 'id = ?', whereArgs: [index]).then((v) {
        debugPrint("Feed deleted: $v");
      });
    } catch (e) {
      debugPrint("Error deleting feed: $e");
    }
  }

  Future<void> deleteFeedWithTitle(String title) async {
    var db = await openDatabase('saved_feeds.db', version: 1);

    try {
      await db.delete('saved_feeds',
          where: 'title = ?', whereArgs: [title]).then((v) {
        debugPrint("Feed deleted: $v");
      });
    } catch (e) {
      debugPrint("Error deleting feed: $e");
    }
  }

  Future<void> saveFeed(RawFeed feed) async {
    var db = await openDatabase('saved_feeds.db', onCreate: (db, version) {
      debugPrint("Creating database");
      return db.execute(
        'CREATE TABLE saved_feeds(id INTEGER PRIMARY KEY, title TEXT, link TEXT, type TEXT)',
      );
    }, version: 1);

    await db.insert('saved_feeds', feed.toJson());
  }

  Future<void> deleteDB() async {
    await deleteDatabase('saved_feeds.db');
  }

  String getFeedTypeInString(FeedType type) {
    switch (type) {
      case FeedType.rss:
        return 'RSS 2.0';
      case FeedType.atom:
        return 'Atom';
      case FeedType.rss1:
        return 'RSS 1.0';
      default:
        return 'Unknown';
    }
  }
}
