import 'package:flutter/material.dart';
import '../models/wish.dart';
import '../widgets/gradient_progress_bar.dart';

//карточка для одной цели
class WishCard  extends StatelessWidget{
  final Wish wish;
  final void Function(double amount) onAddPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback? onTap;

  const WishCard({
    super.key,
    required this.wish,
    this.onTap,
    required this.onAddPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    final progress = wish.targetAmount == 0
        ? 0.0
        : (wish.currentAmount / wish.targetAmount).clamp(0.0, 1.0);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
       child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        child: ListTile(
          onTap: onTap,
          title: Text(wish.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${wish.currentAmount.toStringAsFixed(2)} / ${wish.targetAmount.toStringAsFixed(2)} zł'),
              const SizedBox(height: 4),
             GradientProgressBar(progress: progress)
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _QuickAddButton(
                    label: '+10',
                    onTap: () => onAddPressed(10),
                  ),
                  _QuickAddButton(
                    label: '+20',
                    onTap: () => onAddPressed(20),
                  ),
                  _QuickAddButton(
                    label: '+50',
                    onTap: () => onAddPressed(50),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: onDeletePressed,
                  ),
                ],  
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickAddButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}
