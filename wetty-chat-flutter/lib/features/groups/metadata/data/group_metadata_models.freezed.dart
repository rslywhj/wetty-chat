// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_metadata_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatMetadata {

 String get id; String get name; String? get description; String? get avatarUrl; String? get avatarImageId; String get visibility; DateTime? get createdAt; DateTime? get mutedUntil; String? get myRole;
/// Create a copy of ChatMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMetadataCopyWith<ChatMetadata> get copyWith => _$ChatMetadataCopyWithImpl<ChatMetadata>(this as ChatMetadata, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMetadata&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.avatarImageId, avatarImageId) || other.avatarImageId == avatarImageId)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.mutedUntil, mutedUntil) || other.mutedUntil == mutedUntil)&&(identical(other.myRole, myRole) || other.myRole == myRole));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,avatarUrl,avatarImageId,visibility,createdAt,mutedUntil,myRole);

@override
String toString() {
  return 'ChatMetadata(id: $id, name: $name, description: $description, avatarUrl: $avatarUrl, avatarImageId: $avatarImageId, visibility: $visibility, createdAt: $createdAt, mutedUntil: $mutedUntil, myRole: $myRole)';
}


}

/// @nodoc
abstract mixin class $ChatMetadataCopyWith<$Res>  {
  factory $ChatMetadataCopyWith(ChatMetadata value, $Res Function(ChatMetadata) _then) = _$ChatMetadataCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, String? avatarUrl, String? avatarImageId, String visibility, DateTime? createdAt, DateTime? mutedUntil, String? myRole
});




}
/// @nodoc
class _$ChatMetadataCopyWithImpl<$Res>
    implements $ChatMetadataCopyWith<$Res> {
  _$ChatMetadataCopyWithImpl(this._self, this._then);

  final ChatMetadata _self;
  final $Res Function(ChatMetadata) _then;

/// Create a copy of ChatMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? avatarUrl = freezed,Object? avatarImageId = freezed,Object? visibility = null,Object? createdAt = freezed,Object? mutedUntil = freezed,Object? myRole = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,avatarImageId: freezed == avatarImageId ? _self.avatarImageId : avatarImageId // ignore: cast_nullable_to_non_nullable
as String?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,mutedUntil: freezed == mutedUntil ? _self.mutedUntil : mutedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,myRole: freezed == myRole ? _self.myRole : myRole // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMetadata].
extension ChatMetadataPatterns on ChatMetadata {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMetadata() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMetadata value)  $default,){
final _that = this;
switch (_that) {
case _ChatMetadata():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMetadata() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? avatarUrl,  String? avatarImageId,  String visibility,  DateTime? createdAt,  DateTime? mutedUntil,  String? myRole)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMetadata() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.avatarUrl,_that.avatarImageId,_that.visibility,_that.createdAt,_that.mutedUntil,_that.myRole);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? avatarUrl,  String? avatarImageId,  String visibility,  DateTime? createdAt,  DateTime? mutedUntil,  String? myRole)  $default,) {final _that = this;
switch (_that) {
case _ChatMetadata():
return $default(_that.id,_that.name,_that.description,_that.avatarUrl,_that.avatarImageId,_that.visibility,_that.createdAt,_that.mutedUntil,_that.myRole);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  String? avatarUrl,  String? avatarImageId,  String visibility,  DateTime? createdAt,  DateTime? mutedUntil,  String? myRole)?  $default,) {final _that = this;
switch (_that) {
case _ChatMetadata() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.avatarUrl,_that.avatarImageId,_that.visibility,_that.createdAt,_that.mutedUntil,_that.myRole);case _:
  return null;

}
}

}

/// @nodoc


class _ChatMetadata extends ChatMetadata {
  const _ChatMetadata({required this.id, required this.name, this.description, this.avatarUrl, this.avatarImageId, this.visibility = 'public', this.createdAt, this.mutedUntil, this.myRole}): super._();
  

@override final  String id;
@override final  String name;
@override final  String? description;
@override final  String? avatarUrl;
@override final  String? avatarImageId;
@override@JsonKey() final  String visibility;
@override final  DateTime? createdAt;
@override final  DateTime? mutedUntil;
@override final  String? myRole;

/// Create a copy of ChatMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMetadataCopyWith<_ChatMetadata> get copyWith => __$ChatMetadataCopyWithImpl<_ChatMetadata>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMetadata&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.avatarImageId, avatarImageId) || other.avatarImageId == avatarImageId)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.mutedUntil, mutedUntil) || other.mutedUntil == mutedUntil)&&(identical(other.myRole, myRole) || other.myRole == myRole));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,avatarUrl,avatarImageId,visibility,createdAt,mutedUntil,myRole);

@override
String toString() {
  return 'ChatMetadata(id: $id, name: $name, description: $description, avatarUrl: $avatarUrl, avatarImageId: $avatarImageId, visibility: $visibility, createdAt: $createdAt, mutedUntil: $mutedUntil, myRole: $myRole)';
}


}

/// @nodoc
abstract mixin class _$ChatMetadataCopyWith<$Res> implements $ChatMetadataCopyWith<$Res> {
  factory _$ChatMetadataCopyWith(_ChatMetadata value, $Res Function(_ChatMetadata) _then) = __$ChatMetadataCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, String? avatarUrl, String? avatarImageId, String visibility, DateTime? createdAt, DateTime? mutedUntil, String? myRole
});




}
/// @nodoc
class __$ChatMetadataCopyWithImpl<$Res>
    implements _$ChatMetadataCopyWith<$Res> {
  __$ChatMetadataCopyWithImpl(this._self, this._then);

  final _ChatMetadata _self;
  final $Res Function(_ChatMetadata) _then;

/// Create a copy of ChatMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? avatarUrl = freezed,Object? avatarImageId = freezed,Object? visibility = null,Object? createdAt = freezed,Object? mutedUntil = freezed,Object? myRole = freezed,}) {
  return _then(_ChatMetadata(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,avatarImageId: freezed == avatarImageId ? _self.avatarImageId : avatarImageId // ignore: cast_nullable_to_non_nullable
as String?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,mutedUntil: freezed == mutedUntil ? _self.mutedUntil : mutedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,myRole: freezed == myRole ? _self.myRole : myRole // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
