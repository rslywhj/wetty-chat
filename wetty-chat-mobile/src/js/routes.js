
import NotFoundPage from '@/pages/404.jsx';
import ChatsPage from '@/pages/chats.jsx';

var routes = [
  {
    path: '/',
    component: ChatsPage,
  },
  {
    path: '/chats/',
    component: ChatsPage,
  },
  {
    path: '(.*)',
    component: NotFoundPage,
  },
];

export default routes;
