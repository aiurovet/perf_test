// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';

/// A class to store and display ratio of a performance
/// test result (actual laps, time spent) against another one
///
class PerfTestRatio {
  /// The pattern for the ratio conversion to display string
  ///
  late final PerfTestFmt format;

  /// The primary test object
  ///
  final PerfTestMode mode;

  /// The string showing the ratio
  ///
  late final String outRatio;

  /// The ratio
  ///
  late final num ratio;

  /// The primary test object
  ///
  final PerfTestOne test1;

  /// The secondary test object
  ///
  final PerfTestOne test2;

  /// The constructor
  ///
  PerfTestRatio(this.test1, this.test2, {this.mode = PerfTestMode.byLaps, PerfTestFmt? format}) {
    this.format = format ?? PerfTestFmt();

    final isByLaps = mode == PerfTestMode.byLaps;
    final isPretty = this.format.fieldSeparator.isEmpty;

    final value1 = isByLaps ? test1.span.inMicroseconds : test1.laps;
    final value2 = isByLaps ? test2.span.inMicroseconds : test2.laps;

    if (value1 == value2) {
      ratio = 1;      
      outRatio = (isPretty ? '' : this.format.percent(ratio));
    } else if (value1 == 0) {
      ratio = -1;
      outRatio = this.format.infinite;
    } else {
      ratio = value2 / value1;
      outRatio = this.format.percent(ratio);
    }
  }

  /// The serializer
  ///
  @override
  String toString() => outRatio;
}
