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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const ListTile(
              title: Text("Accent Color"),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 5,
                childAspectRatio: 5,
                padding: const EdgeInsets.all(4),
                children: ThemeHelper().colorOptions.map((e) {
                  return GestureDetector(
                    onTap: () {
                      ref
                          .read(accentColorProvider.notifier)
                          .updateAccentColor(e);
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
            ),
            ListTile(
              title: const Text("Toggle Theme"),
              trailing: TextButton(
                onPressed: () {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
                child: Text(
                  ref.watch(themeProvider).brightness == Brightness.light
                      ? "Currently set to Light"
                      : "Currently set to Dark",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
