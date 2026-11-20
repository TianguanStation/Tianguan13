/datum/quirk/item_quirk/lunchbox_owner
	name = "Lunchbox User"
	desc = "You brought a lunch, homemade or not, you decided to pack one for yourself!"
	icon = FA_ICON_BOX
	value = 0
	quirk_flags = QUIRK_HUMAN_ONLY | QUIRK_HIDE_FROM_SCAN
	mob_trait = TRAIT_LUNCHBOX_OWNER
	gain_text = span_notice("You brought your lunchbox with you, yippee!.")
	lose_text = span_danger("The feeling... the love... the passion for a home made meal leaves you... a tear sheds down your face, a weep... a sorrow... an apology as you say goodbye to your delicious homemade delectables.")
	medical_record_text = "Patient mentions their fondness for exterior foods and drinks."
	mail_goodies = list()

/datum/quirk_constant_data/lunchbox_owner
	associated_typepath = /datum/quirk/item_quirk/lunchbox_owner
	customization_options = list(
		/datum/preference/choiced/lunchbox/design,
		/datum/preference/choiced/lunchbox/meal,
		/datum/preference/choiced/lunchbox/first_snack,
		/datum/preference/choiced/lunchbox/second_snack,
		/datum/preference/choiced/lunchbox/drink,
		/datum/preference/choiced/lunchbox/dessert,
	)

/datum/quirk/item_quirk/lunchbox_owner/add_unique(client/client_source)
	var/datum/preference/choiced/lunchbox/design/design_pref = GLOB.preference_entries[/datum/preference/choiced/lunchbox/design]
	var/box_type = design_pref.resolve_item(client_source)
	var/obj/item/storage/lunchbox/packed/box = new box_type(get_turf(quirk_holder))
	var/datum/quirk_constant_data/options = GLOB.all_quirk_constant_data[type]
	for(var/pref_type in options.customization_options)
		if(pref_type == design_pref.type)
			continue
		var/datum/preference/choiced/lunchbox/food_pref = GLOB.preference_entries[pref_type]
		var/food_type = food_pref.resolve_item(client_source)
		new food_type(box)
	box.name = "[quirk_holder.real_name]'s lunchbox"
	give_item_to_holder(box, list(LOCATION_HANDS), flavour_text = "Looks well packed... delicious!", notify_player = TRUE)

/datum/preference/choiced/lunchbox
	abstract_type = /datum/preference/choiced/lunchbox
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE
	should_generate_icons = TRUE

/datum/preference/choiced/lunchbox/proc/item_options()
	CRASH("Missing lunchbox choices for [type]")

/datum/preference/choiced/lunchbox/init_possible_values()
	return list("Random") + assoc_to_keys(item_options())

/datum/preference/choiced/lunchbox/create_default_value()
	return "Random"

/datum/preference/choiced/lunchbox/icon_for(value)
	if(value == "Random")
		return uni_icon('icons/effects/random_spawners.dmi', "questionmark")
	var/list/options = item_options()
	var/obj/item/selected = options[value]
	return uni_icon(selected::icon, selected::icon_state)

/datum/preference/choiced/lunchbox/is_accessible(datum/preferences/preferences)
	return ..() && (/datum/quirk/item_quirk/lunchbox_owner::name in preferences.all_quirks)

/datum/preference/choiced/lunchbox/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return

/datum/preference/choiced/lunchbox/proc/resolve_item(client/client_source)
	var/list/options = item_options()
	var/choice = client_source?.prefs.read_preference(type)
	return options[choice] || options[pick(options)]

/datum/preference/choiced/lunchbox/design
	savefile_key = "lunchbox_design"

/datum/preference/choiced/lunchbox/design/item_options()
	return GLOB.possible_player_lunchbox_design_choice

/datum/preference/choiced/lunchbox/meal
	savefile_key = "lunchbox_meal_choice"

/datum/preference/choiced/lunchbox/meal/item_options()
	return GLOB.possible_player_lunchbox_meal_choice

/datum/preference/choiced/lunchbox/first_snack
	savefile_key = "lunchbox_first_snack_choice"

/datum/preference/choiced/lunchbox/first_snack/item_options()
	return GLOB.possible_player_lunchbox_snack_choice

