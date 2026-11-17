// THIS IS A TIANGUAN UI FILE - 天关模块 GuideBrowser 的偏好条目
//
// 对应 modular_tianguan/modules/guide_browser/code/guide_prefs.dm 里的
// /datum/preference/toggle/tianguan_guide_button（savefile_key = tianguan_show_guide_hud）。
import { CheckboxInput, type FeatureToggle } from '../base';

export const tianguan_show_guide_hud: FeatureToggle = {
  name: '在左上角显示指南按钮',
  category: 'UI',
  description:
    '默认关闭。勾选后会立即在左上角 HUD 显示「指南浏览器」快捷按钮并在每回合保留；未开启时随时可通过 OOC 栏「指南浏览器」打开目录。',
  component: CheckboxInput,
};
