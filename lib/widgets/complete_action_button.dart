import 'package:flutter/material.dart';
import 'package:wish_saver/l10n/app_localizations.dart';


class CompleteActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? label;

  const CompleteActionButton({
    super.key,
    required this.onPressed,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label ?? AppLocalizations.of(context)!.done),
    );
  }
}
