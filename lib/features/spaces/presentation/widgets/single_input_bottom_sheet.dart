import 'package:design/design.dart';
import 'package:flutter/material.dart';

class SingleInputBottomSheetPage extends StatefulWidget {
  const SingleInputBottomSheetPage({
    super.key,
    required this.title,
    required this.label,
    this.descriptionLabel,
  });

  final String title;
  final String label;
  final String? descriptionLabel;

  @override
  State<SingleInputBottomSheetPage> createState() =>
      _SingleInputBottomSheetPageState();
}

class _SingleInputBottomSheetPageState
    extends State<SingleInputBottomSheetPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      return;
    }
    Navigator.of(context).pop(
      SingleInputResult(
        title: title,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingBottomSheetLayout(
      children: [
        Text(widget.title),
        const SizedBox(height: 12),
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            labelText: widget.label,
            border: const OutlineInputBorder(),
          ),
        ),
        if (widget.descriptionLabel != null) ...[
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: widget.descriptionLabel,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _onSubmit,
            child: const Text('Save'),
          ),
        ),
      ],
    );
  }
}

class SingleInputResult {
  const SingleInputResult({required this.title, this.description});

  final String title;
  final String? description;
}
