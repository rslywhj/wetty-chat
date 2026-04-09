# Threads Feature Plan

## Summary
Implement threads in the Flutter app, modeled after the PWA (wetty-chat-mobile) implementation. The app already has foundational support: `ConversationScope.thread()`, thread-aware API paths, `replyRootId`/`threadInfo` on the message model, and a "N replies" badge on bubbles. The main work is the presentation and navigation layer, thread list, chat list tabbing, and real-time updates.

## Existing Backend Endpoints
Thread-related endpoints already consumed by the PWA:

- `GET /threads?limit=20&before=:cursor` — list subscribed threads (paginated)
- `GET /threads/unread` — total unread thread count
- `POST /threads/:threadRootId/read` — mark thread read up to message `{ messageId }`
- `PUT /chats/:chatId/threads/:threadRootId/subscribe` — subscribe to thread
- `DELETE /chats/:chatId/threads/:threadRootId/subscribe` — unsubscribe
- `GET /chats/:chatId/threads/:threadRootId/subscribe` — check subscription status
- `GET /chats/:chatId/messages?threadId=:threadRootId` — fetch thread messages
- `POST /chats/:chatId/threads/:threadRootId/messages` — send thread message

## Existing Flutter Foundation
- `ConversationScope` (`lib/features/chats/conversation/domain/conversation_scope.dart`) has `.thread(chatId, threadRootId)` constructor
- `MessageApiService` builds thread-aware paths (`/chats/{chatId}/threads/{threadRootId}/messages`)
- `ConversationRepository` filters WS events by scope (chatId + threadRootId)
- `MessageItem.replyRootId` and `MessageItem.threadInfo` (with `replyCount`) exist
- `MessageBubbleContent` renders thread info badge when `replyCount > 0`
- `MessageRow` declares `onOpenThread` callback but `ChatDetailView` never passes it

## WebSocket Events
- Incoming messages with `replyRootId != null` are thread messages — route to thread scope
- `threadUpdate` event payload: `{ threadRootId, chatId, lastReplyAt, replyCount }` — used to bump thread list items

---

## Phase 1 — Core Thread Viewing

**Goal:** User can tap "N replies" on a message bubble and view/send messages in that thread.

### 1.1 Thread detail route
- Add route `/chats/:chatId/thread/:threadId` in `app_router.dart`
- Add route name constant in `route_names.dart`
- The route receives `chatId` and `threadId` path parameters

### 1.2 Thread detail page
- New widget: `lib/features/chats/conversation/presentation/thread_detail_view.dart`
- Reuse `ConversationScope.thread(chatId, threadRootId)` to get a separate repository/VM instance
- Pin the thread root message at the top (non-scrollable or as first item)
- Reuse the existing conversation timeline and composer widgets
- Thread composer should set `replyRootId` on sent messages

### 1.3 Wire onOpenThread in ChatDetailView
- In `chat_detail_view.dart`, pass `onOpenThread` callback to `MessageRow`
- Callback navigates to `/chats/:chatId/thread/:threadRootId` via GoRouter
- Only show the thread badge when NOT already in a thread view

### 1.4 Thread header
- Nav bar title: "Thread"
- Subtitle or context: parent chat name
- Back button returns to parent chat

---

## Phase 2 — Thread List

**Goal:** User can see all their subscribed threads in a dedicated list.

### 2.1 Thread list API service
- New file: `lib/features/chats/threads/data/thread_api_service.dart`
- Methods: `fetchThreads({limit, before})`, `fetchUnreadThreadCount()`, `markThreadAsRead(threadRootId, messageId)`
- Provider: `threadApiServiceProvider`

### 2.2 Thread list data models
- New file: `lib/features/chats/threads/models/thread_models.dart`
- `ThreadListItem`: chatId, chatName, chatAvatar, threadRootMessage (MessageItem), participants, lastReply (ThreadReplyPreview), replyCount, lastReplyAt, unreadCount, subscribedAt
- `ThreadReplyPreview`: sender, message, messageType, stickerEmoji, firstAttachmentKind, isDeleted, mentions
- `ThreadParticipant`: uid, name, avatarUrl
- DTO counterparts in `lib/features/chats/threads/models/thread_api_models.dart`

### 2.3 Thread list repository & provider
- New file: `lib/features/chats/threads/data/thread_repository.dart`
- `ThreadListNotifier` (Notifier): stores items, nextCursor, totalUnreadCount, hasMore
- Handles real-time updates (bump thread to top, update preview, increment unread)
- Provider: `threadListStateProvider`

### 2.4 Thread list view model
- New file: `lib/features/chats/threads/application/thread_list_view_model.dart`
- `ThreadListViewModel` (AsyncNotifier): exposes `ThreadListViewState` (threads, hasMore, isLoadingMore, isRefreshing)
- Methods: `loadMoreThreads()`, `refreshThreads()`
- Provider: `threadListViewModelProvider`

