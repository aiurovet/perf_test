// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:intl/intl.dart';
import 'package:perf_test/perf_test.dart';

/// A type for the user-defined procedure to show result
///
typedef PerfTestShowProc = void Function(PerfTest test);

/// A type for the user-defined procedure to show group result
///
typedef PerfTestGroupShowProc = void Function(PerfTestGroup group);

/// A class to store all performance test results for a group
///
class PerfTestGroupResult {
  /// The list of all actual laps
  ///
  late final lapsResults = <PerfTestResult>[];

  /// The list of all spans
  ///
  late final spanResults = <PerfTestResult>[];

  /// The test group object
  ///
  late final PerfTestFormat format;

  /// The test group object
  ///
  final PerfTestGroup group;

  /// The maximum width of actual laps display ratio
  ///
  late final int maxLapsWidth;

  /// The maximum width of span display ratio
  ///
  late final int maxSpanWidth;

  /// The maximum width of name pairs of test1 and test2
  ///
  late final int maxNameWidth;

  /// The constructor
  ///
  PerfTestGroupResult(this.group, {PerfTestFormat? format}) {
    group.result = this;
    this.format = format ?? PerfTestFormat();
    _createMaxWidths(_createResults());
  }

  /// The default way to print the group title
  ///
  void defaultShowTitle() {
    final now = DateTime.now();
    print('${group.name} - ${format.date(now)} - ${format.time(now)}');
  }

  /// The default group result show proc
  ///
  void defaultShowProc() {
    final tests = group.tests;
    final testCount = tests.length;
    final pairCount = lapsResults.length;

    defaultShowTitle();

    if ((testCount > 0) || (pairCount > 0)) {
      defaultShowSeparator();
    }

    if (testCount > 0) {
      for (var i = 0; i < testCount; i++) {
        group.testShowProc(tests[i]);
      }
      defaultShowSeparator();
    }

    if (pairCount > 0) {
      for (var i = 0; i < pairCount; i++) {
        final rpt = lapsResults[i];
        final rptStr = format.string(rpt.displayRatio, maxLapsWidth, true);

        final dur = spanResults[i];
        final durStr = format.string(dur.displayRatio, maxSpanWidth, true);

        final tnm = format.string(rpt.name, maxNameWidth);

        defaultShowRecord(tnm, rptStr, durStr);
      }
      defaultShowSeparator();
    }

    if ((testCount <= 0) && (pairCount <= 0)) {
      print('No test found');
    }
  }

  /// The default way to print a separator
  ///
  void defaultShowSeparator() {
    final dashes1 = '-' * (1 + maxNameWidth + 1);
    final dashes2 = '-' * (1 + maxLapsWidth + 1);
    final dashes3 = '-' * (1 + maxSpanWidth + 1);

    print('+$dashes1+$dashes2+$dashes3+');
  }

  /// The default way to print a record
  ///
  static void defaultShowRecord(String name, String laps, String span) =>
      print('| $name | $laps | $span |');

  /// The default group show proc
  ///
  static void defaultTestShowProc(PerfTest test) {
    final group = test.group;
    final result = group?.result;
    final format = result?.format;

    if ((result == null) || (format == null)) {
      return;
    }

    final tnm = format.string(test.name, result.maxNameWidth);
    final rpt = format.number(test.laps, result.maxLapsWidth);
    final dur = format.string(test.span.toString(), result.maxSpanWidth);

    defaultShowRecord(tnm, rpt, dur);
  }

  List<String> _createResults() {
    final tests = group.tests;
    final testCount = tests.length;
    final resultNames = <String>[];

    // Collect all results
    //
    for (var i1 = 0; i1 < testCount; i1++) {
      final test1 = tests[i1];

      for (var i2 = 0; i2 < testCount; i2++) {
        if (i2 != i1) {
          final test2 = tests[i2];

          if (test1.isMagnet || test2.isMagnet) {
            final ar1 = test1.laps;
            final ar2 = test2.laps;
            var ptr = PerfTestResult(test1, ar1, test2, ar2, format: format);
            lapsResults.add(ptr);
            resultNames.add(ptr.name);

            final em1 = test1.span.inMicroseconds;
            final em2 = test2.span.inMicroseconds;
            ptr = PerfTestResult(test1, em1, test2, em2, format: format);
            spanResults.add(ptr);
          }
        }
      }
    }

    return resultNames;
  }

  void _createMaxWidths(List<String> resultNames) {
    // Get the maximum width of the actual laps
    //
    var intValues = group.tests.map((x) => x.laps).toList();
    var maxValueLen =
        intValues.isEmpty ? 0 : format.number((intValues..sort()).last).length;

    // Get the maximum width of the actual laps display ratio
    //
    var widths = lapsResults.map((x) => x.displayRatio.length).toList();
    var maxWidth = (widths.isEmpty ? 0 : (widths..sort()).last);

    // Set the maximum actual laps length
    //
    maxLapsWidth = (maxWidth > maxValueLen ? maxWidth : maxValueLen);

    // Get the maximum width of span (always the same)
    //
    maxValueLen = Duration().toString().length;

    // Get the maximum width of span ratio
    //
    widths = spanResults.map((x) => x.displayRatio.length).toList();
    maxWidth = (widths.isEmpty ? 0 : (widths..sort()).last);

    // Set the maximum span width
    //
    maxSpanWidth = (maxWidth > maxValueLen ? maxWidth : maxValueLen);

    // Get the maximum name width
    //
    widths = group.tests.map((x) => x.name.length).toList();
    maxValueLen = widths.isEmpty ? 0 : (widths..sort()).last;

    // Get the maximum pair name width
    //
    widths = resultNames.map((x) => x.length).toList();
    maxWidth = widths.isEmpty ? 0 : (widths..sort()).last;

    // Set the maximum name width
    //
    maxNameWidth = (maxWidth > maxValueLen ? maxWidth : maxValueLen);
  }
}
