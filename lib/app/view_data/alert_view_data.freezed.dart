// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alert_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AlertViewData {

 String get title; String get message; AlertOKButtonViewData? get okButtonViewData; AlertCancelButtonViewData? get cancelButtonViewData;
/// Create a copy of AlertViewData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertViewDataCopyWith<AlertViewData> get copyWith => _$AlertViewDataCopyWithImpl<AlertViewData>(this as AlertViewData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertViewData&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.okButtonViewData, okButtonViewData) || other.okButtonViewData == okButtonViewData)&&(identical(other.cancelButtonViewData, cancelButtonViewData) || other.cancelButtonViewData == cancelButtonViewData));
}


@override
int get hashCode => Object.hash(runtimeType,title,message,okButtonViewData,cancelButtonViewData);

@override
String toString() {
  return 'AlertViewData(title: $title, message: $message, okButtonViewData: $okButtonViewData, cancelButtonViewData: $cancelButtonViewData)';
}


}

/// @nodoc
abstract mixin class $AlertViewDataCopyWith<$Res>  {
  factory $AlertViewDataCopyWith(AlertViewData value, $Res Function(AlertViewData) _then) = _$AlertViewDataCopyWithImpl;
@useResult
$Res call({
 String title, String message, AlertOKButtonViewData? okButtonViewData, AlertCancelButtonViewData? cancelButtonViewData
});


$AlertOKButtonViewDataCopyWith<$Res>? get okButtonViewData;$AlertCancelButtonViewDataCopyWith<$Res>? get cancelButtonViewData;

}
/// @nodoc
class _$AlertViewDataCopyWithImpl<$Res>
    implements $AlertViewDataCopyWith<$Res> {
  _$AlertViewDataCopyWithImpl(this._self, this._then);

  final AlertViewData _self;
  final $Res Function(AlertViewData) _then;

/// Create a copy of AlertViewData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? message = null,Object? okButtonViewData = freezed,Object? cancelButtonViewData = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,okButtonViewData: freezed == okButtonViewData ? _self.okButtonViewData : okButtonViewData // ignore: cast_nullable_to_non_nullable
as AlertOKButtonViewData?,cancelButtonViewData: freezed == cancelButtonViewData ? _self.cancelButtonViewData : cancelButtonViewData // ignore: cast_nullable_to_non_nullable
as AlertCancelButtonViewData?,
  ));
}
/// Create a copy of AlertViewData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlertOKButtonViewDataCopyWith<$Res>? get okButtonViewData {
    if (_self.okButtonViewData == null) {
    return null;
  }

  return $AlertOKButtonViewDataCopyWith<$Res>(_self.okButtonViewData!, (value) {
    return _then(_self.copyWith(okButtonViewData: value));
  });
}/// Create a copy of AlertViewData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlertCancelButtonViewDataCopyWith<$Res>? get cancelButtonViewData {
    if (_self.cancelButtonViewData == null) {
    return null;
  }

  return $AlertCancelButtonViewDataCopyWith<$Res>(_self.cancelButtonViewData!, (value) {
    return _then(_self.copyWith(cancelButtonViewData: value));
  });
}
}


/// @nodoc


class _AlertViewData extends AlertViewData {
  const _AlertViewData({required this.title, required this.message, required this.okButtonViewData, required this.cancelButtonViewData}): super._();
  

@override final  String title;
@override final  String message;
@override final  AlertOKButtonViewData? okButtonViewData;
@override final  AlertCancelButtonViewData? cancelButtonViewData;

/// Create a copy of AlertViewData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertViewDataCopyWith<_AlertViewData> get copyWith => __$AlertViewDataCopyWithImpl<_AlertViewData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlertViewData&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.okButtonViewData, okButtonViewData) || other.okButtonViewData == okButtonViewData)&&(identical(other.cancelButtonViewData, cancelButtonViewData) || other.cancelButtonViewData == cancelButtonViewData));
}


@override
int get hashCode => Object.hash(runtimeType,title,message,okButtonViewData,cancelButtonViewData);

@override
String toString() {
  return 'AlertViewData(title: $title, message: $message, okButtonViewData: $okButtonViewData, cancelButtonViewData: $cancelButtonViewData)';
}


}

