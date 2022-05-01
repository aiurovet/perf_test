// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'print_err_io.dart' if (dart.library.html) 'print_err_html.dart';

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

/// The actual execution
///
void exec({PerfTestFmt? format}) {
  final lotName = format?.style.isPretty ?? false
      ? '\nComparing loops - {M} - {D} at {T}'
      : 'Comparing loops,{M},';

  PerfTestLot(lotName, isMyStopwatch: false, format: format)
    ..add(PerfTestOne('For', testProc: testProc1))
    ..add(PerfTestOne('ForEx', testProc: testProc2))
    ..add(PerfTestOne('ForRev', testProc: testProc3))
    ..add(PerfTestOne('ForEach', testProc: testProc4))
    ..exec(maxLaps: laps, maxSpan: span);
}

/// The entry point
///
void main(List<String> args) {
  parseArgs(args);
  setUp();

  final style = PerfTestStyle(PerfTestStyle.prettyWithPercent);

  exec(format: PerfTestFmt(style: style));
  exec(format: PerfTestFmt(fieldSeparator: ',', printer: printErr));
}

/// Parse command-line arguments
///
void parseArgs(List<String> args) {
  int? microseconds;

  if (args.length == 2) {
    switch (args[0].toLowerCase()) {
      case '-c':
        laps = int.parse(args[1]);
        break;
      case '-t':
        microseconds =
            (num.parse(args[1]) * Duration.microsecondsPerSecond).floor();
        span = durationFromMicroseconds(microseconds);
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

/// The performance test #1
///
void testProc1(PerfTestOne test, int lapNo) {
  // The if condition and even the whole block are unnecessary,
  // as you should know what you do. Just showing the capabilities
  //
  if (test.isMyStopwatch) {
    test.stopwatch.start();
  }

  for (var i = 0, n = codeUnits.length; i < n; i++) {
    codeUnits[i].isEven;
    codeUnits[i].isOdd;
  }

  if (test.isMyStopwatch) {
    test.stopwatch.stop();
  }
}

/// The performance test #2
///
void testProc2(PerfTestOne test, int lapNo) {
  if (test.isMyStopwatch) {
    test.stopwatch.start();
  }

  for (var i = 0, n = codeUnits.length; i < n; i++) {
    final c = codeUnits[i];
    c.isEven;
    c.isOdd;
  }

  if (test.isMyStopwatch) {
    test.stopwatch.stop();
  }
}

/// The performance test #3
///
void testProc3(PerfTestOne test, int lapNo) {
  if (test.isMyStopwatch) {
    test.stopwatch.start();
  }

  for (var i = codeUnits.length; --i >= 0;) {
    codeUnits[i].isEven;
    codeUnits[i].isOdd;
  }

  if (test.isMyStopwatch) {
    test.stopwatch.stop();
  }
}

/// The performance test #4
///
void testProc4(PerfTestOne test, int lapNo) {
  if (test.isMyStopwatch) {
    test.stopwatch.start();
  }

  for (var c in codeUnits) {
    c.isEven;
    c.isOdd;
  }

  if (test.isMyStopwatch) {
    test.stopwatch.stop();
  }
}
