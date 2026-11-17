// THIS IS A TIANGUAN UI FILE
import {
  Box,
  Button,
  Collapsible,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type GuidePageNode = {
  kind: 'page';
  id: string;
  label: string;
};

type GuideCategoryNode = {
  kind: 'category';
  id: string;
  label: string;
  count: number;
  children: GuideNode[];
};

type GuideNode = GuidePageNode | GuideCategoryNode;

type GuideBrowserData = {
  guide_tree: GuideNode[];
  selected_id: string;
  selected_title: string | null;
  page_url: string | null;
  guide_available: boolean;
  selected_mode: string | null;
  supports_iframe: boolean;
  hud_button_visible: boolean;
};

const MODE_LABELS: Record<string, string> = {
  panel: '游戏内侧边面板',
  window: '游戏内独立弹窗',
  frame: '窗口右侧内嵌',
  browser: '系统默认浏览器',
};

function decodeDisplayUrl(url: string | null): string {
  if (!url) return '';
  try {
    return decodeURIComponent(url);
  } catch {
    return url;
  }
}

type GuideTreeProps = {
  nodes: GuideNode[];
  selectedId: string;
  onSelect: (id: string) => void;
};

const GuideTree = ({ nodes, selectedId, onSelect }: GuideTreeProps) => (
  <>
    {nodes.map((node) => {
      if (node.kind === 'category') {
        return (
          <Collapsible
            key={node.id}
            title={`${node.label}（${node.count}）`}
            child_mt={0}
            childStyles={{ padding: '0.25em 0 0.25em 0.5em' }}
          >
            <GuideTree
              nodes={node.children}
              selectedId={selectedId}
              onSelect={onSelect}
            />
          </Collapsible>
        );
      }

      return (
        <Button
          key={node.id}
          fluid
          selected={node.id === selectedId}
          textAlign="left"
          onClick={() => onSelect(node.id)}
        >
          {node.label}
        </Button>
      );
    })}
  </>
);

/** 指南浏览器：左侧目录来自 config/tianguan/guide_browser.json，右侧展示条目详情、
 * 可读地址与打开按钮（或当条目允许 frame 且支持内嵌时直接内嵌）。 */
export const GuideBrowser = () => {
  const { act, data } = useBackend<GuideBrowserData>();
  const {
    guide_tree,
    selected_id,
    selected_title,
    page_url,
    guide_available,
    selected_mode,
    supports_iframe,
    hud_button_visible,
  } = data;

  const frame_mode = selected_mode === 'frame';
  const to_browser = selected_mode === 'browser';
  const embed =
    !!guide_available && frame_mode && supports_iframe && !!page_url;
  const readableUrl = decodeDisplayUrl(page_url);
  const modeLabel = (selected_mode && MODE_LABELS[selected_mode]) || '游戏内打开';

  return (
    <Window width={960} height={680} title="指南浏览器">
      <Window.Content>
        <Stack fill>
          <Stack.Item width="320px">
            <Section
              fill
              scrollable
              title="指南目录"
              buttons={
                <Button
                  icon={hud_button_visible ? 'eye' : 'eye-slash'}
                  selected={hud_button_visible}
                  tooltip="开关左上角 HUD 快捷图标（同步写入游戏偏好设置）"
                  onClick={() => act('toggle_hud_button')}
                >
                  {hud_button_visible ? 'HUD图标: 开' : 'HUD图标: 关'}
                </Button>
              }
            >
              <GuideTree
                nodes={guide_tree}
                selectedId={selected_id}
                onSelect={(id) => act('select_page', { id })}
              />
            </Section>
          </Stack.Item>
          <Stack.Divider />
          <Stack.Item grow minWidth="0">
            <Section
              fill
              title={selected_title || '指南详情'}
              buttons={
                <Button
                  icon="external-link-alt"
                  disabled={!guide_available || !selected_title}
                  onClick={() => act('open_external')}
                >
                  在系统浏览器打开
                </Button>
              }
            >
              {!guide_available && (
                <NoticeBox danger>
                  指南目录未加载，请管理员检查天关指南配置。
                </NoticeBox>
              )}
              {!!guide_available && !embed && (
                <Stack vertical fill>
                  <Stack.Item>
                    <NoticeBox info>
                      天关 Wiki 默认在独立阅读窗口打开以绕过站点 X-Frame-Options
                      限制；先在左侧挑选条目，再点击下方按钮即可浏览。
                    </NoticeBox>
                  </Stack.Item>
                  <Stack.Item>
                    <Section title="当前选中条目">
                      <Box fontSize="1.15em" bold mb={0.75}>
                        {selected_title || '未选择'}
                      </Box>
                      <Box color="label" mb={0.5}>
                        打开方式：{modeLabel}
                      </Box>
                      {!!readableUrl && (
                        <Box
                          color="label"
                          fontSize="0.9em"
                          p={0.75}
                          backgroundColor="rgba(0, 0, 0, 0.25)"
                          style={{
                            borderRadius: '4px',
                            wordBreak: 'break-all',
                          }}
                        >
                          {readableUrl}
                        </Box>
                      )}
                      <Stack mt={1.25}>
                        <Stack.Item grow>
                          <Button
                            fluid
                            color="good"
                            icon={to_browser ? 'external-link-alt' : 'book-open'}
                            disabled={!selected_title}
                            onClick={() => act('open_page')}
                          >
                            {to_browser ? '在系统浏览器打开' : '在游戏内打开'}
                          </Button>
                        </Stack.Item>
                        <Stack.Item grow>
                          <Button
                            fluid
                            icon="external-link-alt"
                            disabled={!selected_title}
                            onClick={() => act('open_external')}
                          >
                            在系统浏览器打开
                          </Button>
                        </Stack.Item>
                      </Stack>
                    </Section>
                  </Stack.Item>
                </Stack>
              )}
              {embed && (
                <iframe
                  key={page_url}
                  src={page_url}
                  title={selected_title || ''}
                  style={{ border: 0, height: '100%', width: '100%' }}
                />
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