/// @nodoc
abstract mixin class _$AlertViewDataCopyWith<$Res> implements $AlertViewDataCopyWith<$Res> {
  factory _$AlertViewDataCopyWith(_AlertViewData value, $Res Function(_AlertViewData) _then) = __$AlertViewDataCopyWithImpl;
@override @useResult
$Res call({
 String title, String message, AlertOKButtonViewData? okButtonViewData, AlertCancelButtonViewData? cancelButtonViewData
});


@override $AlertOKButtonViewDataCopyWith<$Res>? get okButtonViewData;@override $AlertCancelButtonViewDataCopyWith<$Res>? get cancelButtonViewData;

}
/// @nodoc
class __$AlertViewDataCopyWithImpl<$Res>
    implements _$AlertViewDataCopyWith<$Res> {
  __$AlertViewDataCopyWithImpl(this._self, this._then);

  final _AlertViewData _self;
  final $Res Function(_AlertViewData) _then;

/// Create a copy of AlertViewData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? message = null,Object? okButtonViewData = freezed,Object? cancelButtonViewData = freezed,}) {
  return _then(_AlertViewData(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,okButtonViewData: freezed == okButtonViewData ? _self.okButtonViewData : okButtonViewData // ignore: cast_nullable_to_non_nullable
as AlertOKButtonViewData?,cancelButtonViewData: freezed == cancelButtonViewData ? _self.cancelButtonViewData : cancelButtonViewData // ignore: cast_nullable_to_non_nullable
as AlertCancelButtonViewData?,
  ));
}

/// Create a copy of AlertViewData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlertOKButtonViewDataCopyWith<$Res>? get okButtonViewData {
    if (_self.okButtonViewData == null) {
    return null;
  }

  return $AlertOKButtonViewDataCopyWith<$Res>(_self.okButtonViewData!, (value) {
    return _then(_self.copyWith(okButtonViewData: value));
  });
}/// Create a copy of AlertViewData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlertCancelButtonViewDataCopyWith<$Res>? get cancelButtonViewData {
    if (_self.cancelButtonViewData == null) {
    return null;
  }

  return $AlertCancelButtonViewDataCopyWith<$Res>(_self.cancelButtonViewData!, (value) {
    return _then(_self.copyWith(cancelButtonViewData: value));
  });
}
}

/// @nodoc
mixin _$AlertOKButtonViewData {

 String get title; Future<void> Function() get action;
/// Create a copy of AlertOKButtonViewData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertOKButtonViewDataCopyWith<AlertOKButtonViewData> get copyWith => _$AlertOKButtonViewDataCopyWithImpl<AlertOKButtonViewData>(this as AlertOKButtonViewData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertOKButtonViewData&&(identical(other.title, title) || other.title == title)&&(identical(other.action, action) || other.action == action));
}


@override
int get hashCode => Object.hash(runtimeType,title,action);

@override
String toString() {
  return 'AlertOKButtonViewData(title: $title, action: $action)';
}


}

/// @nodoc
abstract mixin class $AlertOKButtonViewDataCopyWith<$Res>  {
  factory $AlertOKButtonViewDataCopyWith(AlertOKButtonViewData value, $Res Function(AlertOKButtonViewData) _then) = _$AlertOKButtonViewDataCopyWithImpl;
@useResult
$Res call({
 String title, Future<void> Function() action
});




}
/// @nodoc
class _$AlertOKButtonViewDataCopyWithImpl<$Res>
    implements $AlertOKButtonViewDataCopyWith<$Res> {
  _$AlertOKButtonViewDataCopyWithImpl(this._self, this._then);

  final AlertOKButtonViewData _self;
  final $Res Function(AlertOKButtonViewData) _then;

/// Create a copy of AlertOKButtonViewData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? action = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as Future<void> Function(),
  ));
}

}


/// @nodoc


class _AlertOKButtonViewData extends AlertOKButtonViewData {
  const _AlertOKButtonViewData({required this.title, required this.action}): super._();
  

@override final  String title;
@override final  Future<void> Function() action;

/// Create a copy of AlertOKButtonViewData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertOKButtonViewDataCopyWith<_AlertOKButtonViewData> get copyWith => __$AlertOKButtonViewDataCopyWithImpl<_AlertOKButtonViewData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlertOKButtonViewData&&(identical(other.title, title) || other.title == title)&&(identical(other.action, action) || other.action == action));
}


@override
int get hashCode => Object.hash(runtimeType,title,action);

@override
String toString() {
  return 'AlertOKButtonViewData(title: $title, action: $action)';
}


}