/datum/preference/choiced/lunchbox/second_snack
	savefile_key = "lunchbox_second_snack_choice"

/datum/preference/choiced/lunchbox/second_snack/item_options()
	return GLOB.possible_player_lunchbox_snack_choice

/datum/preference/choiced/lunchbox/drink
	savefile_key = "lunchbox_drink_choice"

/datum/preference/choiced/lunchbox/drink/item_options()
	return GLOB.possible_player_lunchbox_drink_choice

/datum/preference/choiced/lunchbox/dessert
	savefile_key = "lunchbox_desert_choice"

/datum/preference/choiced/lunchbox/dessert/item_options()
	return GLOB.possible_player_lunchbox_desert_choice

GLOBAL_LIST_INIT(possible_player_lunchbox_design_choice, list(
	"Dark" = /obj/item/storage/lunchbox/packed/dark,
	"Blank" = /obj/item/storage/lunchbox/packed/light,
	"Nanotrasen" = /obj/item/storage/lunchbox/packed,
	"Nanotrasen (Gold)" = /obj/item/storage/lunchbox/packed/nt_gold,
	"Syndicate" = /obj/item/storage/lunchbox/packed/syndicate,
	"Interdyne" = /obj/item/storage/lunchbox/packed/interdyne,
	"SolFed" = /obj/item/storage/lunchbox/packed/solfed,
	"Space" = /obj/item/storage/lunchbox/packed/space,
	"Hearts" = /obj/item/storage/lunchbox/packed/hearts,
	"Heart" = /obj/item/storage/lunchbox/packed/heart,
	"White Heart" = /obj/item/storage/lunchbox/packed/heart/monster,
	"Television" = /obj/item/storage/lunchbox/packed/tvtime,
	"Pride" = /obj/item/storage/lunchbox/packed/ally,
	"Spaceship" = /obj/item/storage/lunchbox/packed/ship,
	"Ammunition" = /obj/item/storage/lunchbox/packed/ammo,
	"Cyber" = /obj/item/storage/lunchbox/packed/cyber,
	"Cyber (Dark)" = /obj/item/storage/lunchbox/packed/cyber/dark,
	"Lavaland" = /obj/item/storage/lunchbox/packed/lavaland,
	"Rainy" = /obj/item/storage/lunchbox/packed/rainy,
	"Clock" = /obj/item/storage/lunchbox/packed/fire_clock,
))

