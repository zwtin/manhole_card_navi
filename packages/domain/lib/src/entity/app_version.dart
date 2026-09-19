import 'dart:math';

final class AppVersion implements Comparable<AppVersion> {
  AppVersion._(this.value, this._numbers);

  factory AppVersion.parse(String value) {
    final version = tryParse(value);
    if (version == null) {
      throw FormatException('アプリのバージョンの形ではありません', value);
    }
    return version;
  }

  static AppVersion? tryParse(String value) {
    if (!_format.hasMatch(value)) {
      return null;
    }
    final numbers = <int>[];
    for (final part in value.split('.')) {
      // 数字だけでも、桁が多すぎて int に収まらなければ読めない。
      final number = int.tryParse(part);
      if (number == null) {
        return null;
      }
      numbers.add(number);
    }
    return AppVersion._(value, List.unmodifiable(numbers));
  }

  static final _format = RegExp(r'^\d+(\.\d+)*$');

  final String value;

  final List<int> _numbers;

  @override
  int compareTo(AppVersion other) {
    final length = max(_numbers.length, other._numbers.length);
    for (var index = 0; index < length; index++) {
      final difference = _numberAt(index).compareTo(other._numberAt(index));
      if (difference != 0) {
        return difference;
      }
    }
    return 0;
  }

  bool operator <(AppVersion other) => compareTo(other) < 0;

  bool operator <=(AppVersion other) => compareTo(other) <= 0;

  bool operator >(AppVersion other) => compareTo(other) > 0;

  bool operator >=(AppVersion other) => compareTo(other) >= 0;

  @override
  bool operator ==(Object other) =>
      other is AppVersion && compareTo(other) == 0;

  @override
  int get hashCode {
    // == は足りない桁を 0 とみなす（`1.5` と `1.5.0` が等しい）ので、末尾の 0 を
    // 除いた桁で作り、等しいバージョンが同じ値になるようにする。
    var length = _numbers.length;
    while (length > 0 && _numbers[length - 1] == 0) {
      length--;
    }
    return Object.hashAll(_numbers.take(length));
  }

  @override
  String toString() => value;

  int _numberAt(int index) => index < _numbers.length ? _numbers[index] : 0;
}
