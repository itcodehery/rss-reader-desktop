import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

String toSentenceCase(String text) {
  text = text.trim();
  return text[0].toUpperCase() + text.substring(1);
}

ToastificationItem showToast(String text, ToastificationType type) {
  Toastification toastification = Toastification();
  return toastification.show(
    type: type,
    autoCloseDuration: const Duration(seconds: 3),
    applyBlurEffect: true,
    borderSide: BorderSide.none,
    title: Text(
      text,
      style: const TextStyle(color: Colors.white),
    ),
    showProgressBar: false,
    backgroundColor: Colors.black38,
    pauseOnHover: true,
  );
}

Future<String> fetchImageFromFeed(String rssUrl) async {
  try {
    final response = await http.get(Uri.parse(rssUrl));
    final document = parser.parse(response.body);
    final imgElement = document.querySelector(
        'img'); // Replace with the appropriate CSS selector for the image

    if (imgElement != null) {
      return imgElement.attributes['src']!;
    } else {
      return '';
    }
  } catch (e) {
    debugPrint('Error fetching image: $e');
    return '';
  }
}
