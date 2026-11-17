// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/clothing/neck/human_petcollar/locked/ringbell
	name = "ringing bell collar"
	desc = "A soft collar that chimes for your little pet!"
	icon_state = "/obj/item/clothing/neck/human_petcollar/locked/ringbell"
	post_init_icon_state = "ringbell"
	greyscale_config = /datum/greyscale_config/collar/ringbell
	greyscale_config_worn = /datum/greyscale_config/collar/ringbell/worn
	greyscale_colors = "#FF4F66#FFCC00"

/obj/item/clothing/neck/human_petcollar/locked/ringbell/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/squeak, list('modular_zubbers/sound/misc/collarbell1.ogg'=1,'modular_zubbers/sound/misc/collarbell2.ogg'=1), 50, 100, 8)


