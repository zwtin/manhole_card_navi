// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_modal_contact_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MapModalContactViewData {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get nameUrl => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MapModalContactViewDataCopyWith<MapModalContactViewData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapModalContactViewDataCopyWith<$Res> {
  factory $MapModalContactViewDataCopyWith(MapModalContactViewData value,
          $Res Function(MapModalContactViewData) then) =
      _$MapModalContactViewDataCopyWithImpl<$Res, MapModalContactViewData>;
  @useResult
  $Res call({String id, String name, String nameUrl});
}

/// @nodoc
class _$MapModalContactViewDataCopyWithImpl<$Res,
        $Val extends MapModalContactViewData>
    implements $MapModalContactViewDataCopyWith<$Res> {
  _$MapModalContactViewDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nameUrl = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nameUrl: null == nameUrl
          ? _value.nameUrl
          : nameUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MapModalContactViewDataCopyWith<$Res>
    implements $MapModalContactViewDataCopyWith<$Res> {
  factory _$$_MapModalContactViewDataCopyWith(_$_MapModalContactViewData value,
          $Res Function(_$_MapModalContactViewData) then) =
      __$$_MapModalContactViewDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String nameUrl});
}

/// @nodoc
class __$$_MapModalContactViewDataCopyWithImpl<$Res>
    extends _$MapModalContactViewDataCopyWithImpl<$Res,
        _$_MapModalContactViewData>
    implements _$$_MapModalContactViewDataCopyWith<$Res> {
  __$$_MapModalContactViewDataCopyWithImpl(_$_MapModalContactViewData _value,
      $Res Function(_$_MapModalContactViewData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nameUrl = null,
  }) {
    return _then(_$_MapModalContactViewData(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nameUrl: null == nameUrl
          ? _value.nameUrl
          : nameUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_MapModalContactViewData extends _MapModalContactViewData {
  const _$_MapModalContactViewData(
      {required this.id, required this.name, required this.nameUrl})
      : super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final String nameUrl;

  @override
  String toString() {
    return 'MapModalContactViewData(id: $id, name: $name, nameUrl: $nameUrl)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MapModalContactViewData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameUrl, nameUrl) || other.nameUrl == nameUrl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, nameUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MapModalContactViewDataCopyWith<_$_MapModalContactViewData>
      get copyWith =>
          __$$_MapModalContactViewDataCopyWithImpl<_$_MapModalContactViewData>(
              this, _$identity);
}

abstract class _MapModalContactViewData extends MapModalContactViewData {
  const factory _MapModalContactViewData(
      {required final String id,
      required final String name,
      required final String nameUrl}) = _$_MapModalContactViewData;
  const _MapModalContactViewData._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  String get nameUrl;
  @override
  @JsonKey(ignore: true)
  _$$_MapModalContactViewDataCopyWith<_$_MapModalContactViewData>
      get copyWith => throw _privateConstructorUsedError;
}
