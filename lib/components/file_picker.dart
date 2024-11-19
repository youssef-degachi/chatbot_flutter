import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

class FilePickerWidget extends StatelessWidget {
  final Function(File) onFileSelected;

  const FilePickerWidget({Key? key, required this.onFileSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.attach_file),
      onPressed: () async {
        try {
          final result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: [
              'jpg', 'jpeg', 'png', 'gif', 
              'pdf', 'doc', 'docx', 'txt'
            ],
          );

          if (result != null) {
            final filePath = result.files.single.path;
            if (filePath != null) {
              final file = File(filePath);
              final fileSize = await file.length();
              
              if (fileSize < 10 * 1024 * 1024) { // 10MB limit
                onFileSelected(file);
              } else {
                _showErrorDialog(context, 'File size exceeds 10MB');
              }
            }
          }
        } catch (e) {
          _showErrorDialog(context, 'Error selecting file: $e');
        }
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('File Selection Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }
}