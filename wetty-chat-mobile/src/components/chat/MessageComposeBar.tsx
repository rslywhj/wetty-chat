import { forwardRef, useCallback, useEffect, useImperativeHandle, useLayoutEffect, useRef, useState } from 'react';
import { IonButton, IonIcon } from '@ionic/react';
import { t } from '@lingui/core/macro';
import { addCircleOutline, closeCircle, happyOutline, lockClosedOutline, micOutline, paperPlaneOutline, send, trashOutline } from 'ionicons/icons';
import styles from './MessageComposeBar.module.scss';
import { type ImageUploadDraft, UploadPreview } from './UploadPreview';
import type { Attachment } from '@/api/messages';
import { getMessagePreviewText } from './messagePreview';
import { FeatureGate } from '../FeatureGate';

interface ReplyTo {
  messageId: string;
  username: string;
  text?: string | null;
  attachments?: Attachment[];
  isDeleted?: boolean;
}

export interface EditingMessage {
  messageId: string;
  text: string;
  attachments?: Attachment[];
}

export interface ComposeUploadInput {
  file: File;
  signal: AbortSignal;
  onProgress: (progress: number) => void;
  dimensions?: {
    width?: number;
    height?: number;
  };
}

export interface ComposeUploadResult {
  attachmentId: string;
}

export interface ComposeUploadedAttachment {
  attachmentId: string;
  file: File;
  mimeType: string;
  size: number;
  width?: number;
  height?: number;
}

export interface ComposeSendTextPayload {
  kind: 'text';
  text: string;
  attachmentIds: string[];
  existingAttachments: Attachment[];
  uploadedAttachments: ComposeUploadedAttachment[];
}

export interface ComposeSendAudioPayload {
  kind: 'audio';
  durationMs: number;
  attachmentId: string;
  uploadedAttachment: ComposeUploadedAttachment;
}

export type ComposeSendPayload = ComposeSendTextPayload | ComposeSendAudioPayload;

interface DraftUploadRecord {
  draft: ImageUploadDraft;
  file: File;
  abortController?: AbortController;
}

interface MessageComposeBarProps {
  onSend: (payload: ComposeSendPayload) => void;
  uploadAttachment: (input: ComposeUploadInput) => Promise<ComposeUploadResult>;
  replyTo?: ReplyTo;
  onCancelReply?: () => void;
  editing?: EditingMessage;
  onCancelEdit?: () => void;
  onRequestEditLastMessage?: () => boolean;
  onFocusChange?: (focused: boolean) => void;
  onError?: (message: string) => void;
}

export interface MessageComposeBarHandle {
  focusInput: () => void;
  blurInput: () => void;
  isFocused: () => boolean;
}

const isAbortError = (error: unknown) => error instanceof DOMException && error.name === 'AbortError';
const VOICE_CANCEL_THRESHOLD_PX = 72;
const VOICE_LOCK_THRESHOLD_PX = 60;
const MIN_VOICE_DURATION_MS = 500;

type VoiceRecorderPhase = 'requesting' | 'recording' | 'locked' | 'uploading';

interface VoiceRecorderState {
  phase: VoiceRecorderPhase;
  startedAt: number;
  durationMs: number;
  cancelArmed: boolean;
  uploadProgress: number;
}

const createDraftId = () => {
  if (typeof crypto !== 'undefined' && typeof crypto.randomUUID === 'function') {
    return crypto.randomUUID();
  }

  return `draft_${Date.now()}_${Math.random().toString(36).slice(2, 10)}`;
};

