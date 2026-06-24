import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:mp3dict/src/id/id_entry.dart';
import 'package:mp3dict/src/id/id_parse.dart';
import 'package:mp3dict/src/writer/dict_writer.dart';

void dbg(IdEntry entry) => print(
  '${entry.word} => '
  'off=${entry.textOffset}, '
  'len=${entry.textLength}, '
  'aoff=${entry.audioOffset}, '
  'alen=${entry.audioLength}',
);

Future<void> main(List<String> arguments) async {
  // final entries = await idParse(File('dict/dict.id'));
  // // entries.sort((a, b) => b.word.compareTo(a.word));

  // dbg(entries.elementAt(1000));
  // dbg(entries.elementAt(1001));
  // dbg(entries.elementAt(1002));

  testWrite();
}

Future<void> testWrite() async {
  await dictWriter({
    'fest': 'Here is my FEST definition!',
    'test': 'Here is my definition!',
  });

  final idEntries = await idParse(File('dict.id'));

  final txtFile = await File('dict.txt').open();
  for (final idEntry in idEntries.take(5)) {
    dbg(idEntry);

    await txtFile.setPosition(idEntry.textOffset);
    final bytes = await txtFile.read(idEntry.textLength);

    print(utf8.decode(bytes));
    print('----------------------------');
  }
}
