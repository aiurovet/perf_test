// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';

/// A class to store and display ratio of a performance
/// test result (actual laps, time spent) against another one
///
class PerfTestOneRatio {
  /// The pattern for the ratio conversion to display string
  ///
  late final PerfTestFmt format;

  /// The default name
  ///
  String get name => '${test1.name} / ${test2.name}';

  /// The string showing the ratio
  ///
  late final String outRatio;

  /// The ratio
  ///
  late final num ratio;

  /// The primary test value (laps or span in microseconds)
  ///
  final num value1;

  /// The secondary test value (laps or span in microseconds)
  ///
  final num value2;

  /// The primary test object
  ///
  final PerfTestOne test1;

  /// The secondary test object
  ///
  final PerfTestOne test2;

  /// The constructor
  ///
  PerfTestOneRatio(this.test1, this.value1, this.test2, this.value2,
      {PerfTestFmt? format}) {
    this.format = format ?? PerfTestFmt();

    if (value1 == value2) {
      ratio = 1;      
      outRatio = this.format.percent(ratio);
    } else if (value2 == 0) {
      ratio = -1;
      outRatio = this.format.infinite;
    } else {
      ratio = value1 / value2;
      outRatio = this.format.percent(ratio);
    }
  }

  /// The serializer
  ///
  @override
  String toString() => outRatio;
}
