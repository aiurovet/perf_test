// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:intl/intl.dart';

/// The output style for all tests
///
class PerfTestFmt {
  /// The character for the border
  ///
  String barChar = '|';

  /// The character for the border
  ///
  String borderChar = '-';

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

  /// The symbol for infinity
  ///
  String infinite = 'NaN';

  /// The format for numbers
  ///
  NumberFormat numberFormat = NumberFormat();

  /// The format for numbers
  ///
  NumberFormat percentFormat = NumberFormat.percentPattern();

  /// The embracing quote character if [fieldSeparator] is not empty
  ///
  String quote = '"';

  /// The escaped version of [quote]
  ///
  String quoteEscaped = '""';

  /// The format for times
  ///
  DateFormat timeFormat = DateFormat.Hm();

  /// The constructor
  ///
  PerfTestFmt(
      {String? barChar,
      String? borderChar,
      String? cornerChar,
      String? fieldSeparator,
      String? infinite,
      // true = display percentage as a number (only if percentFormat is null)
      bool isPercentNumeric = false,
      String? quote,
      String? quoteEscaped,
      DateFormat? dateFormat,
      DateFormat? dateTimeFormat,
      NumberFormat? numberFormat,
      NumberFormat? percentFormat,
      DateFormat? timeFormat}) {
    if (barChar != null) {
      this.barChar = barChar;
    }
    if (borderChar != null) {
      this.borderChar = borderChar;
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
    if (infinite != null) {
      this.infinite = infinite;
    }
    if (numberFormat != null) {
      this.numberFormat = numberFormat;
    }
    if (percentFormat != null) {
      this.percentFormat = percentFormat;
    } else if (isPercentNumeric) {
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
