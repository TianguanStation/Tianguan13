/* GLOBAL_DATUM_INIT(has_no_eol_punctuation, /regex, regex("\\w$"))
GLOBAL_DATUM_INIT(noncapital_i, /regex, regex("\\b\[i]\\b", "g")) */ // TODO: REMOVE THIS IN FAVOUR OF THE SKYRAT FILE.
//Auto punctuation global datums

// The alpha channel gained upon ghosting
#define GHOST_ALPHA 180

/// Used for the trait for when a dragon looses a portal
#define DRAGON_PORTAL_LOSS "dragon_portal_loss"

/// Crew monitoring console update period. Why is this not a global define, why do I have to define it again
#define SENSORS_UPDATE_PERIOD (7 SECONDS)

#define HERETIC_POINTS_PER_INFLUENCE 0.5
#define HERETIC_POINTS_PER_WAY 2

// Restrict extreme chemical growthserum size scaling to safe private areas
#define SIZE_WHITELISTED_AREAS list(\
		/area/centcom/interlink/dorm_rooms,\
		/area/misc/hilbertshotel,\
		/area/station/commons/dorms,\
		/area/misc/condo,\
		/area/centcom/holding,\
		/area/centcom/holding/cafe,\
		/area/centcom/holding/cafe/vox,\
		/area/centcom/holding/cafe/dorms,\
		/area/centcom/holding/cafe/park,\
		/area/centcom/holding/cafe/station,\
		/area/centcom/holding/cafe/station/service/kitchen,\
		/area/centcom/holding/cafe/station/service/kitchen/coldroom,\
		/area/centcom/holding/cafe/station/commons/lounge,\
		/area/centcom/holding/cafe/station/service/hydroponics,\
		/area/centcom/holding/cafe/station/commons/fitness,\
		/area/centcom/holding/cafe/station/commons/fitness/locker_room,\
		/area/centcom/holding/cafe/station/commons/fitness/recreation/sauna,\
		/area/centcom/holding/cafe/station/commons/toilet/shower,\
		/area/centcom/holding/cafe/station/commons/toilet,\
		/area/centcom/holding/cafe/station/service,\
		/area/centcom/holding/cafe/station/service/janitor,\
		/area/centcom/holding/cafe/station/service/lawoffice,\
		/area/centcom/holding/cafe/station/service/barber,\
		/area/centcom/holding/cafe/station/commons/kiosk,\
		/area/centcom/holding/cafe/station/medical,\
		/area/centcom/holding/cafe/station/medical/psychology,\
		/area/centcom/holding/cafe/station/science/robotics/augments,\
		/area/centcom/holding/cafe/station/command,\
		/area/centcom/holding/cafe/station/command/cap,\
		/area/centcom/holding/cafe/station/command/meeting_room,\
		/area/centcom/holding/cafe/station/command/cap/private,\
		/area/centcom/holding/cafe/station/command/teleporter,\
		/area/centcom/holding/cafe/station/maint,\
		/area/centcom/holding/cafe/station/security,\
		/area/centcom/holding/cafe/station/service/library,\
		/area/centcom/holding/cafe/station/engineering,\
		/area/centcom/holding/cafe/ruin/icemoon,\
		/area/centcom/holding/cafe/ruin/caves,\
		/area/centcom/holding/cafe/ruin/ash_walkers,\
		/area/centcom/holding/cafe/ruin/xenonest,\
		/area/centcom/holding/cafe/beach,\
		)
