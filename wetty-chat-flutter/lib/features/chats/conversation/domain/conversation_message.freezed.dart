// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConversationMessage {

 ConversationScope get scope; int? get serverMessageId; String? get localMessageId; String get clientGeneratedId; Sender get sender; String? get message; String get messageType; StickerSummary? get sticker; DateTime? get createdAt; bool get isEdited; bool get isDeleted; int? get replyRootId; bool get hasAttachments; ReplyToMessage? get replyToMessage; List<AttachmentItem> get attachments; List<ReactionSummary> get reactions; List<MentionInfo> get mentions; ThreadInfo? get threadInfo; ConversationDeliveryState get deliveryState;
/// Create a copy of ConversationMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationMessageCopyWith<ConversationMessage> get copyWith => _$ConversationMessageCopyWithImpl<ConversationMessage>(this as ConversationMessage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationMessage&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.serverMessageId, serverMessageId) || other.serverMessageId == serverMessageId)&&(identical(other.localMessageId, localMessageId) || other.localMessageId == localMessageId)&&(identical(other.clientGeneratedId, clientGeneratedId) || other.clientGeneratedId == clientGeneratedId)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.message, message) || other.message == message)&&(identical(other.messageType, messageType) || other.messageType == messageType)&&(identical(other.sticker, sticker) || other.sticker == sticker)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isEdited, isEdited) || other.isEdited == isEdited)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.replyRootId, replyRootId) || other.replyRootId == replyRootId)&&(identical(other.hasAttachments, hasAttachments) || other.hasAttachments == hasAttachments)&&(identical(other.replyToMessage, replyToMessage) || other.replyToMessage == replyToMessage)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&const DeepCollectionEquality().equals(other.reactions, reactions)&&const DeepCollectionEquality().equals(other.mentions, mentions)&&(identical(other.threadInfo, threadInfo) || other.threadInfo == threadInfo)&&(identical(other.deliveryState, deliveryState) || other.deliveryState == deliveryState));
}


@override
int get hashCode => Object.hashAll([runtimeType,scope,serverMessageId,localMessageId,clientGeneratedId,sender,message,messageType,sticker,createdAt,isEdited,isDeleted,replyRootId,hasAttachments,replyToMessage,const DeepCollectionEquality().hash(attachments),const DeepCollectionEquality().hash(reactions),const DeepCollectionEquality().hash(mentions),threadInfo,deliveryState]);

@override
String toString() {
  return 'ConversationMessage(scope: $scope, serverMessageId: $serverMessageId, localMessageId: $localMessageId, clientGeneratedId: $clientGeneratedId, sender: $sender, message: $message, messageType: $messageType, sticker: $sticker, createdAt: $createdAt, isEdited: $isEdited, isDeleted: $isDeleted, replyRootId: $replyRootId, hasAttachments: $hasAttachments, replyToMessage: $replyToMessage, attachments: $attachments, reactions: $reactions, mentions: $mentions, threadInfo: $threadInfo, deliveryState: $deliveryState)';
}


}

