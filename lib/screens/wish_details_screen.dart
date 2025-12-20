import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wish_saver/widgets/gradient_progress_bar.dart';
import '../models/wish.dart';
import '../services/wish_service.dart';

class WishDetalsScreen extends StatefulWidget{
  final Wish wish;
  final WishService wishService;

  const WishDetalsScreen({
    super.key,
    required this.wish,
    required this.wishService,
  });

  @override
  State<WishDetalsScreen> createState() => _WishDetailsScreenState();
}

class _WishDetailsScreenState extends State<WishDetalsScreen> {
  final TextEditingController _addAmountCtrl = TextEditingController();

  Future<void> _openUrl() async {
    if (widget.wish.storeUrl == null) return;

    final uri = Uri.parse(widget.wish.storeUrl!);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось открыть ссылку')),
      );
    }
  }

  void _addAmount() {
      //restore after isar
    _addAmountCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final wish = widget.wish;
    
    final progress = wish.targetAmount == 0
    ? 0.0
    : (wish.currentAmount / wish.targetAmount).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(title: Text(wish.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Накоплено: ${wish.currentAmount.toStringAsFixed(2)} / ${wish.targetAmount} zł',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),

            GradientProgressBar(progress: progress),

            if (wish.storeUrl != null && wish.storeUrl!.isNotEmpty)
              ElevatedButton(onPressed: _openUrl, child: const Text('Открыть магазин'),
              ),
            
            const SizedBox(height: 24),

            TextField(
              controller: _addAmountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Добавить сумму (zł)',
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton(onPressed: _addAmount, child: const Text('Добавить'),
            ),
          ],
        ),
      ),
    );
  }
}

