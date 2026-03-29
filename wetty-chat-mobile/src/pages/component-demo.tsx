import { IonContent, IonPage } from '@ionic/react';
import { AudioRecordButton } from '@/components/chat/compose/AudioRecordButton';
import styles from './component-demo.module.scss';

const ComponentDemoPage: React.FC = () => {
  return (
    <IonPage>
      <IonContent fullscreen className={styles.content}>
        <div className={styles.demo}>
          <AudioRecordButton
            onStart={() => console.log('AudioRecordButton start')}
            onCancel={() => console.log('AudioRecordButton cancel')}
            onComplete={() => console.log('AudioRecordButton complete')}
            onSend={() => console.log('AudioRecordButton send')}
          />
        </div>
      </IonContent>
    </IonPage>
  );
};

export default ComponentDemoPage;
