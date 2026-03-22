import {
  IonApp,
  IonToast,
  setupIonicReact,
} from '@ionic/react';
import { IonReactRouter } from '@ionic/react-router';
import { Redirect, useRouteMatch } from 'react-router-dom';
import { useDispatch } from 'react-redux';
import { useEffect } from 'react';
import type { AppDispatch } from '@/store/index';
import { fetchCurrentUser, setUser } from '@/store/userSlice';
import Cookies from 'js-cookie';

import './app.scss';
import { getCurrentUserId } from './js/current-user';
import { t } from '@lingui/core/macro';
import MobileLayout from './layouts/MobileLayout';
import { AppUpdateProvider } from './hooks/AppUpdateProvider';
import { useIsDesktop } from './hooks/useIsDesktop';
import { useAppLifecycle } from './hooks/useAppLifecycle';
import { useAppUpdate } from './hooks/useAppUpdate';
import { DesktopSplitLayout } from './layouts/DesktopSplitLayout';
import OobePage from '@/pages/oobe';
import LandingPage from './pages/landing';
import { initWebSocket } from '@/api/ws';
import { useDeviceToken } from './hooks/useDeviceToken';

setupIonicReact({
  mode: 'ios',
});

const OOBE_STORAGE_KEY = 'oobe';

function hasCompletedOobe() {
  return localStorage.getItem(OOBE_STORAGE_KEY) !== null;
}

function AppRouter({ isDesktop }: { isDesktop: boolean }) {
  const isOobeRoute = useRouteMatch('/oobe');
  const isLandingRoute = useRouteMatch('/landing');

  if (isLandingRoute?.isExact) {
    return <LandingPage />;
  } else if (isOobeRoute?.isExact) {
    return <OobePage />;
  } else if (!hasCompletedOobe()) {
    return <Redirect to="/oobe" />;
  }

  return isDesktop ? <DesktopSplitLayout /> : <MobileLayout />;
}

function AppShell() {
  const dispatch = useDispatch<AppDispatch>();
  const deviceToken = useDeviceToken();
  const isDesktop = useIsDesktop();
  useAppLifecycle();
  const { needRefresh, setNeedRefresh, updateServiceWorker } = useAppUpdate();

  // Refresh token on app launch
  useEffect(() => {
    const storedDeviceToken = Cookies.get('device_token');
    if (storedDeviceToken === deviceToken && deviceToken !== '') {
      Cookies.set('device_token', deviceToken, {path: '/', expires: 365});
    }
  }, [deviceToken, document.cookie]);

  useEffect(() => {
    initWebSocket();
    if (import.meta.env.DEV) {
      dispatch(setUser({ uid: getCurrentUserId(), username: 'Development User', avatar_url: null }));
    }
    dispatch(fetchCurrentUser());
  }, [dispatch]);

  return (
    <IonApp>
      <IonToast
        isOpen={needRefresh}
        message={t`A new version of the app is available!`}
        position="bottom"
        duration={0}
        buttons={[
          {
            text: t`Update Now`,
            role: 'info',
            handler: () => updateServiceWorker(true)
          },
          {
            text: t`Dismiss`,
            role: 'cancel',
            handler: () => setNeedRefresh(false)
          }
        ]}
      />
      <div className="app-router-shell">
        <IonReactRouter basename={import.meta.env.BASE_URL}>
          <AppRouter isDesktop={isDesktop} />
        </IonReactRouter>
      </div>
    </IonApp>
  );
}

const App: React.FC = () => {
  return (
    <AppUpdateProvider>
      <AppShell />
    </AppUpdateProvider>
  );
};

export default App;
