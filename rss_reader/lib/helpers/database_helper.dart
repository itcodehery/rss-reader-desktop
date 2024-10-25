import 'package:flutter/material.dart';
import 'package:rss_reader/models/raw_feed.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Future<List<RawFeed>> getSavedFeeds() async {
    List<RawFeed> savedFeeds = [];
    var db = await openDatabase('saved_feeds.db', onCreate: (db, version) {
      debugPrint("Creating database");
      return db.execute(
        'CREATE TABLE saved_feeds(id INTEGER PRIMARY KEY, title TEXT, link TEXT)',
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

  Future<void> saveFeed(RawFeed feed) async {
    var db = await openDatabase('saved_feeds.db', onCreate: (db, version) {
      debugPrint("Creating database");
      return db.execute(
        'CREATE TABLE saved_feeds(id INTEGER PRIMARY KEY, title TEXT, link TEXT)',
      );
    }, version: 1);

    await db.insert('saved_feeds', feed.toJson());
  }
}
