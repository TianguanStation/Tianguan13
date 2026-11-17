// THIS IS A TIANGUAN UI FILE
// 模块：admin_sound_board —— 全局音效面板 · 传输详情（由主面板的「查看传输详情」按钮打开）

import { useBackend } from '../backend';
import { Box, Section } from 'tgui-core/components';
import { Window } from '../layouts';
import {
  type TianGuanTransferPlayerRow,
  TianGuanTransferPlayerGrid,
} from './common/TianGuanAudioTransferGrid';

type Data = {
  interval: number;
  status: {
    players: TianGuanTransferPlayerRow[];
    ready_count: number;
    online_count: number;
    total: number;
    queue_left: number;
  };
};

export const TianGuanSoundBoardTransfer = () => {
  const { data } = useBackend<Data>();
  const { interval, status } = data;
  return (
    <Window title="全局音效 · 传输详情" width={760} height={620}>
      <Window.Content scrollable>
        <Section title="总览">
          <Box>
            音频 {status.total} 首 · 在线 {status.online_count} 人 · 已登记{' '}
            {status.players.length} 人 · 已就绪 {status.ready_count} 人
          </Box>
          <Box mt={0.5}>
            每份间隔 {Number(interval).toFixed(1)} 秒 · 队列剩余{' '}
            {status.queue_left} 份
          </Box>
          <Box mt={0.5} color="label">
            一份 = 一个在线玩家的一份音频。进度是
            <Box inline bold>
              服务端已推送
            </Box>
            的量；新加入的玩家会每秒自动补传。
          </Box>
        </Section>

        <TianGuanTransferPlayerGrid
          title="玩家"
          emptyText="（还没有需要传输的音频）"
          players={status.players}
        />
      </Window.Content>
    </Window>
  );
};
