import 'package:design/design.dart';
import 'package:flutter/material.dart';

class CreateSpaceBottomSheetPage extends StatefulWidget {
  const CreateSpaceBottomSheetPage({super.key});

  @override
  State<CreateSpaceBottomSheetPage> createState() =>
      _CreateSpaceBottomSheetPageState();
}

class _CreateSpaceBottomSheetPageState
    extends State<CreateSpaceBottomSheetPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onCreatePressed() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      return;
    }
    Navigator.of(context).pop(
      CreateSpaceResult(
        name: name,
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
        const Text('Create space'),
        const SizedBox(height: 12),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description (optional)',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _onCreatePressed,
            child: const Text('Create'),
          ),
        ),
      ],
    );
  }
}

class CreateSpaceResult {
  const CreateSpaceResult({required this.name, this.description});

  final String name;
  final String? description;
}
