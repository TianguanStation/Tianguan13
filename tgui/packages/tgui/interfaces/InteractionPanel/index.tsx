// THIS IS A NOVA SECTOR UI FILE
import { Stack } from 'tgui-core/components';
import { useBackend } from '../../backend';
import { Window } from '../../layouts';
import { MainContent } from './MainContent';

type Interaction = {
  self: string;
};

export function InteractionPanel() {
  const { data } = useBackend<Interaction>();
  const { self } = data;

  return (
    <Window width={500} height={600} title={`Interact - ${self}`}>
      <Window.Content scrollable>
        <Stack>
          <Stack.Item grow>
            <MainContent />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
}
