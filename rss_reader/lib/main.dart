import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rss_reader/components/feed_drawer.dart';
import 'package:rss_reader/components/feed_home.dart';
import 'package:rss_reader/pages/search_page.dart';
import 'package:rss_reader/pages/splash_page.dart';
import 'package:rss_reader/providers/saved_feeds_provider.dart';
import 'package:rss_reader/providers/theme_provider.dart';
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
    final theme = ref.watch(themeProvider);
    return ToastificationWrapper(
      child: MaterialApp(
        title: 'Drsstiny',
        debugShowCheckedModeBanner: false,
        theme: theme,
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
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: screenWidth > 600
          ? const Row(
              children: [
                FeedDrawer(),
                FeedHome(),
              ],
            )
          : const Column(
              children: [
                FeedDrawer(),
                FeedHome(),
              ],
            ),
    );
  }
}
