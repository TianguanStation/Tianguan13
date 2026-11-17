// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
//This is Bubberstation's special client preferences file, for flavor text. Background stuff like cultures will go here later.

//NSFW Flavor text, a way to let players express their NSFW side without having it be visible in their normal flavor text.
//TODO: Make this save to the mob rather than just be pulled from the client.
//TODO: Everytime I try currently, it makes the NSFW headshot overwrite the regular headshot, both of which aren't associated with this. It's super weird.


/datum/preferences
	var/headshot_silicon = ""
	var/art_ref = ""

//This is literally just the same as the original headshot pref but for silicons :)
/datum/preference/text/headshot/silicon
	category = PREFERENCE_CATEGORY_SILICON_PREFS
	savefile_key = "headshot_silicon"

/datum/preference/text/headshot/silicon/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/preference/text/headshot/silicon/apply_headshot(value)
	if(stored_link[usr.ckey] != value)
		to_chat(usr, span_notice(LANG("datum.7da2af25f60c5607", list(span_bold("do not use a real life photo or use any image that is less than serious.")))))
		log_game("[usr] has set their Silicon Headshot image to '[value]'.")
	stored_link[usr?.ckey] = value
	usr?.client?.prefs.headshot_silicon = value

/datum/preference/text/headshot/art_ref
	savefile_key = "art_ref"

/datum/preference/text/headshot/art_ref

/datum/preference/text/headshot/art_ref/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["art_ref"] = value

/datum/preference/text/headshot/art_ref/apply_headshot(value)
	if(stored_link[usr.ckey] != value)
		log_game("[usr] has set their art reference image to '[value]'.")
	stored_link[usr?.ckey] = value
	usr?.client?.prefs.art_ref = value

//OOC notes for Silicons. Overwrites regular OOC notes when you are playing a Silicon character.
//TODO: Make this your regular OOC notes if you don't have Silicon ones. Every time I've tried, for some reason regular OOC notes haven't shown.
/datum/preference/text/ooc_notes/silicon
	category = PREFERENCE_CATEGORY_SILICON_PREFS
	savefile_key = "ooc_notes_silicon"

/datum/preference/text/ooc_notes/silicon/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

//Custom species and lore for silicons, also known as "Custom Model." This allows silicons to define a custom species rather than receiving, by default "A cyborg unit." BORING.
/datum/preference/text/custom_species/silicon
	category = PREFERENCE_CATEGORY_SILICON_PREFS
	savefile_key = "custom_species_silicon"

/datum/preference/text/custom_species/silicon/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/preference/text/custom_species_lore/silicon
	category = PREFERENCE_CATEGORY_SILICON_PREFS
	savefile_key = "custom_species_lore_silicon"

/datum/preference/text/custom_species_lore/silicon/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

//Config entry for the Silicon flavor text requirement
/datum/config_entry/number/silicon_flavor_text_character_requirement
	default = 150
