import "package:flutter/material.dart";

class Space extends StatelessWidget {
  const Space(this.size, {super.key});
  const Space.sm({super.key}) : size = 8.0;
  const Space.md({super.key}) : size = 16.0;
  const Space.lg({super.key}) : size = 32.0;

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox.square(dimension: size);
}
