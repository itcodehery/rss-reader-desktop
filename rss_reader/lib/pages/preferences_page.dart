import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rss_reader/helpers/theme_helper.dart';
import 'package:rss_reader/providers/customization_provider.dart';
import 'package:rss_reader/providers/theme_provider.dart';

class PreferencesPage extends ConsumerWidget {
  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: const Text("Light Mode"),
              trailing: Switch(
                value: ref.watch(themeProvider).brightness == Brightness.light,
                onChanged: (value) {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
              ),
            ),
            const ListTile(
              title: Text("Accent Color"),
            ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 5,
              childAspectRatio: 5,
              padding: const EdgeInsets.all(4),
              children: ThemeHelper().colorOptions.map((e) {
                return GestureDetector(
                  onTap: () {
                    ref.read(accentColorProvider.notifier).updateAccentColor(e);
                    ref
                        .read(themeProvider.notifier)
                        .updateThemeBasedOnAccentColor(e);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color: ref.watch(accentColorProvider) == e
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 2),
                            color: e),
                      ),
                      Icon(
                        Icons.check,
                        color: ref.watch(accentColorProvider) == e
                            ? Colors.white
                            : Colors.transparent,
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
