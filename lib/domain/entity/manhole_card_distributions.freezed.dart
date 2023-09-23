// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manhole_card_distributions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ManholeCardDistributions {
  List<ManholeCardDistribution> get list => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ManholeCardDistributionsCopyWith<ManholeCardDistributions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManholeCardDistributionsCopyWith<$Res> {
  factory $ManholeCardDistributionsCopyWith(ManholeCardDistributions value,
          $Res Function(ManholeCardDistributions) then) =
      _$ManholeCardDistributionsCopyWithImpl<$Res, ManholeCardDistributions>;
  @useResult
  $Res call({List<ManholeCardDistribution> list});
}

/// @nodoc
class _$ManholeCardDistributionsCopyWithImpl<$Res,
        $Val extends ManholeCardDistributions>
    implements $ManholeCardDistributionsCopyWith<$Res> {
  _$ManholeCardDistributionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
  }) {
    return _then(_value.copyWith(
      list: null == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<ManholeCardDistribution>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ManholeCardDistributionsCopyWith<$Res>
    implements $ManholeCardDistributionsCopyWith<$Res> {
  factory _$$_ManholeCardDistributionsCopyWith(
          _$_ManholeCardDistributions value,
          $Res Function(_$_ManholeCardDistributions) then) =
      __$$_ManholeCardDistributionsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ManholeCardDistribution> list});
}

/// @nodoc
class __$$_ManholeCardDistributionsCopyWithImpl<$Res>
    extends _$ManholeCardDistributionsCopyWithImpl<$Res,
        _$_ManholeCardDistributions>
    implements _$$_ManholeCardDistributionsCopyWith<$Res> {
  __$$_ManholeCardDistributionsCopyWithImpl(_$_ManholeCardDistributions _value,
      $Res Function(_$_ManholeCardDistributions) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
  }) {
    return _then(_$_ManholeCardDistributions(
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<ManholeCardDistribution>,
    ));
  }
}

/// @nodoc

class _$_ManholeCardDistributions extends _ManholeCardDistributions {
  const _$_ManholeCardDistributions(
      {required final List<ManholeCardDistribution> list})
      : _list = list,
        super._();

  final List<ManholeCardDistribution> _list;
  @override
  List<ManholeCardDistribution> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ManholeCardDistributions &&
            const DeepCollectionEquality().equals(other._list, _list));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_list));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ManholeCardDistributionsCopyWith<_$_ManholeCardDistributions>
      get copyWith => __$$_ManholeCardDistributionsCopyWithImpl<
          _$_ManholeCardDistributions>(this, _$identity);
}

abstract class _ManholeCardDistributions extends ManholeCardDistributions {
  const factory _ManholeCardDistributions(
          {required final List<ManholeCardDistribution> list}) =
      _$_ManholeCardDistributions;
  const _ManholeCardDistributions._() : super._();

  @override
  List<ManholeCardDistribution> get list;
  @override
  @JsonKey(ignore: true)
  _$$_ManholeCardDistributionsCopyWith<_$_ManholeCardDistributions>
      get copyWith => throw _privateConstructorUsedError;
}
