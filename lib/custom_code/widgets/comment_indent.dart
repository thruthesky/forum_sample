// Automatic FlutterFlow imports
import '../../backend/backend.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '../../flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';

// Begin custom widget code
class CommentIndent extends StatefulWidget {
  const CommentIndent({
    Key? key,
    this.width,
    this.height,
    required this.indent,
  }) : super(key: key);

  final double? width;
  final double? height;
  final double indent;

  @override
  _CommentIndentState createState() => _CommentIndentState();
}

class _CommentIndentState extends State<CommentIndent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: widget.indent, height: 5);
  }
}
