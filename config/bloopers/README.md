# Vocal Bloopers

The default `blooper_config.json` includes entries backed by samples shipped with the game. To override a sample, place audio at the matching path relative to the bloopers directory. To add a voice, add an entry and its audio files. Voices without any available samples are omitted from the character settings.

## Config Format

- name: Required, the user-friendly name of the voice, will be shown in the config menu
- id: Required, an internal ID for the voice, must be unique
- files: Required, a JSON array of audio file names, relative to the bloopers directory.
  If there's more than one entry, a file is randomly chosen each time the user speaks
- min_speed: Optional, the minimum value the user can set for the voice speed
- max_speed: Optional, the maximum value the user can set for the voice speed
- min_pitch: Optional, the minimum value the user can set for the voice pitch
- max_pitch: Optional, the maximum value the user can set for the voice pitch
- min_vary: Optional, the minimum value the user can set for the voice pitch variance
- max_vary: Optional, the maximum value the user can set for the voice pitch variance
