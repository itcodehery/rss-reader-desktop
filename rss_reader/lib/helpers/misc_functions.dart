import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

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
