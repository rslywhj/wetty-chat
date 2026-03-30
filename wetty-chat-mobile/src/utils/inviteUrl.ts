const INVITE_JOIN_PATH_PREFIX = '/chats/join/';

const INVITE_CODE_REGEX = /^[A-Za-z0-9]{10}$/;

export function buildInviteUrl(code: string): string {
  return document.location.origin + INVITE_JOIN_PATH_PREFIX + code;
}

export function parseInviteCodeFromUrl(url: string): string | null {
  try {
    const parsed = new URL(url);
    if (parsed.origin !== document.location.origin) return null;
    if (!parsed.pathname.startsWith(INVITE_JOIN_PATH_PREFIX)) return null;

    const code = parsed.pathname.slice(INVITE_JOIN_PATH_PREFIX.length);
    if (!INVITE_CODE_REGEX.test(code)) return null;

    return code;
  } catch {
    return null;
  }
}
