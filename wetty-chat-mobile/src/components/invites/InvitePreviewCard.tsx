import { useEffect, useMemo, useState } from 'react';
import axios, { HttpStatusCode } from 'axios';
import { IonButton, IonChip, IonLabel, IonSpinner } from '@ionic/react';
import { t } from '@lingui/core/macro';
import { Trans } from '@lingui/react/macro';
import { useDispatch } from 'react-redux';
import { getChats } from '@/api/chats';
import { type GroupInfoResponse } from '@/api/group';
import { getInvitePreview, redeemInvite, type InvitePreviewResponse } from '@/api/invites';
import { UserAvatar } from '@/components/UserAvatar';
import type { AppDispatch } from '@/store';
import { setChatMeta, setChatsList } from '@/store/chatsSlice';
import styles from './InvitePreviewCard.module.scss';

type PreviewState =
  | { kind: 'loading' }
  | { kind: 'loaded'; data: InvitePreviewResponse }
  | { kind: 'error'; title: string; message: string; status?: number };

export interface InvitePreviewCardProps {
  inviteCode: string;
  onResolved: (chat: GroupInfoResponse) => void | Promise<void>;
  onCancel: () => void;
}

function chatDisplayName(preview: InvitePreviewResponse): string {
  const name = preview.chat.name?.trim();
  if (name) return name;
  return t`Chat ${preview.chat.id}`;
}

function inviteTypeLabel(inviteType: string): string {
  switch (inviteType) {
    case 'group_member':
      return t`Member invite`;
    case 'user':
      return t`Personal invite`;
    case 'group':
    default:
      return t`Group invite`;
  }
}

function visibilityLabel(visibility: string): string {
  switch (visibility) {
    case 'public':
      return t`Public group`;
    case 'private':
      return t`Private group`;
    default:
      return visibility;
  }
}

function buildPreviewError(status?: number): { title: string; message: string } {
  switch (status) {
    case HttpStatusCode.Forbidden:
      return {
        title: t`Invite unavailable`,
        message: t`This invite is not available for your account.`,
      };
    case HttpStatusCode.BadRequest:
      return {
        title: t`Invite unavailable`,
        message: t`This invite is invalid or has expired.`,
      };
    default:
      return {
        title: t`Could not load invite`,
        message: t`Please try again in a moment.`,
      };
  }
}

function buildRedeemError(status?: number): string {
  switch (status) {
    case HttpStatusCode.Conflict:
      return t`You are already a member of this chat.`;
    case HttpStatusCode.Forbidden:
      return t`This invite is not available for your account.`;
    case HttpStatusCode.BadRequest:
      return t`This invite is invalid or has expired.`;
    default:
      return t`We could not join this chat right now.`;
  }
}

