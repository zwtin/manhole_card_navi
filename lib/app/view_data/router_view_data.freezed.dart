// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'router_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RouterViewData {

 TransitionType get type; CommonWidget? get nextWidget;
/// Create a copy of RouterViewData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouterViewDataCopyWith<RouterViewData> get copyWith => _$RouterViewDataCopyWithImpl<RouterViewData>(this as RouterViewData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouterViewData&&(identical(other.type, type) || other.type == type)&&(identical(other.nextWidget, nextWidget) || other.nextWidget == nextWidget));
}


@override
int get hashCode => Object.hash(runtimeType,type,nextWidget);

@override
String toString() {
  return 'RouterViewData(type: $type, nextWidget: $nextWidget)';
}


}

/// @nodoc
abstract mixin class $RouterViewDataCopyWith<$Res>  {
  factory $RouterViewDataCopyWith(RouterViewData value, $Res Function(RouterViewData) _then) = _$RouterViewDataCopyWithImpl;
@useResult
$Res call({
 TransitionType type, CommonWidget? nextWidget
});




}
/// @nodoc
class _$RouterViewDataCopyWithImpl<$Res>
    implements $RouterViewDataCopyWith<$Res> {
  _$RouterViewDataCopyWithImpl(this._self, this._then);

  final RouterViewData _self;
  final $Res Function(RouterViewData) _then;

/// Create a copy of RouterViewData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? nextWidget = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransitionType,nextWidget: freezed == nextWidget ? _self.nextWidget : nextWidget // ignore: cast_nullable_to_non_nullable
as CommonWidget?,
  ));
}

}


/// @nodoc


class _RouterViewData extends RouterViewData {
  const _RouterViewData({required this.type, this.nextWidget}): super._();
  

@override final  TransitionType type;
@override final  CommonWidget? nextWidget;

/// Create a copy of RouterViewData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouterViewDataCopyWith<_RouterViewData> get copyWith => __$RouterViewDataCopyWithImpl<_RouterViewData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouterViewData&&(identical(other.type, type) || other.type == type)&&(identical(other.nextWidget, nextWidget) || other.nextWidget == nextWidget));
}


@override
int get hashCode => Object.hash(runtimeType,type,nextWidget);

@override
String toString() {
  return 'RouterViewData(type: $type, nextWidget: $nextWidget)';
}


}

/// @nodoc
abstract mixin class _$RouterViewDataCopyWith<$Res> implements $RouterViewDataCopyWith<$Res> {
  factory _$RouterViewDataCopyWith(_RouterViewData value, $Res Function(_RouterViewData) _then) = __$RouterViewDataCopyWithImpl;
@override @useResult
$Res call({
 TransitionType type, CommonWidget? nextWidget
});




}
/// @nodoc
class __$RouterViewDataCopyWithImpl<$Res>
    implements _$RouterViewDataCopyWith<$Res> {
  __$RouterViewDataCopyWithImpl(this._self, this._then);

  final _RouterViewData _self;
  final $Res Function(_RouterViewData) _then;

/// Create a copy of RouterViewData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? nextWidget = freezed,}) {
  return _then(_RouterViewData(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransitionType,nextWidget: freezed == nextWidget ? _self.nextWidget : nextWidget // ignore: cast_nullable_to_non_nullable
as CommonWidget?,
  ));
}


}

// dart format on
