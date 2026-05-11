import 'dart:convert';
import 'dart:typed_data';

class AudioMetadata {
  final String? title;
  final List<SyncedLyricsLineDraft> syncedLyrics;
  final String? plainLyrics;

  const AudioMetadata({
    this.title,
    this.syncedLyrics = const [],
    this.plainLyrics,
  });

  bool get hasSyncedLyrics => syncedLyrics.isNotEmpty;
  bool get hasPlainLyrics => plainLyrics != null && plainLyrics!.isNotEmpty;
}

class SyncedLyricsLineDraft {
  final int startMs;
  final int? endMs;
  final String lineText;

  const SyncedLyricsLineDraft({
    required this.startMs,
    this.endMs,
    required this.lineText,
  });
}

AudioMetadata parseAudioMetadata(Uint8List bytes) {
  final id3v2 = _parseId3v2(bytes);
  final title = _normalizeText(id3v2.title) ?? _parseId3v1Title(bytes);

  return AudioMetadata(
    title: title,
    syncedLyrics: id3v2.syncedLyrics,
    plainLyrics: id3v2.plainLyrics,
  );
}

class _Id3V2Result {
  final String? title;
  final List<SyncedLyricsLineDraft> syncedLyrics;
  final String? plainLyrics;

  const _Id3V2Result({
    this.title,
    this.syncedLyrics = const [],
    this.plainLyrics,
  });
}

_Id3V2Result _parseId3v2(Uint8List bytes) {
  if (bytes.length < 10) return const _Id3V2Result();
  if (bytes[0] != 0x49 || bytes[1] != 0x44 || bytes[2] != 0x33) {
    return const _Id3V2Result();
  }

  final version = bytes[3];
  if (version != 2 && version != 3 && version != 4) {
    return const _Id3V2Result();
  }

  final flags = bytes[5];
  final tagSize = _readSynchsafeInt(bytes, 6);
  if (tagSize <= 0) return const _Id3V2Result();

  final tagStart = 10;
  final tagEnd = tagStart + tagSize;
  if (tagStart >= bytes.length) return const _Id3V2Result();

  Uint8List tagData = bytes.sublist(
    tagStart,
    tagEnd > bytes.length ? bytes.length : tagEnd,
  );

  if ((flags & 0x80) != 0) {
    tagData = _removeUnsync(tagData);
  }

  var offset = 0;
  if ((flags & 0x40) != 0) {
    if (version == 3) {
      if (tagData.length >= 4) {
        final extSize = _readBigEndianInt(tagData, 0, 4);
        offset = extSize + 4;
      }
    } else if (version == 4) {
      if (tagData.length >= 4) {
        final extSize = _readSynchsafeInt(tagData, 0);
        offset = extSize;
      }
    }
  }

  String? title;
  List<SyncedLyricsLineDraft> syncedLyrics = const [];
  String? plainLyrics;
  var hasSyncedFrame = false;

  while (offset < tagData.length) {
    if (version == 2) {
      if (offset + 6 > tagData.length) break;
      final frameId = ascii.decode(tagData.sublist(offset, offset + 3));
      if (_isPaddingFrame(frameId)) break;
      final frameSize =
          _readBigEndianInt(tagData, offset + 3, 3);
      offset += 6;
      if (frameSize <= 0 || offset + frameSize > tagData.length) break;
      final frameData = tagData.sublist(offset, offset + frameSize);
      offset += frameSize;

      if (frameId == 'TT2') {
        title ??= _parseTextFrame(frameData);
      } else if (frameId == 'SLT') {
        final parsed = _parseSyltFrame(frameData);
        if (parsed.isNotEmpty) {
          syncedLyrics = [...syncedLyrics, ...parsed];
          hasSyncedFrame = true;
          plainLyrics = null;
        }
      } else if (frameId == 'TXX') {
        final parsed = _parseTxxxSyltFrame(frameData);
        if (parsed.isNotEmpty) {
          syncedLyrics = [...syncedLyrics, ...parsed];
          hasSyncedFrame = true;
          plainLyrics = null;
        }
      } else if (frameId == 'ULT') {
        if (!hasSyncedFrame && plainLyrics == null) {
          plainLyrics = _parseUsltFrame(frameData);
        }
      }
      continue;
    }

    if (offset + 10 > tagData.length) break;
    final frameId = ascii.decode(tagData.sublist(offset, offset + 4));
    if (_isPaddingFrame(frameId)) break;

    final frameSize = version == 4
        ? _readSynchsafeInt(tagData, offset + 4)
        : _readBigEndianInt(tagData, offset + 4, 4);
    offset += 10;
    if (frameSize <= 0 || offset + frameSize > tagData.length) break;

    final frameData = tagData.sublist(offset, offset + frameSize);
    offset += frameSize;

    if (frameId == 'TIT2') {
      title ??= _parseTextFrame(frameData);
    } else if (frameId == 'SYLT') {
      final parsed = _parseSyltFrame(frameData);
      if (parsed.isNotEmpty) {
        syncedLyrics = [...syncedLyrics, ...parsed];
        hasSyncedFrame = true;
        plainLyrics = null;
      }
    } else if (frameId == 'TXXX') {
      final parsed = _parseTxxxSyltFrame(frameData);
      if (parsed.isNotEmpty) {
        syncedLyrics = [...syncedLyrics, ...parsed];
        hasSyncedFrame = true;
        plainLyrics = null;
      }
    } else if (frameId == 'USLT') {
      if (!hasSyncedFrame && plainLyrics == null) {
        plainLyrics = _parseUsltFrame(frameData);
      }
    }
  }

  return _Id3V2Result(
    title: title,
    syncedLyrics: syncedLyrics,
    plainLyrics: plainLyrics,
  );
}

