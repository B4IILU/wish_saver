import 'package:flutter/material.dart';
import 'package:wish_saver/l10n/app_localizations.dart';
import 'package:wish_saver/models/wish.dart';
import 'package:wish_saver/services/wish_service.dart';


class EditWishBottomSheet extends StatefulWidget {
  final Wish wish;
  final WishService wishService;

  const EditWishBottomSheet({
    super.key,
    required this.wish,
    required this.wishService,
  });

  @override
  State<EditWishBottomSheet> createState() => _EditWishBottomSheetStaate();
}

class _EditWishBottomSheetStaate extends State<EditWishBottomSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _targetController;
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.wish.title);
    _targetController = TextEditingController(
      text: widget.wish.targetAmount.toString(),
    );
    _urlController = TextEditingController(text: widget.wish.storeUrl ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _save() async {
    final title = _titleController.text.trim();
    final targetText = _targetController.text.trim();
    final url = _urlController.text.trim();

    if (title.isEmpty || targetText.isEmpty) return;

    final newTarget = double.tryParse(targetText);
    if (newTarget == null || newTarget < 0) return;

    await widget.wishService.updateWishMeta(
      wishId: widget.wish.id,
      title: title,
      targetAmount: newTarget,
      storeUrl: url.isEmpty ? null : url,
    );

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           Text(
            AppLocalizations.of(context)!.editTarget,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

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

          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: _save,
                  child: Text(AppLocalizations.of(context)!.save),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
