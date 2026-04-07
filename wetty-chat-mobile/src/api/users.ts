import apiClient from './client';

export interface StickerPackOrderItem {
  stickerPackId: string;
  lastUsedOn: number;
}

export interface User {
  uid: number;
  username: string;
  avatarUrl?: string | null;
  gender: number;
  stickerPackOrder?: StickerPackOrderItem[];
}

export const usersApi = {
  getCurrentUser: async (): Promise<User> => {
    const response = await apiClient.get<User>('/users/me');
    return response.data;
  },

  updateStickerPackOrder: async (order: StickerPackOrderItem[]): Promise<void> => {
    await apiClient.put('/users/me/stickerpack-order', { order });
  },
};
