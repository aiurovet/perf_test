// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'dart:math';

/// Generic argument to generate any kind of test data
///
abstract class PerfTestArgRange {
  /// Step value indicating random generator is used
  ///
  static const stepRandom = 0;

  /// Current value
  ///
  num cur = 0;

  /// Lowest value
  ///
  late final num min;

  /// Highest value
  ///
  late final num max;

  /// Flag indicating the data is a list of discrete values
  /// rather than contiguous range between [min] and [max]
  ///
  late final bool isList;

  /// Flag indicating the next value is picked using [random]
  ///
  late final bool isRandom;

  /// List of discrete values
  ///
  late final List list;

  /// Random number generator
  ///
  late final Random random;

  /// Increment
  ///
  late final num step;

  /// Number of steps from the lowest to the highest value in the range
  ///
  late final int stepCount;

  /// The constructor
  ///
  PerfTestArgRange({num? min, num? max, num? step, List? list, Random? random}) {
    this.list = list ?? [];
    this.random = random ?? Random();

    isList = this.list.isNotEmpty;

    if (isList) {
      stepCount = this.list.length;
      this.step = 1;
      this.min = 0;
      this.max = stepCount - 1;
    } else {
      this.min = min ?? 0;
      this.max = max ?? this.min;
      this.step = (step == null) || (step == 0) ? 1 : step;
      stepCount = ((this.max - this.min) / this.step).round() + 1;
    }

    cur = this.min;
    isRandom = (step == 0) && (this.max > this.min);
  }

  /// Set [cur] to the next value
  ///
  void moveNext() {
    if (isRandom) {
      cur = min + random.nextInt(randomMax);
    } else {
      if (cur == max) {
        cur = min;
      }
    }
  }

  /// Set [cur] to its initial value
  ///
  void reset();
}