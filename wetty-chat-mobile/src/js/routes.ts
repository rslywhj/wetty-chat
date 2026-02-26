import type { Router } from 'framework7/types';

import NotFoundPage from '@/pages/404';
import ChatsPage from '@/pages/chats';
import CreateChatPage from '@/pages/create-chat';
import ChatThreadPage from '@/pages/chat-thread';

const routes: Router.RouteParameters[] = [
  {
    path: '/',
    component: ChatsPage,
  },
  {
    path: '/chats/',
    component: ChatsPage,
  },
  {
    path: '/chats/new/',
    component: CreateChatPage,
  },
  {
    path: '/chats/:id/',
    component: ChatThreadPage,
  },
  {
    path: '(.*)',
    component: NotFoundPage,
  },
];

export default routes;
