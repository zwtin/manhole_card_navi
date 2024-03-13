// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'modal_contact_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ModalContactViewData {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get nameUrl => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ModalContactViewDataCopyWith<ModalContactViewData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModalContactViewDataCopyWith<$Res> {
  factory $ModalContactViewDataCopyWith(ModalContactViewData value,
          $Res Function(ModalContactViewData) then) =
      _$ModalContactViewDataCopyWithImpl<$Res, ModalContactViewData>;
  @useResult
  $Res call({String id, String name, String nameUrl});
}

/// @nodoc
class _$ModalContactViewDataCopyWithImpl<$Res,
        $Val extends ModalContactViewData>
    implements $ModalContactViewDataCopyWith<$Res> {
  _$ModalContactViewDataCopyWithImpl(this._value, this._then);

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
abstract class _$$_ModalContactViewDataCopyWith<$Res>
    implements $ModalContactViewDataCopyWith<$Res> {
  factory _$$_ModalContactViewDataCopyWith(_$_ModalContactViewData value,
          $Res Function(_$_ModalContactViewData) then) =
      __$$_ModalContactViewDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String nameUrl});
}

/// @nodoc
class __$$_ModalContactViewDataCopyWithImpl<$Res>
    extends _$ModalContactViewDataCopyWithImpl<$Res, _$_ModalContactViewData>
    implements _$$_ModalContactViewDataCopyWith<$Res> {
  __$$_ModalContactViewDataCopyWithImpl(_$_ModalContactViewData _value,
      $Res Function(_$_ModalContactViewData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nameUrl = null,
  }) {
    return _then(_$_ModalContactViewData(
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

class _$_ModalContactViewData extends _ModalContactViewData {
  const _$_ModalContactViewData(
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
    return 'ModalContactViewData(id: $id, name: $name, nameUrl: $nameUrl)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ModalContactViewData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameUrl, nameUrl) || other.nameUrl == nameUrl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, nameUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ModalContactViewDataCopyWith<_$_ModalContactViewData> get copyWith =>
      __$$_ModalContactViewDataCopyWithImpl<_$_ModalContactViewData>(
          this, _$identity);
}

abstract class _ModalContactViewData extends ModalContactViewData {
  const factory _ModalContactViewData(
      {required final String id,
      required final String name,
      required final String nameUrl}) = _$_ModalContactViewData;
  const _ModalContactViewData._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  String get nameUrl;
  @override
  @JsonKey(ignore: true)
  _$$_ModalContactViewDataCopyWith<_$_ModalContactViewData> get copyWith =>
      throw _privateConstructorUsedError;
}
