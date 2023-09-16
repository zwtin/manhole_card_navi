// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alert_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AlertViewData {
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  AlertOKButtonViewData? get okButtonViewData =>
      throw _privateConstructorUsedError;
  AlertCancelButtonViewData? get cancelButtonViewData =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AlertViewDataCopyWith<AlertViewData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertViewDataCopyWith<$Res> {
  factory $AlertViewDataCopyWith(
          AlertViewData value, $Res Function(AlertViewData) then) =
      _$AlertViewDataCopyWithImpl<$Res, AlertViewData>;
  @useResult
  $Res call(
      {String title,
      String message,
      AlertOKButtonViewData? okButtonViewData,
      AlertCancelButtonViewData? cancelButtonViewData});

  $AlertOKButtonViewDataCopyWith<$Res>? get okButtonViewData;
  $AlertCancelButtonViewDataCopyWith<$Res>? get cancelButtonViewData;
}

/// @nodoc
class _$AlertViewDataCopyWithImpl<$Res, $Val extends AlertViewData>
    implements $AlertViewDataCopyWith<$Res> {
  _$AlertViewDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? message = null,
    Object? okButtonViewData = freezed,
    Object? cancelButtonViewData = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      okButtonViewData: freezed == okButtonViewData
          ? _value.okButtonViewData
          : okButtonViewData // ignore: cast_nullable_to_non_nullable
              as AlertOKButtonViewData?,
      cancelButtonViewData: freezed == cancelButtonViewData
          ? _value.cancelButtonViewData
          : cancelButtonViewData // ignore: cast_nullable_to_non_nullable
              as AlertCancelButtonViewData?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AlertOKButtonViewDataCopyWith<$Res>? get okButtonViewData {
    if (_value.okButtonViewData == null) {
      return null;
    }

    return $AlertOKButtonViewDataCopyWith<$Res>(_value.okButtonViewData!,
        (value) {
      return _then(_value.copyWith(okButtonViewData: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AlertCancelButtonViewDataCopyWith<$Res>? get cancelButtonViewData {
    if (_value.cancelButtonViewData == null) {
      return null;
    }

    return $AlertCancelButtonViewDataCopyWith<$Res>(
        _value.cancelButtonViewData!, (value) {
      return _then(_value.copyWith(cancelButtonViewData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_AlertViewDataCopyWith<$Res>
    implements $AlertViewDataCopyWith<$Res> {
  factory _$$_AlertViewDataCopyWith(
          _$_AlertViewData value, $Res Function(_$_AlertViewData) then) =
      __$$_AlertViewDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String message,
      AlertOKButtonViewData? okButtonViewData,
      AlertCancelButtonViewData? cancelButtonViewData});

  @override
  $AlertOKButtonViewDataCopyWith<$Res>? get okButtonViewData;
  @override
  $AlertCancelButtonViewDataCopyWith<$Res>? get cancelButtonViewData;
}

/// @nodoc
class __$$_AlertViewDataCopyWithImpl<$Res>
    extends _$AlertViewDataCopyWithImpl<$Res, _$_AlertViewData>
    implements _$$_AlertViewDataCopyWith<$Res> {
  __$$_AlertViewDataCopyWithImpl(
      _$_AlertViewData _value, $Res Function(_$_AlertViewData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? message = null,
    Object? okButtonViewData = freezed,
    Object? cancelButtonViewData = freezed,
  }) {
    return _then(_$_AlertViewData(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      okButtonViewData: freezed == okButtonViewData
          ? _value.okButtonViewData
          : okButtonViewData // ignore: cast_nullable_to_non_nullable
              as AlertOKButtonViewData?,
      cancelButtonViewData: freezed == cancelButtonViewData
          ? _value.cancelButtonViewData
          : cancelButtonViewData // ignore: cast_nullable_to_non_nullable
              as AlertCancelButtonViewData?,
    ));
  }
}

/// @nodoc

class _$_AlertViewData extends _AlertViewData {
  const _$_AlertViewData(
      {required this.title,
      required this.message,
      required this.okButtonViewData,
      required this.cancelButtonViewData})
      : super._();

  @override
  final String title;
  @override
  final String message;
  @override
  final AlertOKButtonViewData? okButtonViewData;
  @override
  final AlertCancelButtonViewData? cancelButtonViewData;

  @override
  String toString() {
    return 'AlertViewData(title: $title, message: $message, okButtonViewData: $okButtonViewData, cancelButtonViewData: $cancelButtonViewData)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AlertViewData &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.okButtonViewData, okButtonViewData) ||
                other.okButtonViewData == okButtonViewData) &&
            (identical(other.cancelButtonViewData, cancelButtonViewData) ||
                other.cancelButtonViewData == cancelButtonViewData));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, title, message, okButtonViewData, cancelButtonViewData);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AlertViewDataCopyWith<_$_AlertViewData> get copyWith =>
      __$$_AlertViewDataCopyWithImpl<_$_AlertViewData>(this, _$identity);
}

abstract class _AlertViewData extends AlertViewData {
  const factory _AlertViewData(
          {required final String title,
          required final String message,
          required final AlertOKButtonViewData? okButtonViewData,
          required final AlertCancelButtonViewData? cancelButtonViewData}) =
      _$_AlertViewData;
  const _AlertViewData._() : super._();

  @override
  String get title;
  @override
  String get message;
  @override
  AlertOKButtonViewData? get okButtonViewData;
  @override
  AlertCancelButtonViewData? get cancelButtonViewData;
  @override
  @JsonKey(ignore: true)
  _$$_AlertViewDataCopyWith<_$_AlertViewData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AlertOKButtonViewData {
  String get title => throw _privateConstructorUsedError;
  Future<void> Function() get action => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AlertOKButtonViewDataCopyWith<AlertOKButtonViewData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertOKButtonViewDataCopyWith<$Res> {
  factory $AlertOKButtonViewDataCopyWith(AlertOKButtonViewData value,
          $Res Function(AlertOKButtonViewData) then) =
      _$AlertOKButtonViewDataCopyWithImpl<$Res, AlertOKButtonViewData>;
  @useResult
  $Res call({String title, Future<void> Function() action});
}

/// @nodoc
class _$AlertOKButtonViewDataCopyWithImpl<$Res,
        $Val extends AlertOKButtonViewData>
    implements $AlertOKButtonViewDataCopyWith<$Res> {
  _$AlertOKButtonViewDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? action = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as Future<void> Function(),
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AlertOKButtonViewDataCopyWith<$Res>
    implements $AlertOKButtonViewDataCopyWith<$Res> {
  factory _$$_AlertOKButtonViewDataCopyWith(_$_AlertOKButtonViewData value,
          $Res Function(_$_AlertOKButtonViewData) then) =
      __$$_AlertOKButtonViewDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, Future<void> Function() action});
}

/// @nodoc
class __$$_AlertOKButtonViewDataCopyWithImpl<$Res>
    extends _$AlertOKButtonViewDataCopyWithImpl<$Res, _$_AlertOKButtonViewData>
    implements _$$_AlertOKButtonViewDataCopyWith<$Res> {
  __$$_AlertOKButtonViewDataCopyWithImpl(_$_AlertOKButtonViewData _value,
      $Res Function(_$_AlertOKButtonViewData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? action = null,
  }) {
    return _then(_$_AlertOKButtonViewData(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as Future<void> Function(),
    ));
  }
}

/// @nodoc

class _$_AlertOKButtonViewData extends _AlertOKButtonViewData {
  const _$_AlertOKButtonViewData({required this.title, required this.action})
      : super._();

  @override
  final String title;
  @override
  final Future<void> Function() action;

  @override
  String toString() {
    return 'AlertOKButtonViewData(title: $title, action: $action)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AlertOKButtonViewData &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.action, action) || other.action == action));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, action);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AlertOKButtonViewDataCopyWith<_$_AlertOKButtonViewData> get copyWith =>
      __$$_AlertOKButtonViewDataCopyWithImpl<_$_AlertOKButtonViewData>(
          this, _$identity);
}

abstract class _AlertOKButtonViewData extends AlertOKButtonViewData {
  const factory _AlertOKButtonViewData(
          {required final String title,
          required final Future<void> Function() action}) =
      _$_AlertOKButtonViewData;
  const _AlertOKButtonViewData._() : super._();

  @override
  String get title;
  @override
  Future<void> Function() get action;
  @override
  @JsonKey(ignore: true)
  _$$_AlertOKButtonViewDataCopyWith<_$_AlertOKButtonViewData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AlertCancelButtonViewData {
  String get title => throw _privateConstructorUsedError;
  Future<void> Function() get action => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AlertCancelButtonViewDataCopyWith<AlertCancelButtonViewData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertCancelButtonViewDataCopyWith<$Res> {
  factory $AlertCancelButtonViewDataCopyWith(AlertCancelButtonViewData value,
          $Res Function(AlertCancelButtonViewData) then) =
      _$AlertCancelButtonViewDataCopyWithImpl<$Res, AlertCancelButtonViewData>;
  @useResult
  $Res call({String title, Future<void> Function() action});
}

/// @nodoc
class _$AlertCancelButtonViewDataCopyWithImpl<$Res,
        $Val extends AlertCancelButtonViewData>
    implements $AlertCancelButtonViewDataCopyWith<$Res> {
  _$AlertCancelButtonViewDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? action = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as Future<void> Function(),
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AlertCancelButtonViewDataCopyWith<$Res>
    implements $AlertCancelButtonViewDataCopyWith<$Res> {
  factory _$$_AlertCancelButtonViewDataCopyWith(
          _$_AlertCancelButtonViewData value,
          $Res Function(_$_AlertCancelButtonViewData) then) =
      __$$_AlertCancelButtonViewDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, Future<void> Function() action});
}

/// @nodoc
class __$$_AlertCancelButtonViewDataCopyWithImpl<$Res>
    extends _$AlertCancelButtonViewDataCopyWithImpl<$Res,
        _$_AlertCancelButtonViewData>
    implements _$$_AlertCancelButtonViewDataCopyWith<$Res> {
  __$$_AlertCancelButtonViewDataCopyWithImpl(
      _$_AlertCancelButtonViewData _value,
      $Res Function(_$_AlertCancelButtonViewData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? action = null,
  }) {
    return _then(_$_AlertCancelButtonViewData(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as Future<void> Function(),
    ));
  }
}

/// @nodoc

class _$_AlertCancelButtonViewData extends _AlertCancelButtonViewData {
  const _$_AlertCancelButtonViewData(
      {required this.title, required this.action})
      : super._();

  @override
  final String title;
  @override
  final Future<void> Function() action;

  @override
  String toString() {
    return 'AlertCancelButtonViewData(title: $title, action: $action)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AlertCancelButtonViewData &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.action, action) || other.action == action));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, action);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AlertCancelButtonViewDataCopyWith<_$_AlertCancelButtonViewData>
      get copyWith => __$$_AlertCancelButtonViewDataCopyWithImpl<
          _$_AlertCancelButtonViewData>(this, _$identity);
}

abstract class _AlertCancelButtonViewData extends AlertCancelButtonViewData {
  const factory _AlertCancelButtonViewData(
          {required final String title,
          required final Future<void> Function() action}) =
      _$_AlertCancelButtonViewData;
  const _AlertCancelButtonViewData._() : super._();

  @override
  String get title;
  @override
  Future<void> Function() get action;
  @override
  @JsonKey(ignore: true)
  _$$_AlertCancelButtonViewDataCopyWith<_$_AlertCancelButtonViewData>
      get copyWith => throw _privateConstructorUsedError;
}
