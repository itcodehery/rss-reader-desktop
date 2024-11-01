import 'package:html/parser.dart' as html_parser;

String parseHtmlToPlainText(String htmlString) {
  // Parse the HTML content
  final document = html_parser.parse(htmlString);
  // Extract and return only the text content
  return document.body?.text ?? '';
}
