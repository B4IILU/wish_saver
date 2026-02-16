import 'package:flutter/material.dart';
import 'package:wish_saver/l10n/app_localizations.dart';
import 'package:wish_saver/models/wish.dart';
import 'package:wish_saver/screens/add_wish_screen.dart';
import 'package:wish_saver/screens/completed_history_screen.dart';
import 'package:wish_saver/screens/congratulation_screen.dart';
import 'package:wish_saver/screens/wish_details_screen.dart';
import 'package:wish_saver/services/free_money_service.dart';
import 'package:wish_saver/services/wish_service.dart';
import 'package:wish_saver/widgets/add_wish_button.dart';
import 'package:wish_saver/widgets/fake_add_banner.dart';
import 'package:wish_saver/widgets/free_money_card.dart';
import 'package:wish_saver/widgets/settings_drawer.dart';
import 'package:wish_saver/widgets/wish_card.dart';

class HomeScreen extends StatefulWidget {
  final WishService wishService;
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;
  final Function(Locale) onLocaleChanged;

  const HomeScreen({
    super.key,
    required this.wishService,
    required this.isDark,
    required this.onThemeChanged,
    required this.onLocaleChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Wish> _wishes = [];
  double _freeMoney = 0;

  double? _parseAmount(String raw) {
    final normalized = raw.trim().replaceAll(',', '.');
    return double.tryParse(normalized);
  }

  Future<void> _showWithdrawFreeMoneyDialog() async {
    final amountController = TextEditingController();
    String? errorText;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.withdrawFreeMoneyTitle),
              content: TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                autofocus: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.withdrawAmountLabel,
                  errorText: errorText,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                FilledButton(
                  onPressed: () async {
                    final amount = _parseAmount(amountController.text);
                    final loc = AppLocalizations.of(context)!;

                    if (amount == null || amount <= 0) {
                      setDialogState(() {
                        errorText = loc.amountMustBeGreaterThanZero;
                      });
                      return;
                    }

                    if (amount > _freeMoney) {
                      setDialogState(() {
                        errorText = loc.notEnoughFreeMoney;
                      });
                      return;
                    }

                    await FreeMoneyService().subtract(amount);

                    if (!mounted) return;
                    await _loadFreeMoney();

                    if (!dialogContext.mounted) return;
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.withdraw),
                ),
              ],
            );
          },
        );
      },
    );

    amountController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    await Future.wait([_loadWishes(), _loadFreeMoney()]);
  }

  Future<void> _loadWishes() async {
    final wishes = await widget.wishService.getWishes();
    if (!mounted) return;
    setState(() {
      _wishes = wishes;
    });
  }

  Future<void> _loadFreeMoney() async {
    final amount = await FreeMoneyService().getAmount();
    if (!mounted) return;
    setState(() {
      _freeMoney = amount;
    });
  }

  void _showMoveFreeMoneySheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  AppLocalizations.of(context)!.freeMoneyWhere,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (_wishes.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(AppLocalizations.of(context)!.noTargets),
                )
              else
                ..._wishes.map(
                  (w) => ListTile(
                    title: Text(w.title),
                    subtitle: Text(
                      '${w.currentAmount.toStringAsFixed(2)} / '
                      '${w.targetAmount.toStringAsFixed(2)} zł',
                    ),
                    onTap: () async {
                      await widget.wishService.moveFreeMoneyToWish(w.id);

                      if (!context.mounted) return;

                      final updated = await widget.wishService.getWishes();
                      final updatedWish = updated.firstWhere(
                        (x) => x.id == w.id,
                      );
                      final isCompleted =
                          updatedWish.currentAmount >= updatedWish.targetAmount;

                      if (!context.mounted) return;

                      Navigator.pop(context);

                      if (isCompleted && context.mounted) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CongratulationScreen(),
                          ),
                        );
                      }

                      await _loadAllData();
                    },
                  ),
                ),
              ListTile(
                leading: const Icon(Icons.remove_circle_outline),
                title: Text(
                  AppLocalizations.of(context)!.withdrawFromFreeMoney,
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await _showWithdrawFreeMoneyDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: Text(AppLocalizations.of(context)!.cancel),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleQuickAdd(Wish wish, double amount) async {
    if (wish.currentAmount >= wish.targetAmount) {
      return;
    }

    await widget.wishService.addMoneyToWish(wish.id, amount);
    await _loadAllData();

    final updated = _wishes.firstWhere((w) => w.id == wish.id);
    final isCompleted = updated.currentAmount >= updated.targetAmount;

    if (isCompleted && mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CongratulationScreen()),
      );
    }
  }

  Future<void> _openCompletedHistory() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CompletedHistoryScreen(wishService: widget.wishService),
      ),
    );

    await _loadAllData();
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.spa_outlined, color: colorScheme.primary),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                AppLocalizations.of(context)!.noTargetsNow,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: SettingsDrawer(
        isDark: widget.isDark,
        onThemeChanged: widget.onThemeChanged,
        onLocaleChanged: widget.onLocaleChanged,
        onHistoryTap: _openCompletedHistory,
      ),
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.myTargets)),
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.primaryContainer.withValues(alpha: 0.34),
                    colorScheme.surface,
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              if (_freeMoney > 0)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _showMoveFreeMoneySheet,
                    child: FreeMoneyCard(amount: _freeMoney),
                  ),
                ),
              Expanded(
                child: _wishes.isEmpty
                    ? _buildEmptyState(context)
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 140, top: 4),
                        itemCount: _wishes.length,
                        itemBuilder: (context, index) {
                          final wish = _wishes[index];

                          return WishCard(
                            wish: wish,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WishDetalsScreen(
                                    wish: wish,
                                    wishService: widget.wishService,
                                  ),
                                ),
                              );

                              await _loadAllData();
                            },
                            onAddPressed: (amount) async {
                              await _handleQuickAdd(wish, amount);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 96,
            child: AddWishButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddWishScreen(wishService: widget.wishService),
                  ),
                );
                await _loadAllData();
              },
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FakeAddBanner(),
          ),
        ],
      ),
    );
  }
}
