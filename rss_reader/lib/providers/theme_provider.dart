import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rss_reader/helpers/theme_helper.dart';
import 'package:rss_reader/providers/customization_provider.dart';

// Define the ThemeNotifier to listen for changes in the accent color
class ThemeNotifier extends StateNotifier<ThemeData> {
  final Ref _ref;

  ThemeNotifier(this._ref)
      : super(ThemeHelper().darkTheme(
          _ref.read(accentColorProvider), // Initial color
        ));

  // Toggle between light and dark themes dynamically
  void toggleTheme() {
    final accentColor = _ref.read(accentColorProvider); // Current accent color
    state = (state.brightness == Brightness.light)
        ? ThemeHelper().darkTheme(accentColor)
        : ThemeHelper().lightTheme(accentColor);
  }

  // React to accent color changes and update the theme
  void updateThemeBasedOnAccentColor(MaterialColor newColor) {
    state = (state.brightness == Brightness.light)
        ? ThemeHelper().lightTheme(newColor)
        : ThemeHelper().darkTheme(newColor);
  }
}

// Create the themeProvider and make it react to accentColor changes
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>(
  (ref) {
    final themeNotifier = ThemeNotifier(ref);

    // Listen to changes in the accentColorProvider
    ref.listen<MaterialColor>(accentColorProvider, (previous, next) {
      themeNotifier.updateThemeBasedOnAccentColor(next);
    });

    return themeNotifier;
  },
);
