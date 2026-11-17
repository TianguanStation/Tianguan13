import { CheckboxInput, type FeatureToggle } from '../../base';

export const vore_enable_pref: FeatureToggle = {
  name: 'Enable Mechanical Vore',
  category: 'GAMEPLAY',
  description: 'Toggles if you are able to use vore mechanics.',
  component: CheckboxInput,
};

export const vore_overlays: FeatureToggle = {
  name: 'Vore Overlays',
  category: 'GAMEPLAY',
  description:
    'When enabled, will you be shown fullscreen vore overlays while inside of a soulcatcher?',
  component: CheckboxInput,
};

export const vore_overlay_options: FeatureToggle = {
  name: 'Vore Overlay Options',
  category: 'GAMEPLAY',
  description:
    'Do you want to see fullscreen vore overlays as an option for soulcatcher overlays?',
  component: CheckboxInput,
};
