import { expect, it } from 'bun:test';
import { render, screen } from '@testing-library/react';

import { gameDataAtom, store } from '../../events/store';
import { CommunicationsConsole } from './index';
import { ShuttleState } from './types';

it('only shows voice controls in an authenticated, authorized console session', () => {
  const previous = store.get(gameDataAtom);
  const home = { hasConnection: 1, page: ShuttleState.MAIN, sectors: [] };
  const label = 'Station announcer and device voices';
  try {
    store.set(gameDataAtom, {
      ...home,
      authenticated: 1,
      canSetStationVoices: 1,
    });
    const ui = render(<CommunicationsConsole />);
    expect(screen.getByText(label)).toBeDefined();

    store.set(gameDataAtom, {
      ...home,
      authenticated: 1,
      canSetStationVoices: 0,
    });
    ui.rerender(<CommunicationsConsole />);
    expect(screen.queryByText(label)).toBeNull();

    // A delayed editor update must not cover the login screen after logout.
    store.set(gameDataAtom, {
      ...home,
      authenticated: 0,
      canSetStationVoices: 1,
      voiceEditor: { group: 'announcements' },
    });
    ui.rerender(<CommunicationsConsole />);
    expect(screen.getByText('Log In')).toBeDefined();
    expect(screen.queryByText(label)).toBeNull();
  } finally {
    store.set(gameDataAtom, previous);
  }
});
