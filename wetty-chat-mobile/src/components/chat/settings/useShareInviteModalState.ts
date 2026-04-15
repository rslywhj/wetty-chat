import { useState } from 'react';
import type { GroupSelectorItem } from '@/api/group';
import type { InviteInfoResponse } from '@/api/invites';
import type { MemberSummary } from '@/api/users';
import type { InviteExpiryOption, InviteMode, ModalStep, SelectorTarget } from './shareInviteHelpers';

interface ShareInviteModalState {
  step: ModalStep;
  mode: InviteMode;
  requiredChatId: string;
  selectedRequiredGroup: GroupSelectorItem | null;
  selectedTargetMember: MemberSummary | null;
  selectedDestinationGroup: GroupSelectorItem | null;
  expiryOption: InviteExpiryOption;
  submitting: boolean;
  draftInvite: InviteInfoResponse | null;
  groupSelectorOpen: boolean;
  memberSelectorOpen: boolean;
  selectorTarget: SelectorTarget;
  setStep: (step: ModalStep) => void;
  changeMode: (mode: InviteMode) => void;
  setSubmitting: (submitting: boolean) => void;
  changeExpiryOption: (option: InviteExpiryOption) => void;
  setDraftInvite: (invite: InviteInfoResponse | null) => void;
  openSelector: (target: SelectorTarget) => void;
  closeSelector: () => void;
  selectRequiredGroup: (group: GroupSelectorItem) => void;
  selectDestinationGroup: (group: GroupSelectorItem) => void;
  openMemberSelector: () => void;
  closeMemberSelector: () => void;
  selectTargetMember: (member: MemberSummary) => void;
}

export function useShareInviteModalState(): ShareInviteModalState {
  const [step, setStep] = useState<ModalStep>('configure');
  const [mode, setMode] = useState<InviteMode>('public');
  const [requiredChatId, setRequiredChatId] = useState('');
  const [selectedRequiredGroup, setSelectedRequiredGroup] = useState<GroupSelectorItem | null>(null);
  const [selectedTargetMember, setSelectedTargetMember] = useState<MemberSummary | null>(null);
  const [selectedDestinationGroup, setSelectedDestinationGroup] = useState<GroupSelectorItem | null>(null);
  const [expiryOption, setExpiryOption] = useState<InviteExpiryOption>('never');
  const [submitting, setSubmitting] = useState(false);
  const [draftInvite, setDraftInvite] = useState<InviteInfoResponse | null>(null);
  const [groupSelectorOpen, setGroupSelectorOpen] = useState(false);
  const [memberSelectorOpen, setMemberSelectorOpen] = useState(false);
  const [selectorTarget, setSelectorTarget] = useState<SelectorTarget>('required');

  return {
    step,
    mode,
    requiredChatId,
    selectedRequiredGroup,
    selectedTargetMember,
    selectedDestinationGroup,
    expiryOption,
    submitting,
    draftInvite,
    groupSelectorOpen,
    memberSelectorOpen,
    selectorTarget,
    setStep,
    changeMode: (nextMode) => {
      setMode(nextMode);
      setSelectedDestinationGroup(null);
      setDraftInvite(null);
      if (nextMode !== 'membership') {
        setSelectedRequiredGroup(null);
        setRequiredChatId('');
      }
      if (nextMode !== 'targeted') {
        setSelectedTargetMember(null);
        setMemberSelectorOpen(false);
      }
      if (nextMode !== 'membership' && selectorTarget === 'required') {
        setGroupSelectorOpen(false);
      }
    },
    setSubmitting,
    changeExpiryOption: (option) => {
      setExpiryOption(option);
      setDraftInvite(null);
    },
    setDraftInvite,
    openSelector: (target) => {
      setSelectorTarget(target);
      setGroupSelectorOpen(true);
    },
    closeSelector: () => setGroupSelectorOpen(false),
    selectRequiredGroup: (group) => {
      setSelectedRequiredGroup(group);
      setRequiredChatId(group.id);
      setDraftInvite(null);
      setGroupSelectorOpen(false);
    },
    selectDestinationGroup: (group) => {
      setSelectedDestinationGroup(group);
      setGroupSelectorOpen(false);
    },
    openMemberSelector: () => setMemberSelectorOpen(true),
    closeMemberSelector: () => setMemberSelectorOpen(false),
    selectTargetMember: (member) => {
      setSelectedTargetMember(member);
      setDraftInvite(null);
      setMemberSelectorOpen(false);
    },
  };
}
