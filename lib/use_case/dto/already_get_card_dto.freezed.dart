// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'already_get_card_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AlreadyGetCardDTO {

 String get cardId;
/// Create a copy of AlreadyGetCardDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlreadyGetCardDTOCopyWith<AlreadyGetCardDTO> get copyWith => _$AlreadyGetCardDTOCopyWithImpl<AlreadyGetCardDTO>(this as AlreadyGetCardDTO, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlreadyGetCardDTO&&(identical(other.cardId, cardId) || other.cardId == cardId));
}


@override
int get hashCode => Object.hash(runtimeType,cardId);

@override
String toString() {
  return 'AlreadyGetCardDTO(cardId: $cardId)';
}


}

/// @nodoc
abstract mixin class $AlreadyGetCardDTOCopyWith<$Res>  {
  factory $AlreadyGetCardDTOCopyWith(AlreadyGetCardDTO value, $Res Function(AlreadyGetCardDTO) _then) = _$AlreadyGetCardDTOCopyWithImpl;
@useResult
$Res call({
 String cardId
});




}
/// @nodoc
class _$AlreadyGetCardDTOCopyWithImpl<$Res>
    implements $AlreadyGetCardDTOCopyWith<$Res> {
  _$AlreadyGetCardDTOCopyWithImpl(this._self, this._then);

  final AlreadyGetCardDTO _self;
  final $Res Function(AlreadyGetCardDTO) _then;

/// Create a copy of AlreadyGetCardDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cardId = null,}) {
  return _then(_self.copyWith(
cardId: null == cardId ? _self.cardId : cardId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class _AlreadyGetCardDTO extends AlreadyGetCardDTO {
  const _AlreadyGetCardDTO({required this.cardId}): super._();
  

@override final  String cardId;

/// Create a copy of AlreadyGetCardDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlreadyGetCardDTOCopyWith<_AlreadyGetCardDTO> get copyWith => __$AlreadyGetCardDTOCopyWithImpl<_AlreadyGetCardDTO>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlreadyGetCardDTO&&(identical(other.cardId, cardId) || other.cardId == cardId));
}


@override
int get hashCode => Object.hash(runtimeType,cardId);

@override
String toString() {
  return 'AlreadyGetCardDTO(cardId: $cardId)';
}


}

/// @nodoc
abstract mixin class _$AlreadyGetCardDTOCopyWith<$Res> implements $AlreadyGetCardDTOCopyWith<$Res> {
  factory _$AlreadyGetCardDTOCopyWith(_AlreadyGetCardDTO value, $Res Function(_AlreadyGetCardDTO) _then) = __$AlreadyGetCardDTOCopyWithImpl;
@override @useResult
$Res call({
 String cardId
});




}
/// @nodoc
class __$AlreadyGetCardDTOCopyWithImpl<$Res>
    implements _$AlreadyGetCardDTOCopyWith<$Res> {
  __$AlreadyGetCardDTOCopyWithImpl(this._self, this._then);

  final _AlreadyGetCardDTO _self;
  final $Res Function(_AlreadyGetCardDTO) _then;

/// Create a copy of AlreadyGetCardDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cardId = null,}) {
  return _then(_AlreadyGetCardDTO(
cardId: null == cardId ? _self.cardId : cardId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
