import { expect, it, spyOn } from 'bun:test';
import { fireEvent, render } from '@testing-library/react';

import { CommandBar } from './CommandBar';

it('pairs forwarded arrows across input blur, window blur and unmount', () => {
  const command = spyOn(Byond, 'command');
  try {
    const panel = render(<CommandBar />);
    const input = panel.getByRole('textbox');
    fireEvent.focus(input);
    fireEvent.keyDown(input, { key: 'ArrowRight', isComposing: true });
    fireEvent.keyDown(input, { key: 'ArrowLeft', keyCode: 229 });
    expect(fireEvent.keyDown(input, { key: 'Enter', isComposing: true })).toBe(
      true,
    );
    fireEvent.keyDown(input, { key: 'ArrowUp' });
    fireEvent.blur(input);
    fireEvent.keyUp(input, { key: 'ArrowUp' });
    fireEvent.keyDown(input, { key: 'ArrowLeft' });
    window.dispatchEvent(new Event('blur'));
    fireEvent.keyDown(input, { key: 'ArrowLeft' });
    panel.unmount();
    expect(command.mock.calls.map(([value]) => value)).toEqual([
      'Reset-Held-Keys',
      'KeyDown "North" 0 0 0 0',
      'KeyUp "North" 0 0 0 0',
      'KeyDown "West" 0 0 0 0',
      'KeyUp "West" 0 0 0 0',
      'KeyDown "West" 0 0 0 0',
      'KeyUp "West" 0 0 0 0',
    ]);
  } finally {
    command.mockRestore();
  }
});
