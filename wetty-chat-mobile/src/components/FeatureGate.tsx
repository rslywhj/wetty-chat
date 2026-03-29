import React from 'react';
import { useFeatureGate } from '@/hooks/useFeatureGate';

interface FeatureGateProps {
  children: React.ReactNode;
  fallback?: React.ReactNode;
}

export const FeatureGate: React.FC<FeatureGateProps> = ({ children, fallback = null }) => {
  const isEnabled = useFeatureGate();
  return isEnabled ? children : fallback;
};
