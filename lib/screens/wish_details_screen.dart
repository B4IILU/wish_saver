import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wish_saver/l10n/app_localizations.dart';
import 'package:wish_saver/models/wish.dart';
import 'package:wish_saver/models/wish_transaction.dart';
import 'package:wish_saver/screens/congratulation_screen.dart';
import 'package:wish_saver/services/wish_service.dart';
import 'package:wish_saver/widgets/complete_action_button.dart';
import 'package:wish_saver/widgets/edit_wish_bottom_sheet.dart';
import 'package:wish_saver/widgets/gradient_progress_bar.dart';

class WishDetalsScreen extends StatefulWidget {
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
  //контроллер поля ввода суммы
  final TextEditingController _addAmountCtrl = TextEditingController();
  // все цели для переноса в другую цель
  List<Wish> _allWishes = [];
  //ID ТЕКУЩЕЙ цели
  late int _wishId;
  //История транзакций ТЕКУЩЕЙ цели
  List<WishTransaction> _transactionHistory = [];

  // метод открытия ссылки
  Future<void> _openUrl() async {
    if (widget.wish.storeUrl == null) return;

    final uri = Uri.parse(widget.wish.storeUrl!);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        // ignore: use_build_context_synchronously
        SnackBar(content: Text(AppLocalizations.of(context)!.wrongUrl)),
      );
    }
  }

  //метод добавления денег к ТЕКУЩЕЙ цели
  Future<void> _onAddAmountPressed() async {
    final raw = _addAmountCtrl.text.trim();
    if (raw.isEmpty) return;
    final amount = double.tryParse(raw);
    if (amount == null || amount <= 0) return;

    await widget.wishService.addMoneyToWish(widget.wish.id, amount);

    if (!mounted) return;

    _addAmountCtrl.clear();
    await _reloadWish();
    await _loadTransactionHistory();
    debugPrint(
      'WishDetails: after add -> reloaded history length=${_transactionHistory.length}',
    );

    final isCompleted = widget.wish.currentAmount >= widget.wish.targetAmount;

    if (isCompleted && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CongratulationScreen()),
      );
    }
  }

  //оверлей удаления
  void _showDeleteOverlay() {
    final hasMoney = widget.wish.currentAmount > 0;

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
                  hasMoney
                      ? AppLocalizations.of(context)!.moneyWhere
                      : AppLocalizations.of(context)!.deleteTargetQQ,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              if (hasMoney) ...[
                ListTile(
                  leading: const Icon(Icons.account_balance_wallet),
                  title: Text(AppLocalizations.of(context)!.toFreeMoney),
                  onTap: () async {
                    await widget.wishService.deleteWishToFreeMoney(
                      widget.wish.id,
                    );

                    if (!context.mounted) return;

                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.swap_horiz),
                  title: Text(AppLocalizations.of(context)!.toAnotherTarget),
                  onTap: () {
                    Navigator.pop(context);
                    _showMoveToAnotherWishSheet(_allWishes);
                  },
                ),
              ] else ...[
                ListTile(
                  leading: const Icon(Icons.delete_forever),
                  title: Text(AppLocalizations.of(context)!.deleteTarget),
                  onTap: () async {
                    await widget.wishService.deleteWish(widget.wish.id);

                    if (!context.mounted) return;

                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
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

  //оверлей переноса денег
  void _showMoveToAnotherWishSheet(List<Wish> allWishes) {
    final currentId = widget.wish.id;

    final targets = allWishes.where((w) => w.id != currentId).toList();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  AppLocalizations.of(context)!.chooseTarget,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),

              if (targets.isEmpty)
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(AppLocalizations.of(context)!.noMoreTargets),
                )
              else
                ...targets.map(
                  (w) => ListTile(
                    title: Text(w.title),
                    subtitle: Text(
                      '${w.currentAmount.toStringAsFixed(2)} / '
                      '${w.targetAmount.toStringAsFixed(2)} zł',
                    ),
                    onTap: () async {
                      await widget.wishService.moveWishMoneyToAnotherWish(
                        fromWishId: widget.wish.id,
                        toWishId: w.id,
                      );

                      if (!context.mounted) return;

                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
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

  //фиксация ЭТОЙ цели
  @override
  void initState() {
    super.initState();
    //фиксация ID при первом открытии
    _wishId = widget.wish.id;
    //загрузка вспосогательных данных
    _loadWishes();
    //загрузка истории ЭТОЙ цели
    _loadTransactionHistory();
  }

  //загрузка целей используется в оверлей удаления
  Future<void> _loadWishes() async {
    final wishes = await widget.wishService.getWishes();

    if (!mounted) return;

    setState(() {
      _allWishes = wishes;
    });
  }

  //метод для редактирования
  Future<void> _openEditBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return EditWishBottomSheet(
          wish: widget.wish,
          wishService: widget.wishService,
        );
      },
    );

    _reloadWish();
  }

  //перезагрузка после обновления
  Future<void> _reloadWish() async {
    final wishes = await widget.wishService.getWishes();

    if (!mounted) return;

    final updatedWish = wishes.firstWhere(
      (w) => w.id == widget.wish.id,
      orElse: () => widget.wish,
    );

    setState(() {
      widget.wish
        ..title = updatedWish.title
        ..targetAmount = updatedWish.targetAmount
        ..currentAmount = updatedWish.currentAmount
        ..storeUrl = updatedWish.storeUrl;
    });
  }

  //метод выполнения цели
  Future<void> _completeWish() async {
    await widget.wishService.completeWish(widget.wish.id);

    if (!mounted) return;

    Navigator.pop(context);
  }

  //метод загрузки истории ЭТОЙ цели
  Future<void> _loadTransactionHistory() async {
    setState(() {
      _transactionHistory = [];
    });

    final history = await widget.wishService.getWishTransactionHistory(_wishId);

    if (!mounted) return;

    setState(() {
      _transactionHistory = history;
    });
  }

  //виджет истории
  String _formatDate(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    return '$day.$month.${value.year}';
  }

  Widget _transactionRow(WishTransaction tx) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(tx.date),
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
              Text(
                '+${tx.amount.toStringAsFixed(2)} zł',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //метод экрана истории
  void _openAllTransactionsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.33,
            child: Column(
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.transactionsHistory,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(sheetContext),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // LIST
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _transactionHistory.length,
                    separatorBuilder: (_, _) => const Divider(),
                    itemBuilder: (_, i) {
                      final tx = _transactionHistory[i];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${tx.date.day}.${tx.date.month}.${tx.date.year}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Text(
                            '+${tx.amount.toStringAsFixed(2)} zł',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ButtonStyle _organicButtonStyle(
    BuildContext context, {
    required bool emphasized,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilledButton.styleFrom(
      elevation: 0,
      backgroundColor: emphasized
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainerHighest,
      foregroundColor: emphasized
          ? colorScheme.onPrimaryContainer
          : colorScheme.onSurface,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      shape: const StadiumBorder(),
      textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
    );
  }

  //обновляет ID при переходе на другую цель
  @override
  void didUpdateWidget(covariant WishDetalsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.wish.id != widget.wish.id) {
      _wishId = widget.wish.id;
      // сменилась цель → перечитываем историю
      _loadTransactionHistory();
    }
  }

  //САМ ЭКРАН
  @override
  Widget build(BuildContext context) {
    final wish = widget.wish;

    final isCompleted = wish.currentAmount >= wish.targetAmount;

    final progress = wish.targetAmount == 0
        ? 0.0
        : (wish.currentAmount / wish.targetAmount).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(wish.title),

        //кнопка назад (потом можно снести)
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),

        //действия над целью
        actions: [
          if (!isCompleted)
            Builder(
              builder: (ctx) {
                final loc = AppLocalizations.of(ctx)!;

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: loc.edit,
                      onPressed: _openEditBottomSheet,
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      tooltip: loc.delete,
                      onPressed: _showDeleteOverlay,
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.progressText(
                          wish.currentAmount.toStringAsFixed(2),
                          wish.targetAmount.toStringAsFixed(2),
                        ),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      GradientProgressBar(progress: progress, height: 12),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              if (wish.storeUrl != null && wish.storeUrl!.isNotEmpty) ...[
                FilledButton.icon(
                  style: _organicButtonStyle(context, emphasized: false),
                  onPressed: _openUrl,
                  icon: const Icon(Icons.storefront_outlined, size: 18),
                  label: Text(AppLocalizations.of(context)!.openStore),
                ),
                const SizedBox(height: 16),
              ],

              if (!isCompleted) ...[
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        TextField(
                          controller: _addAmountCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.addAmount,
                            prefixIcon: const Icon(Icons.savings_outlined),
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            style: _organicButtonStyle(
                              context,
                              emphasized: true,
                            ),
                            onPressed: _onAddAmountPressed,
                            child: Text(AppLocalizations.of(context)!.add),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              if (_transactionHistory.isNotEmpty) ...[
                const SizedBox(height: 18),
                Text(
                  AppLocalizations.of(context)!.historyTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                ..._transactionHistory.take(5).map(_transactionRow),
                if (_transactionHistory.length > 5)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: _openAllTransactionsSheet,
                      child: Text(AppLocalizations.of(context)!.showAll),
                    ),
                  ),
              ],

              if (isCompleted) ...[
                const SizedBox(height: 16),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context)!.targetCompleted),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                CompleteActionButton(
                  label: AppLocalizations.of(context)!.saveToHistory,
                  onPressed: _completeWish,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
