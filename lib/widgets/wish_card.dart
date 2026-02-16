import 'package:flutter/material.dart';
import 'package:wish_saver/models/wish.dart';
import 'package:wish_saver/widgets/gradient_progress_bar.dart';

class WishCard extends StatelessWidget {
  final Wish wish;
  final void Function(double amount) onAddPressed;
  final VoidCallback? onTap;

  const WishCard({
    super.key,
    required this.wish,
    this.onTap,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = wish.targetAmount == 0
        ? 0.0
        : (wish.currentAmount / wish.targetAmount).clamp(0.0, 1.0);

    final isCompleted = wish.currentAmount >= wish.targetAmount;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        wish.title,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.chevron_right,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${wish.currentAmount.toStringAsFixed(2)} / ${wish.targetAmount.toStringAsFixed(2)} zł',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 8),
                GradientProgressBar(progress: progress),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _QuickAddButton(
                      label: '+10',
                      enabled: !isCompleted,
                      onTap: () => onAddPressed(10),
                    ),
                    _QuickAddButton(
                      label: '+20',
                      enabled: !isCompleted,
                      onTap: () => onAddPressed(20),
                    ),
                    _QuickAddButton(
                      label: '+50',
                      enabled: !isCompleted,
                      onTap: () => onAddPressed(50),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _QuickAddButton({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ActionChip(
      avatar: Icon(
        Icons.add_circle_outline,
        size: 16,
        color: enabled ? colorScheme.primary : colorScheme.outline,
      ),
      backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.5),
      disabledColor: colorScheme.surfaceContainerHighest,
      label: Text(label),
      labelStyle: TextStyle(
        color: enabled ? colorScheme.primary : colorScheme.outline,
        fontWeight: FontWeight.w700,
      ),
      onPressed: enabled ? onTap : null,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: const VisualDensity(horizontal: -1, vertical: -2),
    );
  }
}