GLOBAL_LIST_INIT(possible_player_lunchbox_meal_choice, list(
	"Burger" = /obj/item/food/burger,
	"Tofu" = /obj/item/food/bread/tofu,
	"Baguette" = /obj/item/food/baguette,
	"Pesto Pizza" = /obj/item/food/vendor_tray_meal/pesto_pizza,
	"Baked Rice and Grilled Cheese" = /obj/item/food/vendor_tray_meal/baked_rice,
	"Fueljack's Tray" = /obj/item/food/vendor_tray_meal/fueljack,
	"Moonfish and Nizaya" = /obj/item/food/vendor_tray_meal/moonfish_nizaya,
	"Emperor Roll" = /obj/item/food/vendor_tray_meal/emperor_roll,
	"Mushroom Stirfry" = /obj/item/food/vendor_tray_meal/mushroom_fry,
	"Hotdog" = /obj/item/food/hotdog,
	"Pig in a Blanket" = /obj/item/food/pigblanket,
	"Danish Hotdog" = /obj/item/food/danish_hotdog,
	"Little Hawaii Dog" = /obj/item/food/little_hawaii_hotdog,
	"Butterdog" = /obj/item/food/butterdog,
	"Plasmadog Supreme" = /obj/item/food/plasma_dog_supreme,
	"Sausage" = /obj/item/food/sausage,
	"Tirizan Blood Sausage" = /obj/item/food/tiziran_sausage,
	"Fried Blood Sausage" = /obj/item/food/fried_blood_sausage,
	"Battered Sausage" = /obj/item/food/sausage/battered,
	"Homestyle Noodles" = /obj/item/food/vendor_tray_meal/ramen,
	"Fresh Carp Rolls" = /obj/item/food/vendor_tray_meal/sushi,
	"Beef and Fried Rice" = /obj/item/food/vendor_tray_meal/beef_rice,
	"BBQ Ribs" = /obj/item/food/bbqribs,
	"Beef Wellington" = /obj/item/food/beef_wellington_slice,
	"Korta Wellington" = /obj/item/food/korta_wellington_slice,
	"Philly Cheesesteak" = /obj/item/food/sandwich/philly_cheesesteak,
	"Steak" = /obj/item/food/meat/steak,
	"Lasagna" = /obj/item/food/lasagna,
	"Blood Noodles" = /obj/item/food/hemophage/blood_noodles,
	"Boat Noodles" = /obj/item/food/hemophage/blood_noodles/boat_noodles,
	"Piru Pasta" = /obj/item/food/piru_pasta,
	"Sirisai Wrap" = /obj/item/food/sirisai_wrap,
	"Sweet Piru Noodles" = /obj/item/food/sweet_piru_noodles,
	"Kiri Curry" = /obj/item/food/kiri_curry,
	"Sirisai Flatbread" = /obj/item/food/sirisai_flatbread,
	"Stewed Muli" = /obj/item/food/stewed_muli,
	"Suffed Muli Pod" = /obj/item/food/stuffed_muli_pod,
	"Shreadded Lung Stirfry" = /obj/item/food/shredded_lungs,
	"Moonfish Caviar" = /obj/item/food/moonfish_caviar,
	"Desert Snail Cocleas" = /obj/item/food/lizard_escargot,
	"Eyeball and Brain Pate" = /obj/item/food/brain_pate,
	"Picoss Skewer" = /obj/item/food/kebab/picoss_skewers,
	"Murshroom Stirfy" = /obj/item/food/mushroomy_stirfry,
	"Grilled Moonfish" = /obj/item/food/grilled_moonfish,
	"Moonfish Demiglace" = /obj/item/food/moonfish_demiglace,
	"Zagosk Surf 'n' Turf Smorgasbord" = /obj/item/food/lizard_surf_n_turf,
	"Nizaya Pasta" = /obj/item/food/spaghetti/nizaya,
	"Desert Snail Nizaya" = /obj/item/food/spaghetti/snail_nizaya,
	"Garlic Nizaya" = /obj/item/food/spaghetti/garlic_nizaya,
	"Mushroom Nizaya" = /obj/item/food/spaghetti/mushroom_nizaya,
	"Rustic Flatbread" = /obj/item/food/pizza/flatbread/rustic,
	"Italic Flatbread" = /obj/item/food/pizza/flatbread/italic,
	"Imperial Flatbread" = /obj/item/food/pizza/flatbread/imperial,
	"Meatlovers Flatbread" = /obj/item/food/pizza/flatbread/rawmeat,
	"Stinging Flatbread" = /obj/item/food/pizza/flatbread/stinging,
	"Zmorgast Flatbread" = /obj/item/food/pizza/flatbread/zmorgast,
	"BBQ Fish Flatbread" = /obj/item/food/pizza/flatbread/fish,
	"Mushroom and Tomato Flatbread" = /obj/item/food/pizza/flatbread/mushroom,
	"Nut Paste Flatbread" = /obj/item/food/pizza/flatbread/nutty,
	"Demit Nizaya" = /obj/item/food/spaghetti/demit_nizaya,
	"Sauerkraut" = /obj/item/food/sauerkraut,
	"PB&J Rootwich" = /obj/item/food/rootbread_peanut_butter_jelly,
	"PB&B Rootwich" = /obj/item/food/rootbread_peanut_butter_banana,
	"Plain Rootburger" = /obj/item/food/burger/plain/korta,
	"Rat Rootburger" = /obj/item/food/burger/rat/korta,
	"Root-Guffin" = /obj/item/food/burger/rootguffin,
	"Root Rib" = /obj/item/food/burger/rootrib,
	"Chicken Rootwich" = /obj/item/food/burger/rootchicken,
	"Fish Rootwich" = /obj/item/food/burger/rootfish,
	"Herby Cheese" = /obj/item/food/herby_cheese,
	"Grilled Cheese" = /obj/item/food/grilled_cheese,
	"Mothic Salad" = /obj/item/food/mothic_salad,
	"Skeklitmischtpoppl" = /obj/item/food/squeaking_stir_fry,
	"Sweet Chili Cabbage Wrap" = /obj/item/food/sweet_chili_cabbage_wrap,
	"Ozlsettitæloskekllön Ede Pommes" = /obj/item/food/loaded_curds,
	"Green Lasagne Slice" = /obj/item/food/green_lasagne_slice,
	"Big Baked Rice" = /obj/item/food/big_baked_rice,
	"Fiesta Corn Skillet" = /obj/item/food/fiesta_corn_skillet,
	"Ratatouille" = /obj/item/food/ratatouille,
	"Fish & Chips" = /obj/item/food/fishandchips,
	"Fish Fingers" = /obj/item/food/fishfingers,
))

