import { type ImgHTMLAttributes, type SyntheticEvent, useEffect, useRef, useState } from 'react';
import { convertHeicSourceToJpegBlob, isHeicLikeMedia } from '@/utils/heicMedia';

interface DisplayableImageProps extends ImgHTMLAttributes<HTMLImageElement> {
  src: string;
  mimeType?: string | null;
  fileName?: string | null;
}

export function DisplayableImage({ src, mimeType, fileName, onError, ...imgProps }: DisplayableImageProps) {
  return (
    <DisplayableImageInner
      key={src}
      src={src}
      mimeType={mimeType}
      fileName={fileName}
      onError={onError}
      {...imgProps}
    />
  );
}

function DisplayableImageInner({ src, mimeType, fileName, onError, ...imgProps }: DisplayableImageProps) {
  const [displaySrc, setDisplaySrc] = useState(src);
  const [conversionAttempted, setConversionAttempted] = useState(false);
  const needsConversion = isHeicLikeMedia({ mimeType, fileName, url: src });
  const mountedRef = useRef(true);

  useEffect(() => {
    mountedRef.current = true;
    return () => {
      mountedRef.current = false;
    };
  }, []);

  const handleError = (event: SyntheticEvent<HTMLImageElement, Event>) => {
    if (!needsConversion || conversionAttempted) {
      onError?.(event);
      return;
    }

    setConversionAttempted(true);
    convertHeicSourceToJpegBlob(src)
      .then((blob) => {
        if (!mountedRef.current) return;
        const convertedUrl = URL.createObjectURL(blob);
        setDisplaySrc(convertedUrl);
      })
      .catch((error) => {
        console.warn('[media:heic] Failed to convert HEIC preview', {
          src,
          mimeType,
          fileName,
          error,
        });
        onError?.(event);
      });
  };

  useEffect(() => {
    if (displaySrc === src) return;
    return () => {
      URL.revokeObjectURL(displaySrc);
    };
  }, [displaySrc, src]);

  return <img {...imgProps} src={displaySrc} onError={handleError} />;
}
