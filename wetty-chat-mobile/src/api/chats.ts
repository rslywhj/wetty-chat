import type { AxiosResponse } from 'axios';
import apiClient from './client';

export interface ChatListItem {
  id: string;
  name: string | null;
  last_message_at: string | null;
}

interface ListChatsResponse {
  chats: ChatListItem[];
  next_cursor: string | null;
}

interface CreateChatResponse {
  id: string;
  name: string | null;
  created_at: string;
}

export function getChats(params: { limit?: number; after?: string } = {}): Promise<AxiosResponse<ListChatsResponse>> {
  return apiClient.get('/chats', { params });
}

export function createChat(body: { name?: string } = {}): Promise<AxiosResponse<CreateChatResponse>> {
  return apiClient.post('/chats', body);
}
