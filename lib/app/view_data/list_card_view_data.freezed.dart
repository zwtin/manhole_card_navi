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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ListCardViewData {
  String get id => throw _privateConstructorUsedError;
  Uint8List get icon => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get volume => throw _privateConstructorUsedError;
  String get publicationDate => throw _privateConstructorUsedError;
  bool get isHidden => throw _privateConstructorUsedError;

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
  $Res call(
      {String id,
      Uint8List icon,
      String name,
      String volume,
      String publicationDate,
      bool isHidden});
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
    Object? name = null,
    Object? volume = null,
    Object? publicationDate = null,
    Object? isHidden = null,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as String,
      publicationDate: null == publicationDate
          ? _value.publicationDate
          : publicationDate // ignore: cast_nullable_to_non_nullable
              as String,
      isHidden: null == isHidden
          ? _value.isHidden
          : isHidden // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ListCardViewDataImplCopyWith<$Res>
    implements $ListCardViewDataCopyWith<$Res> {
  factory _$$ListCardViewDataImplCopyWith(_$ListCardViewDataImpl value,
          $Res Function(_$ListCardViewDataImpl) then) =
      __$$ListCardViewDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      Uint8List icon,
      String name,
      String volume,
      String publicationDate,
      bool isHidden});
}

/// @nodoc
class __$$ListCardViewDataImplCopyWithImpl<$Res>
    extends _$ListCardViewDataCopyWithImpl<$Res, _$ListCardViewDataImpl>
    implements _$$ListCardViewDataImplCopyWith<$Res> {
  __$$ListCardViewDataImplCopyWithImpl(_$ListCardViewDataImpl _value,
      $Res Function(_$ListCardViewDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? icon = null,
    Object? name = null,
    Object? volume = null,
    Object? publicationDate = null,
    Object? isHidden = null,
  }) {
    return _then(_$ListCardViewDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as String,
      publicationDate: null == publicationDate
          ? _value.publicationDate
          : publicationDate // ignore: cast_nullable_to_non_nullable
              as String,
      isHidden: null == isHidden
          ? _value.isHidden
          : isHidden // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ListCardViewDataImpl extends _ListCardViewData {
  const _$ListCardViewDataImpl(
      {required this.id,
      required this.icon,
      required this.name,
      required this.volume,
      required this.publicationDate,
      required this.isHidden})
      : super._();

  @override
  final String id;
  @override
  final Uint8List icon;
  @override
  final String name;
  @override
  final String volume;
  @override
  final String publicationDate;
  @override
  final bool isHidden;

  @override
  String toString() {
    return 'ListCardViewData(id: $id, icon: $icon, name: $name, volume: $volume, publicationDate: $publicationDate, isHidden: $isHidden)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListCardViewDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other.icon, icon) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.publicationDate, publicationDate) ||
                other.publicationDate == publicationDate) &&
            (identical(other.isHidden, isHidden) ||
                other.isHidden == isHidden));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(icon),
      name,
      volume,
      publicationDate,
      isHidden);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ListCardViewDataImplCopyWith<_$ListCardViewDataImpl> get copyWith =>
      __$$ListCardViewDataImplCopyWithImpl<_$ListCardViewDataImpl>(
          this, _$identity);
}

abstract class _ListCardViewData extends ListCardViewData {
  const factory _ListCardViewData(
      {required final String id,
      required final Uint8List icon,
      required final String name,
      required final String volume,
      required final String publicationDate,
      required final bool isHidden}) = _$ListCardViewDataImpl;
  const _ListCardViewData._() : super._();

  @override
  String get id;
  @override
  Uint8List get icon;
  @override
  String get name;
  @override
  String get volume;
  @override
  String get publicationDate;
  @override
  bool get isHidden;
  @override
  @JsonKey(ignore: true)
  _$$ListCardViewDataImplCopyWith<_$ListCardViewDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
