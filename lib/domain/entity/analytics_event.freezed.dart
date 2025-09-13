// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnalyticsEvent {

 String get name; Map<String, Object>? get parameters;
/// Create a copy of AnalyticsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsEventCopyWith<AnalyticsEvent> get copyWith => _$AnalyticsEventCopyWithImpl<AnalyticsEvent>(this as AnalyticsEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsEvent&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.parameters, parameters));
}


@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(parameters));

@override
String toString() {
  return 'AnalyticsEvent(name: $name, parameters: $parameters)';
}


}

/// @nodoc
abstract mixin class $AnalyticsEventCopyWith<$Res>  {
  factory $AnalyticsEventCopyWith(AnalyticsEvent value, $Res Function(AnalyticsEvent) _then) = _$AnalyticsEventCopyWithImpl;
@useResult
$Res call({
 String name, Map<String, Object>? parameters
});




}
/// @nodoc
class _$AnalyticsEventCopyWithImpl<$Res>
    implements $AnalyticsEventCopyWith<$Res> {
  _$AnalyticsEventCopyWithImpl(this._self, this._then);

  final AnalyticsEvent _self;
  final $Res Function(AnalyticsEvent) _then;

/// Create a copy of AnalyticsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? parameters = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,parameters: freezed == parameters ? _self.parameters : parameters // ignore: cast_nullable_to_non_nullable
as Map<String, Object>?,
  ));
}

}


/// @nodoc


class _AnalyticsEvent extends AnalyticsEvent {
  const _AnalyticsEvent({required this.name, final  Map<String, Object>? parameters}): _parameters = parameters,super._();
  

@override final  String name;
 final  Map<String, Object>? _parameters;
@override Map<String, Object>? get parameters {
  final value = _parameters;
  if (value == null) return null;
  if (_parameters is EqualUnmodifiableMapView) return _parameters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AnalyticsEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsEventCopyWith<_AnalyticsEvent> get copyWith => __$AnalyticsEventCopyWithImpl<_AnalyticsEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsEvent&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._parameters, _parameters));
}


@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(_parameters));

@override
String toString() {
  return 'AnalyticsEvent(name: $name, parameters: $parameters)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsEventCopyWith<$Res> implements $AnalyticsEventCopyWith<$Res> {
  factory _$AnalyticsEventCopyWith(_AnalyticsEvent value, $Res Function(_AnalyticsEvent) _then) = __$AnalyticsEventCopyWithImpl;
@override @useResult
$Res call({
 String name, Map<String, Object>? parameters
});




}
/// @nodoc
class __$AnalyticsEventCopyWithImpl<$Res>
    implements _$AnalyticsEventCopyWith<$Res> {
  __$AnalyticsEventCopyWithImpl(this._self, this._then);

  final _AnalyticsEvent _self;
  final $Res Function(_AnalyticsEvent) _then;

/// Create a copy of AnalyticsEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? parameters = freezed,}) {
  return _then(_AnalyticsEvent(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,parameters: freezed == parameters ? _self._parameters : parameters // ignore: cast_nullable_to_non_nullable
as Map<String, Object>?,
  ));
}


}

// dart format on
