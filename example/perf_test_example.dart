// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';

/// Test data holder
///
final codeUnits = <int>[];

/// Duration-based tests value
///
Duration? span;

/// Laps-based tests value
///
int? laps;

/// Execute multiple tests with the pretty output
///
void execPretty() => PerfTestLot('\nComparing loops - {M} - {D}')
  ..add(PerfTestOne('For, "as primary"', testProcSync: testProc1))
  ..add(PerfTestOne('ForEx', testProcSync: testProc2))
  ..add(PerfTestOne('ForRev', testProcSync: testProc3))
  ..add(PerfTestOne('ForEach', testProcSync: testProc4))
  ..execSync(maxLaps: laps, maxSpan: span);

/// Execute single test with the pretty output
///
void execPrettyOne() =>
    PerfTestOne('For, "as primary"', testProcSync: testProc1)
        .exec(maxLaps: laps, maxSpan: span);

/// Execute multiple tests with the raw output
///
void execRaw() => PerfTestLot('Comparing loops,{M},',
    isMyStopwatch: true, format: PerfTestFormat.rawCsv)
  ..add(PerfTestOne('For, "as primary"', testProcSync: testProc1w))
  ..add(PerfTestOne('ForEx', testProcSync: testProc2w))
  ..add(PerfTestOne('ForRev', testProcSync: testProc3w))
  ..add(PerfTestOne('ForEach', testProcSync: testProc4w))
  ..execSync(maxLaps: laps, maxSpan: span);

/// The entry point
///
void main(List<String> args) {
  parseArgs(args);
  setUp();
  execPrettyOne();
  execPretty();
  execRaw();
}

/// Parse command-line arguments
///
void parseArgs(List<String> args) {
  int? milliseconds;

  if (args.length == 2) {
    switch (args[0].toLowerCase()) {
      case '-c':
        laps = int.parse(args[1]);
        break;
      case '-t':
        milliseconds =
            (num.parse(args[1]) * Duration.millisecondsPerSecond).floor();
        span = durationFromMilliseconds(milliseconds);
        break;
    }
  }
}

/// Data preparation
///
List<int> setUp() {
  codeUnits.clear();

  for (var c = 0x00; c < 0x7F; c++) {
    codeUnits.add(c);
  }

  return codeUnits;
}

/// Performance test #1
///
void testProc1(PerfTestOne test, int lapNo) {
  for (var i = 0, n = codeUnits.length; i < n; i++) {
    codeUnits[i].isEven;
    codeUnits[i].isOdd;
  }
}

/// Performance test #1 with the user-controlled stopwatch
///
void testProc1w(PerfTestOne test, int lapNo) {
  test.stopwatch.start();

  for (var i = 0, n = codeUnits.length; i < n; i++) {
    codeUnits[i].isEven;
    codeUnits[i].isOdd;
  }

  test.stopwatch.stop();
}

/// Performance test #2
///
void testProc2(PerfTestOne test, int lapNo) {
  for (var i = 0, n = codeUnits.length; i < n; i++) {
    final c = codeUnits[i];
    c.isEven;
    c.isOdd;
  }
}

/// Performance test #2 with the user-controlled stopwatch
///
void testProc2w(PerfTestOne test, int lapNo) {
  test.stopwatch.start();

  for (var i = 0, n = codeUnits.length; i < n; i++) {
    final c = codeUnits[i];
    c.isEven;
    c.isOdd;
  }

  test.stopwatch.stop();
}

/// Performance test #3
///
void testProc3(PerfTestOne test, int lapNo) {
  for (var i = codeUnits.length; --i >= 0;) {
    codeUnits[i].isEven;
    codeUnits[i].isOdd;
  }
}

/// Performance test #3 with the user-controlled stopwatch
///
void testProc3w(PerfTestOne test, int lapNo) {
  test.stopwatch.start();

  for (var i = codeUnits.length; --i >= 0;) {
    codeUnits[i].isEven;
    codeUnits[i].isOdd;
  }

  test.stopwatch.stop();
}

/// Performance test #4
///
void testProc4(PerfTestOne test, int lapNo) {
  for (var c in codeUnits) {
    c.isEven;
    c.isOdd;
  }
}

/// Performance test #4 with the user-controlled stopwatch
///
void testProc4w(PerfTestOne test, int lapNo) {
  test.stopwatch.start();

  for (var c in codeUnits) {
    c.isEven;
    c.isOdd;
  }

  test.stopwatch.stop();
}
