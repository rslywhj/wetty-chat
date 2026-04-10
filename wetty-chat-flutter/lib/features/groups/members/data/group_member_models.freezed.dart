// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_member_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GroupMember {

 int get uid; String? get username; String? get avatarUrl; String get role; DateTime? get joinedAt;
/// Create a copy of GroupMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupMemberCopyWith<GroupMember> get copyWith => _$GroupMemberCopyWithImpl<GroupMember>(this as GroupMember, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupMember&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt));
}


@override
int get hashCode => Object.hash(runtimeType,uid,username,avatarUrl,role,joinedAt);

@override
String toString() {
  return 'GroupMember(uid: $uid, username: $username, avatarUrl: $avatarUrl, role: $role, joinedAt: $joinedAt)';
}


}

/// @nodoc
abstract mixin class $GroupMemberCopyWith<$Res>  {
  factory $GroupMemberCopyWith(GroupMember value, $Res Function(GroupMember) _then) = _$GroupMemberCopyWithImpl;
@useResult
$Res call({
 int uid, String? username, String? avatarUrl, String role, DateTime? joinedAt
});




}
/// @nodoc
class _$GroupMemberCopyWithImpl<$Res>
    implements $GroupMemberCopyWith<$Res> {
  _$GroupMemberCopyWithImpl(this._self, this._then);

  final GroupMember _self;
  final $Res Function(GroupMember) _then;

/// Create a copy of GroupMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? username = freezed,Object? avatarUrl = freezed,Object? role = null,Object? joinedAt = freezed,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as int,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,joinedAt: freezed == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupMember].
extension GroupMemberPatterns on GroupMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupMember value)  $default,){
final _that = this;
switch (_that) {
case _GroupMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupMember value)?  $default,){
final _that = this;
switch (_that) {
case _GroupMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int uid,  String? username,  String? avatarUrl,  String role,  DateTime? joinedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupMember() when $default != null:
return $default(_that.uid,_that.username,_that.avatarUrl,_that.role,_that.joinedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int uid,  String? username,  String? avatarUrl,  String role,  DateTime? joinedAt)  $default,) {final _that = this;
switch (_that) {
case _GroupMember():
return $default(_that.uid,_that.username,_that.avatarUrl,_that.role,_that.joinedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int uid,  String? username,  String? avatarUrl,  String role,  DateTime? joinedAt)?  $default,) {final _that = this;
switch (_that) {
case _GroupMember() when $default != null:
return $default(_that.uid,_that.username,_that.avatarUrl,_that.role,_that.joinedAt);case _:
  return null;

}
}

}

/// @nodoc


class _GroupMember implements GroupMember {
  const _GroupMember({required this.uid, this.username, this.avatarUrl, required this.role, this.joinedAt});
  

@override final  int uid;
@override final  String? username;
@override final  String? avatarUrl;
@override final  String role;
@override final  DateTime? joinedAt;

/// Create a copy of GroupMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupMemberCopyWith<_GroupMember> get copyWith => __$GroupMemberCopyWithImpl<_GroupMember>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupMember&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt));
}


@override
int get hashCode => Object.hash(runtimeType,uid,username,avatarUrl,role,joinedAt);

@override
String toString() {
  return 'GroupMember(uid: $uid, username: $username, avatarUrl: $avatarUrl, role: $role, joinedAt: $joinedAt)';
}


}