GLOBAL_LIST_INIT(possible_player_lunchbox_snack_choice, list(
	"Space Twinkie" = /obj/item/food/spacetwinkie,
	"Cheesy Honkers" = /obj/item/food/cheesiehonkers,
	"Candy" = /obj/item/food/candy,
	"Chips" = /obj/item/food/chips,
	"Shrimp Chips" = /obj/item/food/chips/shrimp,
	"Scaredy's Beef Jerky" = /obj/item/food/sosjerky,
	"Boritos Chips" = /obj/item/food/cornchips/random,
	"4no rasins" = /obj/item/food/no_raisin,
	"Gallery's Peanuts" = /obj/item/food/peanuts,
	"Gallery's Everyflavor Peanuts" = /obj/item/food/peanuts/random,
	"C&Ds" = /obj/item/food/cnds,
	"Mystery C&Ds" = /obj/item/food/cnds/random,
	"Semki Sunflower Seeds" = /obj/item/food/semki,
	"Dry Ramen" = /obj/item/reagent_containers/cup/glass/dry_ramen,
	"Bubblegum" = /obj/item/storage/box/gum,
	"High-Power Energy Bars" = /obj/item/food/energybar,
	"Hot Shots" = /obj/item/food/hot_shots,
	"Sticko Classic" = /obj/item/food/sticko,
	"Sticko Mystery" = /obj/item/food/sticko/random,
	"Shok-roks - Stormcloud Candy" = /obj/item/food/shok_roks,
	"Shok-roks - Hidden Hurricane" = /obj/item/food/shok_roks/random,
	"Spacer's Sidekick" = /obj/item/food/spacers_sidekick,
	"Pistachios" = /obj/item/food/pistachios,
	"Lollipop" = /obj/item/food/swirl_lollipop,
	"Mothmallow" = /obj/item/food/vendor_snacks/mothmallow,
	"Fuel Jack" = /obj/item/food/vendor_snacks/moth_bag/fuel_jack,
	"Packaged Engine Fodder" = /obj/item/food/vendor_snacks/moth_bag,
	"Honey Cheesecake Cube" = /obj/item/food/vendor_snacks/moth_bag/cheesecake/honey,
	"Chocolate Cheesecake Cube" = /obj/item/food/vendor_snacks/moth_bag/cheesecake,
	"Moffin" = /obj/item/food/vendor_tray_meal/side/moffin,
	"Cornbread" = /obj/item/food/vendor_tray_meal/side/cornbread,
	"Roasted Seeds" = /obj/item/food/vendor_tray_meal/side/roasted_seeds,
	"Packagaed Honey Roll" = /obj/item/food/vendor_snacks/lizard_box/sweet_roll,
	"Tirizan Dumplings" = /obj/item/food/vendor_snacks/lizard_box,
	"Candied Mushroom" = /obj/item/food/vendor_snacks/lizard_bag,
	"Moonfish Jerky" = /obj/item/food/vendor_snacks/lizard_bag/moon_jerky,
	"Korta Brittle" = /obj/item/food/vendor_tray_meal/side/korta_brittle,
	"Rootbread Crackers and Pate" = /obj/item/food/vendor_tray_meal/side/root_crackers,
	"Crisped Headcheese" = /obj/item/food/vendor_tray_meal/side/crispy_headcheese,
	"Rice Crackers" = /obj/item/food/vendor_snacks/rice_crackers,
	"Ramen" = /obj/item/reagent_containers/cup/glass/dry_ramen/prepared,
	"Spicy Ramen" = /obj/item/reagent_containers/cup/glass/dry_ramen/prepared/hell,
	"Miso Soup" = /obj/item/food/vendor_tray_meal/side/miso,
	"White Rice" = /obj/item/food/vendor_tray_meal/side/rice,
	"Pickled Vegetables" = /obj/item/food/vendor_tray_meal/side/pickled_vegetables,
	"Kessen Shinju" = /obj/item/food/hemophage/blood_rice_pearl,
	"Dinuguan" = /obj/item/food/soup/hemophage/blood_soup,
	"Blood Curd" = /obj/item/food/hemophage/blood_curd,
	"Piru Bread Slice" = /obj/item/food/breadslice/piru,
	"Spiced Jerky" = /obj/item/food/spiced_jerky,
	"Baked Kiri Fruit" = /obj/item/food/baked_kiri,
	"Baked Muli Pod" = /obj/item/food/baked_muli,
	"Piru Flatbread" = /obj/item/food/grilled_piru_flatbread,
	"Sirisai Flatbread Slice" = /obj/item/food/sirisai_flatbread_slice,
	"Bluefeather Crisps & Dip" = /obj/item/food/bluefeather_crisps_and_dip,
	"Bluefeather Crisp" = /obj/item/food/bluefeather_crisp,
	"Caramel Jelly Toast" = /obj/item/food/caramel_jelly_toast,
	"Headcheese Slice" = /obj/item/food/headcheese_slice,
	"Tsatsikh" = /obj/item/food/tsatsikh,
	"Liver Pate" = /obj/item/food/liver_pate,
	"Lizard Fries" = /obj/item/food/lizard_fries,
	"Nectar Larve" = /obj/item/food/nectar_larvae,
	"Rootroll" = /obj/item/food/rootroll,
	"Egg Rootroll" = /obj/item/food/rootroll/egg,
	"Root Flatbread" = /obj/item/food/root_flatbread,
	"Egg Root Flatbread" = /obj/item/food/root_flatbread/egg,
	"Rootbread Slice" = /obj/item/food/breadslice/root,
	"Egg Rootbread Slice" = /obj/item/food/breadslice/root/egg,
	"Honey Roll" = /obj/item/food/honey_roll,
	"Black Scrambled Eggs" = /obj/item/food/black_eggs,
	"Patzikula" = /obj/item/food/patzikula,
	"Tirizan Dumplings" = /obj/item/food/lizard_dumplings,
	"Steeped Seraka Mushrooms" = /obj/item/food/steeped_mushrooms,
	"Toasted Seeds" = /obj/item/food/toasted_seeds,
	"Engine Fodder" = /obj/item/food/engine_fodder,
	"Lil Baked Rice" = /obj/item/food/lil_baked_rice,
	"Oven Baked Corn" = /obj/item/food/oven_baked_corn,
	"Buttered Baked Corn" = /obj/item/food/buttered_baked_corn,
	"Mozzarella Sticks" = /obj/item/food/mozzarella_sticks,
	"Voltölpaprik" = /obj/item/food/stuffed_peppers,
	"Space Fries" = /obj/item/food/fries,
	"Carrot Fries" = /obj/item/food/carrotfries,
	"Cheesey Fries"  = /obj/item/food/cheesyfries,
	"Garlic Bread" = /obj/item/food/garlicbread,
))

