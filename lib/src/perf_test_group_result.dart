// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';

/// A type for the user-defined procedure to show result
///
typedef PerfTestShowProc = void Function(PerfTestGroupShow show, PerfTest test);

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
    this.format = format ?? PerfTestFormat();
  }

  /// Re-calculate everything
  ///
  void exec() => _createMaxWidths(_createResults());

  /// Get the default title string
  ///
  String getCaption() {
    final now = DateTime.now();
    return '${group.name} - ${format.date(now)} - ${format.time(now)}';
  }

  /// Calculate maximum widths for all columns
  ///
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

  /// Create perf test results for laps and spans
  ///
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

          if (test1.isMagnetic || test2.isMagnetic) {
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
}
