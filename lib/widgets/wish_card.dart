import 'package:flutter/material.dart';
import '../models/wish.dart';

//карточка для одной цели
class WishCard  extends StatelessWidget{
  final Wish wish;
  final VoidCallback onAddPressed;
  final VoidCallback onDeletePressed;

  const WishCard({
    super.key,
    required this.wish,
    required this.onAddPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    final prodress = wish.targetAmount == 0
        ? 0.0
        : (wish.savedAmount / wish.targetAmount).clamp(0.0, 1.0);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(wish.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${wish.savedAmount.toStringAsFixed(2)} / ${wish.targetAmount.toStringAsFixed(2)} zł'),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: prodress,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: onAddPressed,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDeletePressed,
            ),
          ],
        ),
      ),
    );
  }
}