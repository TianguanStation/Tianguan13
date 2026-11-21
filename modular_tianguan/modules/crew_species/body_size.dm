/// Lift old, undersized character choices before the numeric preference or preset validates them.
/proc/tianguan_chosen_body_size(value)
	if(istext(value))
		value = text2num(value)
	if(isnum(value) && value > 0)
		return max(value, BODY_SIZE_MIN)
	return value

/datum/preference/numeric/body_size/deserialize(input, datum/preferences/preferences)
	return ..(tianguan_chosen_body_size(input), preferences)

/datum/quirk/micro/smallest
	size_reduced = BODY_SIZE_MIN
	desc = "You are thirty percent smaller than others... People really squint their eyes to see you! You are also squished like a bug accidentally ALL the time!"
