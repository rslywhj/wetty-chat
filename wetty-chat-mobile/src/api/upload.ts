import axios, { type AxiosResponse } from 'axios';
import apiClient from './client';

export interface UploadUrlRequest {
    filename: string;
    content_type: string;
    size: number;
    width?: number;
    height?: number;
}

export interface UploadUrlResponse {
    attachment_id: string;
    upload_url: string;
}

export interface UploadFileToS3Options {
    signal?: AbortSignal;
    onProgress?: (progress: number) => void;
}

export function requestUploadUrl(
    body: UploadUrlRequest
): Promise<AxiosResponse<UploadUrlResponse>> {
    return apiClient.post('/attachments/upload-url', body);
}

export async function uploadFileToS3(
    url: string,
    file: File,
    options: UploadFileToS3Options = {}
): Promise<AxiosResponse<void>> {
    return axios.put(url, file, {
        headers: {
            'Content-Type': file.type,
            'x-amz-acl': 'public-read',
        },
        signal: options.signal,
        onUploadProgress: (event) => {
            if (!options.onProgress || !event.total) return;
            const progress = Math.max(0, Math.min(100, Math.round((event.loaded / event.total) * 100)));
            options.onProgress(progress);
        },
    });
}
