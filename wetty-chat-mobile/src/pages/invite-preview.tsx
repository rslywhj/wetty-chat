import { IonButtons, IonCard, IonCardContent, IonContent, IonHeader, IonPage, IonTitle, IonToolbar } from '@ionic/react';
import { Trans } from '@lingui/react/macro';
import { useHistory } from 'react-router-dom';
import { BackButton } from '@/components/BackButton';
import { InvitePreviewCard } from '@/components/invites/InvitePreviewCard';
import styles from './invite-preview.module.scss';

interface InvitePreviewPageProps {
  inviteCode: string;
}

export default function InvitePreviewPage({ inviteCode }: InvitePreviewPageProps) {
  const history = useHistory();

  return (
    <IonPage className={styles.page}>
      <IonHeader translucent={true}>
        <IonToolbar>
          <IonButtons slot="start">
            <BackButton action={{ type: 'back', defaultHref: '/chats' }} />
          </IonButtons>
          <IonTitle>
            <Trans>Invite</Trans>
          </IonTitle>
        </IonToolbar>
      </IonHeader>
      <IonContent>
        <IonCard className={styles.card}>
          <IonCardContent className={styles.cardContent}>
            <InvitePreviewCard
              inviteCode={inviteCode}
              onResolved={(chat) => history.replace(`/chats/chat/${chat.id}`)}
              onCancel={() => history.replace('/chats')}
            />
          </IonCardContent>
        </IonCard>
      </IonContent>
    </IonPage>
  );
}
