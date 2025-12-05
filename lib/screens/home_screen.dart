import 'package:flutter/material.dart';
import '../services/wish_service.dart';
import '../widgets/wish_card.dart';
import 'add_wish_screen.dart';

class HomeScreen extends StatefulWidget {
  final WishService wishService;

  const HomeScreen({
    super.key,
    required this.wishService,
  });

  @override
  State<HomeScreen> createState() => _HomeScrenState();
}

class _HomeScrenState extends State<HomeScreen> {
  void _refresh() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final wishes = widget.wishService.wishes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои цели'),
      ),
      body: ListView.builder(
        itemCount: wishes.length,
        itemBuilder: (context, index) {
          final wish = wishes[index];
          return WishCard(
            wish: wish,
            onAddPressed: () {
              setState(() {
                // В будущем тут будет логика +10 zł к цели
                widget.wishService.addMoneyToWish(wish.id, 10);
              });
            },
            onDeletePressed: () {
              setState(() {
                widget.wishService.removeWish(wish.id);
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() async {
          // Переходим на экран добавления цели.
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddWishScreen(
                wishService: widget.wishService,
              ),
            ),
          );

           _refresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}