/// @nodoc
abstract mixin class _$GroupMemberCopyWith<$Res> implements $GroupMemberCopyWith<$Res> {
  factory _$GroupMemberCopyWith(_GroupMember value, $Res Function(_GroupMember) _then) = __$GroupMemberCopyWithImpl;
@override @useResult
$Res call({
 int uid, String? username, String? avatarUrl, String role, DateTime? joinedAt
});




}
/// @nodoc
class __$GroupMemberCopyWithImpl<$Res>
    implements _$GroupMemberCopyWith<$Res> {
  __$GroupMemberCopyWithImpl(this._self, this._then);

  final _GroupMember _self;
  final $Res Function(_GroupMember) _then;

/// Create a copy of GroupMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? username = freezed,Object? avatarUrl = freezed,Object? role = null,Object? joinedAt = freezed,}) {
  return _then(_GroupMember(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as int,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,joinedAt: freezed == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$GroupMembersPage {

 List<GroupMember> get members; bool get canManageMembers; int? get nextCursor;
/// Create a copy of GroupMembersPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupMembersPageCopyWith<GroupMembersPage> get copyWith => _$GroupMembersPageCopyWithImpl<GroupMembersPage>(this as GroupMembersPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupMembersPage&&const DeepCollectionEquality().equals(other.members, members)&&(identical(other.canManageMembers, canManageMembers) || other.canManageMembers == canManageMembers)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(members),canManageMembers,nextCursor);

@override
String toString() {
  return 'GroupMembersPage(members: $members, canManageMembers: $canManageMembers, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $GroupMembersPageCopyWith<$Res>  {
  factory $GroupMembersPageCopyWith(GroupMembersPage value, $Res Function(GroupMembersPage) _then) = _$GroupMembersPageCopyWithImpl;
@useResult
$Res call({
 List<GroupMember> members, bool canManageMembers, int? nextCursor
});




}
/// @nodoc
class _$GroupMembersPageCopyWithImpl<$Res>
    implements $GroupMembersPageCopyWith<$Res> {
  _$GroupMembersPageCopyWithImpl(this._self, this._then);

  final GroupMembersPage _self;
  final $Res Function(GroupMembersPage) _then;

/// Create a copy of GroupMembersPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? members = null,Object? canManageMembers = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<GroupMember>,canManageMembers: null == canManageMembers ? _self.canManageMembers : canManageMembers // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupMembersPage].
extension GroupMembersPagePatterns on GroupMembersPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupMembersPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupMembersPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupMembersPage value)  $default,){
final _that = this;
switch (_that) {
case _GroupMembersPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupMembersPage value)?  $default,){
final _that = this;
switch (_that) {
case _GroupMembersPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<GroupMember> members,  bool canManageMembers,  int? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupMembersPage() when $default != null:
return $default(_that.members,_that.canManageMembers,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<GroupMember> members,  bool canManageMembers,  int? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _GroupMembersPage():
return $default(_that.members,_that.canManageMembers,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<GroupMember> members,  bool canManageMembers,  int? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _GroupMembersPage() when $default != null:
return $default(_that.members,_that.canManageMembers,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc


class _GroupMembersPage implements GroupMembersPage {
  const _GroupMembersPage({required final  List<GroupMember> members, this.canManageMembers = false, this.nextCursor}): _members = members;
  

 final  List<GroupMember> _members;
@override List<GroupMember> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

@override@JsonKey() final  bool canManageMembers;
@override final  int? nextCursor;

/// Create a copy of GroupMembersPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupMembersPageCopyWith<_GroupMembersPage> get copyWith => __$GroupMembersPageCopyWithImpl<_GroupMembersPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupMembersPage&&const DeepCollectionEquality().equals(other._members, _members)&&(identical(other.canManageMembers, canManageMembers) || other.canManageMembers == canManageMembers)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_members),canManageMembers,nextCursor);

@override
String toString() {
  return 'GroupMembersPage(members: $members, canManageMembers: $canManageMembers, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$GroupMembersPageCopyWith<$Res> implements $GroupMembersPageCopyWith<$Res> {
  factory _$GroupMembersPageCopyWith(_GroupMembersPage value, $Res Function(_GroupMembersPage) _then) = __$GroupMembersPageCopyWithImpl;
@override @useResult
$Res call({
 List<GroupMember> members, bool canManageMembers, int? nextCursor
});




}
/// @nodoc
class __$GroupMembersPageCopyWithImpl<$Res>
    implements _$GroupMembersPageCopyWith<$Res> {
  __$GroupMembersPageCopyWithImpl(this._self, this._then);

  final _GroupMembersPage _self;
  final $Res Function(_GroupMembersPage) _then;

/// Create a copy of GroupMembersPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? members = null,Object? canManageMembers = null,Object? nextCursor = freezed,}) {
  return _then(_GroupMembersPage(
members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<GroupMember>,canManageMembers: null == canManageMembers ? _self.canManageMembers : canManageMembers // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
