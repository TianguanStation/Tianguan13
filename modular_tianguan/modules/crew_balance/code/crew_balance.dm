/datum/addiction/nicotine
	withdrawal_stamina_multiplier = 0
	withdrawal_message_class = "warning"

/datum/mood_event/nicotine_withdrawal_moderate
	mood_change = -3

/datum/mood_event/nicotine_withdrawal_severe
	mood_change = -4

/datum/action/cooldown/spell/moth_and_dash
	// A dash at full stamina stays below the human slowdown threshold.
	dash_stamina_cost = 37.5
