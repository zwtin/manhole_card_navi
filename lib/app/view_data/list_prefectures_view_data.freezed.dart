// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_prefectures_view_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ListPrefecturesViewData {
  List<ListPrefectureViewData> get list => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ListPrefecturesViewDataCopyWith<ListPrefecturesViewData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListPrefecturesViewDataCopyWith<$Res> {
  factory $ListPrefecturesViewDataCopyWith(ListPrefecturesViewData value,
          $Res Function(ListPrefecturesViewData) then) =
      _$ListPrefecturesViewDataCopyWithImpl<$Res, ListPrefecturesViewData>;
  @useResult
  $Res call({List<ListPrefectureViewData> list});
}

/// @nodoc
class _$ListPrefecturesViewDataCopyWithImpl<$Res,
        $Val extends ListPrefecturesViewData>
    implements $ListPrefecturesViewDataCopyWith<$Res> {
  _$ListPrefecturesViewDataCopyWithImpl(this._value, this._then);

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
              as List<ListPrefectureViewData>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ListPrefecturesViewDataCopyWith<$Res>
    implements $ListPrefecturesViewDataCopyWith<$Res> {
  factory _$$_ListPrefecturesViewDataCopyWith(_$_ListPrefecturesViewData value,
          $Res Function(_$_ListPrefecturesViewData) then) =
      __$$_ListPrefecturesViewDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ListPrefectureViewData> list});
}

/// @nodoc
class __$$_ListPrefecturesViewDataCopyWithImpl<$Res>
    extends _$ListPrefecturesViewDataCopyWithImpl<$Res,
        _$_ListPrefecturesViewData>
    implements _$$_ListPrefecturesViewDataCopyWith<$Res> {
  __$$_ListPrefecturesViewDataCopyWithImpl(_$_ListPrefecturesViewData _value,
      $Res Function(_$_ListPrefecturesViewData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
  }) {
    return _then(_$_ListPrefecturesViewData(
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<ListPrefectureViewData>,
    ));
  }
}

/// @nodoc

class _$_ListPrefecturesViewData extends _ListPrefecturesViewData {
  const _$_ListPrefecturesViewData(
      {required final List<ListPrefectureViewData> list})
      : _list = list,
        super._();

  final List<ListPrefectureViewData> _list;
  @override
  List<ListPrefectureViewData> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  String toString() {
    return 'ListPrefecturesViewData(list: $list)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ListPrefecturesViewData &&
            const DeepCollectionEquality().equals(other._list, _list));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_list));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ListPrefecturesViewDataCopyWith<_$_ListPrefecturesViewData>
      get copyWith =>
          __$$_ListPrefecturesViewDataCopyWithImpl<_$_ListPrefecturesViewData>(
              this, _$identity);
}

abstract class _ListPrefecturesViewData extends ListPrefecturesViewData {
  const factory _ListPrefecturesViewData(
          {required final List<ListPrefectureViewData> list}) =
      _$_ListPrefecturesViewData;
  const _ListPrefecturesViewData._() : super._();

  @override
  List<ListPrefectureViewData> get list;
  @override
  @JsonKey(ignore: true)
  _$$_ListPrefecturesViewDataCopyWith<_$_ListPrefecturesViewData>
      get copyWith => throw _privateConstructorUsedError;
}
