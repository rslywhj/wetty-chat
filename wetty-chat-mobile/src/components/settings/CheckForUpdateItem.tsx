import { IonIcon, IonItem, IonLabel, IonSpinner, useIonToast } from '@ionic/react';
import { t } from '@lingui/core/macro';
import { Trans } from '@lingui/react/macro';
import { refreshCircle } from 'ionicons/icons';
import { useAppUpdate } from '@/hooks/useAppUpdate';

export function CheckForUpdateItem() {
  const [presentToast] = useIonToast();
  const { checkForUpdate, checkingForUpdate } = useAppUpdate();

  const handleCheckForUpdate = async () => {
    const result = await checkForUpdate();

    if (result === 'no-update') {
      presentToast({ message: t`Update check complete`, duration: 2000 });
      return;
    }

    if (result === 'no-service-worker') {
      presentToast({ message: t`No service worker registered`, duration: 2000 });
      return;
    }

    if (result === 'failed') {
      presentToast({ message: t`Update check failed`, duration: 2000 });
    }
  };

  return (
    <IonItem button detail={false} onClick={handleCheckForUpdate} disabled={checkingForUpdate}>
      {checkingForUpdate ? (
        <IonSpinner slot="start" name="crescent" color="secondary" />
      ) : (
        <IonIcon aria-hidden="true" icon={refreshCircle} slot="start" color="secondary" />
      )}
      <IonLabel color="primary">
        <Trans>Check for Update</Trans>
      </IonLabel>
    </IonItem>
  );
}
