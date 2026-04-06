import apiClient from './client';

export interface User {
  uid: number;
  username: string;
  avatarUrl?: string | null;
  gender: number;
  stickerPackOrder?: string[];
}

export const usersApi = {
  getCurrentUser: async (): Promise<User> => {
    const response = await apiClient.get<User>('/users/me');
    return response.data;
  },

  updateStickerPackOrder: async (order: string[]): Promise<void> => {
    await apiClient.put('/users/me/stickerpack-order', { order });
  },
};
