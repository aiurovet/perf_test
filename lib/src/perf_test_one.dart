// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';

/// Simplified name for [PerfTestOne]
///
typedef PerfTest = PerfTestOne;

/// Wrapper class to execute user-defined procedures multiple times
/// and measure either actual laps for a given time span or time
/// span for a given number of iterations
///
class PerfTestOne {
  /// Parent
  ///
  PerfTestLot? lot;

  /// Convenience property derived from [lot]
  ///
  PerfTestFormat format = PerfTestFormat();

  /// Flag indicating that the output data is laps rather than span
  ///
  bool isOutLaps;

  /// Flag indicating that the stopwatch is started and
  /// stopped by a user rather than by this class object
  ///
  bool isMyStopwatch;

  /// Actual number of the test iterations upon execution completion
  ///
  int laps;

  /// Name of the test
  ///
  final String name;

  /// Output value of [ratio]
  ///
  String outRatio;

  /// Output value of [value]
  ///
  String outValue;

  /// Ratio versus the first test
  ///
  num ratio;

  /// Total duration of [testProc] execution
  ///
  Duration span = Duration();

  /// Stopwatch used to measure performance
  ///
  Stopwatch stopwatch = Stopwatch();

  /// Generic value based on expectation
  ///
  int get value => (isOutLaps ? laps : span.inMilliseconds);

  /// Actual user-defined procedure
  ///
  final PerfTestOneProc testProc;

  /// Constructor
  ///
  PerfTestOne(this.name,
      {PerfTestFormat? format,
      this.isMyStopwatch = false,
      this.isOutLaps = false,
      this.laps = 0,
      this.lot,
      this.outRatio = '',
      this.outValue = '',
      this.ratio = 0,
      Stopwatch? stopwatch,
      this.testProc = emptyTestProc}) {
    if (format != null) {
      this.format = format;
    }
    if (stopwatch != null) {
      this.stopwatch = stopwatch;
    }
  }

  /// Dummy test proc
  ///
  static void emptyTestProc(PerfTestOne test, int lapNo) {}

  /// Actual test execution
  ///
  PerfTestOne exec({int? maxLaps, Duration? maxSpan}) {
    stopwatch.reset();

    isOutLaps = (maxLaps == null);
    num spanAdjustment = 1.0;

    if (maxLaps != null) {
      laps = maxLaps;

      for (var i = 0; i < maxLaps; i++) {
        if (!isMyStopwatch) {
          stopwatch.start();
        }
        testProc(this, i);
        if (!isMyStopwatch) {
          stopwatch.stop();
        }
      }
    } else if (maxSpan != null) {
      laps = 0;
      final maxMilliseconds = maxSpan.inMilliseconds;

      for (; stopwatch.elapsedMilliseconds < maxMilliseconds; laps++) {
        if (!isMyStopwatch) {
          stopwatch.start();
        }
        testProc(this, laps);
        if (!isMyStopwatch) {
          stopwatch.stop();
        }
      }
      if (maxMilliseconds == 0) {
        spanAdjustment = 0;
      } else {
        spanAdjustment = stopwatch.elapsedMilliseconds / maxMilliseconds;
      }
    }

    span = durationFromMilliseconds(stopwatch.elapsedMilliseconds);

    if ((maxSpan != null) && (spanAdjustment != 1)) {
      laps = (laps * spanAdjustment).round();
    }

    setOutValue();

    if (lot == null) {
      final tmpLot = PerfTestLot('',
          stopwatch: stopwatch, isMyStopwatch: isMyStopwatch, format: format)
        ..add(this);

      tmpLot.isOutLaps = isOutLaps;
      tmpLot.maxLaps = maxLaps;
      tmpLot.maxSpan = maxSpan;

      initLot(tmpLot);
      tmpLot.out.exec();
      initLot(null);
    }

    return this;
  }

  /// Initialize parent property with [newLot] as well as
  /// initialize convenience properties depending on that
  ///
  PerfTestOne initLot(PerfTestLot? newLot) {
    lot = newLot;

    if (newLot != null) {
      format = newLot.format;
      isMyStopwatch = newLot.isMyStopwatch;
      isOutLaps = newLot.isOutLaps;

      if (newLot.stopwatch != null) {
        stopwatch = newLot.stopwatch!;
      }
    }

    return this;
  }

  /// Serializer of the mode-specific value
  ///
  void setOutValue() {
    if (isOutLaps) {
      outValue = format.number(laps);
    } else {
      outValue = format.duration(span);
    }
  }

  /// Calculate ratio against another test
  ///
  void setRatio(PerfTestOne versus) {
    final value1 = value;
    final value2 = versus.value;

    if (value1 == value2) {
      ratio = 1;
    } else if (value2 == 0) {
      ratio = format.infinity ?? -1;
    } else {
      ratio = (value1 / value2);
    }

    outRatio = (ratio < 0 ? '' : format.percent(ratio));
  }
}

/// Helper static method to create Duration from a total number of milliseconds
///
Duration durationFromMilliseconds(int totalMilliseconds) =>
    durationFromMicroseconds(
        totalMilliseconds * Duration.microsecondsPerMillisecond);

/// Helper static method to create Duration from a total number of microseconds
///
Duration durationFromMicroseconds(int totalMicroseconds) {
  final days = totalMicroseconds ~/ Duration.microsecondsPerDay;
  totalMicroseconds -= days * Duration.microsecondsPerDay;

  final hours = totalMicroseconds ~/ Duration.microsecondsPerHour;
  totalMicroseconds -= hours * Duration.microsecondsPerHour;

  final minutes = totalMicroseconds ~/ Duration.microsecondsPerMinute;
  totalMicroseconds -= minutes * Duration.microsecondsPerMinute;

  final seconds = totalMicroseconds ~/ Duration.microsecondsPerSecond;
  totalMicroseconds -= seconds * Duration.microsecondsPerSecond;

  final milliseconds = totalMicroseconds ~/ Duration.microsecondsPerMillisecond;
  totalMicroseconds -= milliseconds * Duration.microsecondsPerMillisecond;

  return Duration(
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
      microseconds: totalMicroseconds);
}
