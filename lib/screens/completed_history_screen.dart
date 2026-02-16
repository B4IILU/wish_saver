import 'package:flutter/material.dart';
import 'package:wish_saver/l10n/app_localizations.dart';
import 'package:wish_saver/models/completed_wish.dart';
import 'package:wish_saver/services/wish_service.dart';

class CompletedHistoryScreen extends StatefulWidget {
  final WishService wishService;

  const CompletedHistoryScreen({super.key, required this.wishService});

  @override
  State<CompletedHistoryScreen> createState() => _CompletedHistoryScreenState();
}

class _CompletedHistoryScreenState extends State<CompletedHistoryScreen> {
  List<CompletedWish> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final data = await widget.wishService.getCompletedWishes();
    if (!mounted) return;

    setState(() {
      _items = data;
      _isLoading = false;
    });
  }

  String _date(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    return '$day.$month.${value.year}';
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(loc.completedTargets)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
          ? Center(
              child: Text(
                loc.noCompletedTargets,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
              itemCount: _items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = _items[index];
                return Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${item.savedAmount.toStringAsFixed(2)} / '
                          '${item.targetAmount.toStringAsFixed(2)} zł',
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${loc.completedAt}: ${_date(item.completedAt)}',
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
