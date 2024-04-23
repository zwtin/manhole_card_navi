// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manhole_card_volumes.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ManholeCardVolumes {
  List<ManholeCardVolume> get list => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ManholeCardVolumesCopyWith<ManholeCardVolumes> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManholeCardVolumesCopyWith<$Res> {
  factory $ManholeCardVolumesCopyWith(
          ManholeCardVolumes value, $Res Function(ManholeCardVolumes) then) =
      _$ManholeCardVolumesCopyWithImpl<$Res, ManholeCardVolumes>;
  @useResult
  $Res call({List<ManholeCardVolume> list});
}

/// @nodoc
class _$ManholeCardVolumesCopyWithImpl<$Res, $Val extends ManholeCardVolumes>
    implements $ManholeCardVolumesCopyWith<$Res> {
  _$ManholeCardVolumesCopyWithImpl(this._value, this._then);

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
              as List<ManholeCardVolume>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ManholeCardVolumesImplCopyWith<$Res>
    implements $ManholeCardVolumesCopyWith<$Res> {
  factory _$$ManholeCardVolumesImplCopyWith(_$ManholeCardVolumesImpl value,
          $Res Function(_$ManholeCardVolumesImpl) then) =
      __$$ManholeCardVolumesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ManholeCardVolume> list});
}

/// @nodoc
class __$$ManholeCardVolumesImplCopyWithImpl<$Res>
    extends _$ManholeCardVolumesCopyWithImpl<$Res, _$ManholeCardVolumesImpl>
    implements _$$ManholeCardVolumesImplCopyWith<$Res> {
  __$$ManholeCardVolumesImplCopyWithImpl(_$ManholeCardVolumesImpl _value,
      $Res Function(_$ManholeCardVolumesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
  }) {
    return _then(_$ManholeCardVolumesImpl(
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<ManholeCardVolume>,
    ));
  }
}

/// @nodoc

class _$ManholeCardVolumesImpl extends _ManholeCardVolumes {
  const _$ManholeCardVolumesImpl({required final List<ManholeCardVolume> list})
      : _list = list,
        super._();

  final List<ManholeCardVolume> _list;
  @override
  List<ManholeCardVolume> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  String toString() {
    return 'ManholeCardVolumes(list: $list)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManholeCardVolumesImpl &&
            const DeepCollectionEquality().equals(other._list, _list));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_list));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ManholeCardVolumesImplCopyWith<_$ManholeCardVolumesImpl> get copyWith =>
      __$$ManholeCardVolumesImplCopyWithImpl<_$ManholeCardVolumesImpl>(
          this, _$identity);
}

abstract class _ManholeCardVolumes extends ManholeCardVolumes {
  const factory _ManholeCardVolumes(
      {required final List<ManholeCardVolume> list}) = _$ManholeCardVolumesImpl;
  const _ManholeCardVolumes._() : super._();

  @override
  List<ManholeCardVolume> get list;
  @override
  @JsonKey(ignore: true)
  _$$ManholeCardVolumesImplCopyWith<_$ManholeCardVolumesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
