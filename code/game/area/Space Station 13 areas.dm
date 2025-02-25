/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME 	(you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = "ICON FILENAME" 			(defaults to areas.dmi)
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = 0 				(defaults to 1)

NOTE: there are two lists of areas in the end of this file: centcom and station itself. Please maintain these lists valid. --rastaf0

*/



/area
	var/fire = null
	var/atmos = 1
	var/atmosalm = 0
	var/poweralm = 1
	var/party = null
	level = null
	name = "Unknown"
	icon = 'icons/turf/areas.dmi'
	icon_state = "unknown"
	plane = DEFAULT_PLANE
	layer = BASE_AREA_LAYER
	luminosity = 0
	mouse_opacity = 0
	var/lightswitch = 1

	var/eject = null

	var/debug = 0
	var/requires_power = 1
	var/always_unpowered = 0	//this gets overriden to 1 for space in area/New()

	var/power_equip = 1 // Status
	var/power_light = 1
	var/power_environ = 1
	var/used_equip = 0  // Continuous drain; don't mess with these directly.
	var/used_light = 0
	var/used_environ = 0
	var/oneoff_equip   = 0 //Used once and cleared each tick.
	var/oneoff_light   = 0
	var/oneoff_environ = 0

	var/has_gravity = 1
	var/alwaysgravity
	var/nevergravity

	var/obj/machinery/power/apc/apc = null
	var/no_air = null
//	var/list/lights				// list of all lights on this area
	var/list/all_doors = null		//Added by Strumpetplaya - Alarm Change - Contains a list of doors adjacent to this area
	var/air_doors_activated = 0
	var/ambience_cooldown = 1000
	var/list/ambience = list('sound/stalker/ambience/amb01.ogg','sound/stalker/ambience/amb02.ogg',
									'sound/stalker/ambience/amb03.ogg','sound/stalker/ambience/amb04.ogg',
									'sound/stalker/ambience/amb05.ogg','sound/stalker/ambience/amb06.ogg',
									'sound/stalker/ambience/amb07.ogg','sound/stalker/ambience/amb08.ogg',
									'sound/stalker/ambience/amb09.ogg','sound/stalker/ambience/amb10.ogg',
									'sound/stalker/ambience/amb11.ogg','sound/stalker/ambience/amb12.ogg',
									'sound/stalker/ambience/amb13.ogg','sound/stalker/ambience/amb15.ogg',
									'sound/stalker/ambience/amb16.ogg','sound/stalker/ambience/amb17.ogg',
									'sound/stalker/ambience/amb20.ogg','sound/stalker/ambience/amb21.ogg',
									'sound/stalker/ambience/amb22.ogg','sound/stalker/ambience/amb23.ogg',
									'sound/stalker/ambience/amb24.ogg','sound/stalker/ambience/amb25.ogg',
									'sound/stalker/ambience/amb26.ogg','sound/stalker/ambience/amb27.ogg',
									'sound/stalker/ambience/amb28.ogg','sound/stalker/ambience/amb29.ogg',
									'sound/stalker/ambience/amb30.ogg','sound/stalker/ambience/amb31.ogg',
									'sound/stalker/ambience/amb32.ogg','sound/stalker/ambience/amb33.ogg',
									'sound/stalker/ambience/amb34.ogg','sound/stalker/ambience/amb35.ogg',
									'sound/stalker/ambience/amb36.ogg','sound/stalker/ambience/amb37.ogg',
									'sound/stalker/ambience/amb38.ogg'
								)

	var/list/forced_ambience = null
	var/sound_env = STANDARD_STATION
	var/turf/base_turf //The base turf type of the area, which can be used to override the z-level's base turf
	var/planetary_surface = TRUE // true if the area belongs to a planet.

/*-----------------------------------------------------------------------------*/

/////////
//SPACE//
/////////

/area/space
	name = "\improper Space"
	icon_state = "space"
	requires_power = 1
	always_unpowered = 1
	dynamic_lighting = 1
	power_light = 0
	power_equip = 0
	power_environ = 0
	has_gravity = 0
	area_flags = AREA_FLAG_EXTERNAL | AREA_FLAG_IS_NOT_PERSISTENT
/*[ORIG]
	ambience = list('sound/ambience/ambispace.ogg','sound/ambience/ambispace1.ogg','sound/ambience/ambispace2.ogg','sound/ambience/ambispace3.ogg','sound/ambience/ambispace4.ogg','sound/ambience/ambispace5.ogg','sound/music/title2.ogg','sound/music/space.ogg','sound/music/main.ogg','sound/music/traitor.ogg',\
		'sound/ambience/ominous1.ogg','sound/ambience/ominous2.ogg','sound/ambience/ominous3.ogg', 'sound/ambience/ambispace.ogg')//inf
[/ORIG]*/
	ambience = list() //in deep space, no one will hear your scream //inf
	secure = FALSE

/area/space/atmosalert()
	return

/area/space/fire_alert()
	return

/area/space/fire_reset()
	return

/area/space/readyalert()
	return

/area/space/partyalert()
	return

//////////////////////
//AREAS USED BY CODE//
//////////////////////
/area/centcom
	name = "\improper Centcom"
	icon_state = "centcom"
	requires_power = 0
	dynamic_lighting = 0
	area_flags = AREA_FLAG_IS_NOT_PERSISTENT
	req_access = list(access_cent_general)

/area/centcom/holding
	name = "\improper Holding Facility"

/area/chapel
	name = "\improper Chapel"
	icon_state = "chapel"

/area/centcom/specops
	name = "\improper Centcom Special Ops"
	req_access = list(access_cent_specops)

/area/hallway
	name = "hallway"

/area/medical
	req_access = list(access_medical)

/area/security
	req_access = list(access_sec_doors)

/area/security/brig
	name = "\improper Security - Brig"
	icon_state = "brig"
	area_flags = AREA_FLAG_RAD_SHIELDED
	req_access = list(access_brig)

/area/security/prison
	name = "\improper Security - Prison Wing"
	icon_state = "sec_prison"
	area_flags = AREA_FLAG_RAD_SHIELDED
	req_access = list(access_brig)

/area/maintenance
	area_flags = AREA_FLAG_RAD_SHIELDED
	sound_env = TUNNEL_ENCLOSED
//	turf_initializer = /decl/turf_initializer/maintenance
	forced_ambience = list('sound/ambience/maintambience.ogg',\
																'infinity/sound/SS2/ambience/ambmaintence.wav')//inf
	req_access = list(access_maint_tunnels)

/area/rnd
	req_access = list(access_research)

/area/rnd/xenobiology
	name = "\improper Xenobiology Lab"
	icon_state = "xeno_lab"
	req_access = list(access_xenobiology, access_research)

/area/rnd/xenobiology/xenoflora
	name = "\improper Xenoflora Lab"
	icon_state = "xeno_f_lab"

/area/rnd/xenobiology/xenoflora_storage
	name = "\improper Xenoflora Storage"
	icon_state = "xeno_f_store"

/area/shuttle/escape/centcom
	name = "\improper Emergency Shuttle Centcom"
	icon_state = "shuttle"
	req_access = list(access_cent_general)

/area/shuttle/specops/centcom
	icon_state = "shuttlered"
	req_access = list(access_cent_specops)
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/shuttle/syndicate_elite/mothership
	icon_state = "shuttlered"
	req_access = list(access_syndicate)

/area/shuttle/syndicate_elite/station
	icon_state = "shuttlered2"
	req_access = list(access_syndicate)

/area/supply
	name = "Supply Shuttle"
	icon_state = "shuttle3"
	req_access = list(access_cargo)

/area/syndicate_elite_squad
	name = "\improper Elite Mercenary Squad"
	icon_state = "syndie-elite"
	req_access = list(access_syndicate)

////////////
//SHUTTLES//
////////////
//shuttles only need starting area, movement is handled by landmarks
//All shuttles should now be under shuttle since we have smooth-wall code.

/area/shuttle
	requires_power = 0
	sound_env = SMALL_ENCLOSED
	base_turf = /turf/space

/*
* Special Areas
*/
/area/beach
	name = "Keelin's private beach"
	icon_state = "null"
	luminosity = 1
	dynamic_lighting = 0
	requires_power = 0
	var/sound/mysound = null

/area/beach/New()
	..()
	var/sound/S = new/sound()
	mysound = S
	S.file = 'sound/ambience/shore.ogg'
	S.repeat = 1
	S.wait = 0
	S.channel = GLOB.sound_channels.RequestChannel(/area/beach)
	S.volume = 100
	S.priority = 255
	S.status = SOUND_UPDATE
	process()

/area/beach/Entered(atom/movable/Obj,atom/OldLoc)
	. = ..()
	if(ismob(Obj))
		var/mob/M = Obj
		if(M.client)
			mysound.status = SOUND_UPDATE
			sound_to(M, mysound)

/area/beach/Exited(atom/movable/Obj)
	. = ..()
	if(ismob(Obj))
		var/mob/M = Obj
		if(M.client)
			mysound.status = SOUND_PAUSED | SOUND_UPDATE
			sound_to(M, mysound)

/area/beach/proc/process()
	set background = 1

	var/sound/S = null
	var/sound_delay = 0
	if(prob(25))
		S = sound(file=pick('sound/ambience/seag1.ogg','sound/ambience/seag2.ogg','sound/ambience/seag3.ogg'), volume=100)
		sound_delay = rand(0, 50)

	for(var/mob/living/carbon/human/H in src)
		if(H.client)
			mysound.status = SOUND_UPDATE
			to_chat(H, mysound)
			if(S)
				spawn(sound_delay)
					sound_to(H, S)

	spawn(60) .()
