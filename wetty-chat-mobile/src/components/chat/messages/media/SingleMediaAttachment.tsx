import { type ReactNode, type CSSProperties } from 'react';
import { MEDIA_CONSTANTS, getSingleMediaBounds } from './mediaConstants';
import type { Attachment } from '@/api/messages';

interface SingleMediaAttachmentProps {
  attachment: Attachment;
  interactive: boolean;
  onView: () => void;
  renderElement: (style?: CSSProperties) => ReactNode;
}

export function SingleMediaAttachment({ attachment, interactive, onView, renderElement }: SingleMediaAttachmentProps) {
  const { width, height, url } = attachment;
  const { MAX_WIDTH, MAX_HEIGHT, MIN_WIDTH, MIN_HEIGHT } = getSingleMediaBounds();
  const { BLUR_RADIUS } = MEDIA_CONSTANTS;

  // 如果没有宽高信息，fallback 为自动
  if (!width || !height) {
    return (
      <div
        style={{
          width: '100%',
          maxWidth: MAX_WIDTH,
          maxHeight: MAX_HEIGHT,
          aspectRatio: '1',
          position: 'relative',
          overflow: 'hidden',
          borderRadius: '12px',
        }}
        onClick={interactive ? onView : undefined}
      >
        {renderElement({ width: '100%', height: '100%', objectFit: 'contain' })}
      </div>
    );
  }

  const aspectRatio = width / height;

  // 初步计算长宽，采用 100% 宽度充满目前容器（受气泡 max-width 控制）
  // 以最大允许容器像素来预估是否需要裁切/模糊
  let calcWidth = MAX_WIDTH;
  let calcHeight = calcWidth / aspectRatio;

  // 是否需要截断或加背景填充
  const needsContain = calcHeight < MIN_HEIGHT || calcHeight > MAX_HEIGHT || calcWidth < MIN_WIDTH;

  let containerStyle: CSSProperties;

  // CSS响应式自适应设计：
  if (needsContain) {
    // 强制使用限制的高度并且填充原图的模糊背景
    if (calcHeight > MAX_HEIGHT) {
      calcHeight = MAX_HEIGHT;
      // 宽度不够 MIN_WIDTH 强制保底宽度
      if (calcHeight * aspectRatio < MIN_WIDTH) {
        calcWidth = MIN_WIDTH;
      } else {
        calcWidth = calcHeight * aspectRatio;
      }
    } else if (calcHeight < MIN_HEIGHT) {
      calcHeight = MIN_HEIGHT;
    }

    if (calcWidth > MAX_WIDTH) {
      calcWidth = MAX_WIDTH;
    } else if (calcWidth < MIN_WIDTH) {
      calcWidth = MIN_WIDTH;
    }

    // 如果受限，给予固定的像素尺寸以及包含背景滤镜
    containerStyle = {
      position: 'relative',
      width: calcWidth, // 如果是极窄图片，这个会撑起宽度
      height: calcHeight, // 如果是极度扁的图片，这个会撑高高度
      maxWidth: '100%',
      overflow: 'hidden',
      borderRadius: '12px',
      cursor: interactive ? 'pointer' : 'default',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      backgroundColor: '#000',
    };
  } else {
    // 全自适应：气泡有多宽，图片有多大
    containerStyle = {
      position: 'relative',
      width: '100%',
      maxWidth: MAX_WIDTH,
      aspectRatio: `${aspectRatio}`,
      overflow: 'hidden',
      borderRadius: '12px',
      cursor: interactive ? 'pointer' : 'default',
    };
  }

  const wrapElement = (
    <div
      style={containerStyle}
      onClick={
        interactive
          ? (e) => {
              e.stopPropagation();
              onView();
            }
          : undefined
      }
    >
      {needsContain && (
        <>
          <div
            style={{
              position: 'absolute',
              top: -20,
              right: -20,
              bottom: -20,
              left: -20,
              backgroundImage: `url(${url})`,
              backgroundSize: 'cover',
              backgroundPosition: 'center',
              filter: `blur(${BLUR_RADIUS})`,
              opacity: 0.8,
            }}
          />
          {/* Dark overlay */}
          <div
            style={{
              position: 'absolute',
              top: 0,
              right: 0,
              bottom: 0,
              left: 0,
              backgroundColor: `rgba(0,0,0,${MEDIA_CONSTANTS.BLUR_OVERLAY_OPACITY})`,
            }}
          />
        </>
      )}
      <div
        style={{
          position: 'relative',
          width: '100%',
          height: '100%',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
        }}
      >
        {renderElement({
          maxWidth: '100%',
          maxHeight: '100%',
          objectFit: needsContain ? 'contain' : 'cover', // 如果不溢出就 cover 以免白边
          display: 'block',
        })}
      </div>
    </div>
  );

  return wrapElement;
}
