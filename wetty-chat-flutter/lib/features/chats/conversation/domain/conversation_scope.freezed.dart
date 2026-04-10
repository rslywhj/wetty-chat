// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_scope.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConversationScope {

 String get chatId;
/// Create a copy of ConversationScope
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationScopeCopyWith<ConversationScope> get copyWith => _$ConversationScopeCopyWithImpl<ConversationScope>(this as ConversationScope, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationScope&&(identical(other.chatId, chatId) || other.chatId == chatId));
}


@override
int get hashCode => Object.hash(runtimeType,chatId);

@override
String toString() {
  return 'ConversationScope(chatId: $chatId)';
}


}

/// @nodoc
abstract mixin class $ConversationScopeCopyWith<$Res>  {
  factory $ConversationScopeCopyWith(ConversationScope value, $Res Function(ConversationScope) _then) = _$ConversationScopeCopyWithImpl;
@useResult
$Res call({
 String chatId
});




}
/// @nodoc
class _$ConversationScopeCopyWithImpl<$Res>
    implements $ConversationScopeCopyWith<$Res> {
  _$ConversationScopeCopyWithImpl(this._self, this._then);

  final ConversationScope _self;
  final $Res Function(ConversationScope) _then;

/// Create a copy of ConversationScope
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chatId = null,}) {
  return _then(_self.copyWith(
chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ConversationScope].
extension ConversationScopePatterns on ConversationScope {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ChatScope value)?  chat,TResult Function( ThreadScope value)?  thread,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ChatScope() when chat != null:
return chat(_that);case ThreadScope() when thread != null:
return thread(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ChatScope value)  chat,required TResult Function( ThreadScope value)  thread,}){
final _that = this;
switch (_that) {
case ChatScope():
return chat(_that);case ThreadScope():
return thread(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ChatScope value)?  chat,TResult? Function( ThreadScope value)?  thread,}){
final _that = this;
switch (_that) {
case ChatScope() when chat != null:
return chat(_that);case ThreadScope() when thread != null:
return thread(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String chatId)?  chat,TResult Function( String chatId,  String threadRootId)?  thread,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ChatScope() when chat != null:
return chat(_that.chatId);case ThreadScope() when thread != null:
return thread(_that.chatId,_that.threadRootId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String chatId)  chat,required TResult Function( String chatId,  String threadRootId)  thread,}) {final _that = this;
switch (_that) {
case ChatScope():
return chat(_that.chatId);case ThreadScope():
return thread(_that.chatId,_that.threadRootId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String chatId)?  chat,TResult? Function( String chatId,  String threadRootId)?  thread,}) {final _that = this;
switch (_that) {
case ChatScope() when chat != null:
return chat(_that.chatId);case ThreadScope() when thread != null:
return thread(_that.chatId,_that.threadRootId);case _:
  return null;

}
}

}

/// @nodoc


class ChatScope extends ConversationScope {
  const ChatScope({required this.chatId}): super._();
  

@override final  String chatId;

/// Create a copy of ConversationScope
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatScopeCopyWith<ChatScope> get copyWith => _$ChatScopeCopyWithImpl<ChatScope>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatScope&&(identical(other.chatId, chatId) || other.chatId == chatId));
}


@override
int get hashCode => Object.hash(runtimeType,chatId);

@override
String toString() {
  return 'ConversationScope.chat(chatId: $chatId)';
}


}

/// @nodoc
abstract mixin class $ChatScopeCopyWith<$Res> implements $ConversationScopeCopyWith<$Res> {
  factory $ChatScopeCopyWith(ChatScope value, $Res Function(ChatScope) _then) = _$ChatScopeCopyWithImpl;
@override @useResult
$Res call({
 String chatId
});




}
/// @nodoc
class _$ChatScopeCopyWithImpl<$Res>
    implements $ChatScopeCopyWith<$Res> {
  _$ChatScopeCopyWithImpl(this._self, this._then);

  final ChatScope _self;
  final $Res Function(ChatScope) _then;

/// Create a copy of ConversationScope
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chatId = null,}) {
  return _then(ChatScope(
chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ThreadScope extends ConversationScope {
  const ThreadScope({required this.chatId, required this.threadRootId}): super._();
  

@override final  String chatId;
 final  String threadRootId;

/// Create a copy of ConversationScope
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThreadScopeCopyWith<ThreadScope> get copyWith => _$ThreadScopeCopyWithImpl<ThreadScope>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThreadScope&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.threadRootId, threadRootId) || other.threadRootId == threadRootId));
}


@override
int get hashCode => Object.hash(runtimeType,chatId,threadRootId);

@override
String toString() {
  return 'ConversationScope.thread(chatId: $chatId, threadRootId: $threadRootId)';
}


}

/// @nodoc
abstract mixin class $ThreadScopeCopyWith<$Res> implements $ConversationScopeCopyWith<$Res> {
  factory $ThreadScopeCopyWith(ThreadScope value, $Res Function(ThreadScope) _then) = _$ThreadScopeCopyWithImpl;
@override @useResult
$Res call({
 String chatId, String threadRootId
});




}
/// @nodoc
class _$ThreadScopeCopyWithImpl<$Res>
    implements $ThreadScopeCopyWith<$Res> {
  _$ThreadScopeCopyWithImpl(this._self, this._then);

  final ThreadScope _self;
  final $Res Function(ThreadScope) _then;

/// Create a copy of ConversationScope
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chatId = null,Object? threadRootId = null,}) {
  return _then(ThreadScope(
chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String,threadRootId: null == threadRootId ? _self.threadRootId : threadRootId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
