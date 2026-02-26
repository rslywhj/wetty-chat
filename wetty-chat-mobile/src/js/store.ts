import { createStore } from 'framework7/lite';
import type { MessageResponse } from '@/api/messages';

const store = createStore({
  state: {
    wsConnected: true,
    products: [
      {
        id: '1',
        title: 'Apple iPhone 8',
        description: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nisi tempora similique reiciendis, error nesciunt vero, blanditiis pariatur dolor, minima sed sapiente rerum, dolorem corrupti hic modi praesentium unde saepe perspiciatis.'
      },
      {
        id: '2',
        title: 'Apple iPhone 8 Plus',
        description: 'Velit odit autem modi saepe ratione totam minus, aperiam, labore quia provident temporibus quasi est ut aliquid blanditiis beatae suscipit odio vel! Nostrum porro sunt sint eveniet maiores, dolorem itaque!'
      },
      {
        id: '3',
        title: 'Apple iPhone X',
        description: 'Expedita sequi perferendis quod illum pariatur aliquam, alias laboriosam! Vero blanditiis placeat, mollitia necessitatibus reprehenderit. Labore dolores amet quos, accusamus earum asperiores officiis assumenda optio architecto quia neque, quae eum.'
      },
    ],
    messagesByChat: {} as Record<string, MessageResponse[]>,
    nextCursorByChat: {} as Record<string, string | null>,
  },
  getters: {
    products({ state }) {
      return state.products;
    },
    getMessagesForChat({ state }) {
      return (chatId: string) => state.messagesByChat[chatId] ?? [];
    },
    getNextCursorForChat({ state }) {
      return (chatId: string) => state.nextCursorByChat[chatId] ?? null;
    },
  },
  actions: {
    setWsConnected({ state }, value: boolean) {
      state.wsConnected = value;
      if (typeof window !== 'undefined') {
        window.dispatchEvent(new CustomEvent('ws-connection-change', { detail: { connected: value } }));
      }
    },
    addProduct({ state }, product) {
      state.products = [...state.products, product];
    },
    setMessagesForChat({ state }, { chatId, messages }: { chatId: string; messages: MessageResponse[] }) {
      state.messagesByChat = { ...state.messagesByChat, [chatId]: messages };
      emitMessagesChanged(chatId);
    },
    setNextCursorForChat({ state }, { chatId, cursor }: { chatId: string; cursor: string | null }) {
      state.nextCursorByChat = { ...state.nextCursorByChat, [chatId]: cursor };
    },
    addMessage({ state }, { chatId, message }: { chatId: string; message: MessageResponse }) {
      const list = state.messagesByChat[chatId] ?? [];
      state.messagesByChat = { ...state.messagesByChat, [chatId]: [...list, message] };
      emitMessagesChanged(chatId);
    },
    prependMessages({ state }, { chatId, messages }: { chatId: string; messages: MessageResponse[] }) {
      const list = state.messagesByChat[chatId] ?? [];
      state.messagesByChat = { ...state.messagesByChat, [chatId]: [...messages, ...list] };
      emitMessagesChanged(chatId);
    },
    confirmPendingMessage(
      { state },
      { chatId, clientGeneratedId, message }: { chatId: string; clientGeneratedId: string; message: MessageResponse }
    ) {
      const list = state.messagesByChat[chatId] ?? [];
      const next = list.map((m) =>
        m.client_generated_id === clientGeneratedId ? message : m
      );
      state.messagesByChat = { ...state.messagesByChat, [chatId]: next };
      emitMessagesChanged(chatId);
    },
  },
});
export default store;

function emitMessagesChanged(chatId: string): void {
  if (typeof window !== 'undefined') {
    window.dispatchEvent(new CustomEvent('store-messages-changed', { detail: { chatId } }));
  }
}
