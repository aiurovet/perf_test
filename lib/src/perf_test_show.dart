// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';

class PerfTestShow {
  /// The border line
  ///
  String get line => _line;
  String _line = '';

  /// Formatted string for the laps
  ///
  String displayLaps = '';

  /// Formatted string for the name
  ///
  String displayName = '';

  /// Formatted string for the span
  ///
  String displaySpan = '';

  /// The field formatter
  ///
  late final PerfTestFormat format;

  /// Full width of the data table
  ///
  static int get fullWidth => _fullWidth;
  static int _fullWidth = 0;

  /// A flag indicating the border should be shown rather than data record
  ///
  bool isBorder = false;

  /// The group result parent object
  ///
  final PerfTestGroupShow show;

  /// The constructor
  ///
  PerfTestShow(this.show) {
    format = show.result.format;
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
    final r = show.result;

    isBorder = (index < 0);

    _fullWidth =
        (2 + r.maxNameWidth + 3 + r.maxLapsWidth + 3 + r.maxSpanWidth + 2);

    if (isBorder) {
      _initLineBorder(r, format);
    } else {
      _initLineData(r, format, index, isTest);
    }

    show.printer(_line);
  }

  /// The serializer
  ///
  @override
  String toString() => _line;

  /// Initialize line border
  ///
  void _initLineBorder(PerfTestGroupResult r, PerfTestFormat f) {
    _line = f.cornerChar +
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
      PerfTestGroupResult r, PerfTestFormat f, int index, bool isTest) {
    _initLineDataParts(r, f, index, isTest);

    var sep = f.fieldSeparator;
    var hasSep = sep.isNotEmpty;

    var maxWidth = (hasSep ? 0 : r.maxNameWidth);
    displayName = adjustQuotes(f.string(displayName, maxWidth));

    maxWidth = (hasSep ? 0 : r.maxLapsWidth);
    displayLaps = adjustQuotes(f.string(displayLaps, maxWidth, true));

    maxWidth = (hasSep ? 0 : r.maxSpanWidth);
    displaySpan = adjustQuotes(f.string(displaySpan, maxWidth, true));

    if (hasSep) {
      _line = displayName + sep + displayLaps + sep + displaySpan;
    } else {
      final b = f.barChar;
      _line = '$b $displayName $b $displayLaps $b $displaySpan $b';
    }
  }

  /// Initialize line data parts
  ///
  void _initLineDataParts(
      PerfTestGroupResult r, PerfTestFormat f, int index, bool isTest) {
    if (index >= 0) {
      if (isTest) {
        final t = r.group.tests[index];
        displayName = t.name;
        displayLaps = f.number(t.laps);
        displaySpan = t.span.toString();
      } else {
        displayName = r.lapsResults[index].name;
        displayLaps = r.lapsResults[index].displayRatio;
        displaySpan = r.spanResults[index].displayRatio;
      }
    } else {
      displayName = '';
      displayLaps = '';
      displaySpan = '';
    }
  }
}
