import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/wish_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/wish.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(WishAdapter());
  await Hive.openBox<Wish>('wishes');

  runApp(MyApp());
}

//kornevoi vidget prilozhenia
class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Один общий сервис для всего приложения.
  // Пока без Hive, просто в памяти.
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