### 2.5 Thread list row widget
- New file: `lib/features/chats/threads/presentation/thread_list_row.dart`
- Displays: overlay avatar (chat + sender), root message preview, last reply sender/text, relative timestamp, unread count badge
- Tap navigates to thread detail route

### 2.6 Thread list page
- New file: `lib/features/chats/threads/presentation/thread_list_view.dart`
- Pull-to-refresh + infinite scroll
- Empty state: "No threads yet"
- Can be used standalone (full page) or embedded (in chat list tab)

---

## Phase 3 — Chat List Tabbing

**Goal:** Chat list has segmented tabs: optionally "All" | "Groups" | "Threads".

### 3.1 Segment control widget
- New file: `lib/features/chats/list/presentation/chat_list_segment.dart`
- `CupertinoSegmentedControl` with tab enum
- Each tab shows unread badge (count > 0, capped at 99+)
- Tabs adapt based on `showAllTab` setting:
  - Enabled: All | Groups | Threads
  - Disabled: Groups | Threads (no segment shown if only 2 tabs — or show segment with 2)

### 3.2 Chat list tab state
- Add tab enum: `ChatListTab { all, groups, threads }`
- Track `activeTab` in chat list view state or as local widget state
- Default tab: "All" if enabled, otherwise "Groups"

### 3.3 "Groups" tab
- Current chat list behavior, no change needed — just render existing list

### 3.4 "Threads" tab
- Embed the thread list widget from Phase 2
- Shares the same thread list provider

### 3.5 "All" tab — merged view
- Create `MergedListItem` union type: `group(ChatListItem, sortTime)` | `thread(ThreadListItem, sortTime)`
- Merge chats (by `lastMessageAt`) and threads (by `lastReplyAt`), sort descending
- Render the appropriate row widget per item type
- Memoize/cache the merged list, recompute on chat or thread list changes

### 3.6 Tab unread badges
- "All" badge = chat unread + thread unread (excluding muted chats)
- "Groups" badge = chat unread (excluding muted)
- "Threads" badge = thread total unread count

---

## Phase 4 — Settings: "All" Tab Toggle

### 4.1 Extend AppSettingsState
- Add `showAllTab` (bool, default `true`) to `AppSettingsState`
- Persist to SharedPreferences key `chat_list_show_all_tab`
- Add `setShowAllTab(bool)` method to `AppSettingsNotifier`

### 4.2 Settings UI
- Add "Chat" section in `SettingsView` (or add to existing "General" section)
- Row: "Show 'All' Tab" with `CupertinoSwitch`, reads/writes `appSettingsProvider`

### 4.3 Chat list reacts to setting
- `ChatPage` watches `appSettingsProvider` for `showAllTab`
- When toggled off: hide "All" segment, switch to "Groups" if currently on "All"
- When toggled on: show "All" segment, optionally switch to it

---

## Phase 5 — Subscriptions & Unread Tracking

### 5.1 Subscription API
- Add to thread API service: `subscribeToThread(chatId, threadRootId)`, `unsubscribeFromThread(chatId, threadRootId)`, `getThreadSubscriptionStatus(chatId, threadRootId)`

### 5.2 Subscription state
- Per-thread subscription status provider (family provider by threadRootId)
- Cache subscription status when entering thread detail

### 5.3 Subscription UI
- Bell icon in thread detail header bar
- Toggle subscribe/unsubscribe on tap
- Visual state: filled bell (subscribed) vs outline bell (not subscribed)

### 5.4 Mark thread as read
- On thread detail open / scroll to bottom, call `POST /threads/:threadRootId/read`
- Debounce (500ms cooldown)
- Update thread list item unread count to 0

### 5.5 Auto-subscribe on reply
- When user sends a message in a thread, auto-subscribe if not already subscribed
- Backend may handle this — verify behavior

---

## Phase 6 — Real-time Updates

### 6.1 WebSocket thread message routing
- In WS event handling, messages with `replyRootId` are routed to the thread-scoped repository
- Foundation exists: `ConversationRepository` already filters by scope
- Ensure thread list is also notified of new thread messages

### 6.2 threadUpdate WS event
- Add `ThreadUpdateWsEvent` model: `{ threadRootId, chatId, lastReplyAt, replyCount }`
- Handle in thread repository: bump thread to top of list, update reply count and timestamp
- If thread not known locally (new subscription), refresh thread list

### 6.3 Cached last reply preview
- When thread window is NOT loaded, cache the reply preview from WS events on the thread list item
- When thread window IS loaded, derive last reply from the live message list
- Thread list row picks the freshest source

---

## Phase 7 — Polish

### 7.1 Thread participants list
- Fetch participants from thread list item data
- Display in a bottom sheet or popover from thread header

### 7.2 Empty states
- Thread list: "No threads yet" with icon
- Thread tab: same empty state

### 7.3 Pull-to-refresh
- Thread list (standalone and embedded) supports pull-to-refresh

### 7.4 Infinite scroll
- Thread list loads 20 items per page, cursor-based pagination

---

## Deferred (Push Notifications Milestone)
- App icon badge including thread unreads
- Push notification routing to thread detail
