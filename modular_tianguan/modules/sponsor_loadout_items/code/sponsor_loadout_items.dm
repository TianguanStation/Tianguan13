// SPONSOR_LOADOUT_ITEMS - 天关赞助者配装物品
// 天关模块：给「赞助者」开放配装（loadout）物品。
//
// 赞助者身份：走 DONATOR_LEGACY_SYSTEM，名单在 config/skyrat/donators.txt
// （donator_only = TRUE；admins 默认通过 SSplayer_ranks.is_donator()）。
//
// 本模块在运行期 /datum/loadout_item/New() 里统一处理：
// 1. 清单 TIANGUAN_SPONSOR_ITEM_PATHS 中所有现存于本仓库的 Skyrat/TianGuan 赞助者条目；
// 2. 所有仍带 ckeywhitelist 的捐赠者私人条目（modular_skyrat / modular_zubbers / modular_zzplurt）；
// 3. 所有 donator_only / donator_tier 条目（把分层 donator_tier 统一降为 DONATOR_TIER_1，适配 donators.txt）。
// 结果：全部捐赠者私人条目清空个人 ckey 限制，统一开放给天关赞助者，同时保留原条目自带的职业限定。

#define TIANGUAN_SPONSOR_ITEM_PATHS list( \
	/* belts (1) */ \
	/obj/item/storage/belt/fannypack/occult, \
	/* glasses (4) */ \
	/obj/item/clothing/glasses/eyepatch/rosecolored, \
	/obj/item/clothing/glasses/gold_aviators, \
	/obj/item/clothing/glasses/hud/security/sunglasses/gars/giga/roselia, \
	/obj/item/clothing/glasses/rosecolored, \
	/* gloves (4) */ \
	/obj/item/clothing/gloves/fingerless/blutigen_wraps, \
	/obj/item/clothing/gloves/mikugloves, \
	/obj/item/clothing/gloves/netra, \
	/obj/item/clothing/gloves/skyy, \
	/* head (11) */ \
	/obj/item/clothing/glasses/welding/steampunk_goggles, \
	/obj/item/clothing/head/anubite, \
	/obj/item/clothing/head/avipilot, \
	/obj/item/clothing/head/costume/ushanka/frosty, \
	/obj/item/clothing/head/drake_skull, \
	/obj/item/clothing/head/helmet/space/plasmaman/candlejax2, \
	/obj/item/clothing/head/mikuhair, \
	/obj/item/clothing/head/nanotrasen_consultant/hubert, \
	/obj/item/clothing/head/razurathhat, \
	/obj/item/clothing/head/recruiter_cap, \
	/obj/item/instrument/piano_synth/headphones/catear_headphone, \
	/* inhand / accessories / pocket (10) */ \
	/obj/item/canvas/drawingtablet, \
	/obj/item/card/fuzzy_license, \
	/obj/item/hairbrush/tactical, \
	/obj/item/holocigarette/cigar, \
	/obj/item/holosign_creator/hardlight_wheelchair, \
	/obj/item/implanter/toaster, \
	/obj/item/mob_holder/pet/donator/centralsmith, \
	/obj/item/poster/korpstech, \
	/obj/item/stamp/cat, \
	/* mask (6) */ \
	/obj/item/clothing/mask/animal/wolf, \
	/obj/item/clothing/mask/breath/vox/octus, \
	/obj/item/clothing/mask/gas/britches, \
	/obj/item/clothing/mask/gas/larpswat, \
	/obj/item/clothing/mask/hheart, \
	/obj/item/clothing/mask/luchador/enzo, \
	/* neck (6) */ \
	/obj/item/clothing/neck/cloak/fluffycloak, \
	/obj/item/clothing/neck/cloak/grunnyyy, \
	/obj/item/clothing/neck/cloak/inferno, \
	/obj/item/clothing/neck/cross, \
	/obj/item/clothing/neck/fishpendant, \
	/obj/item/clothing/suit/hooded/cloak/zuliecloak, \
	/* shoes (5) */ \
	/obj/item/clothing/shoes/clown_shoes/britches, \
	/obj/item/clothing/shoes/fancy_heels/drag, \
	/obj/item/clothing/shoes/jackboots/netra, \
	/obj/item/clothing/shoes/jackboots/noble, \
	/obj/item/clothing/shoes/sneakers/mikuleggings, \
	/* suit (22) */ \
	/obj/item/clothing/suit/armor/skyy, \
	/obj/item/clothing/suit/armor/vest/darkcarapace, \
	/obj/item/clothing/suit/armor/vest/nanotrasen_consultant/hubert, \
	/obj/item/clothing/suit/armor/vest/warden/rax, \
	/obj/item/clothing/suit/blutigen_kimono, \
	/obj/item/clothing/suit/hooded/colorblockhoodie, \
	/obj/item/clothing/suit/hooded/occult, \
	/obj/item/clothing/suit/hooded/sigmarcoat, \
	/obj/item/clothing/suit/hooded/techpriest, \
	/obj/item/clothing/suit/jacket/brasspriest, \
	/obj/item/clothing/suit/jacket/cherno, \
	/obj/item/clothing/suit/jacket/delta, \
	/obj/item/clothing/suit/jacket/gorlex_harness, \
	/obj/item/clothing/suit/jacket/hydrogenrobes, \
	/obj/item/clothing/suit/jacket/ryddid, \
	/obj/item/clothing/suit/jacket/skyy, \
	/obj/item/clothing/suit/razurathcoat, \
	/obj/item/clothing/suit/scraparmour, \
	/obj/item/clothing/suit/toggle/labcoat/skyrat/tenrai, \
	/obj/item/clothing/suit/toggle/labcoat/vic_dresscoat_donator, \
	/obj/item/clothing/suit/toggle/rainbowcoat, \
	/obj/item/clothing/suit/toggle/recruiter_jacket, \
	/* toys (2) */ \
	/obj/item/hairbrush/switchblade, \
	/obj/item/toy/plush/skyrat/immovable_rod, \
	/* under (26) */ \
	/obj/item/clothing/under/bimpcap, \
	/obj/item/clothing/under/bubbly_clown/skirt, \
	/obj/item/clothing/under/costume/draculass, \
	/obj/item/clothing/under/costume/dragon_maid, \
	/obj/item/clothing/under/costume/skyrat/kimono/sigmar, \
	/obj/item/clothing/under/blutigen_undergarment, \
	/obj/item/clothing/under/custom/lannese, \
	/obj/item/clothing/under/custom/lannese/vambrace, \
	/obj/item/clothing/under/mikubikini, \
	/obj/item/clothing/under/misc/skyrat/mechanic, \
	/obj/item/clothing/under/nt_idol_skirt, \
	/obj/item/clothing/under/occult, \
	/obj/item/clothing/under/pants/skyy, \
	/obj/item/clothing/under/plasmaman/candlejax, \
	/obj/item/clothing/under/plasmaman/candlejax2, \
	/obj/item/clothing/under/plasmaman/jax2, \
	/obj/item/clothing/under/rank/blueshield/netra, \
	/obj/item/clothing/under/rank/captain/dress, \
	/obj/item/clothing/under/rank/cargo/qm/skirt/old, \
	/obj/item/clothing/under/rank/civilian/chaplain/divine_archer/noble, \
	/obj/item/clothing/under/rank/civilian/clown/britches, \
	/obj/item/clothing/under/rank/nanotrasen_consultant/hubert, \
	/obj/item/clothing/under/rank/security/head_of_security/alt/roselia, \
	/obj/item/clothing/under/rank/security/rax, \
	/obj/item/clothing/under/recruiter_uniform, \
	/obj/item/clothing/under/tactichill, \
	/obj/item/clothing/under/wetsuit_norm \
)

