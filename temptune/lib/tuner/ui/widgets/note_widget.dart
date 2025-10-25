import "package:flutter/material.dart";
import "package:temptune/tuner/domain/entities/note.dart";

final _subscriptConversionMap = Map.fromIterables(
  "-1234567890".runes,
  "₋₁₂₃₄₅₆₇₈₉₀".runes,
);

class NoteWidget extends StatelessWidget {
  const NoteWidget(this.note, {this.style, super.key});

  final Note note;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final octaveStr = String.fromCharCodes(
      note.octave
          .toString()
          .codeUnits
          .map((rune) => _subscriptConversionMap[rune] ?? -1)
          .where((el) => el != -1),
    );
    final noteStr = note.name;
    return Text("$noteStr$octaveStr", style: style);
  }
}