/// @nodoc
abstract mixin class $ConversationMessageCopyWith<$Res>  {
  factory $ConversationMessageCopyWith(ConversationMessage value, $Res Function(ConversationMessage) _then) = _$ConversationMessageCopyWithImpl;
@useResult
$Res call({
 ConversationScope scope, int? serverMessageId, String? localMessageId, String clientGeneratedId, Sender sender, String? message, String messageType, StickerSummary? sticker, DateTime? createdAt, bool isEdited, bool isDeleted, int? replyRootId, bool hasAttachments, ReplyToMessage? replyToMessage, List<AttachmentItem> attachments, List<ReactionSummary> reactions, List<MentionInfo> mentions, ThreadInfo? threadInfo, ConversationDeliveryState deliveryState
});


$ConversationScopeCopyWith<$Res> get scope;$SenderCopyWith<$Res> get sender;$StickerSummaryCopyWith<$Res>? get sticker;$ReplyToMessageCopyWith<$Res>? get replyToMessage;$ThreadInfoCopyWith<$Res>? get threadInfo;

}
/// @nodoc
class _$ConversationMessageCopyWithImpl<$Res>
    implements $ConversationMessageCopyWith<$Res> {
  _$ConversationMessageCopyWithImpl(this._self, this._then);

  final ConversationMessage _self;
  final $Res Function(ConversationMessage) _then;

/// Create a copy of ConversationMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scope = null,Object? serverMessageId = freezed,Object? localMessageId = freezed,Object? clientGeneratedId = null,Object? sender = null,Object? message = freezed,Object? messageType = null,Object? sticker = freezed,Object? createdAt = freezed,Object? isEdited = null,Object? isDeleted = null,Object? replyRootId = freezed,Object? hasAttachments = null,Object? replyToMessage = freezed,Object? attachments = null,Object? reactions = null,Object? mentions = null,Object? threadInfo = freezed,Object? deliveryState = null,}) {
  return _then(_self.copyWith(
scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as ConversationScope,serverMessageId: freezed == serverMessageId ? _self.serverMessageId : serverMessageId // ignore: cast_nullable_to_non_nullable
as int?,localMessageId: freezed == localMessageId ? _self.localMessageId : localMessageId // ignore: cast_nullable_to_non_nullable
as String?,clientGeneratedId: null == clientGeneratedId ? _self.clientGeneratedId : clientGeneratedId // ignore: cast_nullable_to_non_nullable
as String,sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as Sender,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,messageType: null == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as String,sticker: freezed == sticker ? _self.sticker : sticker // ignore: cast_nullable_to_non_nullable
as StickerSummary?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isEdited: null == isEdited ? _self.isEdited : isEdited // ignore: cast_nullable_to_non_nullable
as bool,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,replyRootId: freezed == replyRootId ? _self.replyRootId : replyRootId // ignore: cast_nullable_to_non_nullable
as int?,hasAttachments: null == hasAttachments ? _self.hasAttachments : hasAttachments // ignore: cast_nullable_to_non_nullable
as bool,replyToMessage: freezed == replyToMessage ? _self.replyToMessage : replyToMessage // ignore: cast_nullable_to_non_nullable
as ReplyToMessage?,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<AttachmentItem>,reactions: null == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as List<ReactionSummary>,mentions: null == mentions ? _self.mentions : mentions // ignore: cast_nullable_to_non_nullable
as List<MentionInfo>,threadInfo: freezed == threadInfo ? _self.threadInfo : threadInfo // ignore: cast_nullable_to_non_nullable
as ThreadInfo?,deliveryState: null == deliveryState ? _self.deliveryState : deliveryState // ignore: cast_nullable_to_non_nullable
as ConversationDeliveryState,
  ));
}
/// Create a copy of ConversationMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationScopeCopyWith<$Res> get scope {
  
  return $ConversationScopeCopyWith<$Res>(_self.scope, (value) {
    return _then(_self.copyWith(scope: value));
  });
}/// Create a copy of ConversationMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SenderCopyWith<$Res> get sender {
  
  return $SenderCopyWith<$Res>(_self.sender, (value) {
    return _then(_self.copyWith(sender: value));
  });
}/// Create a copy of ConversationMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StickerSummaryCopyWith<$Res>? get sticker {
    if (_self.sticker == null) {
    return null;
  }

  return $StickerSummaryCopyWith<$Res>(_self.sticker!, (value) {
    return _then(_self.copyWith(sticker: value));
  });
}/// Create a copy of ConversationMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReplyToMessageCopyWith<$Res>? get replyToMessage {
    if (_self.replyToMessage == null) {
    return null;
  }

  return $ReplyToMessageCopyWith<$Res>(_self.replyToMessage!, (value) {
    return _then(_self.copyWith(replyToMessage: value));
  });
}/// Create a copy of ConversationMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ThreadInfoCopyWith<$Res>? get threadInfo {
    if (_self.threadInfo == null) {
    return null;
  }

  return $ThreadInfoCopyWith<$Res>(_self.threadInfo!, (value) {
    return _then(_self.copyWith(threadInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [ConversationMessage].
extension ConversationMessagePatterns on ConversationMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationMessage value)  $default,){
final _that = this;
switch (_that) {
case _ConversationMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ConversationScope scope,  int? serverMessageId,  String? localMessageId,  String clientGeneratedId,  Sender sender,  String? message,  String messageType,  StickerSummary? sticker,  DateTime? createdAt,  bool isEdited,  bool isDeleted,  int? replyRootId,  bool hasAttachments,  ReplyToMessage? replyToMessage,  List<AttachmentItem> attachments,  List<ReactionSummary> reactions,  List<MentionInfo> mentions,  ThreadInfo? threadInfo,  ConversationDeliveryState deliveryState)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationMessage() when $default != null:
return $default(_that.scope,_that.serverMessageId,_that.localMessageId,_that.clientGeneratedId,_that.sender,_that.message,_that.messageType,_that.sticker,_that.createdAt,_that.isEdited,_that.isDeleted,_that.replyRootId,_that.hasAttachments,_that.replyToMessage,_that.attachments,_that.reactions,_that.mentions,_that.threadInfo,_that.deliveryState);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ConversationScope scope,  int? serverMessageId,  String? localMessageId,  String clientGeneratedId,  Sender sender,  String? message,  String messageType,  StickerSummary? sticker,  DateTime? createdAt,  bool isEdited,  bool isDeleted,  int? replyRootId,  bool hasAttachments,  ReplyToMessage? replyToMessage,  List<AttachmentItem> attachments,  List<ReactionSummary> reactions,  List<MentionInfo> mentions,  ThreadInfo? threadInfo,  ConversationDeliveryState deliveryState)  $default,) {final _that = this;
switch (_that) {
case _ConversationMessage():
return $default(_that.scope,_that.serverMessageId,_that.localMessageId,_that.clientGeneratedId,_that.sender,_that.message,_that.messageType,_that.sticker,_that.createdAt,_that.isEdited,_that.isDeleted,_that.replyRootId,_that.hasAttachments,_that.replyToMessage,_that.attachments,_that.reactions,_that.mentions,_that.threadInfo,_that.deliveryState);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ConversationScope scope,  int? serverMessageId,  String? localMessageId,  String clientGeneratedId,  Sender sender,  String? message,  String messageType,  StickerSummary? sticker,  DateTime? createdAt,  bool isEdited,  bool isDeleted,  int? replyRootId,  bool hasAttachments,  ReplyToMessage? replyToMessage,  List<AttachmentItem> attachments,  List<ReactionSummary> reactions,  List<MentionInfo> mentions,  ThreadInfo? threadInfo,  ConversationDeliveryState deliveryState)?  $default,) {final _that = this;
switch (_that) {
case _ConversationMessage() when $default != null:
return $default(_that.scope,_that.serverMessageId,_that.localMessageId,_that.clientGeneratedId,_that.sender,_that.message,_that.messageType,_that.sticker,_that.createdAt,_that.isEdited,_that.isDeleted,_that.replyRootId,_that.hasAttachments,_that.replyToMessage,_that.attachments,_that.reactions,_that.mentions,_that.threadInfo,_that.deliveryState);case _:
  return null;

}
}

}

