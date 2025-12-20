// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class GradientProgressBar extends StatelessWidget {
  final double progress;
  final double height;

  const GradientProgressBar({
    super.key,
    required this.progress,
    this.height = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: progress),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            builder: (context, animatedValue, child) {
              return Stack(
                children: [
                  // Фон
                  Container(
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(height / 2),
                    ),
                  ),

                  // Заполненная часть (гладкая анимация)
                  Container(
                    width: constraints.maxWidth * animatedValue,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height / 2),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromARGB(216, 221, 3, 3),
                          Color.fromARGB(255, 5, 196, 21),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
