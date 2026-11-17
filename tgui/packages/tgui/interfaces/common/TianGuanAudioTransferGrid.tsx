// THIS IS A TIANGUAN UI FILE
// Shared wrapping player-progress grid for TianGuan audio pre-transfer monitors.

import { Box, ProgressBar, Section } from 'tgui-core/components';

export type TianGuanTransferPlayerRow = {
  ckey: string;
  name: string;
  pushed: number;
  total: number;
  ready: boolean;
  online: boolean;
  left?: boolean;
};

type TransferPlayerGridProps = {
  title: string;
  emptyText: string;
  players: TianGuanTransferPlayerRow[];
};

const TransferPlayerTile = (props: { player: TianGuanTransferPlayerRow }) => {
  const { player } = props;
  const ratio = player.total ? player.pushed / player.total : 0;
  return (
    <Box
      width="12.5rem"
      mr={0.5}
      mb={0.5}
      p={0.5}
      backgroundColor="rgba(0, 0, 0, 0.25)"
    >
      <Box
        bold
        color={!player.online ? 'bad' : player.ready ? 'good' : undefined}
      >
        {player.name}
        {player.online ? '' : '（离线）'}
      </Box>
      <ProgressBar value={ratio} mt={0.3}>
        {player.pushed}/{player.total}
      </ProgressBar>
    </Box>
  );
};

export const TianGuanTransferPlayerGrid = (props: TransferPlayerGridProps) => {
  const { title, emptyText, players } = props;
  return (
    <Section title={title}>
      {players.length === 0 ? (
        <Box color="label">{emptyText}</Box>
      ) : (
        <Box style={{ display: 'flex', flexWrap: 'wrap' }}>
          {players.map((player) => (
            <TransferPlayerTile key={player.ckey} player={player} />
          ))}
        </Box>
      )}
    </Section>
  );
};
