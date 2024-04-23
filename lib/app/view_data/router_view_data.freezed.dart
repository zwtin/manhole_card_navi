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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RouterViewData {
  TransitionType get type => throw _privateConstructorUsedError;
  CommonWidget? get nextWidget => throw _privateConstructorUsedError;

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
  $Res call({TransitionType type, CommonWidget? nextWidget});
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
              as CommonWidget?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RouterViewDataImplCopyWith<$Res>
    implements $RouterViewDataCopyWith<$Res> {
  factory _$$RouterViewDataImplCopyWith(_$RouterViewDataImpl value,
          $Res Function(_$RouterViewDataImpl) then) =
      __$$RouterViewDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({TransitionType type, CommonWidget? nextWidget});
}

/// @nodoc
class __$$RouterViewDataImplCopyWithImpl<$Res>
    extends _$RouterViewDataCopyWithImpl<$Res, _$RouterViewDataImpl>
    implements _$$RouterViewDataImplCopyWith<$Res> {
  __$$RouterViewDataImplCopyWithImpl(
      _$RouterViewDataImpl _value, $Res Function(_$RouterViewDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? nextWidget = freezed,
  }) {
    return _then(_$RouterViewDataImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransitionType,
      nextWidget: freezed == nextWidget
          ? _value.nextWidget
          : nextWidget // ignore: cast_nullable_to_non_nullable
              as CommonWidget?,
    ));
  }
}

/// @nodoc

class _$RouterViewDataImpl extends _RouterViewData {
  const _$RouterViewDataImpl({required this.type, this.nextWidget}) : super._();

  @override
  final TransitionType type;
  @override
  final CommonWidget? nextWidget;

  @override
  String toString() {
    return 'RouterViewData(type: $type, nextWidget: $nextWidget)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RouterViewDataImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.nextWidget, nextWidget) ||
                other.nextWidget == nextWidget));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type, nextWidget);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RouterViewDataImplCopyWith<_$RouterViewDataImpl> get copyWith =>
      __$$RouterViewDataImplCopyWithImpl<_$RouterViewDataImpl>(
          this, _$identity);
}

abstract class _RouterViewData extends RouterViewData {
  const factory _RouterViewData(
      {required final TransitionType type,
      final CommonWidget? nextWidget}) = _$RouterViewDataImpl;
  const _RouterViewData._() : super._();

  @override
  TransitionType get type;
  @override
  CommonWidget? get nextWidget;
  @override
  @JsonKey(ignore: true)
  _$$RouterViewDataImplCopyWith<_$RouterViewDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
