class IdEntry {
  IdEntry({
    required this.word,
    required this.textOffset,
    required this.textLength,
    required this.audioOffset,
    required this.audioLength,
  });

  final String word;
  final int textOffset;
  final int textLength;
  final int audioOffset;
  final int audioLength;
}
