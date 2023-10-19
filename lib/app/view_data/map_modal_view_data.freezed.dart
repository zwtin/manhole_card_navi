// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_modal_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MapModalViewData {
  String get id => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MapModalViewDataCopyWith<MapModalViewData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapModalViewDataCopyWith<$Res> {
  factory $MapModalViewDataCopyWith(
          MapModalViewData value, $Res Function(MapModalViewData) then) =
      _$MapModalViewDataCopyWithImpl<$Res, MapModalViewData>;
  @useResult
  $Res call({String id});
}

/// @nodoc
class _$MapModalViewDataCopyWithImpl<$Res, $Val extends MapModalViewData>
    implements $MapModalViewDataCopyWith<$Res> {
  _$MapModalViewDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MapModalViewDataCopyWith<$Res>
    implements $MapModalViewDataCopyWith<$Res> {
  factory _$$_MapModalViewDataCopyWith(
          _$_MapModalViewData value, $Res Function(_$_MapModalViewData) then) =
      __$$_MapModalViewDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id});
}

/// @nodoc
class __$$_MapModalViewDataCopyWithImpl<$Res>
    extends _$MapModalViewDataCopyWithImpl<$Res, _$_MapModalViewData>
    implements _$$_MapModalViewDataCopyWith<$Res> {
  __$$_MapModalViewDataCopyWithImpl(
      _$_MapModalViewData _value, $Res Function(_$_MapModalViewData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
  }) {
    return _then(_$_MapModalViewData(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_MapModalViewData extends _MapModalViewData {
  const _$_MapModalViewData({required this.id}) : super._();

  @override
  final String id;

  @override
  String toString() {
    return 'MapModalViewData(id: $id)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MapModalViewData &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MapModalViewDataCopyWith<_$_MapModalViewData> get copyWith =>
      __$$_MapModalViewDataCopyWithImpl<_$_MapModalViewData>(this, _$identity);
}

abstract class _MapModalViewData extends MapModalViewData {
  const factory _MapModalViewData({required final String id}) =
      _$_MapModalViewData;
  const _MapModalViewData._() : super._();

  @override
  String get id;
  @override
  @JsonKey(ignore: true)
  _$$_MapModalViewDataCopyWith<_$_MapModalViewData> get copyWith =>
      throw _privateConstructorUsedError;
}