/// @nodoc


class _ConversationMessage extends ConversationMessage {
  const _ConversationMessage({required this.scope, this.serverMessageId, this.localMessageId, required this.clientGeneratedId, required this.sender, this.message, this.messageType = 'text', this.sticker, this.createdAt, this.isEdited = false, this.isDeleted = false, this.replyRootId, this.hasAttachments = false, this.replyToMessage, final  List<AttachmentItem> attachments = const [], final  List<ReactionSummary> reactions = const [], final  List<MentionInfo> mentions = const [], this.threadInfo, this.deliveryState = ConversationDeliveryState.sent}): _attachments = attachments,_reactions = reactions,_mentions = mentions,super._();
  

@override final  ConversationScope scope;
@override final  int? serverMessageId;
@override final  String? localMessageId;
@override final  String clientGeneratedId;
@override final  Sender sender;
@override final  String? message;
@override@JsonKey() final  String messageType;
@override final  StickerSummary? sticker;
@override final  DateTime? createdAt;
@override@JsonKey() final  bool isEdited;
@override@JsonKey() final  bool isDeleted;
@override final  int? replyRootId;
@override@JsonKey() final  bool hasAttachments;
@override final  ReplyToMessage? replyToMessage;
 final  List<AttachmentItem> _attachments;
@override@JsonKey() List<AttachmentItem> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}

 final  List<ReactionSummary> _reactions;
