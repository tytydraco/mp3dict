import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// Encode a key-pair of [definitions] to dictionary files.
Future<void> dictWriter(Map<String, String> definitions) async {
  // dict.txt
  final dictTxtBytesBuilder = BytesBuilder();
  final dictTxtOffsets = <int>[];

  for (final entry in definitions.entries) {
    dictTxtOffsets.add(dictTxtBytesBuilder.length);

    final word = entry.key;
    final definition = entry.value;

    final encodedBytes = utf8.encode('$word\r\n$definition\r\n\x00');
    dictTxtBytesBuilder.add(encodedBytes);
  }

  final dictTxtFile = File('dict.txt');
  await dictTxtFile.writeAsBytes(dictTxtBytesBuilder.takeBytes());

  // dict.id
  final dictIdBytesBuilder = BytesBuilder();

  for (var i = 0; i < definitions.entries.length; i++) {
    final entry = definitions.entries.elementAt(i);
    final word = Uint8List(32);
    final encodedWord = utf8.encode(entry.key);
    final length = encodedWord.length.clamp(0, 31);
    word.setRange(0, length, encodedWord);
    dictIdBytesBuilder.add(word);

    final fullEntryBytes = utf8.encode('${entry.key}\r\n${entry.value}\r\n');

    final bd = ByteData(16)
      ..setUint32(0, dictTxtOffsets[i], Endian.little)
      ..setUint32(
        4,
        fullEntryBytes.length,
        Endian.little,
      )
      ..setUint32(8, 0, Endian.little)
      ..setUint32(12, 0, Endian.little);

    dictIdBytesBuilder.add(bd.buffer.asUint8List());
  }

  final dictIdFile = File('dict.id');
  await dictIdFile.writeAsBytes(dictIdBytesBuilder.takeBytes());

  // dict.pcm
  final dictPcmFile = File('dict.pcm');
  await dictPcmFile.writeAsBytes([]);
}
