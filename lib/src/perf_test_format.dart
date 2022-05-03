// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:intl/intl.dart';
import 'package:perf_test/perf_test.dart';

/// Output format for all tests
///
class PerfTestFormat {
  /// Placeholder for the current date in the caption
  ///
  static const String stubDate = '{D}';

  /// Placeholder for the current date in the caption
  ///
  static const String stubFieldName = '{N}';

  /// Placeholder for the current date in the caption
  ///
  static const String stubFieldRatio = '{R}';

  /// Placeholder for the current date in the caption
  ///
  static const String stubFieldValue = '{V}';

  /// Placeholder for the limit (maxLaps or maxSpan) in the caption
  ///
  static const String stubSize = '{M}';

  /// Placeholder for the current date in the caption
  ///
  static final RegExp stubRE = RegExp(r'\{[A-Z]+\}', caseSensitive: false);

  /// Character for drawing grid corners and crossings
  ///
  late final String cornerChar;

  /// Character for drawing horizontal bar
  ///
  late final String horBarChar;

  /// Format for dates
  ///
  late final DateFormat dateFormat;

  /// First character in [lineFormat] after all stubs removed
  /// (not found => space)
  ///
  late final String fieldSeparator;

  /// Special number for infinity (to keep data numeric)
  ///
  late final num? infinity;

  /// Flag indicating the need to embrace a field in quotes
  /// when necessary (i.e. [lineFormat] does not start with '{')
  ///
  late final bool isQuoted;

  /// Format of a line (see the default value in the constructor as an example)
  ///
  /// Allows to split the output in blocks using '\n':
  /// '| {N} | {R} |\n| {N} | {V} |'
  ///
  String lineFormat;

  /// Flag to convert ratio to percentage rather than to leave it as a number
  ///
  bool usePercent;

  /// Flag indicating that no output is expected
  ///
  bool isQuiet;

  /// Flag to avoid nice formatting of data and printing a grid around
  ///
  bool isRaw;

  /// Format for numbers
  ///
  late final NumberFormat numberFormat;

  /// Format for numbers
  ///
  late final NumberFormat percentFormat;

  /// Actual function to send to the output, defaults to [print] from dart:core
  ///
  late final PerfTestPrinter printer;

  /// Embracing quote character if [isRaw] is true
  ///
  late final String quote;

  /// Escaped version of [quote]
  ///
  late final String quoteEscaped;

  /// Convenience pre-created object for the CSV output with formatted data
  ///
  static final PerfTestFormat prettyCsv = createFsv();

  /// Convenience pre-created object for the CSV output with raw (unformatted) data
  ///
  static final PerfTestFormat rawCsv = createFsv(isRaw: true);

  /// The constructor
  ///
  PerfTestFormat(
      {String? borderFormat = '+-',
      this.lineFormat =
          '| $stubFieldName | $stubFieldRatio | $stubFieldValue |',
      this.infinity = 9999.99,
      this.isQuiet = false,
      this.isRaw = false,
      this.printer = print,
      this.quote = '"',
      this.quoteEscaped = '""',
      this.usePercent = false,
      DateFormat? dateFormat,
      NumberFormat? numberFormat,
      NumberFormat? percentFormat}) {
    if ((borderFormat != null) && borderFormat.isNotEmpty) {
      cornerChar = borderFormat[0];
      horBarChar = borderFormat[borderFormat.length - 1];
    } else {
      cornerChar = '';
      horBarChar = '';
    }

    this.dateFormat = dateFormat ?? DateFormat();
    this.numberFormat = numberFormat ?? NumberFormat();

    if (percentFormat != null) {
      this.percentFormat = percentFormat;
    } else if (usePercent) {
      this.percentFormat = NumberFormat.percentPattern();
    } else {
      this.percentFormat = NumberFormat('#,##0.00');
    }

    final nonStub = lineFormat.replaceAll(stubRE, '');
    fieldSeparator = (nonStub.isEmpty ? ' ' : nonStub[0]);
  }

  /// Pre-defined format for the field-separated value output (raw)
  ///
  static PerfTestFormat createFsv(
          {String fieldSeparator = ',',
          bool isRaw = true,
          bool usePercent = false}) =>
      PerfTestFormat(
          borderFormat: '',
          lineFormat: stubFieldName +
              fieldSeparator +
              stubFieldRatio +
              fieldSeparator +
              stubFieldValue,
          isRaw: isRaw,
          usePercent: usePercent);

  /// Date value formatter
  ///
  String date(DateTime value, [int maxWidth = 0]) {
    if (isRaw) {
      return value.toString();
    }
    return string(dateFormat.format(value), maxWidth, true);
  }

  /// Duration value formatter
  ///
  String duration(Duration value, [int precision = 3]) {
    final outValue = value.toString();
    if (precision >= 6) {
      return outValue;
    }
    return outValue.substring(0, outValue.length - 6 + precision);
  }

  /// Numeric value formatter
  ///
  String number(num value, [int maxWidth = 0]) {
    if (isRaw) {
      return value.toString();
    }
    return string(numberFormat.format(value), maxWidth, true);
  }

  /// Percentage value formatter
  ///
  String percent(num value, [int maxWidth = 0]) {
    if (isRaw) {
      return value.toStringAsFixed(2);
    }
    return string(percentFormat.format(value), maxWidth, true);
  }

  /// String value formatter
  ///
  String string(String value, [int maxWidth = 0, bool padLeft = false]) {
    if (isRaw) {
      return value;
    }

    final deltaWidth = maxWidth - value.length;

    if (deltaWidth <= 0) {
      return value;
    }

    final spaces = ' ' * deltaWidth;

    return (padLeft ? spaces + value : value + spaces);
  }
}
