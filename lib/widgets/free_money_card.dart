import 'package:flutter/material.dart';
import 'package:wish_saver/l10n/app_localizations.dart';

class FreeMoneyCard extends StatelessWidget {
  final double amount;

  const FreeMoneyCard({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.local_florist_outlined,
                  size: 20,
                  color: colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.freeMoney,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '${amount.toStringAsFixed(2)} zł',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSecondaryContainer.withValues(
                    alpha: 0.8,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
