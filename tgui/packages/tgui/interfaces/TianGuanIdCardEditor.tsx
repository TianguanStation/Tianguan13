// THIS IS A TIANGUAN UI FILE
// 模块：admin_id_editor —— 管理员「ID 卡编辑器」
//
// 布局：左边是**实时预览**的卡面（服务端用 getFlatIcon + icon2base64 合成，含 trim 徽记），
// 右边三页：外观（card.dmi 里现成的 card_* 状态）、印记（/datum/id_trim 单例）、权限
// （与人事主管控制台同一份 SSid_access 权限表）。改动即回传，预览跟着刷新。

import { useState } from 'react';
import {
  Box,
  Button,
  Input,
  Section,
  Stack,
  Tabs,
  TextArea,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Appearance = {
  index: number;
  state: string;
  name: string;
  icon: string;
  selected: boolean;
};
type Trim = { path: string; name: string };
type TrimGroup = { name: string; trims: Trim[] };
type AccessEntry = { ref: string; desc: string };
type AccessGroup = { name: string; accesses: AccessEntry[] };

type Data = {
  appearances: Appearance[];
  trim_groups: TrimGroup[];
  access_groups: AccessGroup[];
  card_icon_state: string;
  trim_path: string;
  trim_name: string;
  registered_name: string;
  assignment: string;
  desc: string;
  access: string[];
  preview: string;
};

export const TianGuanIdCardEditor = () => {
  const { act, data } = useBackend<Data>();
  const [tab, setTab] = useState(1);

  return (
    <Window title="ID 卡编辑器" width={960} height={760}>
      <Window.Content>
        <Stack fill>
          <Stack.Item width="230px">
            <CardPreview data={data} act={act} />
          </Stack.Item>
          <Stack.Item grow>
            <Stack fill vertical>
              <Stack.Item>
                <Tabs>
                  <Tabs.Tab
                    icon="image"
                    selected={tab === 1}
                    onClick={() => setTab(1)}
                  >
                    外观
                  </Tabs.Tab>
                  <Tabs.Tab
                    icon="stamp"
                    selected={tab === 2}
                    onClick={() => setTab(2)}
                  >
                    印记
                  </Tabs.Tab>
                  <Tabs.Tab
                    icon="key"
                    selected={tab === 3}
                    onClick={() => setTab(3)}
                  >
                    权限（{data.access.length}）
                  </Tabs.Tab>
                </Tabs>
              </Stack.Item>
              <Stack.Item grow>
                {tab === 1 && <AppearanceTab data={data} act={act} />}
                {tab === 2 && <TrimTab data={data} act={act} />}
                {tab === 3 && <AccessTab data={data} act={act} />}
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const CardPreview = (props: {
  data: Data;
  act: (action: string, payload?: object) => void;
}) => {
  const { act, data } = props;
  return (
    <Stack vertical fill>
      <Stack.Item>
        <Box
          mb={1}
          backgroundColor="black"
          style={{ display: 'flex', justifyContent: 'center', padding: '8px' }}
        >
          <img
            src={`data:image/png;base64,${data.preview}`}
            width="128px"
            height="128px"
            style={{ imageRendering: 'pixelated' }}
          />
        </Box>
      </Stack.Item>
      <Stack.Item>
        <Box bold mb={0.5}>
          姓名
        </Box>
        <Input
          fluid
          value={data.registered_name}
          maxLength={42}
          onChange={(value) =>
            act('set_field', { field: 'name', value: value })
          }
        />
      </Stack.Item>
      <Stack.Item>
        <Box bold mb={0.5}>
          职位
        </Box>
        <Input
          fluid
          value={data.assignment}
          maxLength={42}
          onChange={(value) =>
            act('set_field', { field: 'assignment', value: value })
          }
        />
      </Stack.Item>
      <Stack.Item>
        <Box bold mb={0.5}>
          介绍
        </Box>
        <TextArea
          fluid
          height="4rem"
          value={data.desc}
          onChange={(value) => act('set_field', { field: 'desc', value: value })}
        />
      </Stack.Item>
      <Stack.Item>
        <Box color="label" fontSize="11px">
          印记：{data.trim_name || '（无）'} · 外观：{data.card_icon_state}
        </Box>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          color="good"
          icon="id-card"
          content="生成这张卡"
          onClick={() => act('generate')}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          icon="rotate-left"
          content="恢复 ERT 默认"
          onClick={() => act('reset_ert')}
        />
      </Stack.Item>
    </Stack>
  );
};

const AppearanceTab = (props: { data: Data; act: (action: string, payload?: object) => void }) => {
  const { data, act } = props;
  return (
    <Section fill scrollable title="卡面外观">
      <Box mb={0.5} color="label">
        卡片底色就是 card.dmi 里现成的状态；徽记/部门色由「印记」决定。
      </Box>
      <Stack wrap>
        {data.appearances.map((appearance) => (
          <Stack.Item key={appearance.index}>
            <Button
              mb={1}
              mr={1}
              selected={appearance.selected}
              onClick={() => act('set_appearance', { index: appearance.index })}
              tooltip={appearance.name}
            >
              <img
                src={`data:image/png;base64,${appearance.icon}`}
                width="64px"
                height="64px"
                style={{ imageRendering: 'pixelated', display: 'block' }}
              />
              <Box fontSize="11px">{appearance.name}</Box>
            </Button>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

const TrimTab = (props: { data: Data; act: (action: string, payload?: object) => void }) => {
  const { data, act } = props;
  const [search, setSearch] = useState('');
  return (
    <Section fill scrollable title="印记（id_trim）">
      <Button
        fluid
        mb={0.5}
        icon="ban"
        selected={!data.trim_path}
        content="无印记（只保留卡面底色，不盖任何徽记）"
        onClick={() => act('clear_trim')}
      />
      <Input
        fluid
        mb={1}
        placeholder="搜索印记…"
        value={search}
        onChange={(value) => setSearch(value)}
      />
      {data.trim_groups.map((group) => {
        const trims = group.trims.filter(
          (trim) =>
            !search || trim.name?.toLowerCase().includes(search.toLowerCase()),
        );
        if (!trims.length) {
          return null;
        }
        return (
          <Section key={group.name} title={group.name} >
            <Stack wrap>
              {trims.map((trim) => (
                <Stack.Item key={trim.path}>
                  <Button
                    mb={0.5}
                    mr={0.5}
                    selected={data.trim_path === trim.path}
                    content={trim.name}
                    onClick={() => act('set_trim', { path: trim.path })}
                  />
                </Stack.Item>
              ))}
            </Stack>
          </Section>
        );
      })}
    </Section>
  );
};

const AccessTab = (props: { data: Data; act: (action: string, payload?: object) => void }) => {
  const { data, act } = props;
  const [search, setSearch] = useState('');
  return (
    <Section fill scrollable title="权限（与人事主管控制台同一份定义）">
      <Stack mb={1}>
        <Stack.Item grow>
          <Input
            fluid
            placeholder="搜索权限…"
            value={search}
            onChange={(value) => setSearch(value)}
          />
        </Stack.Item>
        <Stack.Item>
          <Button icon="eraser" content="清空" onClick={() => act('clear_access')} />
        </Stack.Item>
      </Stack>
      {data.access_groups.map((group) => {
        const entries = group.accesses.filter(
          (entry) =>
            !search || entry.desc?.toLowerCase().includes(search.toLowerCase()),
        );
        if (!entries.length) {
          return null;
        }
        return (
          <Section
            key={group.name}
            title={`${group.name}（${
              group.accesses.filter((entry) => data.access.includes(entry.ref))
                .length
            }/${group.accesses.length}）`}
          >
            {entries.map((entry) => (
              <Button.Checkbox
                key={entry.ref}
                mb={0.5}
                checked={data.access.includes(entry.ref)}
                content={entry.desc}
                onClick={() => act('toggle_access', { ref: entry.ref })}
              />
            ))}
          </Section>
        );
      })}
    </Section>
  );
};
