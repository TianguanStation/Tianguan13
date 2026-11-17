// SPONSOR_LOADOUT_ITEMS - 天关赞助者玩偶（本模块自建物品）
//
// 五只赞助者专属玩偶：在配装（loadout）界面里开放给「赞助者」，判定与其它赞助者物品同源
// （donator_only ⇒ 走捐赠者机制，名单在 config/skyrat/donators.txt，见 sponsor_loadout_items.dm 说明）。
//
// 素材：天关提供的五张玩偶图，落在本模块的 icons/plushies.dmi（32x32，一态一帧，dirs=1）。

#define TIANGUAN_PLUSH_ICON 'modular_tianguan/modules/sponsor_loadout_items/icons/plushies.dmi'

/// 天关自建玩偶的公共父类（不在父类覆盖 icon，以免继承默认的 icon_state = "debug" 在新图集中找不到）
/obj/item/toy/plush/tianguan
	inhand_icon_state = null

/obj/item/toy/plush/tianguan/xindiliya
	name = "辛迪莉亚娃娃"
	desc = "一个猩红玩偶，有一种阴谋与邪恶。"
	icon = TIANGUAN_PLUSH_ICON
	icon_state = "plushie_xindiliya"

/obj/item/toy/plush/tianguan/huitu
	name = "绘兔娃娃"
	desc = "某一天绘兔在图书馆里拿起了针线与织布。。。于是绘兔娃娃诞生了。"
	icon = TIANGUAN_PLUSH_ICON
	icon_state = "plushie_huitu"

/obj/item/toy/plush/tianguan/luna
	name = "Luna娃娃"
	desc = "心血来潮的绘兔在那天看着Luna，以她的样貌做出来绘兔的第二个娃娃。"
	icon = TIANGUAN_PLUSH_ICON
	icon_state = "plushie_luna"

/obj/item/toy/plush/tianguan/lanhongqiu
	name = "蓝红球娃娃"
	desc = "蓝红球的生日礼物——绘兔专定"
	icon = TIANGUAN_PLUSH_ICON
	icon_state = "plushie_lanhongqiu"

/obj/item/toy/plush/tianguan/mona
	name = "Mona娃娃"
	desc = "来自绘兔给mona的专属定制"
	icon = TIANGUAN_PLUSH_ICON
	icon_state = "plushie_mona"

#undef TIANGUAN_PLUSH_ICON

// ——— 配装条目 ———

/datum/loadout_item/toys/plush/xindiliya
	name = "辛迪莉亚娃娃"
	item_path = /obj/item/toy/plush/tianguan/xindiliya
	donator_only = TRUE

/datum/loadout_item/toys/plush/huitu
	name = "绘兔娃娃"
	item_path = /obj/item/toy/plush/tianguan/huitu
	donator_only = TRUE

/datum/loadout_item/toys/plush/luna
	name = "Luna娃娃"
	item_path = /obj/item/toy/plush/tianguan/luna
	donator_only = TRUE

/datum/loadout_item/toys/plush/lanhongqiu
	name = "蓝红球娃娃"
	item_path = /obj/item/toy/plush/tianguan/lanhongqiu
	donator_only = TRUE

/datum/loadout_item/toys/plush/mona
	name = "Mona娃娃"
	item_path = /obj/item/toy/plush/tianguan/mona
	donator_only = TRUE
