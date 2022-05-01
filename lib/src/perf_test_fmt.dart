// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:intl/intl.dart';
import 'package:perf_test/perf_test.dart';

/// The output style for all tests
///
class PerfTestFmt {
  /// Placeholder for the current date in the caption
  ///
  static const String stubDate = '{D}';

  /// Placeholder for the limit (maxLaps or maxSpan) in the caption
  ///
  static const String stubSize = '{M}';

  /// Placeholder for the current time in the caption
  ///
  static const String stubTime = '{T}';

  /// The character for the horizontal bar
  ///
  String horBarChar = '-';

  /// The character for the vertical bar
  ///
  String verBarChar = '|';

  /// The character for the corners of the border
  ///
  String cornerChar = '+';

  /// The format for dates
  ///
  DateFormat dateFormat = DateFormat.yMMMMd();

  /// The format for datetimes
  ///
  DateFormat dateTimeFormat = DateFormat();

  /// The field separator in case of FSV output
  ///
  String fieldSeparator = '';

  /// The number for infinity
  ///
  num infinity = 9999.99;

  /// The number for infinity
  ///
  bool get isPretty => fieldSeparator.isEmpty;

  /// The format for numbers
  ///
  NumberFormat numberFormat = NumberFormat();

  /// The format for numbers
  ///
  NumberFormat percentFormat = NumberFormat.percentPattern();

  /// The actual function to send to the output
  ///
  late final PerfTestPrinter printer;

  /// The embracing quote character if [fieldSeparator] is not empty
  ///
  String quote = '"';

  /// The escaped version of [quote]
  ///
  String quoteEscaped = '""';

  /// Bitwise combination of style* constants
  ///
  PerfTestStyle style = PerfTestStyle();

  /// The format for times
  ///
  DateFormat timeFormat = DateFormat.Hm();

  /// The constructor
  ///
  PerfTestFmt(
      {String? horBarChar,
      String? verBarChar,
      String? cornerChar,
      String? fieldSeparator,
      num? infinity,
      // true = display percentage as a number (only if percentFormat is null)
      PerfTestPrinter? printer,
      String? quote,
      String? quoteEscaped,
      PerfTestStyle? style,
      DateFormat? dateFormat,
      DateFormat? dateTimeFormat,
      NumberFormat? numberFormat,
      NumberFormat? percentFormat,
      DateFormat? timeFormat}) {
    this.printer = printer ?? print;

    if (style != null) {
      this.style = style;
    }

    if (verBarChar != null) {
      this.verBarChar = verBarChar;
    }
    if (horBarChar != null) {
      this.horBarChar = horBarChar;
    }
    if (cornerChar != null) {
      this.cornerChar = cornerChar;
    }
    if (dateFormat != null) {
      this.dateFormat = dateFormat;
    }
    if (dateTimeFormat != null) {
      this.dateTimeFormat = dateTimeFormat;
    }
    if (fieldSeparator != null) {
      this.fieldSeparator = fieldSeparator;
    }
    if (infinity != null) {
      this.infinity = infinity;
    }
    if (numberFormat != null) {
      this.numberFormat = numberFormat;
    }
    if (percentFormat != null) {
      this.percentFormat = percentFormat;
    } else if (this.style.isPercent) {
      this.percentFormat = NumberFormat.percentPattern();
    } else {
      this.percentFormat = NumberFormat('#,##0.00');
    }
    if (quote != null) {
      this.quote = quote;
    }
    if (quoteEscaped != null) {
      this.quoteEscaped = quoteEscaped;
    }
    if (timeFormat != null) {
      this.timeFormat = timeFormat;
    }
  }

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

  /// The numeric value formatter
  ///
  String number(num value, [int maxWidth = 0]) =>
      string(numberFormat.format(value), maxWidth, true);

  /// The percentage value formatter
  ///
  String percent(num value, [int maxWidth = 0]) =>
      string(percentFormat.format(value), maxWidth, true);

  /// The time value formatter
  ///
  String time(DateTime value, [int maxWidth = 0]) =>
      string(timeFormat.format(value), maxWidth, true);

  /// The string value formatter
  ///
  String string(String value, [int maxWidth = 0, bool padLeft = false]) {
    final deltaWidth = maxWidth - value.length;

    if (deltaWidth <= 0) {
      return value;
    }

    final spaces = ' ' * deltaWidth;

    return (padLeft ? spaces + value : value + spaces);
  }
}
