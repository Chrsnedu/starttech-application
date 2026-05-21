import axios from 'axios';
import type { AxiosError } from 'axios';

const API_BASE_URL =
    import.meta.env.VITE_API_BASE_URL || 'http://prod-backend-alb-823465914.us-east-1.elb.amazonaws.com';
const AUTH_TOKEN_STORAGE_KEY = 'muchtodo_auth_token';

export const getAuthToken = () => localStorage.getItem(AUTH_TOKEN_STORAGE_KEY);

export const setAuthToken = (token: string) => {
    localStorage.setItem(AUTH_TOKEN_STORAGE_KEY, token);
};

export const clearAuthToken = () => {
    localStorage.removeItem(AUTH_TOKEN_STORAGE_KEY);
};

export const apiClient = axios.create({
    baseURL: API_BASE_URL,
    withCredentials: true, // Crucial for httpOnly cookies
});

type ApiErrorResponse = {
    error?: string;
    message?: string;
};

export const getApiErrorMessage = (error: unknown, fallbackMessage: string) => {
    if (axios.isAxiosError(error)) {
        const axiosError = error as AxiosError<ApiErrorResponse>;
        return axiosError.response?.data?.error
            || axiosError.response?.data?.message
            || fallbackMessage;
    }

    if (error instanceof Error && error.message) {
        return error.message;
    }

    return fallbackMessage;
};

apiClient.interceptors.request.use((config) => {
    const token = getAuthToken();

    if (token) {
        config.headers.Authorization = `Bearer ${token}`;
    }

    return config;
});
