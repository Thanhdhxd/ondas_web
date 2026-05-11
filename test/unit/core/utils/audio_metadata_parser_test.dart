import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:ondas_web/core/utils/audio_metadata_parser.dart';

void main() {
  test('parses title and SYLT from ID3v2.3', () {
    const title = 'Test Title';
    const lineText = 'You were looking at me like you wanted to stay';

    final bytes = _buildId3v23Tag(
      title: title,
      syltEntries: const [
        _SyltEntry(startMs: 14000, text: lineText),
      ],
    );

    final metadata = parseAudioMetadata(bytes);

    expect(metadata.title, title);
    expect(metadata.syncedLyrics, hasLength(1));
    expect(metadata.syncedLyrics.first.startMs, 14000);
    expect(metadata.syncedLyrics.first.endMs, isNull);
    expect(metadata.syncedLyrics.first.lineText, lineText);
  });

  test('falls back to ID3v1 title when no ID3v2 tag', () {
    const title = 'Legacy Title';
    final bytes = Uint8List(128);
    bytes[0] = 0x54; // T
    bytes[1] = 0x41; // A
    bytes[2] = 0x47; // G
    final titleBytes = latin1.encode(title);
    bytes.setRange(3, 3 + titleBytes.length, titleBytes);

    final metadata = parseAudioMetadata(bytes);

    expect(metadata.title, title);
    expect(metadata.syncedLyrics, isEmpty);
  });

  test('uses bracketed timestamp from SYLT text', () {
    const textWithTime = '[00:14]You were looking at me like you wanted to stay';
    final bytes = _buildId3v23Tag(
      title: 'Bracketed',
      syltEntries: const [
        _SyltEntry(startMs: 0, text: textWithTime),
      ],
    );

    final metadata = parseAudioMetadata(bytes);

    expect(metadata.syncedLyrics, hasLength(1));
    expect(metadata.syncedLyrics.first.startMs, 14000);
    expect(
      metadata.syncedLyrics.first.lineText,
      'You were looking at me like you wanted to stay',
    );
  });

  test('parses bracketed SYLT when timestamp format is frames', () {
    const textWithTime = '[00:14]You were looking at me like you wanted to stay';
    final bytes = _buildId3v23Tag(
      title: 'Bracketed Frames',
      syltEntries: const [
        _SyltEntry(startMs: 0, text: textWithTime),
      ],
      syltTimestampFormat: 2,
    );

    final metadata = parseAudioMetadata(bytes);

    expect(metadata.syncedLyrics, hasLength(1));
    expect(metadata.syncedLyrics.first.startMs, 14000);
    expect(
      metadata.syncedLyrics.first.lineText,
      'You were looking at me like you wanted to stay',
    );
  });

  test('parses TXXX SYLT with bracketed lines', () {
    const textWithTime = '[00:14]You were looking at me like you wanted to stay';
    final txxx = _buildTxxxFrame(
      description: 'SYLT',
      value: textWithTime,
      encoding: 1,
    );
    final bytes = _buildId3v23Tag(
      title: 'TXXX',
      extraFrames: txxx,
    );

    final metadata = parseAudioMetadata(bytes);

    expect(metadata.syncedLyrics, hasLength(1));
    expect(metadata.syncedLyrics.first.startMs, 14000);
    expect(
      metadata.syncedLyrics.first.lineText,
      'You were looking at me like you wanted to stay',
    );
  });

  test('parses USLT when SYLT is absent', () {
    const lyrics = 'Line 1\nLine 2';
    final bytes = _buildId3v23Tag(
      title: 'Plain',
      usltText: lyrics,
    );

    final metadata = parseAudioMetadata(bytes);

    expect(metadata.syncedLyrics, isEmpty);
    expect(metadata.plainLyrics, lyrics);
  });

  test('ignores USLT when SYLT exists', () {
    final bytes = _buildId3v23Tag(
      title: 'Both',
      usltText: 'Plain lyrics',
      syltEntries: const [
        _SyltEntry(startMs: 5000, text: 'Synced line'),
      ],
    );

    final metadata = parseAudioMetadata(bytes);

    expect(metadata.syncedLyrics, isNotEmpty);
    expect(metadata.plainLyrics, isNull);
  });

  test('uses USLT when SYLT is unparseable', () {
    const lyrics = 'Fallback lyrics';
    final bytes = _buildId3v23Tag(
      title: 'Fallback',
      usltText: lyrics,
      syltEntries: const [
        _SyltEntry(startMs: 1200, text: 'No bracket timestamp'),
      ],
      syltTimestampFormat: 2,
    );

    final metadata = parseAudioMetadata(bytes);

    expect(metadata.syncedLyrics, isEmpty);
    expect(metadata.plainLyrics, lyrics);
  });
}