export const MessageComposeBar = forwardRef<MessageComposeBarHandle, MessageComposeBarProps>(function MessageComposeBar(
  {
    onSend,
    uploadAttachment,
    replyTo,
    onCancelReply,
    editing,
    onCancelEdit,
    onRequestEditLastMessage,
    onFocusChange,
    onError,
  }: MessageComposeBarProps,
  ref,
) {
  const textareaRef = useRef<HTMLTextAreaElement>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const draftsRef = useRef<DraftUploadRecord[]>([]);
  const previousEditingMessageIdRef = useRef<string | null>(null);
  const [text, setText] = useState('');
  const prevTextLenRef = useRef(0);
  const [drafts, setDrafts] = useState<DraftUploadRecord[]>([]);
  const [existingAttachments, setExistingAttachments] = useState<Attachment[]>([]);
  const [voiceRecorder, setVoiceRecorder] = useState<VoiceRecorderState | null>(null);
  const voiceRecorderRef = useRef<VoiceRecorderState | null>(null);
  const voiceMediaRecorderRef = useRef<MediaRecorder | null>(null);
  const voiceStreamRef = useRef<MediaStream | null>(null);
  const voiceChunksRef = useRef<Blob[]>([]);
  const voiceGestureRef = useRef<{
    pointerId: number | null;
    startX: number;
    startY: number;
    active: boolean;
    finishAfterStart: 'send' | 'cancel' | null;
  }>({ pointerId: null, startX: 0, startY: 0, active: false, finishAfterStart: null });
  const voiceUploadAbortControllerRef = useRef<AbortController | null>(null);

  useImperativeHandle(
    ref,
    () => ({
      focusInput: () => textareaRef.current?.focus(),
      blurInput: () => textareaRef.current?.blur(),
      isFocused: () => document.activeElement === textareaRef.current,
    }),
    [],
  );

  const resizeTextarea = useCallback(() => {
    const ta = textareaRef.current;
    if (!ta) return;

    ta.style.height = 'auto';
    ta.style.height = `${Math.min(ta.scrollHeight, 120)}px`;
  }, []);

  const cleanupDraft = useCallback((draft: DraftUploadRecord) => {
    draft.abortController?.abort();
    URL.revokeObjectURL(draft.draft.previewUrl);
  }, []);

  const clearDrafts = useCallback(
    (currentDrafts: DraftUploadRecord[]) => {
      currentDrafts.forEach(cleanupDraft);
      setDrafts([]);
    },
    [cleanupDraft],
  );

  useEffect(() => {
    draftsRef.current = drafts;
  }, [drafts]);

  useEffect(() => {
    voiceRecorderRef.current = voiceRecorder;
  }, [voiceRecorder]);

  useEffect(() => {
    const editingMessageId = editing?.messageId ?? null;
    const previousEditingMessageId = previousEditingMessageIdRef.current;

    if (editing && editingMessageId !== previousEditingMessageId) {
      setText(editing.text);
      prevTextLenRef.current = editing.text.length;
      setExistingAttachments(editing.attachments ?? []);
      setDrafts((prev) => {
        prev.forEach(cleanupDraft);
        return [];
      });
    } else if (!editing && previousEditingMessageId != null) {
      setText('');
      prevTextLenRef.current = 0;
      setExistingAttachments([]);
      setDrafts((prev) => {
        prev.forEach(cleanupDraft);
        return [];
      });
      const ta = textareaRef.current;
      if (ta) ta.style.height = 'auto';
    }
    previousEditingMessageIdRef.current = editingMessageId;
  }, [cleanupDraft, editing]);

  useLayoutEffect(() => {
    resizeTextarea();
  }, [resizeTextarea, text]);

  useEffect(
    () => () => {
      draftsRef.current.forEach(cleanupDraft);
      voiceUploadAbortControllerRef.current?.abort();
      if (voiceMediaRecorderRef.current?.state && voiceMediaRecorderRef.current.state !== 'inactive') {
        voiceMediaRecorderRef.current.stop();
      }
      voiceStreamRef.current?.getTracks().forEach((track) => track.stop());
    },
    [cleanupDraft],
  );

  useEffect(() => {
    if (!voiceRecorder || (voiceRecorder.phase !== 'recording' && voiceRecorder.phase !== 'locked')) {
      return;
    }

    const timer = window.setInterval(() => {
      setVoiceRecorder((current) =>
        current == null
          ? null
          : {
            ...current,
            durationMs: Date.now() - current.startedAt,
          },
      );
    }, 200);

    return () => window.clearInterval(timer);
  }, [voiceRecorder]);

  const reportVoiceError = useCallback(
    (message: string) => {
      onError?.(message);
    },
    [onError],
  );

  const stopVoiceStream = useCallback(() => {
    voiceStreamRef.current?.getTracks().forEach((track) => track.stop());
    voiceStreamRef.current = null;
  }, []);

  const resetVoiceGesture = useCallback(() => {
    voiceGestureRef.current = {
      pointerId: null,
      startX: 0,
      startY: 0,
      active: false,
      finishAfterStart: null,
    };
  }, []);

  const resetVoiceRecorder = useCallback(() => {
    voiceUploadAbortControllerRef.current?.abort();
    voiceUploadAbortControllerRef.current = null;
    voiceChunksRef.current = [];
    voiceMediaRecorderRef.current = null;
    stopVoiceStream();
    setVoiceRecorder(null);
    resetVoiceGesture();
  }, [resetVoiceGesture, stopVoiceStream]);

  const formatVoiceDuration = useCallback((durationMs: number) => {
    const totalSeconds = Math.max(0, Math.round(durationMs / 1000));
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    return `${minutes}:${seconds.toString().padStart(2, '0')}`;
  }, []);

  const getSupportedVoiceMimeType = useCallback(() => {
    if (typeof MediaRecorder === 'undefined' || typeof MediaRecorder.isTypeSupported !== 'function') {
      return '';
    }

    const candidates = ['audio/webm;codecs=opus', 'audio/mp4', 'audio/webm', 'audio/ogg;codecs=opus'];
    return candidates.find((candidate) => MediaRecorder.isTypeSupported(candidate)) ?? '';
  }, []);

  const getVoiceFileExtension = useCallback((mimeType: string) => {
    if (mimeType.includes('mp4')) return 'm4a';
    if (mimeType.includes('ogg')) return 'ogg';
    return 'webm';
  }, []);

  const finishVoiceRecording = useCallback(
    (mode: 'send' | 'cancel') => {
      const current = voiceRecorderRef.current;
      if (!current) {
        resetVoiceGesture();
        return;
      }

      const recorder = voiceMediaRecorderRef.current;
      if (current.phase === 'requesting') {
        voiceGestureRef.current.finishAfterStart = mode;
        return;
      }

      if (mode === 'cancel') {
        voiceChunksRef.current = [];
      }

      voiceGestureRef.current.active = false;
      voiceGestureRef.current.pointerId = null;
      voiceGestureRef.current.finishAfterStart = null;

      const nextDurationMs = Date.now() - current.startedAt;
      setVoiceRecorder({
        ...current,
        phase: mode === 'send' ? 'uploading' : 'recording',
        durationMs: nextDurationMs,
        cancelArmed: false,
        uploadProgress: 0,
      });

      if (!recorder || recorder.state === 'inactive') {
        if (mode === 'cancel') {
          resetVoiceRecorder();
        }
        return;
      }

      if (mode === 'cancel') {
        recorder.onstop = () => {
          resetVoiceRecorder();
        };
      }

      recorder.stop();
    },
    [resetVoiceGesture, resetVoiceRecorder],
  );

  const getImageDimensions = (file: File): Promise<{ width?: number; height?: number }> => {
    return new Promise((resolve) => {
      if (file.type.startsWith('image/')) {
        const img = new Image();
        const objectUrl = URL.createObjectURL(file);
        img.onload = () => {
          URL.revokeObjectURL(objectUrl);
          resolve({ width: img.width, height: img.height });
        };
        img.onerror = () => {
          URL.revokeObjectURL(objectUrl);
          resolve({});
        };
        img.src = objectUrl;
      } else if (file.type.startsWith('video/')) {
        const video = document.createElement('video');
        const url = URL.createObjectURL(file);
        video.onloadedmetadata = () => {
          URL.revokeObjectURL(url);
          resolve({ width: video.videoWidth, height: video.videoHeight });
        };
        video.onerror = () => {
          URL.revokeObjectURL(url);
          resolve({});
        };
        video.src = url;
      } else {
        resolve({});
      }
    });
  };

  const startUpload = useCallback(
    async (localId: string, file: File) => {
      const abortController = new AbortController();

      setDrafts((prev) =>
        prev.map((draftRecord) =>
          draftRecord.draft.localId === localId
            ? {
              ...draftRecord,
              abortController,
              draft: {
                ...draftRecord.draft,
                status: 'uploading',
                progress: 0,
                errorMessage: undefined,
                attachmentId: undefined,
              },
            }
            : draftRecord,
        ),
      );

      try {
        const dimensions = await getImageDimensions(file);
        setDrafts((prev) =>
          prev.map((draftRecord) =>
            draftRecord.draft.localId === localId
              ? {
                ...draftRecord,
                draft: {
                  ...draftRecord.draft,
                  width: dimensions.width,
                  height: dimensions.height,
                },
              }
              : draftRecord,
          ),
        );
        const result = await uploadAttachment({
          file,
          dimensions,
          signal: abortController.signal,
          onProgress: (progress) => {
            setDrafts((prev) =>
              prev.map((draftRecord) =>
                draftRecord.draft.localId === localId
                  ? {
                    ...draftRecord,
                    draft: {
                      ...draftRecord.draft,
                      progress,
                    },
                  }
                  : draftRecord,
              ),
            );
          },
        });

        setDrafts((prev) =>
          prev.map((draftRecord) =>
            draftRecord.draft.localId === localId
              ? {
                ...draftRecord,
                abortController: undefined,
                draft: {
                  ...draftRecord.draft,
                  status: 'uploaded',
                  progress: 100,
                  attachmentId: result.attachmentId,
                  errorMessage: undefined,
                },
              }
              : draftRecord,
          ),
        );
      } catch (error) {
        if (isAbortError(error) || abortController.signal.aborted) {
          return;
        }

        console.error('Failed to upload attachment:', error);
        setDrafts((prev) =>
          prev.map((draftRecord) =>
            draftRecord.draft.localId === localId
              ? {
                ...draftRecord,
                abortController: undefined,
                draft: {
                  ...draftRecord.draft,
                  status: 'error',
                  progress: 0,
                  attachmentId: undefined,
                  errorMessage: t`Upload failed`,
                },
              }
              : draftRecord,
          ),
        );
      } finally {
        if (fileInputRef.current) fileInputRef.current.value = '';
      }
    },
    [uploadAttachment],
  );

  const queueFiles = useCallback(
    (files: File[]) => {
      const mediaFiles = files.filter((file) => file.type.startsWith('image/') || file.type.startsWith('video/'));
      if (mediaFiles.length === 0) return;

      const queuedDrafts = mediaFiles.map((file) => ({
        file,
        draft: {
          localId: createDraftId(),
          kind: file.type.startsWith('image/') ? 'image' : ('video' as 'image' | 'video'),
          name: file.name,
          previewUrl: URL.createObjectURL(file),
          mimeType: file.type || 'application/octet-stream',
          size: file.size,
          progress: 0,
          status: 'uploading' as const,
        },
      }));

      setDrafts((prev) => [...prev, ...queuedDrafts]);
      queuedDrafts.forEach(({ draft, file }) => {
        void startUpload(draft.localId, file);
      });
    },
    [startUpload],
  );

  const startVoiceRecording = useCallback(async () => {
    if (
      typeof navigator === 'undefined' ||
      !navigator.mediaDevices?.getUserMedia ||
      typeof MediaRecorder === 'undefined'
    ) {
      reportVoiceError(t`Voice recording is not supported on this device.`);
      resetVoiceGesture();
      return;
    }

    const requestedAt = Date.now();
    setVoiceRecorder({
      phase: 'requesting',
      startedAt: requestedAt,
      durationMs: 0,
      cancelArmed: false,
      uploadProgress: 0,
    });

    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      voiceStreamRef.current = stream;
      voiceChunksRef.current = [];

      const mimeType = getSupportedVoiceMimeType();
      const recorder = mimeType ? new MediaRecorder(stream, { mimeType }) : new MediaRecorder(stream);
      voiceMediaRecorderRef.current = recorder;
      const startedAt = Date.now();

      recorder.ondataavailable = (event) => {
        if (event.data.size > 0) {
          voiceChunksRef.current.push(event.data);
        }
      };

      recorder.onstop = async () => {
        const current = voiceRecorderRef.current;
        const durationMs = current ? Math.max(current.durationMs, Date.now() - startedAt) : Date.now() - startedAt;
        const recordedChunks = voiceChunksRef.current;
        voiceMediaRecorderRef.current = null;
        stopVoiceStream();

        if (recordedChunks.length === 0) {
          setVoiceRecorder(null);
          return;
        }

        if (durationMs < MIN_VOICE_DURATION_MS) {
          voiceChunksRef.current = [];
          setVoiceRecorder(null);
          reportVoiceError(t`Recording is too short.`);
          return;
        }

        const blobType = recorder.mimeType || mimeType || 'audio/webm';
        const blob = new Blob(recordedChunks, { type: blobType });
        const file = new File([blob], `voice-${Date.now()}.${getVoiceFileExtension(blobType)}`, {
          type: blobType,
          lastModified: Date.now(),
        });
        const uploadAbortController = new AbortController();
        voiceUploadAbortControllerRef.current = uploadAbortController;

        setVoiceRecorder({
          phase: 'uploading',
          startedAt,
          durationMs,
          cancelArmed: false,
          uploadProgress: 0,
        });

        try {
          const result = await uploadAttachment({
            file,
            signal: uploadAbortController.signal,
            onProgress: (progress) => {
              setVoiceRecorder((currentVoice) =>
                currentVoice == null
                  ? null
                  : {
                    ...currentVoice,
                    uploadProgress: progress,
                  },
              );
            },
          });

          onSend({
            kind: 'audio',
            durationMs,
            attachmentId: result.attachmentId,
            uploadedAttachment: {
              attachmentId: result.attachmentId,
              file,
              mimeType: blobType,
              size: file.size,
            },
          });
          setVoiceRecorder(null);
        } catch (error) {
          if (!isAbortError(error) && !uploadAbortController.signal.aborted) {
            console.error('Failed to upload voice message:', error);
            reportVoiceError(t`Failed to send voice message.`);
          }
          setVoiceRecorder(null);
        } finally {
          voiceUploadAbortControllerRef.current = null;
          voiceChunksRef.current = [];
        }
      };

      recorder.start();
      setVoiceRecorder({
        phase: 'recording',
        startedAt,
        durationMs: 0,
        cancelArmed: false,
        uploadProgress: 0,
      });

      const deferredFinish = voiceGestureRef.current.finishAfterStart;
      if (deferredFinish) {
        finishVoiceRecording(deferredFinish);
      }
    } catch (error) {
      console.error('Failed to access microphone:', error);
      stopVoiceStream();
      setVoiceRecorder(null);
      resetVoiceGesture();
      reportVoiceError(t`Microphone access was denied.`);
    }
  }, [finishVoiceRecording, getSupportedVoiceMimeType, getVoiceFileExtension, onSend, reportVoiceError, resetVoiceGesture, stopVoiceStream, uploadAttachment]);

  const handleSend = useCallback(() => {
    const trimmed = text.trim();
    const uploadedDrafts = drafts.filter(
      (draftRecord) => draftRecord.draft.status === 'uploaded' && Boolean(draftRecord.draft.attachmentId),
    );
    const attachmentIds = [
      ...existingAttachments.map((attachment) => attachment.id),
      ...uploadedDrafts.map((draftRecord) => draftRecord.draft.attachmentId!),
    ];

    if (!trimmed && attachmentIds.length === 0) return;

    onSend({
      kind: 'text',
      text: trimmed,
      attachmentIds,
      existingAttachments,
      uploadedAttachments: uploadedDrafts.map((draftRecord) => ({
        attachmentId: draftRecord.draft.attachmentId!,
        file: draftRecord.file,
        mimeType: draftRecord.draft.mimeType,
        size: draftRecord.draft.size,
        width: draftRecord.draft.width,
        height: draftRecord.draft.height,
      })),
    });
    setText('');
    setExistingAttachments([]);
    clearDrafts(drafts);
    const ta = textareaRef.current;
    if (ta) ta.style.height = 'auto';
  }, [clearDrafts, drafts, existingAttachments, onSend, text]);

  const handleSendRef = useRef(handleSend);
  useEffect(() => {
    handleSendRef.current = handleSend;
  }, [handleSend]);

  const hasUploadingDraft = drafts.some((draftRecord) => draftRecord.draft.status === 'uploading');
  const hasFailedDraft = drafts.some((draftRecord) => draftRecord.draft.status === 'error');
  const uploadedDrafts = drafts.filter((draftRecord) => draftRecord.draft.status === 'uploaded');
  const currentAttachmentIds = [
    ...existingAttachments.map((attachment) => attachment.id),
    ...uploadedDrafts
      .map((draftRecord) => draftRecord.draft.attachmentId)
      .filter((attachmentId): attachmentId is string => Boolean(attachmentId)),
  ];
  const hasAttachment = currentAttachmentIds.length > 0;
  const trimmedText = text.trim();
  const originalEditText = editing?.text.trim() ?? '';
  const originalAttachmentIds = editing?.attachments?.map((attachment) => attachment.id) ?? [];
  const isUnchangedEdit =
    editing != null &&
    trimmedText === originalEditText &&
    currentAttachmentIds.length === originalAttachmentIds.length &&
    currentAttachmentIds.every((attachmentId, index) => attachmentId === originalAttachmentIds[index]);
  const canSend =
    !hasUploadingDraft && !hasFailedDraft && (trimmedText.length > 0 || hasAttachment) && !isUnchangedEdit;
  const voiceActive = voiceRecorder != null;
  const canStartVoice =
    trimmedText.length === 0 &&
    !hasAttachment &&
    !editing &&
    !hasUploadingDraft &&
    !hasFailedDraft &&
    !voiceActive;
  const canRequestRecentEdit = !editing && !replyTo && text.length === 0 && !hasAttachment && drafts.length === 0;

  useEffect(() => {
    const textarea = textareaRef.current;
    if (!textarea) return;
    textarea.setAttribute('enterkeyhint', 'send');
    const onKeyDown = (e: KeyboardEvent) => {
      const isImeConfirm = e.isComposing || e.keyCode === 229 || e.which === 229;
      if (e.key === 'Enter' && !e.shiftKey && !isImeConfirm) {
        e.preventDefault();
        handleSendRef.current();
        return;
      }

      if (e.key === 'ArrowUp' && canRequestRecentEdit) {
        const didStartEdit = onRequestEditLastMessage?.() ?? false;
        if (didStartEdit) {
          e.preventDefault();
        }
        return;
      }

      if (e.key === 'Escape' && editing && isUnchangedEdit) {
        e.preventDefault();
        onCancelEdit?.();
      }
    };
    textarea.addEventListener('keydown', onKeyDown);
    return () => textarea.removeEventListener('keydown', onKeyDown);
  }, [canRequestRecentEdit, editing, isUnchangedEdit, onCancelEdit, onRequestEditLastMessage]);

  const handleFileChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = Array.from(e.target.files ?? []);
    queueFiles(files);
  };

  useEffect(() => {
    const handleGlobalPaste = (e: ClipboardEvent) => {
      const items = e.clipboardData?.items;
      if (!items) return;

      const files: File[] = [];

      for (let i = 0; i < items.length; i++) {
        if (items[i].type.startsWith('image/') || items[i].type.startsWith('video/')) {
          const file = items[i].getAsFile();
          if (file) {
            files.push(file);
          }
        }
      }

      if (files.length > 0) {
        e.preventDefault();
        queueFiles(files);
      }
    };

    document.addEventListener('paste', handleGlobalPaste);
    return () => document.removeEventListener('paste', handleGlobalPaste);
  }, [queueFiles]);

  const removeDraft = useCallback(
    (localId: string) => {
      setDrafts((prev) => {
        const draftToRemove = prev.find((draftRecord) => draftRecord.draft.localId === localId);
        if (draftToRemove) {
          cleanupDraft(draftToRemove);
        }
        return prev.filter((draftRecord) => draftRecord.draft.localId !== localId);
      });
    },
    [cleanupDraft],
  );

  const retryDraft = useCallback(
    (localId: string) => {
      const file = draftsRef.current.find((draftRecord) => draftRecord.draft.localId === localId)?.file;
      if (!file) return;
      void startUpload(localId, file);
    },
    [startUpload],
  );

  const removeExistingAttachment = useCallback((localId: string) => {
    const attachmentId = localId.replace(/^existing-/, '');
    setExistingAttachments((prev) => prev.filter((attachment) => attachment.id !== attachmentId));
  }, []);
  const previewItems = [
    ...existingAttachments.map((attachment) => ({
      itemType: 'existing' as const,
      localId: `existing-${attachment.id}`,
      attachmentId: attachment.id,
      kind: attachment.kind,
      name: attachment.file_name,
      previewUrl: attachment.kind.startsWith('image/') ? attachment.url : undefined,
    })),
    ...drafts.map((draftRecord) => ({
      itemType: 'draft' as const,
      ...draftRecord.draft,
    })),
  ];

  const handleVoicePointerDown = useCallback(
    (event: React.PointerEvent<HTMLElement>) => {
      if (!canStartVoice) {
        return;
      }

      event.preventDefault();
      textareaRef.current?.blur();
      voiceGestureRef.current = {
        pointerId: event.pointerId,
        startX: event.clientX,
        startY: event.clientY,
        active: true,
        finishAfterStart: null,
      };
      void startVoiceRecording();
    },
    [canStartVoice, startVoiceRecording],
  );

  useEffect(() => {
    const handlePointerMove = (event: PointerEvent) => {
      const gesture = voiceGestureRef.current;
      const current = voiceRecorderRef.current;
      if (!gesture.active || gesture.pointerId !== event.pointerId || current?.phase !== 'recording') {
        return;
      }

      const deltaX = event.clientX - gesture.startX;
      const deltaY = event.clientY - gesture.startY;

      if (deltaY <= -VOICE_LOCK_THRESHOLD_PX) {
        setVoiceRecorder((voice) =>
          voice == null
            ? null
            : {
              ...voice,
              phase: 'locked',
              cancelArmed: false,
            },
        );
        voiceGestureRef.current.active = false;
        voiceGestureRef.current.pointerId = null;
        return;
      }

      const cancelArmed = deltaX <= -VOICE_CANCEL_THRESHOLD_PX;
      if (cancelArmed !== current.cancelArmed) {
        setVoiceRecorder({
          ...current,
          cancelArmed,
        });
      }
    };

    const handlePointerFinish = (event: PointerEvent) => {
      const gesture = voiceGestureRef.current;
      if (gesture.pointerId == null || gesture.pointerId !== event.pointerId) {
        return;
      }

      const current = voiceRecorderRef.current;
      if (!current) {
        resetVoiceGesture();
        return;
      }

      if (current.phase === 'requesting') {
        voiceGestureRef.current.finishAfterStart = 'cancel';
        return;
      }

      if (current.phase !== 'recording') {
        return;
      }

      finishVoiceRecording(current.cancelArmed ? 'cancel' : 'send');
    };

    window.addEventListener('pointermove', handlePointerMove);
    window.addEventListener('pointerup', handlePointerFinish);
    window.addEventListener('pointercancel', handlePointerFinish);
    return () => {
      window.removeEventListener('pointermove', handlePointerMove);
      window.removeEventListener('pointerup', handlePointerFinish);
      window.removeEventListener('pointercancel', handlePointerFinish);
    };
  }, [finishVoiceRecording, resetVoiceGesture]);

  return (
    <div className={styles.bar}>
      <input
        type="file"
        accept="image/*,video/*"
        multiple
        style={{ display: 'none' }}
        ref={fileInputRef}
        onChange={handleFileChange}
      />
      <button
        type="button"
        className={styles.attachBtn}
        aria-label={t`Attach image`}
        onClick={() => fileInputRef.current?.click()}
        disabled={voiceActive}
      >
        <IonIcon icon={addCircleOutline} />
      </button>
      <div className={styles.inputWrapper}>
        {editing ? (
          <div className={styles.replyPreview}>
            <div className={styles.replyText}>
              <span className={styles.replyUsername}>{t`Edit message`}</span>
              <span className={styles.replySnippet}>{editing.text}</span>
            </div>
            <button type="button" className={styles.replyClose} aria-label={t`Cancel edit`} onClick={onCancelEdit}>
              <IonIcon icon={closeCircle} />
            </button>
          </div>
        ) : replyTo ? (
          <div className={styles.replyPreview}>
            <div className={styles.replyText}>
              <span className={styles.replyUsername}>{t`Replying to ${replyTo.username}`}</span>
              <span className={styles.replySnippet}>
                {getMessagePreviewText({
                  message: replyTo.text,
                  attachments: replyTo.attachments,
                  isDeleted: replyTo.isDeleted,
                })}
              </span>
            </div>
            <button type="button" className={styles.replyClose} aria-label={t`Cancel reply`} onClick={onCancelReply}>
              <IonIcon icon={closeCircle} />
            </button>
          </div>
        ) : null}

        <UploadPreview
          items={previewItems}
          onRemove={(localId) => {
            if (localId.startsWith('existing-')) {
              removeExistingAttachment(localId);
              return;
            }
            removeDraft(localId);
          }}
          onRetry={retryDraft}
        />

        {voiceRecorder ? (
          <div className={styles.voiceRecorder} data-phase={voiceRecorder.phase}>
            <div className={styles.voiceRecorderMain}>
              <div className={styles.voiceIndicator} aria-hidden="true" />
              <span className={styles.voiceTimer}>{formatVoiceDuration(voiceRecorder.durationMs)}</span>
              {voiceRecorder.phase === 'locked' ? (
                <span className={styles.voiceHint}>{t`Locked recording`}</span>
              ) : voiceRecorder.phase === 'uploading' ? (
                <span className={styles.voiceHint}>{t`Uploading ${voiceRecorder.uploadProgress}%`}</span>
              ) : voiceRecorder.cancelArmed ? (
                <span className={styles.voiceHint}>{t`Release to cancel`}</span>
              ) : voiceRecorder.phase === 'requesting' ? (
                <span className={styles.voiceHint}>{t`Waiting for microphone…`}</span>
              ) : (
                <span className={styles.voiceHint}>{t`Slide left to cancel, up to lock`}</span>
              )}
            </div>
            {voiceRecorder.phase === 'locked' ? (
              <div className={styles.voiceActions}>
                <button
                  type="button"
                  className={`${styles.voiceActionBtn} ${styles.voiceCancelBtn}`}
                  onClick={() => finishVoiceRecording('cancel')}
                  aria-label={t`Cancel recording`}
                >
                  <IonIcon icon={trashOutline} />
                </button>
                <button
                  type="button"
                  className={`${styles.voiceActionBtn} ${styles.voiceSendBtn}`}
                  onClick={() => finishVoiceRecording('send')}
                  aria-label={t`Send voice message`}
                >
                  <IonIcon icon={paperPlaneOutline} />
                </button>
              </div>
            ) : voiceRecorder.phase === 'recording' ? (
              <div className={styles.voiceLockBadge} aria-hidden="true">
                <IonIcon icon={lockClosedOutline} />
              </div>
            ) : null}
          </div>
        ) : (
          <div className={styles.inputRow}>
            <textarea
              id="messageCompose"
              ref={textareaRef}
              className={styles.textarea}
              placeholder={t`Message`}
              value={text}
              rows={1}
              onChange={(e) => {
                setText(e.target.value);
                const newLen = e.target.value.length;
                prevTextLenRef.current = newLen;
              }}
              onFocus={() => onFocusChange?.(true)}
              onBlur={() => onFocusChange?.(false)}
            />
            <FeatureGate>
              <button type="button" className={styles.stickerBtn} aria-label={t`Sticker`}>
                <IonIcon icon={happyOutline} />
              </button>
            </FeatureGate>
          </div>
        )}
      </div>
      {canStartVoice || voiceActive ? (
        <IonButton
          fill="solid"
          color="primary"
          className={`${styles.sendBtn} ${voiceActive ? styles.recordingBtn : ''}`}
          onPointerDown={handleVoicePointerDown}
          onClick={(event) => event.preventDefault()}
          aria-label={t`Record voice`}
          disabled={voiceRecorder?.phase === 'uploading'}
        >
          <IonIcon slot="icon-only" icon={micOutline} />
        </IonButton>
      ) : (
        <IonButton
          fill="solid"
          color="primary"
          className={`${styles.sendBtn}${!canSend ? ` ${styles.disabled}` : ''}`}
          onClick={handleSend}
          aria-label={t`Send message`}
          disabled={!canSend}
        >
          <IonIcon slot="icon-only" icon={send} className={styles.moveRight} />
        </IonButton>
      )}
    </div>
  );
});
