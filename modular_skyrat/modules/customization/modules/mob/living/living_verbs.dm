// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
GLOBAL_VAR_INIT(temporary_flavor_text_indicator, generate_temporary_flavor_text_indicator())

/proc/generate_temporary_flavor_text_indicator()
	var/mutable_appearance/temporary_flavor_text_indicator = mutable_appearance('modular_skyrat/modules/indicators/icons/temporary_flavor_text_indicator.dmi', "flavor", FLY_LAYER)
	temporary_flavor_text_indicator.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA | KEEP_APART
	return temporary_flavor_text_indicator

GAME_VERB_DESC(/mob/living, set_temporary_flavor, "设置临时风味文本", "Allows you to set a temporary flavor text.", "IC")
	if(IS_UNCONSCIOUS_OR_CRIT(src))
		to_chat(src, span_warning(LANG("mob.a3ef0a20fc538af4", null)))
		return

	var/msg = tgui_input_text(src, LANG("mob.3b4f7fa20fd17927", null), LANG("mob.bfbb9785cda3b2ae", null), temporary_flavor_text, max_length = MAX_FLAVOR_LEN, multiline = TRUE)
	if(msg == null)
		return

	// Turn empty input into no flavor text
	var/result = msg || null
	temporary_flavor_text = result
	update_appearance(UPDATE_ICON|UPDATE_OVERLAYS)

/mob/living/update_overlays()
	. = ..()
	if (temporary_flavor_text)
		. += GLOB.temporary_flavor_text_indicator

GAME_VERB(/mob/living, reflexes_verb, "切换敏捷反应", "IC")
	if(!HAS_TRAIT_FROM(src, TRAIT_QUICKREFLEXES, REF(src)))
		ADD_TRAIT(src, TRAIT_QUICKREFLEXES, REF(src))
		to_chat(src, span_notice("[get_reflexes_gain_text()]"))
	else
		REMOVE_TRAIT(src, TRAIT_QUICKREFLEXES, REF(src))
		to_chat(src, span_notice("[get_reflexes_lose_text()]"))

/mob/living/proc/get_reflexes_gain_text()
	return "You don't feel like being touched right now."

/mob/living/proc/get_reflexes_lose_text()
	return "You'll allow yourself to be touched now."

/mob/living/silicon/get_reflexes_gain_text()
	return "Our systems will disallow platonic contact."

/mob/living/silicon/get_reflexes_lose_text()
	return "Our systems will allow platonic contact."

GAME_VERB(/mob/living/carbon/human, lick, "舔", "IC")
	VERB_ARG_TYPED(target, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_VIEW, /mob/living/carbon/human)
	if(!istype(target) || !(target in get_adjacent_humans()))
		return FALSE

	var/taste = target?.dna?.features["taste"]
	if(!taste)
		to_chat(src, span_warning(LANG("mob.77fc7cc54a3486a2", list(target))))
		return FALSE

	to_chat(src, span_notice(LANG("mob.bed05d4616376ba8", list(target, taste))))
	to_chat(target, span_notice(LANG("mob.c262fc2bc1bcf54b", list(src))))

GAME_VERB(/mob/living/carbon/human, smell, "闻", "IC")
	VERB_ARG_TYPED(target, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_VIEW, /mob/living/carbon/human)
	if(!istype(target) || !(target in get_adjacent_humans()))
		return FALSE

	var/smell = target?.dna?.features["smell"]
	if(!smell)
		to_chat(src, span_warning(LANG("mob.2a8abd411466dfc2", list(target))))
		return FALSE

	to_chat(src, span_notice(LANG("mob.28205dc00f302dac", list(target, smell))))

/// Returns a list containing all of the humans adjacent to the user.
/mob/living/proc/get_adjacent_humans()
	var/list/nearby_humans = orange(1, src)
	for(var/mob/living/carbon/human/nearby_human as anything in nearby_humans)
		if(ishuman(nearby_human))
			continue

		nearby_humans -= nearby_human

	return nearby_humans

