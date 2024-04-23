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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

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
abstract class _$$AlertViewDataImplCopyWith<$Res>
    implements $AlertViewDataCopyWith<$Res> {
  factory _$$AlertViewDataImplCopyWith(
          _$AlertViewDataImpl value, $Res Function(_$AlertViewDataImpl) then) =
      __$$AlertViewDataImplCopyWithImpl<$Res>;
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
class __$$AlertViewDataImplCopyWithImpl<$Res>
    extends _$AlertViewDataCopyWithImpl<$Res, _$AlertViewDataImpl>
    implements _$$AlertViewDataImplCopyWith<$Res> {
  __$$AlertViewDataImplCopyWithImpl(
      _$AlertViewDataImpl _value, $Res Function(_$AlertViewDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? message = null,
    Object? okButtonViewData = freezed,
    Object? cancelButtonViewData = freezed,
  }) {
    return _then(_$AlertViewDataImpl(
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

class _$AlertViewDataImpl extends _AlertViewData {
  const _$AlertViewDataImpl(
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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertViewDataImpl &&
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
  _$$AlertViewDataImplCopyWith<_$AlertViewDataImpl> get copyWith =>
      __$$AlertViewDataImplCopyWithImpl<_$AlertViewDataImpl>(this, _$identity);
}

abstract class _AlertViewData extends AlertViewData {
  const factory _AlertViewData(
          {required final String title,
          required final String message,
          required final AlertOKButtonViewData? okButtonViewData,
          required final AlertCancelButtonViewData? cancelButtonViewData}) =
      _$AlertViewDataImpl;
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
  _$$AlertViewDataImplCopyWith<_$AlertViewDataImpl> get copyWith =>
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
abstract class _$$AlertOKButtonViewDataImplCopyWith<$Res>
    implements $AlertOKButtonViewDataCopyWith<$Res> {
  factory _$$AlertOKButtonViewDataImplCopyWith(
          _$AlertOKButtonViewDataImpl value,
          $Res Function(_$AlertOKButtonViewDataImpl) then) =
      __$$AlertOKButtonViewDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, Future<void> Function() action});
}

/// @nodoc
class __$$AlertOKButtonViewDataImplCopyWithImpl<$Res>
    extends _$AlertOKButtonViewDataCopyWithImpl<$Res,
        _$AlertOKButtonViewDataImpl>
    implements _$$AlertOKButtonViewDataImplCopyWith<$Res> {
  __$$AlertOKButtonViewDataImplCopyWithImpl(_$AlertOKButtonViewDataImpl _value,
      $Res Function(_$AlertOKButtonViewDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? action = null,
  }) {
    return _then(_$AlertOKButtonViewDataImpl(
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

class _$AlertOKButtonViewDataImpl extends _AlertOKButtonViewData {
  const _$AlertOKButtonViewDataImpl({required this.title, required this.action})
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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertOKButtonViewDataImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.action, action) || other.action == action));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, action);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertOKButtonViewDataImplCopyWith<_$AlertOKButtonViewDataImpl>
      get copyWith => __$$AlertOKButtonViewDataImplCopyWithImpl<
          _$AlertOKButtonViewDataImpl>(this, _$identity);
}

abstract class _AlertOKButtonViewData extends AlertOKButtonViewData {
  const factory _AlertOKButtonViewData(
          {required final String title,
          required final Future<void> Function() action}) =
      _$AlertOKButtonViewDataImpl;
  const _AlertOKButtonViewData._() : super._();

  @override
  String get title;
  @override
  Future<void> Function() get action;
  @override
  @JsonKey(ignore: true)
  _$$AlertOKButtonViewDataImplCopyWith<_$AlertOKButtonViewDataImpl>
      get copyWith => throw _privateConstructorUsedError;
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
abstract class _$$AlertCancelButtonViewDataImplCopyWith<$Res>
    implements $AlertCancelButtonViewDataCopyWith<$Res> {
  factory _$$AlertCancelButtonViewDataImplCopyWith(
          _$AlertCancelButtonViewDataImpl value,
          $Res Function(_$AlertCancelButtonViewDataImpl) then) =
      __$$AlertCancelButtonViewDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, Future<void> Function() action});
}

/// @nodoc
class __$$AlertCancelButtonViewDataImplCopyWithImpl<$Res>
    extends _$AlertCancelButtonViewDataCopyWithImpl<$Res,
        _$AlertCancelButtonViewDataImpl>
    implements _$$AlertCancelButtonViewDataImplCopyWith<$Res> {
  __$$AlertCancelButtonViewDataImplCopyWithImpl(
      _$AlertCancelButtonViewDataImpl _value,
      $Res Function(_$AlertCancelButtonViewDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? action = null,
  }) {
    return _then(_$AlertCancelButtonViewDataImpl(
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

class _$AlertCancelButtonViewDataImpl extends _AlertCancelButtonViewData {
  const _$AlertCancelButtonViewDataImpl(
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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertCancelButtonViewDataImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.action, action) || other.action == action));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, action);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertCancelButtonViewDataImplCopyWith<_$AlertCancelButtonViewDataImpl>
      get copyWith => __$$AlertCancelButtonViewDataImplCopyWithImpl<
          _$AlertCancelButtonViewDataImpl>(this, _$identity);
}

abstract class _AlertCancelButtonViewData extends AlertCancelButtonViewData {
  const factory _AlertCancelButtonViewData(
          {required final String title,
          required final Future<void> Function() action}) =
      _$AlertCancelButtonViewDataImpl;
  const _AlertCancelButtonViewData._() : super._();

  @override
  String get title;
  @override
  Future<void> Function() get action;
  @override
  @JsonKey(ignore: true)
  _$$AlertCancelButtonViewDataImplCopyWith<_$AlertCancelButtonViewDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