GLOBAL_LIST_INIT(possible_player_lunchbox_drink_choice, list(
	"Space Cola" = /obj/item/reagent_containers/cup/soda_cans/cola,
	"Space Mountain Wind" = /obj/item/reagent_containers/cup/soda_cans/space_mountain_wind,
	"Dr. Gibb" = /obj/item/reagent_containers/cup/soda_cans/dr_gibb,
	"Star Kist" = /obj/item/reagent_containers/cup/soda_cans/starkist,
	"Space-Up!" = /obj/item/reagent_containers/cup/soda_cans/space_up,
	"Pwr Game" = /obj/item/reagent_containers/cup/soda_cans/pwr_game,
	"Orange Soda" = /obj/item/reagent_containers/cup/soda_cans/lemon_lime,
	"Sol Dry" = /obj/item/reagent_containers/cup/soda_cans/sol_dry,
	"Bottle of Water" = /obj/item/reagent_containers/cup/glass/waterbottle,
	"Solzara Mushi Kombucha" = /obj/item/reagent_containers/cup/glass/bottle/mushi_kombucha,
	"24-Volt Energy" = /obj/item/reagent_containers/cup/soda_cans/volt_energy,
	"Two Time Rootbeer" = /obj/item/reagent_containers/cup/glass/bottle/rootbeer,
	"LubriCola" = /obj/item/reagent_containers/cup/soda_cans/skyrat/lubricola,
	"Welding Fizz" = /obj/item/reagent_containers/cup/soda_cans/skyrat/welding_fizz,
	"Orchard Green" = /obj/item/reagent_containers/cup/soda_cans/thc,
	"Gyárhajó 1023: Lemonade" = /obj/item/reagent_containers/cup/soda_cans/skyrat/lemonade,
	"Gyárhajó 1506: Navy Rum" = /obj/item/reagent_containers/cup/soda_cans/skyrat/navy_rum,
	"Gyárhajó 1023: Soda Water" = /obj/item/reagent_containers/cup/soda_cans/skyrat/soda_water_moth,
	"Gyárhajó 1023: Ginger Beer" = /obj/item/reagent_containers/cup/soda_cans/skyrat/ginger_beer,
	"Mushroom Tea" = /obj/item/reagent_containers/cup/glass/waterbottle/tea/mushroom,
	"Korta" = /obj/item/reagent_containers/cup/soda_cans/skyrat/kortara,
	"Astra Tea" = /obj/item/reagent_containers/cup/glass/waterbottle/tea/astra,
	"Tea (Glass)" = /obj/item/reagent_containers/cup/glass/waterbottle/tea,
	"Tea (Cup)" = /obj/item/reagent_containers/cup/glass/mug/tea,
	"Strawberry Tea" = /obj/item/reagent_containers/cup/glass/waterbottle/tea/strawberry,
	"Catnip Tea" = /obj/item/reagent_containers/cup/glass/waterbottle/tea/nip,
	"Beekhof Blauw Curacao" = /obj/item/reagent_containers/cup/glass/bottle/curacao,
	"Buckin' Bronco's Applejack" = /obj/item/reagent_containers/cup/glass/bottle/applejack,
	"Voltaic Yellow Wine" = /obj/item/reagent_containers/cup/glass/bottle/wine_voltaic,
	"Caccavo Tequila" = /obj/item/reagent_containers/cup/glass/bottle/tequila,
	"Captain Pete's Rum" = /obj/item/reagent_containers/cup/glass/bottle/rum,
	"Chateu De Baton Premium Cognac" = /obj/item/reagent_containers/cup/glass/bottle/cognac,
	"Bearded Special Wine" = /obj/item/reagent_containers/cup/glass/bottle/wine,
	"Extra Strong Absinthe" = /obj/item/reagent_containers/cup/glass/bottle/absinthe,
	"Goldeneye Vermouth" = /obj/item/reagent_containers/cup/glass/bottle/vermouth,
	"Griffeater Gin" = /obj/item/reagent_containers/cup/glass/bottle/gin,
	"Jester Grenadine" = /obj/item/reagent_containers/cup/glass/bottle/grenadine,
	"Jian Hard Cider" = /obj/item/reagent_containers/cup/glass/bottle/hcider,
	"Luini Arametto" = /obj/item/reagent_containers/cup/glass/bottle/amaretto,
	"Magm-Ale" = /obj/item/reagent_containers/cup/glass/bottle/ale,
	"Phillipes Grappa" = /obj/item/reagent_containers/cup/glass/bottle/grappa,
	"Navy Strength Rum" = /obj/item/reagent_containers/cup/glass/bottle/navy_rum,
	"Rapid Beer Malt Liquor" = /obj/item/reagent_containers/cup/glass/bottle/maltliquor,
	"Robert Robust's Coffee Liqueur" = /obj/item/reagent_containers/cup/glass/bottle/kahlua,
	"Ryo's Traditional Sake" = /obj/item/reagent_containers/cup/glass/bottle/sake,
	"Space Beer" = /obj/item/reagent_containers/cup/glass/bottle/beer,
	"Tunguska Triple Distilled" = /obj/item/reagent_containers/cup/glass/bottle/vodka,
	"Uncle Git's Special Reserve" = /obj/item/reagent_containers/cup/glass/bottle/whiskey,
	"Breezy Shoals Coconut Rum" = /obj/item/reagent_containers/cup/glass/bottle/coconut_rum,
	"Moonlabor Yuyake" = /obj/item/reagent_containers/cup/glass/bottle/yuyake,
	"Shu-Kuoba Straight Shochu" = /obj/item/reagent_containers/cup/glass/bottle/shochu,
	"Space Beer (Canned)" = /obj/item/reagent_containers/cup/soda_cans/beer,
	"Rice Beer" = /obj/item/reagent_containers/cup/soda_cans/beer/rice,
	"Silly Cone's Synthanol" = /obj/item/reagent_containers/cup/soda_cans/skyrat/synthanolcan,
	"Canned Laughter" = /obj/item/reagent_containers/cup/soda_cans/canned_laughter,
))

