import { IonModal, IonContent, IonIcon } from '@ionic/react';
import { close } from 'ionicons/icons';
import { t } from '@lingui/core/macro';
import type { Sender } from '@/api/messages';
import { useIsDesktop } from '@/hooks/useIsDesktop';
import { UserAvatar } from '@/components/UserAvatar';
import { FeatureGate } from '../FeatureGate';

interface UserProfileModalProps {
  sender: Sender | null;
  onDismiss: () => void;
}

export function UserProfileModal({ sender, onDismiss }: UserProfileModalProps) {
  const isDesktop = useIsDesktop();
  const displayName = sender?.name ?? (sender ? `User ${sender.uid}` : '');

  return (
    <IonModal
      isOpen={sender != null}
      onDidDismiss={onDismiss}
      {...(!isDesktop ? { initialBreakpoint: 0.5, breakpoints: [0, 0.5] } : {})}
    >
      <IonContent className="ion-padding">
        <button
          onClick={onDismiss}
          aria-label={t`Close`}
          style={{
            position: 'absolute', top: 12, right: 12,
            background: 'var(--ion-color-light)', border: 'none', borderRadius: '50%',
            width: 32, height: 32, display: 'flex', alignItems: 'center', justifyContent: 'center',
            cursor: 'pointer', zIndex: 1,
          }}
        >
          <IonIcon icon={close} style={{ fontSize: 20 }} />
        </button>
        {sender && (
          <div style={{ textAlign: 'center', paddingTop: 24 }}>
            <UserAvatar
              name={displayName}
              avatarUrl={sender.avatar_url}
              size={80}
              style={{ display: 'inline-flex' }}
            />
            <h2>{displayName}</h2>
            <FeatureGate>
              <p style={{ color: 'var(--ion-color-medium)' }}>UID: {sender.uid}</p>
            </FeatureGate>
          </div>
        )}
      </IonContent>
    </IonModal>
  );
}
