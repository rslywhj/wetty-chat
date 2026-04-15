import { IonButton, IonButtons, IonContent, IonHeader, IonIcon, IonModal, IonTitle, IonToolbar } from '@ionic/react';
import { close } from 'ionicons/icons';
import { t } from '@lingui/core/macro';
import { Trans } from '@lingui/react/macro';
import type { MemberSummary } from '@/api/users';
import { MemberSelector } from '@/components/member-selector/MemberSelector';
import styles from './ShareInviteModal.module.scss';

interface ShareInviteMemberSelectorModalProps {
  isOpen: boolean;
  isDesktop: boolean;
  chatId: string;
  onDismiss: () => void;
  onSelect: (member: MemberSummary) => void;
}

export function ShareInviteMemberSelectorModal({
  isOpen,
  isDesktop,
  chatId,
  onDismiss,
  onSelect,
}: ShareInviteMemberSelectorModalProps) {
  return (
    <IonModal
      isOpen={isOpen}
      onDidDismiss={onDismiss}
      {...(!isDesktop ? { initialBreakpoint: 0.92, breakpoints: [0, 0.92] } : {})}
    >
      <IonHeader>
        <IonToolbar>
          <IonTitle>
            <Trans>Select User</Trans>
          </IonTitle>
          <IonButtons slot="end">
            <IonButton onClick={onDismiss} aria-label={t`Close`}>
              <IonIcon slot="icon-only" icon={close} />
            </IonButton>
          </IonButtons>
        </IonToolbar>
      </IonHeader>
      <IonContent color="light" className={styles.selectorModalContent}>
        <div className={styles.selectorBody}>
          <MemberSelector excludeMemberOf={chatId} onSelect={onSelect} />
        </div>
      </IonContent>
    </IonModal>
  );
}
