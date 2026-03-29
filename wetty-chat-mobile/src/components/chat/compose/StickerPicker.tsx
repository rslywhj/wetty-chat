import { useState } from 'react';
import { t } from '@lingui/core/macro';
import styles from './StickerPicker.module.scss';

interface Sticker {
  id: string;
  emoji: string;
  label: string;
}

interface StickerPack {
  id: string;
  name: string;
  icon: string;
  stickers: Sticker[];
}

const MOCK_PACKS: StickerPack[] = [
  {
    id: 'favorites',
    name: 'Favorites',
    icon: '⭐',
    stickers: [
      { id: 'fav-1', emoji: '⭐', label: 'Star' },
      { id: 'fav-2', emoji: '❤️', label: 'Heart' },
      { id: 'fav-3', emoji: '🔥', label: 'Fire' },
      { id: 'fav-4', emoji: '💯', label: '100' },
      { id: 'fav-5', emoji: '🎉', label: 'Party' },
      { id: 'fav-6', emoji: '👍', label: 'Thumbs up' },
      { id: 'fav-7', emoji: '😂', label: 'Laughing' },
      { id: 'fav-8', emoji: '🥹', label: 'Holding back tears' },
    ],
  },
  {
    id: 'smileys',
    name: 'Smileys',
    icon: '😀',
    stickers: [
      { id: 'sml-1', emoji: '😀', label: 'Grinning' },
      { id: 'sml-2', emoji: '😄', label: 'Grinning with big eyes' },
      { id: 'sml-3', emoji: '😆', label: 'Grinning squinting' },
      { id: 'sml-4', emoji: '🤣', label: 'Rolling on the floor' },
      { id: 'sml-5', emoji: '😅', label: 'Sweat smile' },
      { id: 'sml-6', emoji: '😊', label: 'Smiling face' },
      { id: 'sml-7', emoji: '🥰', label: 'Smiling with hearts' },
      { id: 'sml-8', emoji: '😍', label: 'Heart eyes' },
      { id: 'sml-9', emoji: '🤩', label: 'Star-struck' },
      { id: 'sml-10', emoji: '😎', label: 'Cool' },
      { id: 'sml-11', emoji: '🤔', label: 'Thinking' },
      { id: 'sml-12', emoji: '😏', label: 'Smirking' },
    ],
  },
  {
    id: 'animals',
    name: 'Animals',
    icon: '🐶',
    stickers: [
      { id: 'ani-1', emoji: '🐶', label: 'Dog' },
      { id: 'ani-2', emoji: '🐱', label: 'Cat' },
      { id: 'ani-3', emoji: '🐭', label: 'Mouse' },
      { id: 'ani-4', emoji: '🐹', label: 'Hamster' },
      { id: 'ani-5', emoji: '🐰', label: 'Rabbit' },
      { id: 'ani-6', emoji: '🦊', label: 'Fox' },
      { id: 'ani-7', emoji: '🐻', label: 'Bear' },
      { id: 'ani-8', emoji: '🐼', label: 'Panda' },
      { id: 'ani-9', emoji: '🐨', label: 'Koala' },
      { id: 'ani-10', emoji: '🐯', label: 'Tiger' },
    ],
  },
  {
    id: 'food',
    name: 'Food',
    icon: '🍕',
    stickers: [
      { id: 'food-1', emoji: '🍕', label: 'Pizza' },
      { id: 'food-2', emoji: '🍔', label: 'Burger' },
      { id: 'food-3', emoji: '🌮', label: 'Taco' },
      { id: 'food-4', emoji: '🍜', label: 'Noodles' },
      { id: 'food-5', emoji: '🍣', label: 'Sushi' },
      { id: 'food-6', emoji: '🍩', label: 'Donut' },
      { id: 'food-7', emoji: '🍦', label: 'Ice cream' },
      { id: 'food-8', emoji: '🧋', label: 'Bubble tea' },
    ],
  },
];

interface StickerPickerProps {
  isOpen: boolean;
  onStickerSelect: (stickerId: string) => void;
}

export function StickerPicker({ isOpen, onStickerSelect }: StickerPickerProps) {
  const [selectedPackId, setSelectedPackId] = useState(MOCK_PACKS[0].id);

  if (!isOpen) return null;

  const activePack = MOCK_PACKS.find((p) => p.id === selectedPackId) ?? MOCK_PACKS[0];

  return (
    <div className={styles.container}>
      <div className={styles.stickerGrid} role="grid" aria-label={activePack.name}>
        {activePack.stickers.map((sticker) => (
          <button
            key={sticker.id}
            type="button"
            role="gridcell"
            aria-label={sticker.label}
            className={styles.stickerItem}
            onClick={() => onStickerSelect(sticker.id)}
          >
            <span className={styles.stickerEmoji} aria-hidden="true">
              {sticker.emoji}
            </span>
          </button>
        ))}
      </div>

      <div className={styles.packBar} role="tablist" aria-label={t`Sticker packs`}>
        {MOCK_PACKS.map((pack) => (
          <button
            key={pack.id}
            type="button"
            role="tab"
            aria-selected={pack.id === selectedPackId}
            aria-label={pack.name}
            className={`${styles.packTab}${pack.id === selectedPackId ? ` ${styles.packTabActive}` : ''}`}
            onClick={() => setSelectedPackId(pack.id)}
          >
            <span className={styles.packIcon} aria-hidden="true">
              {pack.icon}
            </span>
          </button>
        ))}
      </div>
    </div>
  );
}
