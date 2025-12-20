import 'package:flutter/material.dart';
import '../services/wish_service.dart';

// Экран для создания новой цели
class AddWishScreen extends StatefulWidget{
  final WishService wishService;

  const AddWishScreen({
    super.key,
    required this.wishService,
  });

  @override
  State<AddWishScreen> createState() => _AddWishScreenState();
}

class _AddWishScreenState extends State<AddWishScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  //save & return back
  void _save() {
  final title = _titleController.text.trim();
  final targetText = _targetController.text.trim();

  if (title.isEmpty || targetText.isEmpty) return;

  final target = double.tryParse(targetText);
  if (target == null) return;

  final url = _urlController.text.trim();

  widget.wishService.addWish(
    title: title,
    targetAmount: target,
    storeUrl: url.isEmpty ? null : url,
  );

  Navigator.pop(context);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая хотелка'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Название',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _targetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Сколько надо бабла (zł)',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Ссылка на товар (необязательно)',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _save,
              child: const Text('Поехали')
            ),
          ],          
        ),
      ),
    );
  }
}