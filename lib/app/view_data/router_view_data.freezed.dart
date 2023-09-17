// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'router_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RouterViewData {
  TransitionType get type => throw _privateConstructorUsedError;
  Widget? get nextWidget => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RouterViewDataCopyWith<RouterViewData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RouterViewDataCopyWith<$Res> {
  factory $RouterViewDataCopyWith(
          RouterViewData value, $Res Function(RouterViewData) then) =
      _$RouterViewDataCopyWithImpl<$Res, RouterViewData>;
  @useResult
  $Res call({TransitionType type, Widget? nextWidget});
}

/// @nodoc
class _$RouterViewDataCopyWithImpl<$Res, $Val extends RouterViewData>
    implements $RouterViewDataCopyWith<$Res> {
  _$RouterViewDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? nextWidget = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransitionType,
      nextWidget: freezed == nextWidget
          ? _value.nextWidget
          : nextWidget // ignore: cast_nullable_to_non_nullable
              as Widget?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_RouterViewDataCopyWith<$Res>
    implements $RouterViewDataCopyWith<$Res> {
  factory _$$_RouterViewDataCopyWith(
          _$_RouterViewData value, $Res Function(_$_RouterViewData) then) =
      __$$_RouterViewDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({TransitionType type, Widget? nextWidget});
}

/// @nodoc
class __$$_RouterViewDataCopyWithImpl<$Res>
    extends _$RouterViewDataCopyWithImpl<$Res, _$_RouterViewData>
    implements _$$_RouterViewDataCopyWith<$Res> {
  __$$_RouterViewDataCopyWithImpl(
      _$_RouterViewData _value, $Res Function(_$_RouterViewData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? nextWidget = freezed,
  }) {
    return _then(_$_RouterViewData(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransitionType,
      nextWidget: freezed == nextWidget
          ? _value.nextWidget
          : nextWidget // ignore: cast_nullable_to_non_nullable
              as Widget?,
    ));
  }
}

/// @nodoc

class _$_RouterViewData extends _RouterViewData {
  const _$_RouterViewData({required this.type, this.nextWidget}) : super._();

  @override
  final TransitionType type;
  @override
  final Widget? nextWidget;

  @override
  String toString() {
    return 'RouterViewData(type: $type, nextWidget: $nextWidget)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RouterViewData &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.nextWidget, nextWidget) ||
                other.nextWidget == nextWidget));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type, nextWidget);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RouterViewDataCopyWith<_$_RouterViewData> get copyWith =>
      __$$_RouterViewDataCopyWithImpl<_$_RouterViewData>(this, _$identity);
}

abstract class _RouterViewData extends RouterViewData {
  const factory _RouterViewData(
      {required final TransitionType type,
      final Widget? nextWidget}) = _$_RouterViewData;
  const _RouterViewData._() : super._();

  @override
  TransitionType get type;
  @override
  Widget? get nextWidget;
  @override
  @JsonKey(ignore: true)
  _$$_RouterViewDataCopyWith<_$_RouterViewData> get copyWith =>
      throw _privateConstructorUsedError;
}
