/// Oversized crew can still fight normally. Walking onto another character is never an attack.
/mob/living/proc/tianguan_cannot_trample(mob/living/target)
	return HAS_TRAIT(src, TRAIT_OVERSIZED) && (iscarbon(target) || target.mind || target.client)
