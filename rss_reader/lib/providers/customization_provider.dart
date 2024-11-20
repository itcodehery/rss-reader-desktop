import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:rss_reader/helpers/shared_prefs_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontSizeNotifier extends StateNotifier<double> {
  FontSizeNotifier() : super(16.0);

  final double maxSize = 32.0;
  final double minSize = 8.0;

  void updateFontSize(double newSize) async {
    if (newSize > maxSize) {
      state = maxSize;
    } else if (newSize < minSize) {
      state = minSize;
    } else {
      state = newSize;
    }
  }
}

final fontSizeProvider = StateNotifierProvider<FontSizeNotifier, double>(
  (ref) => FontSizeNotifier(),
);

class AccentColorNotifier extends StateNotifier<MaterialColor> {
  AccentColorNotifier() : super(Colors.deepOrange);
  void initialize() {
    SharedPreferences.getInstance().then((prefs) {
      final color = prefs.getString('accent_color');
      if (color != null) {
        state = MaterialColor(int.parse(color), {
          50: Color(int.parse(color)).withOpacity(0.1),
          100: Color(int.parse(color)).withOpacity(0.2),
          200: Color(int.parse(color)).withOpacity(0.3),
          300: Color(int.parse(color)).withOpacity(0.4),
          400: Color(int.parse(color)).withOpacity(0.5),
          500: Color(int.parse(color)).withOpacity(0.6),
          600: Color(int.parse(color)).withOpacity(0.7),
          700: Color(int.parse(color)).withOpacity(0.8),
          800: Color(int.parse(color)).withOpacity(0.9),
          900: Color(int.parse(color)).withOpacity(1),
        });
      }
    });
  }

  void updateAccentColor(MaterialColor newColor) {
    state = newColor;
    SharedPrefsHelper.setString('accent_color', newColor.value.toString());
  }
}

final accentColorProvider =
    StateNotifierProvider<AccentColorNotifier, MaterialColor>(
  (ref) => AccentColorNotifier(),
);