String? _parseId3v1Title(Uint8List bytes) {
  if (bytes.length < 128) return null;
  final start = bytes.length - 128;
  if (bytes[start] != 0x54 || bytes[start + 1] != 0x41 || bytes[start + 2] != 0x47) {
    return null;
  }

  final titleBytes = bytes.sublist(start + 3, start + 33);
  final title = latin1.decode(titleBytes).replaceAll('\u0000', '').trim();
  return title.isEmpty ? null : title;
}

String? _parseTextFrame(List<int> frameData) {
  if (frameData.isEmpty) return null;
  final encoding = frameData[0];
  final text = _decodeText(frameData.sublist(1), encoding);
  return _normalizeText(text);
}

List<SyncedLyricsLineDraft> _parseSyltFrame(List<int> frameData) {
  if (frameData.length < 6) return const [];
  final encoding = frameData[0];
  final timestampFormat = frameData[4];
  final isMsFormat = timestampFormat == 1;
  final isFrameFormat = timestampFormat == 2;
  if (!isMsFormat && !isFrameFormat) {
    // Still try to parse bracketed timestamps from text.
  }

  var offset = 6;
  final descriptor = _readEncodedString(frameData, offset, encoding);
  if (descriptor == null) return const [];
  offset = descriptor.nextIndex;

  final lines = <SyncedLyricsLineDraft>[];
  while (offset < frameData.length) {
    final textResult = _readEncodedString(frameData, offset, encoding);
    if (textResult == null) break;
    offset = textResult.nextIndex;
    int? timestamp;
    if (offset + 4 <= frameData.length) {
      timestamp = _readBigEndianInt(frameData, offset, 4);
      offset += 4;
    }

    var lineText = _normalizeText(textResult.text);
    if (lineText == null) continue;

    int? startMs;
    final bracket = _parseBracketTimestamp(lineText);
    if (bracket != null) {
      startMs = bracket.startMs;
      lineText = bracket.text;
    } else if (isMsFormat) {
      startMs = timestamp;
    }

    if (lineText.isEmpty) continue;
    if (startMs == null || startMs < 0) continue;

    if (lineText.isNotEmpty) {
      lines.add(
        SyncedLyricsLineDraft(
          startMs: startMs,
          endMs: null,
          lineText: lineText,
        ),
      );
    }

    if (timestamp == null) break;
  }

  return lines;
}

List<SyncedLyricsLineDraft> _parseTxxxSyltFrame(List<int> frameData) {
  if (frameData.isEmpty) return const [];
  final encoding = frameData[0];
  var offset = 1;
  final descriptor = _readEncodedString(frameData, offset, encoding);
  if (descriptor == null) return const [];
  offset = descriptor.nextIndex;
  final description = _normalizeText(descriptor.text);
  if (description == null || description.toUpperCase() != 'SYLT') {
    return const [];
  }
  if (offset >= frameData.length) return const [];

  final rawText = _decodeTextAllowNulls(frameData.sublist(offset), encoding);
  final normalized = rawText.replaceAll('\u0000', '\n').trim();
  if (normalized.isEmpty) return const [];

  final lines = <SyncedLyricsLineDraft>[];
  for (final line in normalized.split(RegExp(r'[\r\n]+'))) {
    final bracket = _parseBracketTimestamp(line.trim());
    if (bracket == null) continue;
    if (bracket.text.isEmpty) continue;
    lines.add(
      SyncedLyricsLineDraft(
        startMs: bracket.startMs,
        endMs: null,
        lineText: bracket.text,
      ),
    );
  }
  return lines;
}

String? _parseUsltFrame(List<int> frameData) {
  if (frameData.length < 5) return null;
  final encoding = frameData[0];
  var offset = 1;
  if (offset + 3 > frameData.length) return null;
  offset += 3; // Language code
  final descriptor = _readEncodedString(frameData, offset, encoding);
  if (descriptor == null) return null;
  offset = descriptor.nextIndex;
  if (offset >= frameData.length) return null;
  final text = _decodeText(frameData.sublist(offset), encoding);
  return _normalizeText(text);
}

class _TextParseResult {
  final String text;
  final int nextIndex;

  const _TextParseResult({required this.text, required this.nextIndex});
}

