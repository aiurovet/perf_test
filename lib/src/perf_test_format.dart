// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:intl/intl.dart';
import 'package:perf_test/perf_test.dart';

/// The output format for all tests
///
class PerfTestFormat {
  /// Placeholder for the current date in the caption
  ///
  static final RegExp stubRE = RegExp(r'\{[A-Z]+\}', caseSensitive: false);

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

  /// Placeholder for the current time in the caption
  ///
  static const String stubTime = '{T}';

  /// Character for drawing grid corners and crossings
  ///
  late final String cornerChar;

  /// Character for drawing horizontal bar
  ///
  late final String horBarChar;

  /// The format for dates
  ///
  late final DateFormat dateFormat;

  /// The format for datetimes
  ///
  late final DateFormat dateTimeFormat;

  /// First character in lineFormat after all stubs removed
  /// (not found => space)
  ///
  late final String fieldSeparator;

  /// The number for infinity
  ///
  late final num? infinity;

  /// Flag indicating the need to embrace a field in quotes
  /// when necessary (i.e. [lineFormat] does not start with '{')
  ///
  late final bool isQuoted;

  /// Format of a line
  /// (see the default value in the constructor as an example)
  ///
  String lineFormat;

  /// The format for numbers
  ///
  late final NumberFormat numberFormat;

  /// The format for numbers
  ///
  late final NumberFormat percentFormat;

  /// The actual function to send to the output
  ///
  late final PerfTestPrinter printer;

  /// The embracing quote character if [rawFieldSeparator] is not empty
  ///
  late final String quote;

  /// The escaped version of [quote]
  ///
  late final String quoteEscaped;

  /// Bitwise combination of style* constants
  ///
  late final PerfTestDataStyle dataStyle;

  /// The format for times
  ///
  late final DateFormat timeFormat;

  ///
  ///
  static final PerfTestFormat prettyCsv = createFsv();

  ///
  ///
  static final PerfTestFormat rawCsv = createFsv(
    dataStyleFlags: PerfTestDataStyle.raw);

  /// The constructor
  ///
  PerfTestFormat(
      {String? borderFormat = '+-',
      this.lineFormat = '| $stubFieldName | $stubFieldValue | $stubFieldRatio |',
      this.infinity = 9999.99,
      this.printer = print,
      this.quote = '"',
      this.quoteEscaped = '""',
      PerfTestDataStyle? dataStyle,
      DateFormat? dateFormat,
      DateFormat? dateTimeFormat,
      NumberFormat? numberFormat,
      NumberFormat? percentFormat,
      DateFormat? timeFormat}) {
    this.dataStyle = dataStyle ?? PerfTestDataStyle();

    this.dateFormat = dateFormat ?? DateFormat();
    this.dateTimeFormat = dateTimeFormat ?? this.dateFormat;

    if ((borderFormat != null) && borderFormat.isNotEmpty) {
      cornerChar = borderFormat[0];
      horBarChar = borderFormat[borderFormat.length - 1];
    } else {
      cornerChar = '';
      horBarChar = '';
    }

    this.numberFormat = numberFormat ?? NumberFormat();

    if (percentFormat != null) {
      this.percentFormat = percentFormat;
    } else if (this.dataStyle.isPercent) {
      this.percentFormat = NumberFormat.percentPattern();
    } else {
      this.percentFormat = NumberFormat('#,##0.00');
    }

    this.timeFormat = timeFormat ?? DateFormat.Hm();

    final nonStub = lineFormat.replaceAll(stubRE, '');
    fieldSeparator = (nonStub.isEmpty ? ' ' : nonStub[0]);
  }

  /// The date value formatter
  ///
  static PerfTestFormat createFsv({
    String fieldSeparator = ',',
    int dataStyleFlags = PerfTestDataStyle.raw}) => PerfTestFormat(
      borderFormat: '',
      lineFormat: stubFieldName + fieldSeparator + stubFieldRatio + fieldSeparator+ stubFieldValue,
      dataStyle: PerfTestDataStyle(dataStyleFlags));

  /// The date value formatter
  ///
  String date(DateTime value, [int maxWidth = 0]) =>
      string(dateFormat.format(value), maxWidth, true);

  /// The date value formatter
  ///
  String dateTime(DateTime value, [int maxWidth = 0]) => string(
      dateFormat.format(value) + ' ' + timeFormat.format(value),
      maxWidth,
      true);

  /// Duration value formatter
  ///
  String duration(Duration value, {int precision = 3}) {
    final outValue = value.toString();
    if (precision >= 6) {
      return outValue;
    }
    return outValue.substring(0, outValue.length - 6 + precision);
  }

  /// The numeric value formatter
  ///
  String number(num value, [int maxWidth = 0]) {
    if (dataStyle.isRaw) {
      return value.toString();
    }
    return string(numberFormat.format(value), maxWidth, true);
  }

  /// The percentage value formatter
  ///
  String percent(num value, [int maxWidth = 0]) {
    if (dataStyle.isRaw) {
      return value.toStringAsFixed(2);
    }
    return string(percentFormat.format(value), maxWidth, true);
  }

  /// The time value formatter
  ///
  String time(DateTime value, [int maxWidth = 0]) =>
      string(timeFormat.format(value), maxWidth, true);

  /// The string value formatter
  ///
  String string(String value, [int maxWidth = 0, bool padLeft = false]) {
    if (dataStyle.isRaw) {
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
