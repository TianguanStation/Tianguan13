// THIS IS A TIANGUAN UI FILE
// 倒计时 · 传输详情（由全局倒计时面板的「查看传输详情」按钮打开）

import { useBackend } from '../backend';
import { Box, Section } from 'tgui-core/components';
import { Window } from '../layouts';
import {
  type TianGuanTransferPlayerRow,
  TianGuanTransferPlayerGrid,
} from './common/TianGuanAudioTransferGrid';

type Data = {
  state: number;
  remaining: number;
  silent: boolean;
  music_interval: number;
  rate_manual: number;
  selection_count: number;
  queue_left: number;
  status: {
    players: TianGuanTransferPlayerRow[];
    ready_count: number;
    online_count: number;
    total: number;
  };
};

const STATE_TEXT = ['未进行任何设置', '倒计时中', '已暂停', '结束文本中'];

export const TianGuanCountdownTransfer = () => {
  const { data } = useBackend<Data>();
  const {
    state,
    remaining,
    silent,
    music_interval,
    rate_manual,
    selection_count,
    queue_left,
    status,
  } = data;
  return (
    <Window title="倒计时 · 传输详情" width={760} height={620}>
      <Window.Content scrollable>
        <Section title="总览">
          <Box>
            状态：{STATE_TEXT[state] ?? '未知'}
            {state === 1 ? `（剩余 ${Math.max(Math.round(remaining), 0)} 秒）` : ''}
            {silent ? ' · 纯准备模式' : ''}
          </Box>
          <Box mt={0.5}>
            已选 {selection_count} 首 · 节奏：
            {rate_manual > 0
              ? `手动 ${rate_manual} 秒/份`
              : `自动 ${music_interval.toFixed(1)} 秒/份`}
            {' · '}队列剩余 {queue_left} 份
          </Box>
          <Box mt={0.5} color="label">
            一份 = 一个玩家的一首歌（只有一首歌时就是「秒/人」）。进度是**服务端已推送**的量。
          </Box>
        </Section>

        <TianGuanTransferPlayerGrid
          title={`玩家（在线 ${status.online_count} · 已登记 ${status.players.length} · 就绪 ${status.ready_count}）`}
          emptyText="（还没有启动倒计时音频传输）"
          players={status.players}
        />
      </Window.Content>
    </Window>
  );
};
