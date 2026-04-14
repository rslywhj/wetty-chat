import { useEffect, useRef, useState } from 'react';
import { IonIcon } from '@ionic/react';
import { play, volumeMute } from 'ionicons/icons';
import styles from '../ChatBubble.module.scss';
import type { CSSProperties } from 'react';

interface VideoPreviewProps {
  src: string;
  className?: string;
  style?: CSSProperties;
  onLoaded?: (el: HTMLVideoElement) => void;
  autoPlay?: boolean;
  showPlayButton?: boolean;
}

export function VideoPreview({
  src,
  className,
  style,
  onLoaded,
  autoPlay = true,
  showPlayButton = false,
}: VideoPreviewProps) {
  const videoRef = useRef<HTMLVideoElement | null>(null);
  const [remaining, setRemaining] = useState<number | null>(null);

  useEffect(() => {
    const video = videoRef.current;
    if (!video) return;

    const updateRemaining = () => {
      const dur = video.duration;
      const currentTime = video.currentTime;
      if (!isFinite(dur) || dur <= 0 || !Number.isFinite(currentTime) || currentTime < 0) {
        setRemaining(null);
        return;
      }
      const rem = Math.max(0, Math.ceil(dur - currentTime));
      setRemaining(rem);
    };

    const onLoadedMeta = () => {
      onLoaded?.(video);
      updateRemaining();
    };

    video.addEventListener('loadedmetadata', onLoadedMeta);
    video.addEventListener('timeupdate', updateRemaining);

    updateRemaining();

    return () => {
      video.removeEventListener('loadedmetadata', onLoadedMeta);
      video.removeEventListener('timeupdate', updateRemaining);
    };
  }, [src, onLoaded]);

  function formatRemaining(rem: number | null) {
    if (rem == null || Number.isNaN(rem)) return '';
    const minutes = Math.floor(rem / 60);
    const seconds = rem % 60;
    return `${minutes}:${String(seconds).padStart(2, '0')}`;
  }

  const showRemaining = autoPlay && remaining != null;

  return (
    <div style={{ position: 'relative', width: '100%', height: '100%', ...style }}>
      <video
        ref={videoRef}
        autoPlay={autoPlay}
        loop={autoPlay}
        muted
        playsInline
        src={src}
        className={className}
        style={{ width: '100%', height: '100%' }}
      />
      {showPlayButton && (
        <span className={styles.videoPlayButton} aria-hidden>
          <IonIcon icon={play} />
        </span>
      )}
      {showRemaining && (
        <span className={styles.mediaRemaining} aria-hidden>
          <span>{formatRemaining(remaining)}</span>
          <IonIcon icon={volumeMute} className={styles.remainingMuteIcon} />
        </span>
      )}
    </div>
  );
}
