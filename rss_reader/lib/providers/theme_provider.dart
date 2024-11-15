import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rss_reader/helpers/theme_helper.dart';

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(darkTheme);

  void toggleTheme() {
    state = (state.brightness == Brightness.light) ? darkTheme : lightTheme;
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>(
  (ref) => ThemeNotifier(),
);