_TextParseResult? _readEncodedString(
  List<int> data,
  int start,
  int encoding,
) {
  if (start >= data.length) return null;

  if (encoding == 0 || encoding == 3) {
    final end = data.indexOf(0x00, start);
    final actualEnd = end == -1 ? data.length : end;
    final text = _decodeText(data.sublist(start, actualEnd), encoding);
    return _TextParseResult(
      text: text,
      nextIndex: end == -1 ? data.length : actualEnd + 1,
    );
  }

  var i = start;
  for (; i + 1 < data.length; i += 2) {
    if (data[i] == 0x00 && data[i + 1] == 0x00) break;
  }
  final actualEnd = i >= data.length ? data.length : i;
  final text = _decodeText(data.sublist(start, actualEnd), encoding);
  return _TextParseResult(
    text: text,
    nextIndex: i + 1 < data.length ? i + 2 : data.length,
  );
}

String _decodeText(List<int> bytes, int encoding) {
  if (bytes.isEmpty) return '';
  switch (encoding) {
    case 0:
      return latin1.decode(bytes);
    case 1:
      return _decodeUtf16(bytes);
    case 2:
      return _decodeUtf16(bytes, bigEndian: true);
    case 3:
      return utf8.decode(bytes, allowMalformed: true);
    default:
      return latin1.decode(bytes);
  }
}

String _decodeTextAllowNulls(List<int> bytes, int encoding) {
  if (bytes.isEmpty) return '';
  switch (encoding) {
    case 0:
      return latin1.decode(bytes);
    case 1:
      return _decodeUtf16(bytes, stopOnNull: false);
    case 2:
      return _decodeUtf16(bytes, bigEndian: true, stopOnNull: false);
    case 3:
      return utf8.decode(bytes, allowMalformed: true);
    default:
      return latin1.decode(bytes);
  }
}

String _decodeUtf16(
  List<int> bytes, {
  bool? bigEndian,
  bool stopOnNull = true,
}) {
  if (bytes.isEmpty) return '';

  var offset = 0;
  var resolvedBigEndian = bigEndian ?? false;

  if (bigEndian == null && bytes.length >= 2) {
    if (bytes[0] == 0xFE && bytes[1] == 0xFF) {
      resolvedBigEndian = true;
      offset = 2;
    } else if (bytes[0] == 0xFF && bytes[1] == 0xFE) {
      resolvedBigEndian = false;
      offset = 2;
    }
  }

  final length = (bytes.length - offset) ~/ 2 * 2;
  final codeUnits = <int>[];
  for (var i = offset; i < offset + length; i += 2) {
    final unit = resolvedBigEndian
        ? (bytes[i] << 8) | bytes[i + 1]
        : (bytes[i + 1] << 8) | bytes[i];
    if (unit == 0x0000 && stopOnNull) break;
    codeUnits.add(unit);
  }

  return String.fromCharCodes(codeUnits);
}

int _readSynchsafeInt(List<int> data, int start) {
  if (start + 4 > data.length) return 0;
  return (data[start] << 21) |
      (data[start + 1] << 14) |
      (data[start + 2] << 7) |
      data[start + 3];
}

int _readBigEndianInt(List<int> data, int start, int length) {
  var value = 0;
  for (var i = 0; i < length; i++) {
    value = (value << 8) | data[start + i];
  }
  return value;
}

Uint8List _removeUnsync(Uint8List data) {
  final output = <int>[];
  for (var i = 0; i < data.length; i++) {
    final byte = data[i];
    output.add(byte);
    if (byte == 0xFF && i + 1 < data.length && data[i + 1] == 0x00) {
      i++;
    }
  }
  return Uint8List.fromList(output);
}

bool _isPaddingFrame(String frameId) {
  return frameId.trim().isEmpty || frameId == '\u0000\u0000\u0000\u0000';
}

String? _normalizeText(String? text) {
  if (text == null) return null;
  final cleaned = text.replaceAll('\u0000', '').trim();
  return cleaned.isEmpty ? null : cleaned;
}

class _BracketTimestampResult {
  final int startMs;
  final String text;

  const _BracketTimestampResult({required this.startMs, required this.text});
}

_BracketTimestampResult? _parseBracketTimestamp(String text) {
  final match = RegExp(
    r'^\[(\d{1,2}):(\d{2})(?:[\.,](\d{1,3}))?\](.*)$',
  ).firstMatch(text);
  if (match == null) return null;

  final minutes = int.tryParse(match.group(1) ?? '');
  final seconds = int.tryParse(match.group(2) ?? '');
  if (minutes == null || seconds == null || seconds >= 60) return null;

  final msPart = match.group(3);
  final millis = msPart == null
      ? 0
      : int.tryParse(msPart.padRight(3, '0')) ?? 0;

  final lineText = (match.group(4) ?? '').trim();
  return _BracketTimestampResult(
    startMs: (minutes * 60 + seconds) * 1000 + millis,
    text: lineText,
  );
}
