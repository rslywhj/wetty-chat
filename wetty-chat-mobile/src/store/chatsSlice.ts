import { createSlice } from '@reduxjs/toolkit';
import type { PayloadAction } from '@reduxjs/toolkit';
import type { RootState } from './index';

export interface ChatMeta {
  name: string | null;
  description?: string | null;
  avatar?: string | null;
  visibility?: string;
  created_at?: string;
}

export interface ChatsState {
  byId: Record<string, ChatMeta>;
}

const initialState: ChatsState = {
  byId: {},
};

const chatsSlice = createSlice({
  name: 'chats',
  initialState,
  reducers: {
    setChatMeta(state, action: PayloadAction<{ chatId: string; meta: ChatMeta }>) {
      const existing = state.byId[action.payload.chatId];
      state.byId[action.payload.chatId] = existing
        ? { ...existing, ...action.payload.meta }
        : action.payload.meta;
    },
    setChatsMeta(state, action: PayloadAction<Record<string, ChatMeta>>) {
      for (const [chatId, meta] of Object.entries(action.payload)) {
        const existing = state.byId[chatId];
        state.byId[chatId] = existing ? { ...existing, ...meta } : meta;
      }
    },
  },
});

export const { setChatMeta, setChatsMeta } = chatsSlice.actions;
export const selectChatMeta = (state: RootState, chatId: string): ChatMeta | undefined =>
  state.chats.byId[chatId];
export const selectChatName = (state: RootState, chatId: string): string | null =>
  state.chats.byId[chatId]?.name ?? null;
export default chatsSlice.reducer;
