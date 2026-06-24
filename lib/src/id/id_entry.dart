/// A `dict.id` entry.
class IdEntry {
  /// Creates a new [IdEntry].
  IdEntry({
    required this.word,
    required this.textOffset,
    required this.textLength,
    required this.audioOffset,
    required this.audioLength,
  });

  /// The word key.
  final String word;

  /// The text offset in `dict.txt`.
  final int textOffset;

  /// The word + text length.
  final int textLength;

  /// The audio offset in `dict.pcm`.
  final int audioOffset;

  /// The audio length.
  final int audioLength;
}
