// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';

class PerfTestOutOne {
  /// Full width of the data table
  ///
  static int get fullWidth => _fullWidth;
  static int _fullWidth = 0;

  /// A flag indicating the border should be shown rather than data record
  ///
  bool isBorder = false;

  /// Formatted string for the laps
  ///
  String outLaps = '';

  /// The any line of the output (border or data)
  ///
  String get outLine => _outLine;
  String _outLine = '';

  /// Formatted string for the name
  ///
  String outName = '';

  /// Formatted string for the span
  ///
  String outSpan = '';

  /// The convenience field formatter (derived from the lot)
  ///
  late final PerfTestFmt format;

  /// The parent
  ///
  final PerfTestOutLot outLot;

  /// The constructor
  ///
  PerfTestOutOne(this.outLot) {
    format = outLot.format;
  }

  /// Ensure every string is embraced in quotes if needed, all internal quotes are escaped,
  /// and the field separator appended if the string does not represent the last field
  ///
  String adjustQuotes(String fieldValue) {
    var fieldValueEx = fieldValue;
    var requiresQuotes = fieldValueEx.contains(format.quote);

    if (!requiresQuotes && format.fieldSeparator.isNotEmpty) {
      requiresQuotes = fieldValueEx.contains(format.fieldSeparator);
    }

    if (requiresQuotes) {
      fieldValueEx = format.quote +
          fieldValueEx.replaceAll(format.quote, format.quoteEscaped) +
          format.quote;
    }

    return fieldValueEx;
  }

  /// The actual printing
  ///
  void exec({int index = -1, bool isTest = false}) {
    final r = outLot.result;

    isBorder = (index < 0);

    _fullWidth =
        (2 + r.maxNameWidth + 3 + r.maxLapsWidth + 3 + r.maxSpanWidth + 2);

    if (isBorder) {
      _initLineBorder(r, format);
    } else {
      _initLineData(r, format, index, isTest);
    }

    outLot.printer(_outLine);
  }

  /// The serializer
  ///
  @override
  String toString() => _outLine;

  /// Initialize line border
  ///
  void _initLineBorder(PerfTestLotResult r, PerfTestFmt f) {
    _outLine = f.cornerChar +
        f.borderChar * (1 + r.maxNameWidth + 1) +
        f.cornerChar +
        f.borderChar * (1 + r.maxLapsWidth + 1) +
        f.cornerChar +
        f.borderChar * (1 + r.maxSpanWidth + 1) +
        f.cornerChar;
  }

  /// Initialize line data
  ///
  void _initLineData(
      PerfTestLotResult r, PerfTestFmt f, int index, bool isTest) {
    _initLineDataParts(r, f, index, isTest);

    var sep = f.fieldSeparator;
    var hasSep = sep.isNotEmpty;

    var maxWidth = (hasSep ? 0 : r.maxNameWidth);
    outName = adjustQuotes(f.string(outName, maxWidth));

    maxWidth = (hasSep ? 0 : r.maxLapsWidth);
    outLaps = adjustQuotes(f.string(outLaps, maxWidth, true));

    maxWidth = (hasSep ? 0 : r.maxSpanWidth);
    outSpan = adjustQuotes(f.string(outSpan, maxWidth, true));

    if (hasSep) {
      _outLine = outName + sep + outLaps + sep + outSpan;
    } else {
      final b = f.barChar;
      _outLine = '$b $outName $b $outLaps $b $outSpan $b';
    }
  }

  /// Initialize line data parts
  ///
  void _initLineDataParts(
      PerfTestLotResult r, PerfTestFmt f, int index, bool isTest) {
    if (index >= 0) {
      if (isTest) {
        final t = r.lot.tests[index];
        outName = t.name;
        outLaps = f.number(t.laps);
        outSpan = t.span.toString();
      } else {
        outName = r.lapsRatios[index].name;
        outLaps = r.lapsRatios[index].outRatio;
        outSpan = r.spanRatios[index].outRatio;
      }
    } else {
      outName = '';
      outLaps = '';
      outSpan = '';
    }
  }
}
