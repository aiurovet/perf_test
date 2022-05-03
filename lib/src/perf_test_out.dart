// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';

/// Display the result of testing a lot
///
class PerfTestOut {
  /// Look and feel of the output
  ///
  late final PerfTestFormat format;

  /// Convenience lot object
  ///
  final PerfTestLot lot;

  /// The constructor
  ///
  PerfTestOut(this.lot) {
    format = lot.format;
  }

  /// Actual output
  ///
  void exec() {
    _execName();

    final lineFormats = format.lineFormat.split('\n');

    for (var lineFormat in lineFormats) {
      final border = _getBorder(lineFormat);
      _execData(border, lineFormat);
    }

    if (!format.isRaw) {
      format.printer('');
    }
  }

  /// Ensure every string is embraced in quotes if needed, all internal quotes are escaped,
  /// and the field separator appended if the string does not represent the last field
  ///
  String _adjustQuotes(String fieldValue) {
    final isRaw = format.isRaw;
    final hasQuote = isRaw && fieldValue.contains(format.quote);
    final hasSep = isRaw && fieldValue.contains(format.fieldSeparator);

    if (hasQuote || hasSep) {
      return format.quote +
          fieldValue.replaceAll(format.quote, format.quoteEscaped) +
          format.quote;
    }

    return fieldValue;
  }

  /// Output single line of data
  ///
  void _execData(String? border, String lineFormat) {
    final count = lot.tests.length;

    if (count <= 0) {
      return;
    }

    final newLine = format.isRaw ? '' : '\n';

    if (border != null) {
      format.printer(newLine + border);
    }

    for (var i = 0; i < count; i++) {
      format.printer(_getData(lineFormat, i));
    }

    if (border != null) {
      format.printer(border);
    }
  }

  /// Output the lot name
  ///
  void _execName() {
    final name = _getName();

    if (name != null) {
      format.printer(name);
    }
  }

  /// Initialize line border
  ///
  String? _getBorder(String lineFormat) {
    if (format.horBarChar.isEmpty || format.isRaw) {
      return null;
    }

    final border = lineFormat.replaceAllMapped(PerfTestFormat.stubRE, (match) {
      var stub = lineFormat.substring(match.start, match.end);
      var size = 0;

      switch (stub) {
        case PerfTestFormat.stubFieldName:
          size = lot.maxNameWidth;
          break;
        case PerfTestFormat.stubFieldRatio:
          size = lot.maxRatioWidth;
          break;
        case PerfTestFormat.stubFieldValue:
          size = lot.maxValueWidth;
          break;
      }
      return format.horBarChar * size;
    });

    return border
        .replaceAll(format.fieldSeparator, format.cornerChar)
        .replaceAll(' ', format.horBarChar);
  }

  /// Initialize line data
  ///
  String _getData(String lineFormat, int index) {
    final test = lot.tests[index];

    var outName = test.name;
    var outValue = test.outValue;
    var outRatio = test.outRatio;

    if (format.isRaw) {
      outName = _adjustQuotes(outName);
      outRatio = _adjustQuotes(outRatio);
      outValue = _adjustQuotes(outValue);

      final sep = format.fieldSeparator;

      return outName + sep + outRatio + sep + outValue;
    }

    if ((index == 0) || (outRatio == lot.tests[0].outRatio)) {
      outRatio = '';
    }

    outName = format.string(outName, lot.maxNameWidth);
    outValue = format.string(outValue, lot.maxValueWidth, true);
    outRatio = format.string(outRatio, lot.maxRatioWidth, true);

    return lineFormat
        .replaceAll(PerfTestFormat.stubFieldName, outName)
        .replaceAll(PerfTestFormat.stubFieldRatio, outRatio)
        .replaceAll(PerfTestFormat.stubFieldValue, outValue);
  }

  /// Expand and return name
  ///
  String? _getName() {
    var name = lot.name;

    if (name.isEmpty) {
      return name;
    }

    final date = format.date(DateTime.now());
    var size = '';

    final maxLaps = lot.maxLaps;

    if (maxLaps != null) {
      size = format.number(maxLaps);
    } else if (lot.maxSpan != null) {
      size = format.duration(lot.maxSpan!);
    }

    return name
        .replaceAll(PerfTestFormat.stubDate, date)
        .replaceAll(PerfTestFormat.stubSize, size);
  }
}
