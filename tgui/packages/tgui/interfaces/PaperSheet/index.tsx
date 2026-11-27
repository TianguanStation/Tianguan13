import { useBackend, useLocalState } from '../../backend';
import { Window } from '../../layouts';
import { TEXTAREA_INPUT_HEIGHT } from './constants';
import { canEdit } from './helpers';
import { PrimaryView } from './PrimaryView';
import type { PaperContext } from './types';

export function PaperSheet(props) {
  const { data } = useBackend<PaperContext>();
  const {
    paper_blood_stain,
    paper_color,
    paper_dirt_stain,
    paper_name,
    held_item_details,
  } = data;

  const writeMode = canEdit(held_item_details);
  const stainLayers: string[] = [];
  if (paper_blood_stain) {
    stainLayers.push(
      'radial-gradient(ellipse at 87% 9%, #a52b2452, #a52b2415 12%, transparent 21%)',
      'radial-gradient(ellipse at 72% 13%, #a52b2440, transparent 5%)',
    );
  }
  if (paper_dirt_stain) {
    stainLayers.push(
      'radial-gradient(ellipse at 7% 92%, #72522e55, #72522e18 14%, transparent 27%)',
    );
  }

  if (!writeMode) {
    const [inputFieldData, setInputFieldData] = useLocalState(
      'inputFieldData',
      {},
    );
    if (Object.keys(inputFieldData).length) {
      setInputFieldData({});
    }
  }

  return (
    <Window
      title={paper_name}
      theme="paper"
      width={420}
      height={500 + (writeMode ? TEXTAREA_INPUT_HEIGHT : 0)}
    >
      <Window.Content
        backgroundColor={paper_color}
        style={{ backgroundImage: stainLayers.join(', ') || undefined }}
      >
        <PrimaryView />
      </Window.Content>
    </Window>
  );
}
