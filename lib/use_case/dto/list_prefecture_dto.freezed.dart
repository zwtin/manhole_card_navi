// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_prefecture_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ListPrefectureDTO {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<ListCardDTO> get cards => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ListPrefectureDTOCopyWith<ListPrefectureDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListPrefectureDTOCopyWith<$Res> {
  factory $ListPrefectureDTOCopyWith(
          ListPrefectureDTO value, $Res Function(ListPrefectureDTO) then) =
      _$ListPrefectureDTOCopyWithImpl<$Res, ListPrefectureDTO>;
  @useResult
  $Res call({String id, String name, List<ListCardDTO> cards});
}

/// @nodoc
class _$ListPrefectureDTOCopyWithImpl<$Res, $Val extends ListPrefectureDTO>
    implements $ListPrefectureDTOCopyWith<$Res> {
  _$ListPrefectureDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? cards = null,
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
      cards: null == cards
          ? _value.cards
          : cards // ignore: cast_nullable_to_non_nullable
              as List<ListCardDTO>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ListPrefectureDTOCopyWith<$Res>
    implements $ListPrefectureDTOCopyWith<$Res> {
  factory _$$_ListPrefectureDTOCopyWith(_$_ListPrefectureDTO value,
          $Res Function(_$_ListPrefectureDTO) then) =
      __$$_ListPrefectureDTOCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, List<ListCardDTO> cards});
}

/// @nodoc
class __$$_ListPrefectureDTOCopyWithImpl<$Res>
    extends _$ListPrefectureDTOCopyWithImpl<$Res, _$_ListPrefectureDTO>
    implements _$$_ListPrefectureDTOCopyWith<$Res> {
  __$$_ListPrefectureDTOCopyWithImpl(
      _$_ListPrefectureDTO _value, $Res Function(_$_ListPrefectureDTO) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? cards = null,
  }) {
    return _then(_$_ListPrefectureDTO(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      cards: null == cards
          ? _value._cards
          : cards // ignore: cast_nullable_to_non_nullable
              as List<ListCardDTO>,
    ));
  }
}

/// @nodoc

class _$_ListPrefectureDTO extends _ListPrefectureDTO {
  const _$_ListPrefectureDTO(
      {required this.id,
      required this.name,
      required final List<ListCardDTO> cards})
      : _cards = cards,
        super._();

  @override
  final String id;
  @override
  final String name;
  final List<ListCardDTO> _cards;
  @override
  List<ListCardDTO> get cards {
    if (_cards is EqualUnmodifiableListView) return _cards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cards);
  }

  @override
  String toString() {
    return 'ListPrefectureDTO(id: $id, name: $name, cards: $cards)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ListPrefectureDTO &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._cards, _cards));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, const DeepCollectionEquality().hash(_cards));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ListPrefectureDTOCopyWith<_$_ListPrefectureDTO> get copyWith =>
      __$$_ListPrefectureDTOCopyWithImpl<_$_ListPrefectureDTO>(
          this, _$identity);
}

abstract class _ListPrefectureDTO extends ListPrefectureDTO {
  const factory _ListPrefectureDTO(
      {required final String id,
      required final String name,
      required final List<ListCardDTO> cards}) = _$_ListPrefectureDTO;
  const _ListPrefectureDTO._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  List<ListCardDTO> get cards;
  @override
  @JsonKey(ignore: true)
  _$$_ListPrefectureDTOCopyWith<_$_ListPrefectureDTO> get copyWith =>
      throw _privateConstructorUsedError;
}
