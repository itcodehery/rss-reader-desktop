import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

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
  AccentColorNotifier() : super(Colors.orange);

  void updateAccentColor(MaterialColor newColor) {
    state = newColor;
  }
}

final accentColorProvider =
    StateNotifierProvider<AccentColorNotifier, MaterialColor>(
  (ref) => AccentColorNotifier(),
);
