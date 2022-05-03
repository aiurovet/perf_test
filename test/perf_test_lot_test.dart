// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';
import 'package:test/test.dart';

/// Unit tests for PerfTestFormat
///
void main() {
  group('PerfTestLot - ', () {
    final lot = PerfTestLot('Lot', format: PerfTestFormat(isQuiet: true));

    test('add one', () {
      lot.tests.clear();
      lot.add(PerfTestOne(''));
      expect(lot.tests.length, 1);
    });
    test('exec', () {
      lot.tests.clear();
      lot
        ..add(PerfTestOne('T1'))
        ..add(PerfTestOne('T2 T2'))
        ..add(PerfTestOne('T3 T3 T3'))
        ..exec(maxLaps: 10);
      expect(lot.tests.length, 3);
      expect(lot.maxLaps, 10);
      expect(lot.maxSpan, null);
      expect(lot.isOutLaps, false);
      expect(lot.maxNameWidth, 8);
      expect(lot.tests[0].outRatio, '1.00');
      expect(lot.tests[1].outRatio, '1.00');
      expect(lot.tests[2].outRatio, '1.00');
    });
  });
}
