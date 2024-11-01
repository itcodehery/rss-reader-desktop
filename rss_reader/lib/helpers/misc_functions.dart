String toSentenceCase(String text) {
  text = text.trim();
  return text[0].toUpperCase() + text.substring(1);
}
