import 'package:flutter/material.dart';
import 'package:wish_saver/models/free_money.dart';
import 'screens/home_screen.dart';
import 'services/wish_service.dart';
import 'models/wish.dart';
import 'package:wish_saver/models/wish_transaction.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
//kornevoi vidget prilozhenia
class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Один общий сервис для всего приложения.
  final WishService _wishService = WishService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Копилка хотелок',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 0, 255)),
        useMaterial3: true,
      ),
      home: HomeScreen(
        wishService: _wishService,
      ),
    );
  }
}


