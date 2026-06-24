import 'dart:convert';
import 'dart:io';

import 'package:mp3dict/src/id/id_entry.dart';
import 'package:mp3dict/src/id/id_parse.dart';
import 'package:mp3dict/src/writer/dict_writer.dart';

void _dbg(IdEntry entry) => stdout.writeln(
  '${entry.word} => '
  'off=${entry.textOffset}, '
  'len=${entry.textLength}, '
  'aoff=${entry.audioOffset}, '
  'alen=${entry.audioLength}',
);

Future<void> main(List<String> arguments) async {
  testWrite();
}

Future<void> testWrite() async {
  await dictWriter({
    'abc': 'Here is my ABC definition!',
    'test': 'Here is my TEST definition!',
  });

  final idEntries = await idParse(File('dict.id'));

  final txtFile = await File('dict.txt').open();
  for (final idEntry in idEntries.take(5)) {
    _dbg(idEntry);

    await txtFile.setPosition(idEntry.textOffset);
    final bytes = await txtFile.read(idEntry.textLength);

    stdout
      ..writeln(utf8.decode(bytes))
      ..writeln('----------------------------');
  }
}
