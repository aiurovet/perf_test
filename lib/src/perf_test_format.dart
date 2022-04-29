// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:intl/intl.dart';

/// A class to store all performance test results for a group
///
class PerfTestFormat {
  /// The character for the border
  ///
  final String barChar;

  /// The character for the border
  ///
  final String borderChar;

  /// The character for the corners of the border
  ///
  final String cornerChar;

  /// The format for dates
  ///
  late final DateFormat dateFormat;

  /// The format for datetimes
  ///
  late final DateFormat dateTimeFormat;

  /// The field separator in case of FSV output
  ///
  String fieldSeparator;

  /// The string indicating the result is the same instead of 100%
  ///
  final String identical;

  /// The symbol for infinity
  ///
  final String infinite;

  /// The format for numbers
  ///
  late final NumberFormat numberFormat;

  /// The format for numbers
  ///
  late final NumberFormat percentFormat;

  /// The embracing quote character
  ///
  final String quote;

  /// The escaped version of [_quote]
  ///
  final String quoteEscaped;

  /// The format for times
  ///
  late final DateFormat timeFormat;

  /// The constructor
  ///
  PerfTestFormat(
      {this.barChar = '|',
      this.borderChar = '-',
      this.cornerChar = '+',
      this.fieldSeparator = '',
      this.identical = '==',
      this.infinite = '??',
      this.quote = '"',
      this.quoteEscaped = '""',
      DateFormat? dateFormat,
      DateFormat? dateTimeFormat,
      NumberFormat? numberFormat,
      NumberFormat? percentFormat,
      DateFormat? timeFormat}) {
    this.dateFormat = dateFormat ?? DateFormat.yMMMMd();
    this.dateTimeFormat = dateFormat ?? DateFormat();
    this.numberFormat = numberFormat ?? NumberFormat();
    this.percentFormat = percentFormat ?? NumberFormat.percentPattern();
    this.timeFormat = dateFormat ?? DateFormat.Hm();
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