@override@JsonKey() List<ReactionSummary> get reactions {
  if (_reactions is EqualUnmodifiableListView) return _reactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reactions);
}

 final  List<MentionInfo> _mentions;
@override@JsonKey() List<MentionInfo> get mentions {
  if (_mentions is EqualUnmodifiableListView) return _mentions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mentions);
}

@override final  ThreadInfo? threadInfo;
@override@JsonKey() final  ConversationDeliveryState deliveryState;

/// Create a copy of ConversationMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationMessageCopyWith<_ConversationMessage> get copyWith => __$ConversationMessageCopyWithImpl<_ConversationMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationMessage&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.serverMessageId, serverMessageId) || other.serverMessageId == serverMessageId)&&(identical(other.localMessageId, localMessageId) || other.localMessageId == localMessageId)&&(identical(other.clientGeneratedId, clientGeneratedId) || other.clientGeneratedId == clientGeneratedId)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.message, message) || other.message == message)&&(identical(other.messageType, messageType) || other.messageType == messageType)&&(identical(other.sticker, sticker) || other.sticker == sticker)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isEdited, isEdited) || other.isEdited == isEdited)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.replyRootId, replyRootId) || other.replyRootId == replyRootId)&&(identical(other.hasAttachments, hasAttachments) || other.hasAttachments == hasAttachments)&&(identical(other.replyToMessage, replyToMessage) || other.replyToMessage == replyToMessage)&&const DeepCollectionEquality().equals(other._attachments, _attachments)&&const DeepCollectionEquality().equals(other._reactions, _reactions)&&const DeepCollectionEquality().equals(other._mentions, _mentions)&&(identical(other.threadInfo, threadInfo) || other.threadInfo == threadInfo)&&(identical(other.deliveryState, deliveryState) || other.deliveryState == deliveryState));
}


@override
int get hashCode => Object.hashAll([runtimeType,scope,serverMessageId,localMessageId,clientGeneratedId,sender,message,messageType,sticker,createdAt,isEdited,isDeleted,replyRootId,hasAttachments,replyToMessage,const DeepCollectionEquality().hash(_attachments),const DeepCollectionEquality().hash(_reactions),const DeepCollectionEquality().hash(_mentions),threadInfo,deliveryState]);

@override
String toString() {
  return 'ConversationMessage(scope: $scope, serverMessageId: $serverMessageId, localMessageId: $localMessageId, clientGeneratedId: $clientGeneratedId, sender: $sender, message: $message, messageType: $messageType, sticker: $sticker, createdAt: $createdAt, isEdited: $isEdited, isDeleted: $isDeleted, replyRootId: $replyRootId, hasAttachments: $hasAttachments, replyToMessage: $replyToMessage, attachments: $attachments, reactions: $reactions, mentions: $mentions, threadInfo: $threadInfo, deliveryState: $deliveryState)';
}


}

