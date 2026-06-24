import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mp3dict/src/id/id_entry.dart';

/// Parse `dict.id`.
Future<List<IdEntry>> idParse(File dictIdFile) async {
  final f = await dictIdFile.open();

  final entries = <IdEntry>[];

  while (true) {
    final entry = await f.read(48);
    if (entry.length != 48) break;

    final end = entry.indexOf(0);
    final word = utf8.decode(
      entry.sublist(0, end == -1 ? 32 : end),
    );

    final bd = ByteData.sublistView(entry);

    final idEntry = IdEntry(
      word: word,
      textOffset: bd.getUint32(32, Endian.little),
      textLength: bd.getUint32(36, Endian.little),
      audioOffset: bd.getUint32(40, Endian.little),
      audioLength: bd.getUint32(44, Endian.little),
    );

    entries.add(idEntry);
  }

  return entries;
}
