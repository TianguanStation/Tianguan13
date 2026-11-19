## Input method friendly controls

Module ID: IME_KEYBOARD

### Description:

With a Chinese, Japanese or Korean input method switched on, keystrokes are consumed by the input method before DreamSeeker's key macros see them: pressing WASD opens a candidate window instead of moving, and every hotkey stops working.

The native map control's input method cannot be changed from the server, but the browser controls sent to the client can. This module places a 1x1 WebView2 control (`mapwindow.ime_capture`) in the map window and keeps keyboard focus on a non-editable element inside it. Chromium disables the input method for its window while a non-editable element has focus, so keys arrive unmodified.

- The page forwards each key exactly like the native `Any` macro does: `KeyDown "W" [[map.mouse-pos]] [[map.size]]`. The capture page uses the built-in `BYOND.command()` bridge when available and the existing winset transport on older clients. The embedded wingets are expanded by the client, so keybindings get the same mouse position as with native macros. The page uses `KeyboardEvent.code` (physical key), falling back to `keyCode`.
- Native macros never fire while a browser control has focus. The page forwards the press before running the injected Escape, Tab, Back or admin macro, so a focus transfer or reset cannot precede the press it should clean up.
- When the map takes focus back (clicking the map, closing the say box or a popup), the page reclaims it locally with `winget`/`winset`, without a server round trip. Editable inputs (chat bar, say box, TGUI text fields) are never reclaimed, so typing with the input method works as usual.
- The native map sends physical key releases directly through explicit `+UP` macros for every physical key recognized by the page. A key first pressed in the browser can miss the native wildcard release when focus changes. The page sends the same `KeyUp` command for DOM releases. The server owns the held-key state and resolves current bindings, including secondary slots and chords. Ordinary movement rebinding takes effect without reloading the page.
- Keys without a preference binding still reach raw game handlers such as AI camera shortcuts. Keyboard repeat is ignored. Entering chat or switching applications resets game holds once per focus transition. Focus polling runs only while the capture page is unfocused.
- While this preference is enabled, a single-key movement binding takes priority over a communication action on the same key. With east on L, pressing L walks east even if L is still bound to LOOC. Players can assign LOOC another key or a chord such as Ctrl+L.
- The injected macro commands are rebuilt whenever `update_special_keybinds()` runs: the admin holder is associated after preferences are applied on login, and auto-deadmin/readmin and rebinding change the asay key later.

The feature is a game preference (`ime_keyboard`, default on). Turning it off removes the control and returns focus to the map.

### Deployment and limitations

Rebuild and deploy the game resources and TGUI bundles together. DreamSeeker receives the capture page from the server at login. Players keep their Chinese IME enabled throughout gameplay and chat; no Windows utility, keyboard layout change, or client installation is required. An explicitly disabled preference stays disabled.

The server distributes DM skin settings and the capture HTML at login; keyboard events still originate in DreamSeeker. The native map keeps its normal hit testing, HUD, clicks and drags. It can briefly take focus; there is no documented map setting to prevent that while keeping it interactive. The native map handles releases during that interval. Entering chat deliberately resets game holds and leaves composition keystrokes to the input method.

Run the capture-page event regressions with `node --test tools/zh/ime-capture.test.mjs` (Node 22+). For a DreamSeeker smoke test, enable Microsoft Pinyin, walk diagonally, click the map while releasing one direction, then use another shortcut before releasing the second direction. Also check holding Space through a throw, opening chat while walking, and Alt-Tab. Confirm movement stops without another tap and chat can still compose Chinese text.

### TG Proc/File Changes:

- `code/modules/client/client_procs.dm`: `/client/proc/update_special_keybinds()` (modular override, calls parent)
- `code/modules/keybindings/bindings_client.dm`: movement and communication key dispatch
- `code/modules/keybindings/setup.dm`: the modular `erase_all_macros()` override marks the explicit release macros for reinstallation
- `code/modules/escape_menu/escape_menu.dm`: the focus-reset verb runs through the same instant native path as key presses and releases

### Modular Overrides:

- N/A

### Defines:

- N/A

### Included files that are not contained in this module:

- `tgui/packages/tgui/interfaces/PreferencesMenu/preferences/features/game_preferences/nova/ime_keyboard.tsx`

### Credits:

sernseek