Uint8List _buildId3v23Tag({
  required String title,
  List<_SyltEntry> syltEntries = const [],
  String? usltText,
  int syltTimestampFormat = 1,
  List<int> extraFrames = const [],
}) {
  final frames = <int>[];
  frames.addAll(_buildTextFrame('TIT2', title));
  if (usltText != null) {
    frames.addAll(_buildUsltFrame(usltText));
  }
  if (syltEntries.isNotEmpty) {
    frames.addAll(_buildSyltFrame(
      syltEntries,
      timestampFormat: syltTimestampFormat,
    ));
  }
  if (extraFrames.isNotEmpty) {
    frames.addAll(extraFrames);
  }

  final header = <int>[
    0x49, 0x44, 0x33, // ID3
    0x03, 0x00, // v2.3.0
    0x00, // flags
    ..._encodeSynchsafe(frames.length),
  ];

  return Uint8List.fromList([...header, ...frames]);
}

List<int> _buildTextFrame(String id, String text) {
  final payload = <int>[0x03, ...utf8.encode(text)];
  return [
    ...ascii.encode(id),
    ..._encodeInt32(payload.length),
    0x00,
    0x00,
    ...payload,
  ];
}

List<int> _buildSyltFrame(
  List<_SyltEntry> entries, {
  int timestampFormat = 1,
}) {
  final payload = <int>[
    0x03, // UTF-8
    ...ascii.encode('eng'),
    timestampFormat, // timestamp format
    0x00, // content type
    0x00, // descriptor terminator
  ];

  for (final entry in entries) {
    payload.addAll(utf8.encode(entry.text));
    payload.add(0x00);
    payload.addAll(_encodeInt32(entry.startMs));
  }

  return [
    ...ascii.encode('SYLT'),
    ..._encodeInt32(payload.length),
    0x00,
    0x00,
    ...payload,
  ];
}

List<int> _buildUsltFrame(String lyrics) {
  final payload = <int>[
    0x03, // UTF-8
    ...ascii.encode('eng'),
    0x00, // descriptor terminator
    ...utf8.encode(lyrics),
  ];

  return [
    ...ascii.encode('USLT'),
    ..._encodeInt32(payload.length),
    0x00,
    0x00,
    ...payload,
  ];
}

List<int> _buildTxxxFrame({
  required String description,
  required String value,
  int encoding = 3,
}) {
  final payload = <int>[encoding];
  payload.addAll(_encodeText(encoding, description));
  payload.addAll(_encodeTextTerminator(encoding));
  payload.addAll(_encodeText(encoding, value));

  return [
    ...ascii.encode('TXXX'),
    ..._encodeInt32(payload.length),
    0x00,
    0x00,
    ...payload,
  ];
}

List<int> _encodeText(int encoding, String text) {
  switch (encoding) {
    case 0:
      return latin1.encode(text);
    case 1:
      return _encodeUtf16(text);
    case 2:
      return _encodeUtf16(text, bigEndian: true);
    case 3:
    default:
      return utf8.encode(text);
  }
}

List<int> _encodeTextTerminator(int encoding) {
  if (encoding == 0 || encoding == 3) {
    return const [0x00];
  }
  return const [0x00, 0x00];
}

List<int> _encodeUtf16(String text, {bool bigEndian = false}) {
  final output = <int>[];
  output.addAll(bigEndian ? const [0xFE, 0xFF] : const [0xFF, 0xFE]);
  for (final unit in text.codeUnits) {
    if (bigEndian) {
      output.add((unit >> 8) & 0xFF);
      output.add(unit & 0xFF);
    } else {
      output.add(unit & 0xFF);
      output.add((unit >> 8) & 0xFF);
    }
  }
  return output;
}

List<int> _encodeSynchsafe(int value) {
  return [
    (value >> 21) & 0x7F,
    (value >> 14) & 0x7F,
    (value >> 7) & 0x7F,
    value & 0x7F,
  ];
}

List<int> _encodeInt32(int value) {
  return [
    (value >> 24) & 0xFF,
    (value >> 16) & 0xFF,
    (value >> 8) & 0xFF,
    value & 0xFF,
  ];
}

class _SyltEntry {
  final int startMs;
  final String text;

  const _SyltEntry({required this.startMs, required this.text});
}
