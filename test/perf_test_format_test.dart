// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:intl/intl.dart';
import 'package:perf_test/perf_test.dart';
import 'package:test/test.dart';

/// Unit tests for PerfTestFormat
///
void main() {
  group('PerfTestFormat - date -', () {
    test('default', () {
      final now = DateTime.now();
      expect(PerfTestFormat().date(now), DateFormat().format(now));
    });
    test('padded', () {
      final now = DateTime.now();
      final nowStr = DateFormat().format(now);
      expect(
          PerfTestFormat().date(now, 20), ' ' * (20 - nowStr.length) + nowStr);
    });
    test('raw', () {
      final now = DateTime.now();
      expect(PerfTestFormat(isRaw: true).date(now, 10), now.toString());
    });
  });
  group('PerfTestFormat - duration -', () {
    test('default', () {
      final duration = Duration(minutes: 1, seconds: 23, milliseconds: 456);
      expect(PerfTestFormat().duration(duration), '0:01:23.456');
    });
    test('microseconds', () {
      final duration = Duration(minutes: 1, seconds: 23, milliseconds: 456);
      expect(PerfTestFormat().duration(duration, 6), '0:01:23.456000');
    });
  });
  group('PerfTestFormat - number -', () {
    test('default', () {
      expect(PerfTestFormat().number(1234.56), NumberFormat().format(1234.56));
    });
    test('#,##0', () {
      expect(
          PerfTestFormat(numberFormat: NumberFormat('#,##0')).number(1234.56),
          NumberFormat('#,##0').format(1234.56));
    });
    test('padded', () {
      expect(PerfTestFormat().number(1234.56, 10), '  1,234.56');
    });
    test('raw', () {
      expect(
          PerfTestFormat(isRaw: true).number(1234.56, 10), 1234.56.toString());
    });
  });
  group('PerfTestFormat - percent -', () {
    test('default', () {
      expect(PerfTestFormat(usePercent: true).percent(1234.56),
          NumberFormat.percentPattern().format(1234.56));
    });
  });
  group('PerfTestFormat - string -', () {
    test('default', () {
      expect(PerfTestFormat().string('abc'), 'abc');
    });
    test('padded - left', () {
      expect(PerfTestFormat().string('abc', 5, true), '  abc');
    });
    test('padded - right', () {
      expect(PerfTestFormat().string('abc', 5), 'abc  ');
    });
  });
}
