// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/plant_gene/reagent
	mutability_flags = PLANT_GENE_GRAFTABLE | PLANT_GENE_REMOVABLE

/*
 *  Plant DNA disk
 */

/obj/item/disk/computer/plantgene
	name = "plant data disk"
	desc = "A disk for storing plant genetic data."
	icon_state = "datadisk4"
	custom_materials = list(/datum/material/iron=30, /datum/material/glass=10)
	var/datum/plant_gene/gene
	read_only = FALSE //Well, it's still a floppy disk
	obj_flags = UNIQUE_RENAME

/obj/item/disk/computer/plantgene/Initialize(mapload)
	. = ..()
	set_sticker_icon_state("o_dna1")
	src.pixel_x = rand(-5, 5)
	src.pixel_y = rand(-5, 5)

/obj/item/disk/computer/plantgene/proc/update_disk_name()
	if(gene)
		name = "[gene.get_name()] (plant data disk)"
	else
		name = "plant data disk"

/obj/item/disk/computer/plantgene/attack_self(mob/user)
	read_only = !read_only
	to_chat(user, LANG("obj.eab97949e6aa1c4e", list(src.read_only ? "protected" : "unprotected")))

/obj/item/disk/computer/plantgene/examine(mob/user)
	. = ..()
	if(gene && (istype(gene, /datum/plant_gene/core/potency)))
		. += LANG("obj.13cee2beefc4364b", null)
	. += LANG("obj.4add0e25760d40db", list(src.read_only ? "protected" : "unprotected"))
