// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';
import 'package:test/test.dart';

/// Unit tests for PerfTestFormat
///
void main() {
  group('PerfTestOne -', () {
    final t1 = PerfTestOne('T1', format: PerfTestFormat(isQuiet: true));

    setUp(() {
      t1.isOutLaps = true;
      t1.laps = 12;
      t1.span = Duration(seconds: 3, milliseconds: 456);
    });
    test('exec', () {
      t1.exec(maxLaps: 10);
      expect(t1.lot, null);
      expect(t1.ratio, 1);
      expect(t1.outRatio, '1.00');
    });
    test('initLot', () {
      final lot = PerfTestLot('Lot');
      t1.initLot(lot);

      expect(t1.lot, lot);

      expect(t1.format, lot.format);
      expect(t1.isMyStopwatch, lot.isMyStopwatch);
      expect(t1.isOutLaps, lot.isOutLaps);
      expect(t1.stopwatch, lot.stopwatch);
    });
    test('setOutValue - laps', () {
      t1.setOutValue();
      expect(t1.outValue, '12');
    });
    test('setRatio - laps', () {
      final t2 = PerfTestOne('T2');

      t2.laps = t1.laps ~/ 2;
      t2.isOutLaps = true;

      t2.setRatio(t1);

      expect(t2.ratio, 0.5);
      expect(t2.outRatio, '0.50');
    });
    test('setRatio - span', () {
      final format = PerfTestFormat(usePercent: true);
      t1.isOutLaps = false;
      t1.format = format;

      final t2 = PerfTestOne('T2', format: format);
      t2.span = Duration(seconds: 6, milliseconds: 912);
      t2.setRatio(t1);

      expect(t2.ratio, 2.0);
      expect(t2.outRatio, '200%');
    });
  });
  group('durationFromMilliseconds - ', () {
    test('1s', () {
      expect(durationFromMilliseconds(1000), Duration(seconds: 1));
    });
    test('2m', () {
      expect(durationFromMilliseconds(120000), Duration(minutes: 2));
    });
    test('2m 3s 456ms', () {
      expect(durationFromMilliseconds(123456),
          Duration(minutes: 2, seconds: 3, milliseconds: 456));
    });
    test('1h 2m 3s 456ms', () {
      expect(durationFromMilliseconds(3723456),
          Duration(hours: 1, minutes: 2, seconds: 3, milliseconds: 456));
    });
  });
  group('durationFromMicroseconds - ', () {
    test('1s', () {
      expect(durationFromMicroseconds(1000000), Duration(seconds: 1));
    });
    test('2m', () {
      expect(durationFromMicroseconds(120000000), Duration(minutes: 2));
    });
    test('2m 3s 456ms 789mcs', () {
      expect(
          durationFromMicroseconds(123456789),
          Duration(
              minutes: 2, seconds: 3, milliseconds: 456, microseconds: 789));
    });
    test('1h 2m 3s 456ms 789mcs', () {
      expect(
          durationFromMicroseconds(3723456789),
          Duration(
              hours: 1,
              minutes: 2,
              seconds: 3,
              milliseconds: 456,
              microseconds: 789));
    });
  });
}
