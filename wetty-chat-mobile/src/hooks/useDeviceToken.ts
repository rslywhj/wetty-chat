import Cookies from "js-cookie";
import { useMemo } from "react";

export function useDeviceToken(): string {
    const deviceTokenQuery: string | null = useMemo(() => {
        const searchParams = new URLSearchParams(window.location.search);
        return searchParams.get('token');
    }, []);
    const deviceTokenCookie: string | undefined = useMemo(() => {
        return Cookies.get('device_token');
    }, []);

    if (deviceTokenQuery && deviceTokenQuery.length > 0) {
        return deviceTokenQuery;
    }

    if (deviceTokenCookie && deviceTokenCookie.length > 0) {
        return deviceTokenCookie;
    }

    return "";
}
