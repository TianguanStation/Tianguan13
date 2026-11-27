#define BULLDOG_DESCRIPTION "A magazine-fed semi-automatic shotgun known as the Bulldog by boarding parties. It uses specialized eight-round drum magazines and can carry a spare magazine for quick swaps."

/obj/item/gun/ballistic/shotgun/bulldog
	desc = BULLDOG_DESCRIPTION

/obj/item/gun/ballistic/shotgun/bulldog/lang_localize_desc_for_display(display_desc)
	if(display_desc == BULLDOG_DESCRIPTION)
		return lang_reverse_text(display_desc)
	return ..()

#undef BULLDOG_DESCRIPTION
