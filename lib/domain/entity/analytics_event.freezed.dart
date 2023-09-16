// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AnalyticsEvent {
  String get name => throw _privateConstructorUsedError;
  Map<String, Object>? get parameters => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AnalyticsEventCopyWith<AnalyticsEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsEventCopyWith<$Res> {
  factory $AnalyticsEventCopyWith(
          AnalyticsEvent value, $Res Function(AnalyticsEvent) then) =
      _$AnalyticsEventCopyWithImpl<$Res, AnalyticsEvent>;
  @useResult
  $Res call({String name, Map<String, Object>? parameters});
}

/// @nodoc
class _$AnalyticsEventCopyWithImpl<$Res, $Val extends AnalyticsEvent>
    implements $AnalyticsEventCopyWith<$Res> {
  _$AnalyticsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? parameters = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      parameters: freezed == parameters
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, Object>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AnalyticsEventCopyWith<$Res>
    implements $AnalyticsEventCopyWith<$Res> {
  factory _$$_AnalyticsEventCopyWith(
          _$_AnalyticsEvent value, $Res Function(_$_AnalyticsEvent) then) =
      __$$_AnalyticsEventCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, Map<String, Object>? parameters});
}

/// @nodoc
class __$$_AnalyticsEventCopyWithImpl<$Res>
    extends _$AnalyticsEventCopyWithImpl<$Res, _$_AnalyticsEvent>
    implements _$$_AnalyticsEventCopyWith<$Res> {
  __$$_AnalyticsEventCopyWithImpl(
      _$_AnalyticsEvent _value, $Res Function(_$_AnalyticsEvent) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? parameters = freezed,
  }) {
    return _then(_$_AnalyticsEvent(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      parameters: freezed == parameters
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, Object>?,
    ));
  }
}

/// @nodoc

class _$_AnalyticsEvent extends _AnalyticsEvent {
  const _$_AnalyticsEvent(
      {required this.name, final Map<String, Object>? parameters})
      : _parameters = parameters,
        super._();

  @override
  final String name;
  final Map<String, Object>? _parameters;
  @override
  Map<String, Object>? get parameters {
    final value = _parameters;
    if (value == null) return null;
    if (_parameters is EqualUnmodifiableMapView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'AnalyticsEvent(name: $name, parameters: $parameters)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AnalyticsEvent &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, name, const DeepCollectionEquality().hash(_parameters));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AnalyticsEventCopyWith<_$_AnalyticsEvent> get copyWith =>
      __$$_AnalyticsEventCopyWithImpl<_$_AnalyticsEvent>(this, _$identity);
}

abstract class _AnalyticsEvent extends AnalyticsEvent {
  const factory _AnalyticsEvent(
      {required final String name,
      final Map<String, Object>? parameters}) = _$_AnalyticsEvent;
  const _AnalyticsEvent._() : super._();

  @override
  String get name;
  @override
  Map<String, Object>? get parameters;
  @override
  @JsonKey(ignore: true)
  _$$_AnalyticsEventCopyWith<_$_AnalyticsEvent> get copyWith =>
      throw _privateConstructorUsedError;
}
