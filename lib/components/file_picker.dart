import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FilePickerWidget extends StatelessWidget {
  final Function(String) onFileSelected;

  FilePickerWidget({required this.onFileSelected});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.attach_file),
      onPressed: () async {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'jpg', 'png'],
        );
        if (result != null) {
          onFileSelected(result.files.single.path!);
        }
      },
    );
  }
}
