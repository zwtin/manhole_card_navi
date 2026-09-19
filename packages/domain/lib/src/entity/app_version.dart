import 'dart:math';

/// アプリのバージョン（例: `1.5.0`）。
///
/// ドットで区切った数字を、前の桁から順に数として比べる。前の桁で差がつけば、
/// 後ろの桁は見ない。桁数が違うときは、足りない桁を 0 とみなす（`1.5` と
/// `1.5.0` は同じ）。
final class AppVersion implements Comparable<AppVersion> {
  AppVersion._(this.value, this._numbers);

  /// ドットで区切った数字（`1.5.0` など）から作る。その形でなければ
  /// [FormatException] を投げる。
  factory AppVersion.parse(String value) {
    final version = tryParse(value);
    if (version == null) {
      throw FormatException('アプリのバージョンの形ではありません', value);
    }
    return version;
  }

  /// ドットで区切った数字（`1.5.0` など）から作る。その形でなければ null。
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

  /// 元の文字列。画面に出すときに使う。
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

  /// [compareTo] と合わせ、`1.5` と `1.5.0` を等しいとする。
  @override
  bool operator ==(Object other) =>
      other is AppVersion && compareTo(other) == 0;

  @override
  int get hashCode {
    // 末尾の 0 を除いた桁で作り、等しいバージョンが同じ値になるようにする。
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
