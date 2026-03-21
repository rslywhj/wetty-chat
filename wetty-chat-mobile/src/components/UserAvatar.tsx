interface UserAvatarProps {
  name: string;
  avatarUrl?: string | null;
  size?: number;
  className?: string;
  style?: React.CSSProperties;
  onClick?: () => void;
}

function getInitials(name: string): string {
  return name.slice(0, 2).toUpperCase();
}

function colorForUser(name: string): string {
  let hash = 0;
  for (const char of name) {
    hash = (hash << 5) - hash + char.charCodeAt(0);
    hash |= 0;
  }
  const hue = ((hash * 137) % 360 + 360) % 360;
  return `hsl(${hue}, 55%, 50%)`;
}

export function UserAvatar({ name, avatarUrl, size = 36, className, style, onClick }: UserAvatarProps) {
  const base: React.CSSProperties = {
    width: size,
    height: size,
    borderRadius: '50%',
    flexShrink: 0,
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    overflow: 'hidden',
    userSelect: 'none',
    cursor: onClick ? 'pointer' : undefined,
    ...style,
  };

  if (avatarUrl) {
    return (
      <div className={className} style={base} onClick={onClick}>
        <img
          src={avatarUrl}
          alt=""
          style={{ width: '100%', height: '100%', objectFit: 'cover' }}
        />
      </div>
    );
  }

  return (
    <div
      className={className}
      style={{
        ...base,
        backgroundColor: colorForUser(name),
        color: '#fff',
        fontSize: Math.round(size * 0.36),
        fontWeight: 600,
      }}
      onClick={onClick}
    >
      {getInitials(name)}
    </div>
  );
}
