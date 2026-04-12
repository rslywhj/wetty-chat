import { useMemo } from 'react';
import type { ReactionReactor } from '@/api/messages';
import { MAX_REACTION_HEAD_TABS } from '@/constants/emojiAndStickers';

export interface ReactionGroup {
  emoji: string;
  reactors: ReactionReactor[];
}

export interface GroupedUser extends ReactionReactor {
  emojis: string[];
  // Store an index for original time-based sorting if no timestamp is present,
  // smaller index = earlier.
  firstReactIndex: number;
}

export interface ReactionCategory {
  key: string; // 'all', 'more', or specific emoji
  label: string; // Display name or emoji
  count: number;
  users: GroupedUser[];
}

export interface ReactionGroupingResult {
  categories: ReactionCategory[];
}

export function useReactionGrouping(groups: ReactionGroup[]): ReactionGroupingResult {
  return useMemo(() => {
    if (!groups || groups.length === 0) return { categories: [] };

    const sortedGroups = [...groups].sort((a, b) => {
      if (b.reactors.length !== a.reactors.length) {
        return b.reactors.length - a.reactors.length;
      }
      return a.emoji.localeCompare(b.emoji);
    });

    const topGroups = sortedGroups.slice(0, MAX_REACTION_HEAD_TABS);
    const moreGroups = sortedGroups.slice(MAX_REACTION_HEAD_TABS);

    const categories: ReactionCategory[] = [];

    const allUsersMap = new Map<number, GroupedUser>();
    let globalIndex = 0;

    groups.forEach((g) => {
      g.reactors.forEach((r) => {
        if (!allUsersMap.has(r.uid)) {
          allUsersMap.set(r.uid, {
            ...r,
            emojis: [g.emoji],
            firstReactIndex: globalIndex++,
          });
        } else {
          allUsersMap.get(r.uid)!.emojis.push(g.emoji);
        }
      });
    });

    const allUsersSorted = Array.from(allUsersMap.values()).sort((a, b) => a.firstReactIndex - b.firstReactIndex);

    categories.push({
      key: 'all',
      label: 'All',
      count: allUsersMap.size,
      users: allUsersSorted,
    });

    topGroups.forEach((g) => {
      const users: GroupedUser[] = g.reactors.map((r, i) => ({
        ...r,
        emojis: [g.emoji],
        firstReactIndex: i,
      }));

      categories.push({
        key: g.emoji,
        label: g.emoji,
        count: users.length,
        users,
      });
    });

    // --- Process 'More' category ---
    if (moreGroups.length > 0) {
      const moreUsers: GroupedUser[] = [];
      moreGroups.forEach((g) => {
        g.reactors.forEach((r, i) => {
          moreUsers.push({
            ...r,
            emojis: [g.emoji],
            firstReactIndex: i,
          });
        });
      });

      categories.push({
        key: 'more',
        label: 'More',
        count: moreUsers.length,
        users: moreUsers,
      });
    }

    return { categories };
  }, [groups]);
}
