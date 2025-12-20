import 'package:flutter/material.dart';
import '../services/wish_service.dart';
import '../widgets/wish_card.dart';
import 'add_wish_screen.dart';
import 'wish_details_screen.dart';
import '../widgets/fake_add_banner.dart';
import '../models/wish.dart';


class HomeScreen extends StatefulWidget {
  final WishService wishService;

  const HomeScreen({
    super.key,
    required this.wishService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: const Text('Мои цели'),
      ),

      body: Stack(
  children: [
    Column(
      children: [
       Expanded(
  child: FutureBuilder<List<Wish>>(
    future: widget.wishService.getWishes(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        return Center(child: Text('Ошибка: ${snapshot.error}'));
      }

      final wishes = snapshot.data ?? [];

      if (wishes.isEmpty) {
        return const Center(child: Text('Пока нет целей'));
      }

      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 140),
        itemCount: wishes.length,
        itemBuilder: (context, index) {
          final wish = wishes[index];

          return WishCard(
            wish: wish,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WishDetalsScreen(
                    wish: wish,
                    wishService: widget.wishService,
                  ),
                ),
              );
              _refresh();
            },
            onAddPressed: (amount) async {
              await widget.wishService.addMoneyToWish(wish.id, amount);
              _refresh();
            },
            onDeletePressed: () async {
              await widget.wishService.removeWish(wish.id);
              _refresh();
            },
          );
        },
      );
    },
  ),
),

      ],
    ),

    // 🔥 КНОПКА — ВНЕ Column
    Positioned(
      right: 16,
      bottom: 96,
      child: _AddWishButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
            builder: (_) => AddWishScreen(
              wishService: widget.wishService,
            ),
      ) ,
      );
        _refresh();
              }
      ),
    ),

    // 🔥 БАННЕР — ТОЖЕ ВНЕ Column
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

class _AddWishButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddWishButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(16),
      color: Theme.of(context).colorScheme.primary,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical:12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.add, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Добавить цель',
                style: TextStyle(
                  color: Colors.white,
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