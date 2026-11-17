/// Takes gender string and returns Gender display string if set.
/proc/get_gender_attraction_string(gender, attraction = "Unset")
	if(!gender || gender == "Unset")
		return ""
	return "Gender: [span_revenboldnotice(gender)]"
