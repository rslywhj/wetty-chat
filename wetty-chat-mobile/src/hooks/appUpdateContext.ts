import { createContext } from 'react';

export type CheckForUpdateResult = 'update-found' | 'no-update' | 'no-service-worker' | 'failed';

export interface AppUpdateContextValue {
  needRefresh: boolean;
  setNeedRefresh: (value: boolean) => void;
  updateServiceWorker: (reloadPage?: boolean) => Promise<void>;
  checkingForUpdate: boolean;
  checkForUpdate: () => Promise<CheckForUpdateResult>;
}

export const AppUpdateContext = createContext<AppUpdateContextValue | null>(null);
