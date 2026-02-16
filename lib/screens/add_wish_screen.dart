import 'package:flutter/material.dart';
import 'package:wish_saver/l10n/app_localizations.dart';
import 'package:wish_saver/services/wish_service.dart';


// Экран для создания новой цели
class AddWishScreen extends StatefulWidget {
  final WishService wishService;

  const AddWishScreen({super.key, required this.wishService});

  @override
  State<AddWishScreen> createState() => _AddWishScreenState();
}

class _AddWishScreenState extends State<AddWishScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  //save & return back
  Future<void> _save() async {
    final title = _titleController.text.trim();
    final targetText = _targetController.text.trim();

    if (title.isEmpty || targetText.isEmpty) return;

    final target = double.tryParse(targetText);
    if (target == null || target <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(AppLocalizations.of(context)!.priceMustBePositive)),
      );
      return;
    }
    

    final url = _urlController.text.trim();

    await widget.wishService.addWish(
      title: title,
      targetAmount: target,
      storeUrl: url.isEmpty ? null : url,
    );

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.newTarget)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.name),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _targetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.price),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.url,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _save, child: Text(AppLocalizations.of(context)!.save)),
          ],
        ),
      ),
    );
  }
}
