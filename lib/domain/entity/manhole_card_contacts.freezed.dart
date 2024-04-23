// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manhole_card_contacts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ManholeCardContacts {
  List<ManholeCardContact> get list => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ManholeCardContactsCopyWith<ManholeCardContacts> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManholeCardContactsCopyWith<$Res> {
  factory $ManholeCardContactsCopyWith(
          ManholeCardContacts value, $Res Function(ManholeCardContacts) then) =
      _$ManholeCardContactsCopyWithImpl<$Res, ManholeCardContacts>;
  @useResult
  $Res call({List<ManholeCardContact> list});
}

/// @nodoc
class _$ManholeCardContactsCopyWithImpl<$Res, $Val extends ManholeCardContacts>
    implements $ManholeCardContactsCopyWith<$Res> {
  _$ManholeCardContactsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
  }) {
    return _then(_value.copyWith(
      list: null == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<ManholeCardContact>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ManholeCardContactsImplCopyWith<$Res>
    implements $ManholeCardContactsCopyWith<$Res> {
  factory _$$ManholeCardContactsImplCopyWith(_$ManholeCardContactsImpl value,
          $Res Function(_$ManholeCardContactsImpl) then) =
      __$$ManholeCardContactsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ManholeCardContact> list});
}

/// @nodoc
class __$$ManholeCardContactsImplCopyWithImpl<$Res>
    extends _$ManholeCardContactsCopyWithImpl<$Res, _$ManholeCardContactsImpl>
    implements _$$ManholeCardContactsImplCopyWith<$Res> {
  __$$ManholeCardContactsImplCopyWithImpl(_$ManholeCardContactsImpl _value,
      $Res Function(_$ManholeCardContactsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
  }) {
    return _then(_$ManholeCardContactsImpl(
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<ManholeCardContact>,
    ));
  }
}

/// @nodoc

class _$ManholeCardContactsImpl extends _ManholeCardContacts {
  const _$ManholeCardContactsImpl(
      {required final List<ManholeCardContact> list})
      : _list = list,
        super._();

  final List<ManholeCardContact> _list;
  @override
  List<ManholeCardContact> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  String toString() {
    return 'ManholeCardContacts(list: $list)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManholeCardContactsImpl &&
            const DeepCollectionEquality().equals(other._list, _list));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_list));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ManholeCardContactsImplCopyWith<_$ManholeCardContactsImpl> get copyWith =>
      __$$ManholeCardContactsImplCopyWithImpl<_$ManholeCardContactsImpl>(
          this, _$identity);
}

abstract class _ManholeCardContacts extends ManholeCardContacts {
  const factory _ManholeCardContacts(
          {required final List<ManholeCardContact> list}) =
      _$ManholeCardContactsImpl;
  const _ManholeCardContacts._() : super._();

  @override
  List<ManholeCardContact> get list;
  @override
  @JsonKey(ignore: true)
  _$$ManholeCardContactsImplCopyWith<_$ManholeCardContactsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