/// @nodoc
abstract mixin class _$ConversationMessageCopyWith<$Res> implements $ConversationMessageCopyWith<$Res> {
  factory _$ConversationMessageCopyWith(_ConversationMessage value, $Res Function(_ConversationMessage) _then) = __$ConversationMessageCopyWithImpl;
@override @useResult
$Res call({
 ConversationScope scope, int? serverMessageId, String? localMessageId, String clientGeneratedId, Sender sender, String? message, String messageType, StickerSummary? sticker, DateTime? createdAt, bool isEdited, bool isDeleted, int? replyRootId, bool hasAttachments, ReplyToMessage? replyToMessage, List<AttachmentItem> attachments, List<ReactionSummary> reactions, List<MentionInfo> mentions, ThreadInfo? threadInfo, ConversationDeliveryState deliveryState
});


@override $ConversationScopeCopyWith<$Res> get scope;@override $SenderCopyWith<$Res> get sender;@override $StickerSummaryCopyWith<$Res>? get sticker;@override $ReplyToMessageCopyWith<$Res>? get replyToMessage;@override $ThreadInfoCopyWith<$Res>? get threadInfo;

}
/// @nodoc
class __$ConversationMessageCopyWithImpl<$Res>
    implements _$ConversationMessageCopyWith<$Res> {
  __$ConversationMessageCopyWithImpl(this._self, this._then);

  final _ConversationMessage _self;
  final $Res Function(_ConversationMessage) _then;

/// Create a copy of ConversationMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scope = null,Object? serverMessageId = freezed,Object? localMessageId = freezed,Object? clientGeneratedId = null,Object? sender = null,Object? message = freezed,Object? messageType = null,Object? sticker = freezed,Object? createdAt = freezed,Object? isEdited = null,Object? isDeleted = null,Object? replyRootId = freezed,Object? hasAttachments = null,Object? replyToMessage = freezed,Object? attachments = null,Object? reactions = null,Object? mentions = null,Object? threadInfo = freezed,Object? deliveryState = null,}) {
  return _then(_ConversationMessage(
scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as ConversationScope,serverMessageId: freezed == serverMessageId ? _self.serverMessageId : serverMessageId // ignore: cast_nullable_to_non_nullable
as int?,localMessageId: freezed == localMessageId ? _self.localMessageId : localMessageId // ignore: cast_nullable_to_non_nullable
as String?,clientGeneratedId: null == clientGeneratedId ? _self.clientGeneratedId : clientGeneratedId // ignore: cast_nullable_to_non_nullable
as String,sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as Sender,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,messageType: null == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as String,sticker: freezed == sticker ? _self.sticker : sticker // ignore: cast_nullable_to_non_nullable
as StickerSummary?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isEdited: null == isEdited ? _self.isEdited : isEdited // ignore: cast_nullable_to_non_nullable
as bool,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,replyRootId: freezed == replyRootId ? _self.replyRootId : replyRootId // ignore: cast_nullable_to_non_nullable
as int?,hasAttachments: null == hasAttachments ? _self.hasAttachments : hasAttachments // ignore: cast_nullable_to_non_nullable
as bool,replyToMessage: freezed == replyToMessage ? _self.replyToMessage : replyToMessage // ignore: cast_nullable_to_non_nullable
as ReplyToMessage?,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<AttachmentItem>,reactions: null == reactions ? _self._reactions : reactions // ignore: cast_nullable_to_non_nullable
as List<ReactionSummary>,mentions: null == mentions ? _self._mentions : mentions // ignore: cast_nullable_to_non_nullable
as List<MentionInfo>,threadInfo: freezed == threadInfo ? _self.threadInfo : threadInfo // ignore: cast_nullable_to_non_nullable
as ThreadInfo?,deliveryState: null == deliveryState ? _self.deliveryState : deliveryState // ignore: cast_nullable_to_non_nullable
as ConversationDeliveryState,
  ));
}

/// Create a copy of ConversationMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationScopeCopyWith<$Res> get scope {
  
  return $ConversationScopeCopyWith<$Res>(_self.scope, (value) {
    return _then(_self.copyWith(scope: value));
  });
}/// Create a copy of ConversationMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SenderCopyWith<$Res> get sender {
  
  return $SenderCopyWith<$Res>(_self.sender, (value) {
    return _then(_self.copyWith(sender: value));
  });
}/// Create a copy of ConversationMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StickerSummaryCopyWith<$Res>? get sticker {
    if (_self.sticker == null) {
    return null;
  }

  return $StickerSummaryCopyWith<$Res>(_self.sticker!, (value) {
    return _then(_self.copyWith(sticker: value));
  });
}/// Create a copy of ConversationMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReplyToMessageCopyWith<$Res>? get replyToMessage {
    if (_self.replyToMessage == null) {
    return null;
  }

  return $ReplyToMessageCopyWith<$Res>(_self.replyToMessage!, (value) {
    return _then(_self.copyWith(replyToMessage: value));
  });
}/// Create a copy of ConversationMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ThreadInfoCopyWith<$Res>? get threadInfo {
    if (_self.threadInfo == null) {
    return null;
  }

  return $ThreadInfoCopyWith<$Res>(_self.threadInfo!, (value) {
    return _then(_self.copyWith(threadInfo: value));
  });
}
}

// dart format on
