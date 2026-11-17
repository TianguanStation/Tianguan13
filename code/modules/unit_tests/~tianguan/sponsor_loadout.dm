/// 验证天关赞助者配装（modular_tianguan/modules/sponsor_loadout_items）：
/// 1) 解锁清单与自建条目均存在于 GLOB.all_loadout_datums 且 donator_only = TRUE；
/// 2) 全仓所有配装条目与捐赠者公寓模板均不再残留 ckeywhitelist 锁定；
/// 3) 所有 donator 条目的 donator_tier 均已归一化到 <= DONATOR_TIER_1。
/datum/unit_test/tianguan_sponsor_loadout

/datum/unit_test/tianguan_sponsor_loadout/Run()
	for(var/path in tianguan_sponsor_item_paths())
		var/datum/loadout_item/entry = GLOB.all_loadout_datums[path]
		if(isnull(entry))
			TEST_FAIL("赞助者解锁清单里的 [path] 没有对应的配装条目（上游改名或删除了？）")
			continue
		if(!entry.donator_only)
			TEST_FAIL("[entry.type]（[path]）应为 donator_only")
		if(LAZYLEN(entry.ckeywhitelist))
			TEST_FAIL("[entry.type]（[path]）的 ckeywhitelist 应已清空，实为 [jointext(entry.ckeywhitelist, ", ")]")

	var/list/own_items = list(
		/obj/item/storage/box/balloons,
		/obj/item/skillchip/job/clown,
		/obj/item/holosign_creator/hardlight_wheelchair,
		/obj/item/toy/plush/tianguan/xindiliya,
		/obj/item/toy/plush/tianguan/huitu,
		/obj/item/toy/plush/tianguan/luna,
		/obj/item/toy/plush/tianguan/lanhongqiu,
		/obj/item/toy/plush/tianguan/mona,
	)
	for(var/path in own_items)
		var/datum/loadout_item/entry = GLOB.all_loadout_datums[path]
		if(isnull(entry))
			TEST_FAIL("缺少天关赞助者配装条目：[path]")
			continue
		if(!entry.donator_only)
			TEST_FAIL("天关赞助者配装条目 [entry.type] 应为 donator_only")
		if(LAZYLEN(entry.ckeywhitelist))
			TEST_FAIL("天关赞助者配装条目 [entry.type] 不应保留 ckeywhitelist")

	for(var/path in GLOB.all_loadout_datums)
		var/datum/loadout_item/entry = GLOB.all_loadout_datums[path]
		if(LAZYLEN(entry.ckeywhitelist))
			TEST_FAIL("配装条目 [entry.type]（[path]）仍残留个人 ckeywhitelist：[jointext(entry.ckeywhitelist, ", ")]")
		if(entry.donator_tier > DONATOR_TIER_1)
			TEST_FAIL("配装条目 [entry.type]（[path]）的 donator_tier 为 [entry.donator_tier]，应已归一化为 <= DONATOR_TIER_1")
