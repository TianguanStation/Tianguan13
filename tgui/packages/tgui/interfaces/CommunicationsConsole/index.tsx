import { Box, Button, Section } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { Window } from '../../layouts';
import {
  StationVoiceButton,
  StationVoiceControls,
} from '../StationVoiceConsole';
import { PageBuyingShuttle } from './BuyingShuttle';
import { PageChangingStatus } from './ChangingStatus';
import { PageMain } from './Main';
import { PageMessages } from './Messages';
import { NoConnectionModal } from './NoConnectionModal';
import { type CommsConsoleData, ShuttleState } from './types';

export function CommunicationsConsole(props) {
  const { act, data } = useBackend<CommsConsoleData>();
  const {
    authenticated,
    authorizeName,
    canLogOut,
    canRequestSafeCode,
    emagged,
    hasConnection,
    page,
    safeCodeDeliveryArea,
    safeCodeDeliveryWait,
  } = data;

  if (data.voiceEditor && data.canSetStationVoices) {
    return (
      <Window width={400} height={650}>
        <Window.Content scrollable>
          <StationVoiceControls
            onBack={() => act('stationVoices', { operation: 'back' })}
          />
        </Window.Content>
      </Window>
    );
  }

  let currentPage;
  switch (page) {
    case ShuttleState.BUYING_SHUTTLE:
      currentPage = <PageBuyingShuttle />;
      break;
    case ShuttleState.CHANGING_STATUS:
      currentPage = <PageChangingStatus />;
      break;
    case ShuttleState.MAIN:
      currentPage = <PageMain />;
      break;
    case ShuttleState.MESSAGES:
      currentPage = <PageMessages />;
      break;
    default:
      currentPage = <Box>Page not implemented: {page}</Box>;
      break;
  }

  return (
    <Window width={400} height={650} theme={emagged ? 'syndicate' : undefined}>
      <Window.Content scrollable>
        {!hasConnection && <NoConnectionModal />}

        {(canLogOut || !authenticated) && (
          <Section title="Authentication">
            <Button
              icon={authenticated ? 'sign-out-alt' : 'sign-in-alt'}
              color={authenticated ? 'bad' : 'good'}
              onClick={() => act('toggleAuthentication')}
            >
              {authenticated
                ? `Log Out${authorizeName ? ` (${authorizeName})` : ''}`
                : 'Log In'}
            </Button>
            {!authenticated && !!data.canSetStationVoices && (
              <StationVoiceButton />
            )}
          </Section>
        )}

        {canRequestSafeCode ? (
          <Section title="Emergency Safe Code">
            <Button
              icon="key"
              color="good"
              onClick={() => act('requestSafeCodes')}
            >
              Request Safe Code
            </Button>
          </Section>
        ) : (
          !!safeCodeDeliveryWait && (
            <Section title="Emergency Safe Code Delivery" color="label">
              {`Drop pod to ${safeCodeDeliveryArea} in \
            ${Math.round(safeCodeDeliveryWait / 10)}s`}
            </Section>
          )
        )}

        {!!authenticated && currentPage}
      </Window.Content>
    </Window>
  );
}
