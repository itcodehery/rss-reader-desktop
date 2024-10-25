import 'package:flutter/material.dart';

class FeedHome extends StatelessWidget {
  const FeedHome({super.key});

  @override
  Widget build(BuildContext context) {
    // create a gridview depending on the width of the screen
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemBuilder: (context, index) {
          return Container(
            color: Colors.grey[300],
            child: Center(
              child: Text(
                'Feed $index',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          );
        },
        itemCount: 9,
      ),
    );
  }
}
