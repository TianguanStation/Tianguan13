// THIS IS A BUBBER UI FILE

import { useState } from 'react';
import {
  Button,
  Icon,
  Input,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';

import { InteractionsTab } from './tabs';

export const MainContent = () => {
  const [searchText, setSearchText] = useState('');
  const [showCategories, setShowCategories] = useState(true);

  return (
    <Section fill>
      <Stack vertical fill>
        <Stack.Item>
          <Tabs fluid textAlign="center">
            <Tabs.Tab selected>Interactions</Tabs.Tab>
          </Tabs>
        </Stack.Item>
        <Stack.Item>
          <Stack align="baseline" fill>
            <Stack.Item>
              <Icon name="search" />
            </Stack.Item>
            <Stack.Item grow>
              <Input
                fluid
                value={searchText}
                placeholder="Search for an interaction"
                onChange={(value) => setSearchText(value)}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon={showCategories ? 'folder' : 'list'}
                color="green"
                tooltip={
                  showCategories ? 'Hide Categories' : 'Show Categories'
                }
                onClick={() => setShowCategories(!showCategories)}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item grow mb={-1.6}>
          <Section fill>
            <InteractionsTab
              searchText={searchText}
              showCategories={showCategories}
            />
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
