// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:perf_test/perf_test.dart';

/// Generic argument to generate any kind of test data
///
class PerfTestArgIntRange extends PerfTestArgRange<int, int> {
  /// The constructor
  ///
  PerfTestArgIntRange({int? min, int? max, int? step, List<int>? list, super.isRandom, super.random}) :
    super(min: min, max: max, step: step, list: list) {

    if (!isList) {
      this.min = min ?? 0;
      this.max = max ?? min ?? 0;
      this.step = step ?? 1;
    }

    if (isRandom) {
      if (isList) {
        randomMax = this.list.length;
      } else {
        randomMax = (this.max - this.min + 1);
      }
    } else {
      randomMax = 0;
    }

    reset();
  }

  @override void moveNext() {
    final r = (isRandom ? random.nextInt(randomMax) : 0);

    if (isList) {
      if (r > 0) {
        cur = list[r];
      } else {
        cur = 
      }
    }
    if (isRandom) {
      cur = (this.min ?? 0) + random.nextInt(this.max ?? 0);
    } else {
      if (cur == this.max) {
        cur = this.min;
      } else {
        cur = (cur as int) + (step as int);
      }
    }
  }

  @override void reset() =>
    cur = (isList ? list[0] : this.min);
}