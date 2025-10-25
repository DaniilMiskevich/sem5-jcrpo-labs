import "dart:math";
import "dart:math" as math show max, min;

import "package:circular_slider/circular_slider.dart";
import "package:flutter/material.dart";

class MyCircularSlider extends StatelessWidget {
  const MyCircularSlider({
    required this.value,
    required this.min,
    required this.max,
    this.onChanged,
    this.divisions,
    this.sizeFactor = 0.55,
    super.key,
  });

  final double value, min, max;
  final int? divisions;
  final ValueChanged<double>? onChanged;

  final double sizeFactor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    const trackHeight = 28.0, thumbSize = 22.0, inactiveTrackHeight = 22.0;

    final trackColor = colorScheme.primary;
    final inactiveTrackColor = Color.alphaBlend(
      colorScheme.onSurface.withAlpha(0x20),
      colorScheme.surface,
    );

    final mediaQuerySize = MediaQuery.of(context).size;
    final size =
        math
            .max(math.min(mediaQuerySize.width, mediaQuerySize.height), 100)
            .toDouble() *
        sizeFactor;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical:
            math.max(math.max(trackHeight, inactiveTrackHeight), thumbSize) / 2,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: size, maxWidth: size),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: CircularSlider(
              value: value,
              min: min,
              max: max,
              steps: divisions ?? 0,
              onChanged: (val) => onChanged?.call(val),

              radius: size / 2,
              startAngle: 0,
              endAngle: pi + pi * 5 / 6,
              offsetRadian: -pi,
              track: CircularSliderTrack(
                width: inactiveTrackHeight,
                color: inactiveTrackColor,
              ),
              knobSize: const Size.square(thumbSize),
              knobBuilder: (_, v) => Card(
                elevation: 0,
                shape: const CircleBorder(),
                margin: EdgeInsets.zero,
                color: inactiveTrackColor,
              ),
              segments: [
                CircularSliderSegment(
                  start: 0,
                  length: (value - min) / (max - min) + 0.00001,
                  width: trackHeight,
                  color: trackColor,
                ),
              ],
              showArrow: false,
            ),
          ),
        ),
      ),
    );
  }
}
