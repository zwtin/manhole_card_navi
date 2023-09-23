// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manhole_card_distribution.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ManholeCardDistribution {
  String get id => throw _privateConstructorUsedError;
  String get other => throw _privateConstructorUsedError;
  ManholeCardDistributionState get state => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ManholeCardDistributionCopyWith<ManholeCardDistribution> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManholeCardDistributionCopyWith<$Res> {
  factory $ManholeCardDistributionCopyWith(ManholeCardDistribution value,
          $Res Function(ManholeCardDistribution) then) =
      _$ManholeCardDistributionCopyWithImpl<$Res, ManholeCardDistribution>;
  @useResult
  $Res call({String id, String other, ManholeCardDistributionState state});
}

/// @nodoc
class _$ManholeCardDistributionCopyWithImpl<$Res,
        $Val extends ManholeCardDistribution>
    implements $ManholeCardDistributionCopyWith<$Res> {
  _$ManholeCardDistributionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? other = null,
    Object? state = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      other: null == other
          ? _value.other
          : other // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as ManholeCardDistributionState,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ManholeCardDistributionCopyWith<$Res>
    implements $ManholeCardDistributionCopyWith<$Res> {
  factory _$$_ManholeCardDistributionCopyWith(_$_ManholeCardDistribution value,
          $Res Function(_$_ManholeCardDistribution) then) =
      __$$_ManholeCardDistributionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String other, ManholeCardDistributionState state});
}

/// @nodoc
class __$$_ManholeCardDistributionCopyWithImpl<$Res>
    extends _$ManholeCardDistributionCopyWithImpl<$Res,
        _$_ManholeCardDistribution>
    implements _$$_ManholeCardDistributionCopyWith<$Res> {
  __$$_ManholeCardDistributionCopyWithImpl(_$_ManholeCardDistribution _value,
      $Res Function(_$_ManholeCardDistribution) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? other = null,
    Object? state = null,
  }) {
    return _then(_$_ManholeCardDistribution(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      other: null == other
          ? _value.other
          : other // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as ManholeCardDistributionState,
    ));
  }
}

/// @nodoc

class _$_ManholeCardDistribution extends _ManholeCardDistribution {
  const _$_ManholeCardDistribution(
      {required this.id, required this.other, required this.state})
      : super._();

  @override
  final String id;
  @override
  final String other;
  @override
  final ManholeCardDistributionState state;

  @override
  String toString() {
    return 'ManholeCardDistribution(id: $id, other: $other, state: $state)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ManholeCardDistribution &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.other, this.other) || other.other == this.other) &&
            (identical(other.state, state) || other.state == state));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, other, state);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ManholeCardDistributionCopyWith<_$_ManholeCardDistribution>
      get copyWith =>
          __$$_ManholeCardDistributionCopyWithImpl<_$_ManholeCardDistribution>(
              this, _$identity);
}

abstract class _ManholeCardDistribution extends ManholeCardDistribution {
  const factory _ManholeCardDistribution(
          {required final String id,
          required final String other,
          required final ManholeCardDistributionState state}) =
      _$_ManholeCardDistribution;
  const _ManholeCardDistribution._() : super._();

  @override
  String get id;
  @override
  String get other;
  @override
  ManholeCardDistributionState get state;
  @override
  @JsonKey(ignore: true)
  _$$_ManholeCardDistributionCopyWith<_$_ManholeCardDistribution>
      get copyWith => throw _privateConstructorUsedError;
}
