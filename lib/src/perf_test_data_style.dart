// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

/// The output style for data (names, values and ratios)
///
class PerfTestDataStyle {
  /// Style: print percentage as percentage rather than a number
  ///
  static const int percent = (1 << 0);

  /// Convenience flag for [percent]
  ///
  bool get isPercent => ((_flags & percent) != 0);

  /// Style: print data without using formatters
  ///
  static const int raw = (1 << 1);

  /// Convenience flag for [raw]
  ///
  bool get isRaw => ((_flags & raw) != 0);

  /// Convenience style combining [raw] and [percent]
  ///
  static const int rawWithPercent = (raw | percent);

  /// Style: print values and ratios in separate blocks
  ///
  static const int split = (1 << 2);

  /// Convenience flag for [split]
  ///
  bool get isSplit => ((_flags & split) != 0);

  /// Style: print values before ratios
  ///
  static const int valueFirst = (1 << 3);

  /// Convenience flag for [valueFirst]
  ///
  bool get isValueFirst => ((_flags & valueFirst) != 0);

  /// Bitwise combination of style* constants
  ///
  int get flags => _flags;
  final int _flags;

  /// The constructor
  ///
  PerfTestDataStyle([this._flags = 0]);
}