/// @nodoc
abstract mixin class _$AlertOKButtonViewDataCopyWith<$Res> implements $AlertOKButtonViewDataCopyWith<$Res> {
  factory _$AlertOKButtonViewDataCopyWith(_AlertOKButtonViewData value, $Res Function(_AlertOKButtonViewData) _then) = __$AlertOKButtonViewDataCopyWithImpl;
@override @useResult
$Res call({
 String title, Future<void> Function() action
});




}
/// @nodoc
class __$AlertOKButtonViewDataCopyWithImpl<$Res>
    implements _$AlertOKButtonViewDataCopyWith<$Res> {
  __$AlertOKButtonViewDataCopyWithImpl(this._self, this._then);

  final _AlertOKButtonViewData _self;
  final $Res Function(_AlertOKButtonViewData) _then;

/// Create a copy of AlertOKButtonViewData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? action = null,}) {
  return _then(_AlertOKButtonViewData(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as Future<void> Function(),
  ));
}


}

/// @nodoc
mixin _$AlertCancelButtonViewData {

 String get title; Future<void> Function() get action;
/// Create a copy of AlertCancelButtonViewData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertCancelButtonViewDataCopyWith<AlertCancelButtonViewData> get copyWith => _$AlertCancelButtonViewDataCopyWithImpl<AlertCancelButtonViewData>(this as AlertCancelButtonViewData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertCancelButtonViewData&&(identical(other.title, title) || other.title == title)&&(identical(other.action, action) || other.action == action));
}


@override
int get hashCode => Object.hash(runtimeType,title,action);

@override
String toString() {
  return 'AlertCancelButtonViewData(title: $title, action: $action)';
}


}

/// @nodoc
abstract mixin class $AlertCancelButtonViewDataCopyWith<$Res>  {
  factory $AlertCancelButtonViewDataCopyWith(AlertCancelButtonViewData value, $Res Function(AlertCancelButtonViewData) _then) = _$AlertCancelButtonViewDataCopyWithImpl;
@useResult
$Res call({
 String title, Future<void> Function() action
});




}
/// @nodoc
class _$AlertCancelButtonViewDataCopyWithImpl<$Res>
    implements $AlertCancelButtonViewDataCopyWith<$Res> {
  _$AlertCancelButtonViewDataCopyWithImpl(this._self, this._then);

  final AlertCancelButtonViewData _self;
  final $Res Function(AlertCancelButtonViewData) _then;

/// Create a copy of AlertCancelButtonViewData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? action = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as Future<void> Function(),
  ));
}

}


/// @nodoc


class _AlertCancelButtonViewData extends AlertCancelButtonViewData {
  const _AlertCancelButtonViewData({required this.title, required this.action}): super._();
  

@override final  String title;
@override final  Future<void> Function() action;

/// Create a copy of AlertCancelButtonViewData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertCancelButtonViewDataCopyWith<_AlertCancelButtonViewData> get copyWith => __$AlertCancelButtonViewDataCopyWithImpl<_AlertCancelButtonViewData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlertCancelButtonViewData&&(identical(other.title, title) || other.title == title)&&(identical(other.action, action) || other.action == action));
}


@override
int get hashCode => Object.hash(runtimeType,title,action);

@override
String toString() {
  return 'AlertCancelButtonViewData(title: $title, action: $action)';
}


}

/// @nodoc
abstract mixin class _$AlertCancelButtonViewDataCopyWith<$Res> implements $AlertCancelButtonViewDataCopyWith<$Res> {
  factory _$AlertCancelButtonViewDataCopyWith(_AlertCancelButtonViewData value, $Res Function(_AlertCancelButtonViewData) _then) = __$AlertCancelButtonViewDataCopyWithImpl;
@override @useResult
$Res call({
 String title, Future<void> Function() action
});




}
/// @nodoc
class __$AlertCancelButtonViewDataCopyWithImpl<$Res>
    implements _$AlertCancelButtonViewDataCopyWith<$Res> {
  __$AlertCancelButtonViewDataCopyWithImpl(this._self, this._then);

  final _AlertCancelButtonViewData _self;
  final $Res Function(_AlertCancelButtonViewData) _then;

/// Create a copy of AlertCancelButtonViewData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? action = null,}) {
  return _then(_AlertCancelButtonViewData(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as Future<void> Function(),
  ));
}


}

// dart format on
