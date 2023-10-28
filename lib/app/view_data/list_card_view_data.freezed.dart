// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_card_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ListCardViewData {
  String get id => throw _privateConstructorUsedError;
  Uint8List get icon => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ListCardViewDataCopyWith<ListCardViewData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListCardViewDataCopyWith<$Res> {
  factory $ListCardViewDataCopyWith(
          ListCardViewData value, $Res Function(ListCardViewData) then) =
      _$ListCardViewDataCopyWithImpl<$Res, ListCardViewData>;
  @useResult
  $Res call({String id, Uint8List icon});
}

/// @nodoc
class _$ListCardViewDataCopyWithImpl<$Res, $Val extends ListCardViewData>
    implements $ListCardViewDataCopyWith<$Res> {
  _$ListCardViewDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? icon = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as Uint8List,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ListCardViewDataCopyWith<$Res>
    implements $ListCardViewDataCopyWith<$Res> {
  factory _$$_ListCardViewDataCopyWith(
          _$_ListCardViewData value, $Res Function(_$_ListCardViewData) then) =
      __$$_ListCardViewDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, Uint8List icon});
}

/// @nodoc
class __$$_ListCardViewDataCopyWithImpl<$Res>
    extends _$ListCardViewDataCopyWithImpl<$Res, _$_ListCardViewData>
    implements _$$_ListCardViewDataCopyWith<$Res> {
  __$$_ListCardViewDataCopyWithImpl(
      _$_ListCardViewData _value, $Res Function(_$_ListCardViewData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? icon = null,
  }) {
    return _then(_$_ListCardViewData(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as Uint8List,
    ));
  }
}

/// @nodoc

class _$_ListCardViewData extends _ListCardViewData {
  const _$_ListCardViewData({required this.id, required this.icon}) : super._();

  @override
  final String id;
  @override
  final Uint8List icon;

  @override
  String toString() {
    return 'ListCardViewData(id: $id, icon: $icon)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ListCardViewData &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other.icon, icon));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, const DeepCollectionEquality().hash(icon));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ListCardViewDataCopyWith<_$_ListCardViewData> get copyWith =>
      __$$_ListCardViewDataCopyWithImpl<_$_ListCardViewData>(this, _$identity);
}

abstract class _ListCardViewData extends ListCardViewData {
  const factory _ListCardViewData(
      {required final String id,
      required final Uint8List icon}) = _$_ListCardViewData;
  const _ListCardViewData._() : super._();

  @override
  String get id;
  @override
  Uint8List get icon;
  @override
  @JsonKey(ignore: true)
  _$$_ListCardViewDataCopyWith<_$_ListCardViewData> get copyWith =>
      throw _privateConstructorUsedError;
}
