import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';
import { runInNewContext } from 'node:vm';

const html = readFileSync(new URL('../../modular_zh/modules/ime_keyboard/html/ime_capture.html', import.meta.url), 'utf8');
const script = html.match(/<script>([\s\S]*?)<\/script>/)[1];

function capture(context, macros = {}, onCommand, byond) {
  context.mock.timers.enable({ apis: ['setTimeout', 'Date'], now: 10000 });
  let focused = true;
  let destination = 'map';
  const listeners = {};
  const commands = [];
  const requests = [];
  const window = {
    BYOND: byond,
    addEventListener: (name, listener) => { listeners[name] = listener; },
    cef_to_byond(raw) {
      const { hostname, searchParams } = new URL(raw);
      requests.push(hostname);
      if (hostname === 'winget') window[searchParams.get('callback')]({ focus: destination });
      if (searchParams.has('command')) {
        const command = searchParams.get('command').split(' [[')[0];
        commands.push(command);
        onCommand?.(command, listeners);
      }
    },
  };
  const injected = script.replace('/*IME_MACRO_COMMANDS*/{}', JSON.stringify(macros));
  runInNewContext(injected, {
    window, Date, setTimeout, clearTimeout,
    document: { hasFocus: () => focused, getElementById: () => ({ focus() {} }) },
  });
  return {
    commands,
    requests,
    key(code, type = 'keydown', repeat = false, modifiers = {}) {
      listeners[type]({ code, type, repeat, preventDefault() {}, ...modifiers });
    },
    blur(target = 'map') { focused = false; destination = target; listeners.blur(); },
    focus() { focused = true; listeners.focus(); },
    tick: (ms) => context.mock.timers.tick(ms),
  };
}

test('a focus-changing macro follows its press and resets game input on leaving', (context) => {
  const page = capture(context, { Tab: 'FocusChat' }, (command, listeners) => {
    if (command === 'FocusChat') listeners.pagehide();
  });
  page.key('KeyW');
  page.key('Tab');
  assert.deepEqual(page.commands, ['KeyDown "W"', 'KeyDown "Tab"', 'FocusChat', 'Reset-Held-Keys']);
});

test('unbound keys are forwarded to raw key handlers and never expire on a map click', (context) => {
  const page = capture(context);
  page.key('Digit9');
  page.blur();
  page.tick(1);
  page.focus();
  page.tick(30000);
  page.key('Digit9', 'keydown', true);
  assert.deepEqual(page.commands, ['KeyDown "9"']);
  page.key('Digit9', 'keyup');
  assert.equal(page.commands.at(-1), 'KeyUp "9"');
});

test('a fresh physical press after a native release does not synthesize an extra up', (context) => {
  const page = capture(context);
  page.key('KeyI');
  page.key('KeyL');
  page.key('Space');
  page.blur(); // L is physically released on the native map.
  page.tick(1);
  page.focus();
  page.key('KeyI', 'keydown', true);
  page.key('KeyL');
  page.key('Space', 'keyup');
  page.key('KeyL', 'keyup');
  page.key('KeyI', 'keyup');
  assert.deepEqual(page.commands, ['KeyDown "I"', 'KeyDown "L"', 'KeyDown "Space"', 'KeyDown "L"', 'KeyUp "Space"', 'KeyUp "L"', 'KeyUp "I"']);
});

test('a key first pressed on the map is released once by the page', (context) => {
  const page = capture(context);
  page.key('KeyJ', 'keydown', true);
  page.key('KeyJ', 'keyup');
  assert.deepEqual(page.commands, ['KeyUp "J"']);
});

test('chat and application blur each cancel game input once, including silent native holds', (context) => {
  const page = capture(context);
  for (const destination of ['input', '']) {
    page.key('KeyI');
    page.key('KeyL');
    page.key('Space');
    page.blur(destination);
    page.tick(1);
    page.tick(2000);
    assert.deepEqual(page.commands.splice(0), ['KeyDown "I"', 'KeyDown "L"', 'KeyDown "Space"', 'Reset-Held-Keys']);
    page.focus();
    page.key('Space', 'keydown', true);
    assert.deepEqual(page.commands, []);
  }
});

test('focus polling sleeps while the capture page owns the keyboard', (context) => {
  const page = capture(context);
  page.tick(5000);
  assert.deepEqual(page.requests, []);
  page.blur();
  page.tick(1);
  assert.deepEqual(page.requests, ['winget', 'winset']);
  page.focus();
  page.tick(5000);
  assert.deepEqual(page.requests, ['winget', 'winset']);
});

test('releasing a modifier preserves the other physical keys in its chord', (context) => {
  const page = capture(context);
  page.key('ControlLeft');
  page.key('KeyI', 'keydown', false, { ctrlKey: true });
  page.blur();
  page.tick(1);
  page.focus();
  page.key('ControlLeft', 'keyup');
  page.tick(5000);
  assert.deepEqual(page.commands, ['KeyDown "Ctrl"', 'KeyDown "I"', 'KeyUp "Ctrl"']);
  page.key('KeyI', 'keyup');
  assert.equal(page.commands.at(-1), 'KeyUp "I"');
});

test('a quick tap dispatches both edges without waiting for a timer', (context) => {
  const page = capture(context);
  page.key('Space');
  page.key('Space', 'keyup');
  assert.deepEqual(page.commands, ['KeyDown "Space"', 'KeyUp "Space"']);
});

test('backslash stays one quoted BYOND command argument on both edges', (context) => {
  const page = capture(context);
  page.key('Backslash');
  page.key('Backslash', 'keyup');
  const argument = JSON.stringify('\\');
  assert.deepEqual(page.commands, [`KeyDown ${argument}`, `KeyUp ${argument}`]);
});

test('the native BYOND bridge receives ordered presses and releases with mouse coordinates', (context) => {
  const received = [];
  const page = capture(context, { Tab: 'FocusChat' }, undefined, {
    command: (command) => received.push(command),
  });
  page.key('KeyI');
  page.key('KeyI', 'keydown', true);
  page.key('KeyI', 'keyup');
  page.key('Tab');
  assert.deepEqual(page.requests, []);
  assert.deepEqual(received, [
    'KeyDown "I" [[map.mouse-pos]] [[map.size]]',
    'KeyUp "I" [[map.mouse-pos]] [[map.size]]',
    'KeyDown "Tab" [[map.mouse-pos]] [[map.size]]',
    'FocusChat',
  ]);
});
