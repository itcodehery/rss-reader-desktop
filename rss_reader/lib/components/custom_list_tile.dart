import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    // TODO: make a menu button appear on hover
    return InkWell(
      onTap: () {},
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(
          radius: 10,
          backgroundColor: Colors.deepOrange,
          child: FittedBox(
            child: Icon(
              Icons.rss_feed,
              size: 12,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
      ),
    );
  }
}
