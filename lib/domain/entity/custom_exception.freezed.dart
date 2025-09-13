// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CustomException {

 String get title; String get text;
/// Create a copy of CustomException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomExceptionCopyWith<CustomException> get copyWith => _$CustomExceptionCopyWithImpl<CustomException>(this as CustomException, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomException&&(identical(other.title, title) || other.title == title)&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,title,text);

@override
String toString() {
  return 'CustomException(title: $title, text: $text)';
}


}

/// @nodoc
abstract mixin class $CustomExceptionCopyWith<$Res>  {
  factory $CustomExceptionCopyWith(CustomException value, $Res Function(CustomException) _then) = _$CustomExceptionCopyWithImpl;
@useResult
$Res call({
 String title, String text
});




}
/// @nodoc
class _$CustomExceptionCopyWithImpl<$Res>
    implements $CustomExceptionCopyWith<$Res> {
  _$CustomExceptionCopyWithImpl(this._self, this._then);

  final CustomException _self;
  final $Res Function(CustomException) _then;

/// Create a copy of CustomException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? text = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class _CustomException extends CustomException {
  const _CustomException({required this.title, required this.text}): super._();
  

@override final  String title;
@override final  String text;

/// Create a copy of CustomException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomExceptionCopyWith<_CustomException> get copyWith => __$CustomExceptionCopyWithImpl<_CustomException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomException&&(identical(other.title, title) || other.title == title)&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,title,text);

@override
String toString() {
  return 'CustomException(title: $title, text: $text)';
}


}

/// @nodoc
abstract mixin class _$CustomExceptionCopyWith<$Res> implements $CustomExceptionCopyWith<$Res> {
  factory _$CustomExceptionCopyWith(_CustomException value, $Res Function(_CustomException) _then) = __$CustomExceptionCopyWithImpl;
@override @useResult
$Res call({
 String title, String text
});




}
/// @nodoc
class __$CustomExceptionCopyWithImpl<$Res>
    implements _$CustomExceptionCopyWith<$Res> {
  __$CustomExceptionCopyWithImpl(this._self, this._then);

  final _CustomException _self;
  final $Res Function(_CustomException) _then;

/// Create a copy of CustomException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? text = null,}) {
  return _then(_CustomException(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