GLOBAL_LIST_INIT(possible_player_lunchbox_desert_choice, list(
	"Banana Nut Bread" = /obj/item/food/breadslice/banana,
	"Plain Cake Slice" = /obj/item/food/cakeslice/plain,
	"Berry Chocolate Cake Slice" = /obj/item/food/cakeslice/berry_chocolate_cake,
	"Carrot Cake Slice" = /obj/item/food/cakeslice/carrot,
	"Cheese Cake Slice" = /obj/item/food/cakeslice/cheese,
	"Lime Cake Slice" = /obj/item/food/cakeslice/lime,
	"Lemon Cake Slice" = /obj/item/food/cakeslice/lemon,
	"Chocolate Cake Slice" = /obj/item/food/cakeslice/chocolate,
	"Birthday Cake Slice" = /obj/item/food/cakeslice/birthday,
	"Energy Cake Slice" = /obj/item/food/cakeslice/birthday/energy,
	"Apple Cake Slice" = /obj/item/food/cakeslice/apple,
	"Slime Cake Slice" = /obj/item/food/cakeslice/slimecake,
	"Pumpkin Spice Cake Slice" = /obj/item/food/cakeslice/pumpkinspice,
	"Berry Vanilla Cake Slice" = /obj/item/food/cakeslice/berry_vanilla_cake,
	"Pound Cake Slice" = /obj/item/food/cakeslice/pound_cake_slice,
	"Hardware Cake Slice" = /obj/item/food/cakeslice/hardware_cake_slice,
	"Vanilla Cake Slice" = /obj/item/food/cakeslice/vanilla_slice,
	"Clown Cake Slice" = /obj/item/food/cakeslice/clown_slice,
	"Spaceman's Cake Slice" = /obj/item/food/cakeslice/trumpet,
	"Brioche Cake Slice" = /obj/item/food/cakeslice/brioche,
	"Pavlova Slice" = /obj/item/food/cakeslice/pavlova,
	"Nutty Pavlova Slice" = /obj/item/food/cakeslice/pavlova/nuts,
	"Fruit Cake Slice" = /obj/item/food/cakeslice/fruit,
	"Plum Cake Slice" = /obj/item/food/cakeslice/plum,
	"Angel Food Cake Slice" = /obj/item/food/cakeslice/holy_cake_slice,
	"Pinapple Cream Cake Slice" = /obj/item/food/cakeslice/pineapple_cream_cake,
	"Ice Cream Sandwich" = /obj/item/food/icecreamsandwich,
	"Ice Cream Sandwich (Strawberry)" = /obj/item/food/strawberryicecreamsandwich,
	"Space Freezy" = /obj/item/food/spacefreezy,
	"Matcha Mochi Balls" = /obj/item/food/vendor_snacks/mochi_ice_cream/matcha,
	"Vanilla Mochi Balls" = /obj/item/food/vendor_snacks/mochi_ice_cream,
	"Ti Hoeh Koe" = /obj/item/food/hemophage/blood_cake,
	"Kiri Jelly Puff" = /obj/item/food/kiri_jellypuff,
	"Korta Brittle Slice" = /obj/item/food/cakeslice/korta_brittle,
	"Korta Ice" = /obj/item/food/snowcones/korta_ice,
	"Candied Mushroom" = /obj/item/food/kebab/candied_mushrooms,
))
