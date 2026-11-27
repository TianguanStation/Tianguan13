/// 验证蓝红球宠物生命周期、天武剑拾取/重置/GC 清理及翻滚闪避时机（modular_tianguan/modules/lanhongqiu_pet）。
/datum/unit_test/tianguan_lanhongqiu_pet

/datum/unit_test/tianguan_lanhongqiu_pet/Run()
	var/mob/living/basic/pet/lanhongqiu/pet = allocate(/mob/living/basic/pet/lanhongqiu)
	var/obj/item/skysword/sword = allocate(/obj/item/skysword)

	// 1. 远程点击不应拾取天武剑
	pet.UnarmedAttack(sword, FALSE)
	TEST_ASSERT_NULL(pet.weapon, "远程点击不应拾取天武剑")
	TEST_ASSERT_EQUAL(sword.loc, run_loc_floor_bottom_left, "远程点击后天武剑应留在原地")

	// 2. 近身点击应拾取天武剑，并更新伤害与图标
	pet.UnarmedAttack(sword, TRUE)
	TEST_ASSERT_EQUAL(pet.weapon, sword, "近身点击应拾取天武剑")
	TEST_ASSERT_EQUAL(sword.loc, pet, "拾取后天武剑应进入蓝红球体内")
	TEST_ASSERT_EQUAL(pet.melee_damage_lower, 18, "持剑后最小近战伤害应为 18")
	TEST_ASSERT_EQUAL(pet.melee_damage_upper, 22, "持剑后最大近战伤害应为 22")
	TEST_ASSERT_EQUAL(pet.icon_state, "lanhongqiu_sword", "持剑后图标应切换为 lanhongqiu_sword")

	// 3. 死亡掉落天武剑并重置近战伤害
	pet.death()
	TEST_ASSERT_NULL(pet.weapon, "死亡后应清空 weapon 引用")
	TEST_ASSERT_EQUAL(sword.loc, run_loc_floor_bottom_left, "死亡后天武剑应掉回地面")
	TEST_ASSERT_EQUAL(pet.melee_damage_lower, 0, "死亡丢剑后最小近战伤害应重置为 0")
	TEST_ASSERT_EQUAL(pet.melee_damage_upper, 0, "死亡丢剑后最大近战伤害应重置为 0")

	// 4. 复活后应维持空手伤害与常态图标
	pet.revive(ALL)
	TEST_ASSERT_EQUAL(pet.melee_damage_lower, 0, "复活后空手最小近战伤害应保持 0")
	TEST_ASSERT_EQUAL(pet.melee_damage_upper, 0, "复活后空手最大近战伤害应保持 0")
	TEST_ASSERT_EQUAL(pet.icon_state, "lanhongqiu", "复活后图标应恢复为 lanhongqiu")

	// 5. 再次拾取后若天武剑被 qdel，应同步清理引用与伤害并恢复图标
	pet.UnarmedAttack(sword, TRUE)
	TEST_ASSERT_EQUAL(pet.weapon, sword, "复活后应可再次拾取天武剑")
	qdel(sword)
	TEST_ASSERT_NULL(pet.weapon, "天武剑销毁后应清空 weapon 引用")
	TEST_ASSERT_EQUAL(pet.melee_damage_lower, 0, "天武剑销毁后最小近战伤害应重置为 0")
	TEST_ASSERT_EQUAL(pet.melee_damage_upper, 0, "天武剑销毁后最大近战伤害应重置为 0")
	TEST_ASSERT_EQUAL(pet.icon_state, "lanhongqiu", "天武剑销毁后图标应恢复为 lanhongqiu")

	// 6. 对自身触发翻滚不应获得弹道免疫；正常指示阶段应立即获得并在到期后移除
	TEST_ASSERT_NOTNULL(pet.charge, "蓝红球初始化应授予 dodgeroll 动作")
	pet.charge.do_charge(pet, pet, pet.charge.charge_delay, pet.charge.charge_past)
	TEST_ASSERT(!HAS_TRAIT(pet, TRAIT_UNHITTABLE_BY_PROJECTILES), "对自身触发翻滚不应获得弹道免疫")

	pet.charge.do_charge_indicator(pet, run_loc_floor_top_right)
	TEST_ASSERT(HAS_TRAIT(pet, TRAIT_UNHITTABLE_BY_PROJECTILES), "翻滚指示阶段应立即获得弹道免疫")
	sleep(TAUNT_EMOTE_DURATION + 0.2 SECONDS)
	TEST_ASSERT(!HAS_TRAIT(pet, TRAIT_UNHITTABLE_BY_PROJECTILES), "翻滚结束后应移除弹道免疫")

	// 7. 趴着死亡再复活后，图标应与仍在休息的姿势一致。
	pet.set_resting(TRUE, instant = TRUE)
	TEST_ASSERT_EQUAL(pet.icon_state, "lanhongqiu_rest", "趴下后应显示休息图标")
	pet.death()
	TEST_ASSERT_EQUAL(pet.icon_state, "lanhongqiu_dead", "死亡后应显示死亡图标")
	TEST_ASSERT(pet.revive(ALL), "蓝红球应能从死亡中复活")
	TEST_ASSERT(pet.resting, "复活应保留原来的休息状态")
	TEST_ASSERT_EQUAL(pet.icon_state, "lanhongqiu_rest", "复活后仍在休息时应显示休息图标")
	pet.set_resting(FALSE, instant = TRUE)
	TEST_ASSERT_EQUAL(pet.icon_state, "lanhongqiu", "结束休息后应恢复常态图标")
