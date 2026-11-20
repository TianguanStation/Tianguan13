import { useState } from 'react';
import {
  Box,
  Button,
  Dropdown,
  LabeledList,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { useT } from '../i18n';
import { Window } from '../layouts';
import { SearchBar } from './common/SearchBar';

type Voice = { id: string; name: string };
type Editor = {
  group: string;
  area: string | null;
  device: string | null;
  current: string | null;
  canPreview: BooleanLike;
};

export type StationVoiceData = {
  voiceEditor?: Editor;
  voiceCatalog?: {
    voices: Voice[];
    area?: string | null;
    areas?: Record<string, string>;
    machines?: Record<string, string>;
  };
};

const groups: Record<string, string> = {
  announcements: 'System announcements',
  computers: 'Computer terminals',
  vendors: 'Vending machines',
  transit: 'Trams and arrival shuttles',
};

export function StationVoiceButton() {
  const { act } = useBackend();
  return (
    <Button
      icon="volume-high"
      onClick={() => act('stationVoices', { operation: 'open' })}
    >
      Station announcer and device voices
    </Button>
  );
}

function options(labels: Record<string, string> = {}) {
  return Object.entries(labels)
    .map(([value, displayText]) => ({ value, displayText }))
    .sort((a, b) => a.displayText.localeCompare(b.displayText));
}

export function StationVoiceControls({ onBack }: { onBack?: () => void }) {
  const { act, data } = useBackend<StationVoiceData>();
  const t = useT();
  const editor = data.voiceEditor;
  const catalog = data.voiceCatalog;
  if (!editor || !catalog) return <Section>Loading...</Section>;
  const single = editor.group === 'device';
  const machines = catalog.area === editor.area ? catalog.machines : undefined;
  const send = (operation: string, params = {}) =>
    act('stationVoices', { operation, ...params });
  const setGroup = (group: string) => send('group', { group });

  return (
    <>
      <Section
        title="Station announcer and device voices"
        buttons={
          onBack && (
            <Button icon="chevron-left" onClick={onBack}>
              Back
            </Button>
          )
        }
      >
        <Tabs fluid>
          <Tabs.Tab
            icon="broadcast-tower"
            selected={!single}
            onClick={() => single && setGroup('announcements')}
          >
            By equipment type
          </Tabs.Tab>
          <Tabs.Tab
            icon="microchip"
            selected={single}
            onClick={() => !single && setGroup('device')}
          >
            Individual machine
          </Tabs.Tab>
        </Tabs>
        <LabeledList>
          {single ? (
            <>
              <LabeledList.Item label="Area">
                <Dropdown
                  fluid
                  searchInput
                  width="100%"
                  selected={editor.area}
                  displayText={catalog.areas?.[editor.area ?? '']}
                  placeholder={t('Select an area')}
                  options={options(catalog.areas)}
                  onSelected={(area) => send('area', { area })}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Machine">
                <Dropdown
                  fluid
                  searchInput
                  width="100%"
                  selected={editor.device}
                  displayText={machines?.[editor.device ?? '']}
                  disabled={!editor.area || !machines}
                  placeholder={t('Select a machine')}
                  options={options(machines)}
                  onSelected={(device) => send('device', { device })}
                />
              </LabeledList.Item>
            </>
          ) : (
            <LabeledList.Item label="Source">
              <Dropdown
                fluid
                width="100%"
                selected={editor.group}
                displayText={t(groups[editor.group])}
                options={Object.entries(groups).map(([value, name]) => ({
                  value,
                  displayText: t(name),
                }))}
                onSelected={setGroup}
              />
            </LabeledList.Item>
          )}
        </LabeledList>
      </Section>
      {(!single || editor.device) && (
        <VoiceLibrary
          key={editor.device || editor.group}
          editor={editor}
          voices={catalog.voices}
        />
      )}
    </>
  );
}

function VoiceLibrary({ editor, voices }: { editor: Editor; voices: Voice[] }) {
  const { act } = useBackend();
  const t = useT();
  const [query, setQuery] = useState('');
  const [choice, setChoice] = useState<string | null>(null);
  const selected = choice ?? editor.current;
  const speaker = voices.find((voice) => voice.id === selected);
  const current = voices.find((voice) => voice.id === editor.current);
  const search = query.trim().toLowerCase();
  const matches = voices.filter((voice) =>
    `${voice.name} ${voice.id}`.toLowerCase().includes(search),
  );
  function send(operation: string) {
    act('stationVoices', {
      operation,
      group: editor.group,
      device: editor.device,
      speaker: selected,
    });
  }
  return (
    <Section title="Voice library">
      <LabeledList>
        <LabeledList.Item
          label="Current voice"
          buttons={
            <Button
              icon="undo"
              disabled={!editor.current}
              onClick={() => {
                setChoice(null);
                send('reset');
              }}
            >
              Restore default
            </Button>
          }
        >
          {current?.name || editor.current || t('Default voice')}
        </LabeledList.Item>
      </LabeledList>
      <Box mt={1} mb={0.5}>
        <SearchBar
          query={query}
          onSearch={setQuery}
          placeholder={t('Search voices by name or ID')}
        />
      </Box>
      <Box style={{ maxHeight: '23em', overflowY: 'auto' }}>
        {matches.map((voice) => (
          <Button
            key={voice.id}
            fluid
            selected={voice.id === selected}
            icon={voice.id === selected ? 'check' : 'volume-low'}
            onClick={() => setChoice(voice.id)}
          >
            {voice.name}
            {voice.name !== voice.id && (
              <Box as="span" ml={1} opacity={0.65}>
                {voice.id}
              </Box>
            )}
          </Button>
        ))}
        {!matches.length && (
          <Box color="label">
            {voices.length
              ? 'No matching voices.'
              : 'No public voices available.'}
          </Box>
        )}
      </Box>
      <Stack mt={1}>
        <Stack.Item grow>
          <Button
            fluid
            textAlign="center"
            icon="headphones"
            disabled={!speaker || !editor.canPreview}
            onClick={() => send('preview')}
          >
            Private preview
          </Button>
        </Stack.Item>
        <Stack.Item grow>
          <Button
            fluid
            textAlign="center"
            icon="check"
            color="good"
            disabled={!speaker || selected === editor.current}
            onClick={() => send('apply')}
          >
            Apply voice
          </Button>
        </Stack.Item>
      </Stack>
    </Section>
  );
}

export function StationVoiceConsole() {
  return (
    <Window width={400} height={650}>
      <Window.Content scrollable>
        <StationVoiceControls />
      </Window.Content>
    </Window>
  );
}
