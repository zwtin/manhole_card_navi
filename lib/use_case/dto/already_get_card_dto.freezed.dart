// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'already_get_card_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AlreadyGetCardDTO {
  String get cardId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AlreadyGetCardDTOCopyWith<AlreadyGetCardDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlreadyGetCardDTOCopyWith<$Res> {
  factory $AlreadyGetCardDTOCopyWith(
          AlreadyGetCardDTO value, $Res Function(AlreadyGetCardDTO) then) =
      _$AlreadyGetCardDTOCopyWithImpl<$Res, AlreadyGetCardDTO>;
  @useResult
  $Res call({String cardId});
}

/// @nodoc
class _$AlreadyGetCardDTOCopyWithImpl<$Res, $Val extends AlreadyGetCardDTO>
    implements $AlreadyGetCardDTOCopyWith<$Res> {
  _$AlreadyGetCardDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardId = null,
  }) {
    return _then(_value.copyWith(
      cardId: null == cardId
          ? _value.cardId
          : cardId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AlreadyGetCardDTOImplCopyWith<$Res>
    implements $AlreadyGetCardDTOCopyWith<$Res> {
  factory _$$AlreadyGetCardDTOImplCopyWith(_$AlreadyGetCardDTOImpl value,
          $Res Function(_$AlreadyGetCardDTOImpl) then) =
      __$$AlreadyGetCardDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String cardId});
}

/// @nodoc
class __$$AlreadyGetCardDTOImplCopyWithImpl<$Res>
    extends _$AlreadyGetCardDTOCopyWithImpl<$Res, _$AlreadyGetCardDTOImpl>
    implements _$$AlreadyGetCardDTOImplCopyWith<$Res> {
  __$$AlreadyGetCardDTOImplCopyWithImpl(_$AlreadyGetCardDTOImpl _value,
      $Res Function(_$AlreadyGetCardDTOImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardId = null,
  }) {
    return _then(_$AlreadyGetCardDTOImpl(
      cardId: null == cardId
          ? _value.cardId
          : cardId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AlreadyGetCardDTOImpl extends _AlreadyGetCardDTO {
  const _$AlreadyGetCardDTOImpl({required this.cardId}) : super._();

  @override
  final String cardId;

  @override
  String toString() {
    return 'AlreadyGetCardDTO(cardId: $cardId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlreadyGetCardDTOImpl &&
            (identical(other.cardId, cardId) || other.cardId == cardId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cardId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AlreadyGetCardDTOImplCopyWith<_$AlreadyGetCardDTOImpl> get copyWith =>
      __$$AlreadyGetCardDTOImplCopyWithImpl<_$AlreadyGetCardDTOImpl>(
          this, _$identity);
}

abstract class _AlreadyGetCardDTO extends AlreadyGetCardDTO {
  const factory _AlreadyGetCardDTO({required final String cardId}) =
      _$AlreadyGetCardDTOImpl;
  const _AlreadyGetCardDTO._() : super._();

  @override
  String get cardId;
  @override
  @JsonKey(ignore: true)
  _$$AlreadyGetCardDTOImplCopyWith<_$AlreadyGetCardDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