/// 将配装条目统一设为「天关赞助者可用」：清空个人 ckey 白名单，设 donator_only = TRUE 并规范到 DONATOR_TIER_1。
/proc/tianguan_unlock_sponsor_item(datum/loadout_item/entry)
	entry.ckeywhitelist = null
	entry.donator_only = TRUE
	entry.donator_tier = DONATOR_TIER_1

/datum/loadout_item
	/// 该条目的 ckeywhitelist 是「真实私人限定」，赞助者解锁不得清空它。
	/// 目前只有蓝红球召唤信标使用（见 modular_tianguan/modules/lanhongqiu_pet）。
	var/private_ckey_lock = FALSE

/// 在 modular_zzplurt/code/modules/loadout/loadout_items.dm 之后接管 /datum/loadout_item/New()：
/// 清单条目、现存 ckeywhitelist 私人条目，以及各类 donator 条目统一开放给所有天关赞助者。
/datum/loadout_item/New(category)
	var/orig_donator_only = donator_only
	var/orig_donator_tier = donator_tier
	. = ..()
	if(private_ckey_lock)
		donator_only = orig_donator_only
		donator_tier = orig_donator_tier
		return
	if(tianguan_sponsor_item_paths()[item_path] || LAZYLEN(ckeywhitelist) || donator_only || donator_tier)
		tianguan_unlock_sponsor_item(src)

/// 返回天关赞助者清单查找表（item_path -> TRUE），惰性构建以避开 GLOBAL_LIST_INIT 初始化顺序竞争。
/proc/tianguan_sponsor_item_paths()
	var/static/list/lookup
	if(isnull(lookup))
		lookup = list()
		for(var/path in TIANGUAN_SPONSOR_ITEM_PATHS)
			lookup[path] = TRUE
	return lookup

// ——— 本仓库没有配装条目、需本模块新建的赞助者条目 ———
// 注：hardlight_wheelchair 已在 modular_skyrat donator_personal.dm 中存在配装条目，走上方清单统一解锁。

/// 长气球盒 —— Toys 页签
/datum/loadout_item/toys/sponsor_box_of_long_balloons
	name = "box of long balloons"
	item_path = /obj/item/storage/box/balloons
	donator_only = TRUE

/// B@L00NY 技能芯片 —— Other 页签
/datum/loadout_item/pocket_items/sponsor_b_l00ny_skillchip
	name = "B@L00NY skillchip"
	item_path = /obj/item/skillchip/job/clown
	donator_only = TRUE

// ——— 额外追加职业限定的既有条目 ———

/// 需求指定：NTC（Nanotrasen Consultant）独有
/datum/loadout_item/head/razurathhat
	restricted_roles = list(JOB_NT_REP)

/datum/loadout_item/suit/razurathcoat
	restricted_roles = list(JOB_NT_REP)

#undef TIANGUAN_SPONSOR_ITEM_PATHS
