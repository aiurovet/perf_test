// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';

/// A class to store all performance test results for a lot (group)
///
class PerfTestLotResult {
  /// The list of all actual laps
  ///
  late final lapsRatios = <PerfTestOneRatio>[];

  /// The list of all spans
  ///
  late final spanRatios = <PerfTestOneRatio>[];

  /// The output format
  ///
  late final PerfTestFmt format;

  /// The test lot object
  ///
  final PerfTestLot lot;

  /// The maximum width of actual laps display ratio
  ///
  late final int maxLapsWidth;

  /// The maximum width of name pairs of test1 and test2
  ///
  late final int maxNameWidth;

  /// The maximum width of span display ratio
  ///
  late final int maxSpanWidth;

  /// The constructor
  ///
  PerfTestLotResult(this.lot, {PerfTestFmt? format}) {
    this.format = format ?? PerfTestFmt();
  }

  /// Re-calculate everything
  ///
  void exec() => _createMaxWidths(_createRatios());

  /// Get the default title string
  ///
  String getCaption() {
    final now = DateTime.now();
    return '${lot.name} - ${format.date(now)} - ${format.time(now)}';
  }

  /// Calculate maximum widths for all columns
  ///
  void _createMaxWidths(List<String> ratioNames) {
    // Get the maximum width of the actual laps
    //
    var intValues = lot.tests.map((x) => x.laps).toList();
    var maxValueLen =
        intValues.isEmpty ? 0 : format.number((intValues..sort()).last).length;

    // Get the maximum width of the actual laps display ratio
    //
    var widths = lapsRatios.map((x) => x.outRatio.length).toList();
    var maxWidth = (widths.isEmpty ? 0 : (widths..sort()).last);

    // Set the maximum actual laps length
    //
    maxLapsWidth = (maxWidth > maxValueLen ? maxWidth : maxValueLen);

    // Get the maximum width of span (always the same)
    //
    maxValueLen = Duration().toString().length;

    // Get the maximum width of span ratio
    //
    widths = spanRatios.map((x) => x.outRatio.length).toList();
    maxWidth = (widths.isEmpty ? 0 : (widths..sort()).last);

    // Set the maximum span width
    //
    maxSpanWidth = (maxWidth > maxValueLen ? maxWidth : maxValueLen);

    // Get the maximum name width
    //
    widths = lot.tests.map((x) => x.name.length).toList();
    maxValueLen = widths.isEmpty ? 0 : (widths..sort()).last;

    // Get the maximum pair name width
    //
    widths = ratioNames.map((x) => x.length).toList();
    maxWidth = widths.isEmpty ? 0 : (widths..sort()).last;

    // Set the maximum name width
    //
    maxNameWidth = (maxWidth > maxValueLen ? maxWidth : maxValueLen);
  }

  /// Create perf test ratios for laps and spans
  ///
  List<String> _createRatios() {
    final tests = lot.tests;
    final testCount = tests.length;
    final ratioNames = <String>[];

    // Collect all single test ratios
    //
    for (var i1 = 0; i1 < testCount; i1++) {
      final test1 = tests[i1];

      for (var i2 = 0; i2 < testCount; i2++) {
        if (i2 != i1) {
          final test2 = tests[i2];

          if (test1.isMagnetic || test2.isMagnetic) {
            final ar1 = test1.laps;
            final ar2 = test2.laps;
            var ptr = PerfTestOneRatio(test1, ar1, test2, ar2, format: format);
            lapsRatios.add(ptr);
            ratioNames.add(ptr.name);

            final em1 = test1.span.inMicroseconds;
            final em2 = test2.span.inMicroseconds;
            ptr = PerfTestOneRatio(test1, em1, test2, em2, format: format);
            spanRatios.add(ptr);
          }
        }
      }
    }

    return ratioNames;
  }
}