export function InvitePreviewCard({ inviteCode, onResolved, onCancel }: InvitePreviewCardProps) {
  const dispatch = useDispatch<AppDispatch>();
  const [previewState, setPreviewState] = useState<PreviewState>({ kind: 'loading' });
  const [joining, setJoining] = useState(false);
  const [joinError, setJoinError] = useState<string | null>(null);

  useEffect(() => {
    let cancelled = false;
    setPreviewState({ kind: 'loading' });
    setJoinError(null);

    getInvitePreview(inviteCode)
      .then((response) => {
        if (cancelled) return;
        setPreviewState({ kind: 'loaded', data: response.data });
      })
      .catch((error: unknown) => {
        if (cancelled) return;
        const status = axios.isAxiosError(error) ? error.response?.status : undefined;
        const mapped = buildPreviewError(status);
        setPreviewState({ kind: 'error', ...mapped, status });
      });

    return () => {
      cancelled = true;
    };
  }, [inviteCode]);

  const preview = previewState.kind === 'loaded' ? previewState.data : null;
  const displayName = useMemo(() => (preview ? chatDisplayName(preview) : ''), [preview]);

  const handleRefreshChats = async () => {
    try {
      const chatsResponse = await getChats();
      dispatch(setChatsList(chatsResponse.data.chats ?? []));
    } catch {
      // The chat thread can still load lazily after navigation.
    }
  };

  const handleResolve = async (chat: GroupInfoResponse) => {
    const { id, ...meta } = chat;
    dispatch(setChatMeta({ chatId: id, meta }));
    await handleRefreshChats();
    await onResolved(chat);
  };

  const handleJoin = async () => {
    if (!preview || joining || preview.already_member) return;

    setJoining(true);
    setJoinError(null);

    try {
      const response = await redeemInvite({ code: inviteCode });
      await handleResolve(response.data.chat);
    } catch (error: unknown) {
      const status = axios.isAxiosError(error) ? error.response?.status : undefined;
      setJoinError(buildRedeemError(status));
    } finally {
      setJoining(false);
    }
  };

  const openChat = async () => {
    if (!preview) return;
    await handleResolve(preview.chat);
  };

  return (
    <>
      {previewState.kind === 'loading' ? (
        <div className={styles.hero}>
          <IonSpinner />
          <p className={styles.description}>
            <Trans>Loading invite…</Trans>
          </p>
        </div>
      ) : previewState.kind === 'error' ? (
        <>
          <div className={styles.hero}>
            <p className={styles.eyebrow}>
              <Trans>Invite</Trans>
            </p>
            <h1 className={styles.title}>{previewState.title}</h1>
            <p className={styles.description}>{previewState.message}</p>
          </div>
          <div className={`${styles.status} ${styles.statusError}`}>{previewState.message}</div>
        </>
      ) : previewState.data.already_member ? (
        <>
          <div className={styles.hero}>
            <UserAvatar
              name={displayName}
              avatarUrl={previewState.data.chat.avatar}
              size={96}
              className={styles.avatar}
            />
            <p className={styles.eyebrow}>
              <Trans>Invite</Trans>
            </p>
            <h1 className={styles.title}>{displayName}</h1>
            <p className={styles.description}>
              <Trans>You are already a member of this chat.</Trans>
            </p>
            <div className={styles.meta}>
              <IonChip className={styles.chip}>
                <IonLabel>{inviteTypeLabel(previewState.data.invite.invite_type)}</IonLabel>
              </IonChip>
              <IonChip className={styles.chip}>
                <IonLabel>{visibilityLabel(previewState.data.chat.visibility)}</IonLabel>
              </IonChip>
            </div>
          </div>

          <div className={styles.status}>
            <Trans>This invite points to a chat you already joined.</Trans>
          </div>

          <div className={styles.actions}>
            <IonButton expand="block" size="large" onClick={openChat}>
              <Trans>Open chat</Trans>
            </IonButton>
            <IonButton expand="block" fill="clear" onClick={onCancel}>
              <Trans>Back to chats</Trans>
            </IonButton>
          </div>
        </>
      ) : (
        <>
          <div className={styles.hero}>
            <UserAvatar
              name={displayName}
              avatarUrl={previewState.data.chat.avatar}
              size={96}
              className={styles.avatar}
            />
            <p className={styles.eyebrow}>
              <Trans>You’ve been invited</Trans>
            </p>
            <h1 className={styles.title}>{displayName}</h1>
            <p className={styles.description}>
              {previewState.data.chat.description?.trim() || t`Join this chat to start reading and sending messages.`}
            </p>
            <div className={styles.meta}>
              <IonChip className={styles.chip}>
                <IonLabel>{inviteTypeLabel(previewState.data.invite.invite_type)}</IonLabel>
              </IonChip>
              <IonChip className={styles.chip}>
                <IonLabel>{visibilityLabel(previewState.data.chat.visibility)}</IonLabel>
              </IonChip>
            </div>
          </div>

          {joinError && <div className={`${styles.status} ${styles.statusError}`}>{joinError}</div>}

          <div className={styles.actions}>
            <IonButton expand="block" size="large" onClick={handleJoin} disabled={joining}>
              {joining ? <Trans>Joining…</Trans> : <Trans>Join chat</Trans>}
            </IonButton>
            <IonButton expand="block" fill="clear" onClick={onCancel}>
              <Trans>Not now</Trans>
            </IonButton>
          </div>

          <p className={styles.supporting}>
            <Trans>You can review the chat before joining. Nothing changes until you tap Join chat.</Trans>
          </p>
        </>
      )}
    </>
  );
}
