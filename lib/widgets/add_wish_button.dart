import 'package:flutter/material.dart';
import 'package:wish_saver/l10n/app_localizations.dart';

class AddWishButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddWishButton({
    super.key,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(16),
      color: colorScheme.primary,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical:12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: colorScheme.onPrimary),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.addTarget,
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
