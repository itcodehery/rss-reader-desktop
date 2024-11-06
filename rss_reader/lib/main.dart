import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rss_reader/components/feed_drawer.dart';
import 'package:rss_reader/components/feed_home.dart';
import 'package:rss_reader/pages/search_page.dart';
import 'package:rss_reader/pages/splash_page.dart';
import 'package:rss_reader/providers/saved_feeds_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:toastification/toastification.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await windowManager.ensureInitialized().then((_) {
    windowManager.setMinimumSize(const Size(800, 600)); // set minimum size
  });

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(savedFeedsProvider.notifier).fetchAllFeeds();
    return ToastificationWrapper(
      child: MaterialApp(
        title: 'Drsstiny',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          primarySwatch: Colors.deepOrange,
          useMaterial3: true,
          textTheme: GoogleFonts.dmSansTextTheme(),
        ),
        home: const SplashPage(),
        routes: {
          '/home': (context) => const HomePage(),
          '/search': (context) => const SearchPage(),
        },
      ),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Row(
        children: [
          FeedDrawer(),
          FeedHome(),
        ],
      ),
    );
  }
}
