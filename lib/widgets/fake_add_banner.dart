import 'package:flutter/material.dart';

class FakeAddBanner extends StatelessWidget {
  const FakeAddBanner({super.key});

  @override
  Widget build(BuildContext context) {
      return Container(
        width: double.infinity,
        height: 64,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 66, 62, 62),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: const Text(
          'Тут будет реклама',
          style: TextStyle(color: Color.fromARGB(216, 255, 255, 255), fontSize: 14),)
      );
    }
  }

