/client/proc/Cell()
	set category = "Debug"
	set name = "Cell"
	if(!mob)
		return
	var/turf/T = mob.loc

	if (!( istype(T, /turf) ))
		return

	var/datum/gas_mixture/env = T.return_air()

	var/t = "<span class='notice'>Coordinates: [T.x],[T.y],[T.z]</span>\n"
	t += "<span class='warning'>Temperature: [env.temperature]</span>\n"
	t += "<span class='warning'>Pressure: [env.return_pressure()]kPa</span>\n"
	for(var/g in env.gas)
		t += "<span class='notice'>[g]: [env.gas[g]] / [env.gas[g] * R_IDEAL_GAS_EQUATION * env.temperature / env.volume]kPa</span>\n"

	usr.show_message(t, 1)
	SSstatistics.add_field_details("admin_verb","ASL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_robotize(var/mob/M in SSmobs.mob_list)
	set category = "Fun"
	set name = "Make Robot"

	if(GAME_STATE < RUNLEVEL_GAME)
		alert("Wait until the game starts")
		return
	if(istype(M, /mob/living/carbon/human))
		log_admin("[key_name(src)] has robotized [M.key].")
		spawn(10)
			M:Robotize()

	else
		alert("Invalid mob")

/client/proc/cmd_admin_animalize(var/mob/M in SSmobs.mob_list)
	set category = "Fun"
	set name = "Make Simple Animal"

	if(GAME_STATE < RUNLEVEL_GAME)
		alert("Wait until the game starts")
		return

	if(!M)
		alert("That mob doesn't seem to exist, close the panel and try again.")
		return

	if(istype(M, /mob/new_player))
		alert("The mob must not be a new_player.")
		return

	log_admin("[key_name(src)] has animalized [M.key].")
	spawn(10)
		M.Animalize()


/client/proc/makepAI(var/turf/T in SSmobs.mob_list)
	set category = "Fun"
	set name = "Make pAI"
	set desc = "Specify a location to spawn a pAI device, then specify a key to play that pAI"

	var/list/available = list()
	for(var/mob/C in SSmobs.mob_list)
		if(C.key)
			available.Add(C)
	var/mob/choice = input("Choose a player to play the pAI", "Spawn pAI") in available
	if(!choice)
		return 0
	if(!isghost(choice))
		var/confirm = input("[choice.key] isn't ghosting right now. Are you sure you want to yank them out of them out of their body and place them in this pAI?", "Spawn pAI Confirmation", "No") in list("Yes", "No")
		if(confirm != "Yes")
			return 0
	var/obj/item/device/paicard/card = new(T)
	var/mob/living/silicon/pai/pai = new(card)
	pai.SetName(sanitizeSafe(input(choice, "Enter your pAI name:", "pAI Name", "Personal AI") as text))
	pai.real_name = pai.name
	pai.key = choice.key
	card.setPersonality(pai)
	for(var/datum/paiCandidate/candidate in paiController.pai_candidates)
		if(candidate.key == choice.key)
			paiController.pai_candidates.Remove(candidate)
	SSstatistics.add_field_details("admin_verb","MPAI") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_slimeize(var/mob/M in SSmobs.mob_list)
	set category = "Fun"
	set name = "Make slime"

	if(GAME_STATE < RUNLEVEL_GAME)
		alert("Wait until the game starts")
		return
	if(ishuman(M))
		log_admin("[key_name(src)] has slimeized [M.key].")
		spawn(10)
			M:slimeize()
			SSstatistics.add_field_details("admin_verb","MKMET") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		log_and_message_admins("made [key_name(M)] into a slime.")
	else
		alert("Invalid mob")

/proc/make_types_fancy(var/list/types)
	if(ispath(types))
		types = list(types)
	. = list()
	for(var/type in types)
		var/typename = "[type]"
		var/static/list/TYPES_SHORTCUTS = list(
			/obj/effect/decal/cleanable = "CLEANABLE",
			/obj/item/device/radio/headset = "HEADSET",
			/obj/item/clothing/head/helmet/space = "SPESSHELMET",
			/obj/item/book/manual = "MANUAL",
			/obj/item/reagent_containers/food/drinks = "DRINK",
			/obj/item/reagent_containers/food = "FOOD",
			/obj/item/reagent_containers = "REAGENT_CONTAINERS",
			/obj/item/ = "WEAPON",
			/obj/machinery/atmospherics = "ATMOS_MECH",
			/obj/machinery/portable_atmospherics = "PORT_ATMOS",
			//obj/item/mech_equipment/weapon/ballistic/missile_rack = "MECHA_MISSILE_RACK",
			/obj/item/mech_equipment = "MECHA_EQUIP",
			/obj/item/organ = "ORGAN",
			/obj/item = "ITEM",
			/obj/machinery = "MACHINERY",
			/obj/effect = "EFFECT",
			/obj = "O",
			/datum = "D",
			/turf/simulated = "SIMUL",
			/turf/unsimulated = "UNSIMUL",
			/turf = "T",
			/mob/living/carbon = "CARBON",
			/mob/living/simple_animal = "SIMPLE",
			/mob/living = "LIVING",
			/mob = "M"
		)
		for(var/tn in TYPES_SHORTCUTS)
			if(copytext(typename,1, length("[tn]/")+1)=="[tn]/" /*findtextEx(typename,"[tn]/",1,2)*/ )
				typename = TYPES_SHORTCUTS[tn]+copytext(typename,length("[tn]/"))
				break
		.[typename] = type

/proc/get_fancy_list_of_atom_types()
	var/static/list/pre_generated_list
	if(!pre_generated_list) //init
		pre_generated_list = make_types_fancy(typesof(/atom))
	return pre_generated_list


/proc/get_fancy_list_of_datum_types()
	var/static/list/pre_generated_list
	if(!pre_generated_list) //init
		pre_generated_list = make_types_fancy(sortList(typesof(/datum) - typesof(/atom)))
	return pre_generated_list


/proc/filter_fancy_list(list/L, filter as text)
	var/list/matches = new
	for(var/key in L)
		var/value = L[key]
		if(findtext("[key]", filter) || findtext("[value]", filter))
			matches[key] = value
	return matches

//TODO: merge the vievars version into this or something maybe mayhaps
/* Baystation12 original
/client/proc/cmd_debug_del_all()
	set category = "Debug"
	set name = "Del-All"

	// to prevent REALLY stupid deletions
	var/blocked = list(/obj, /mob, /mob/living, /mob/living/carbon, /mob/living/carbon/human, /mob/observer, /mob/living/silicon, /mob/living/silicon/robot, /mob/living/silicon/ai)
	var/hsbitem = input(usr, "Choose an object to delete.", "Delete:") as null|anything in typesof(/obj) + typesof(/mob) - blocked
	if(hsbitem)
		for(var/atom/O in world)
			if(istype(O, hsbitem))
				qdel(O)
		log_admin("[key_name(src)] has deleted all instances of [hsbitem].")
		message_admins("[key_name_admin(src)] has deleted all instances of [hsbitem].", 0)
	SSstatistics.add_field_details("admin_verb","DELA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
*/
/client/proc/cmd_debug_del_all(object as text)
	set category = "Debug"
	set name = "Del-All"

	var/list/matches = get_fancy_list_of_atom_types()
	if(!isnull(object) && object!="")
		matches = filter_fancy_list(matches, object)

	if(matches.len==0)
		return
	var/hsbitem = input(usr, "Choose an object to delete.", "Delete:") as null|anything in matches
	if(hsbitem)
		hsbitem = matches[hsbitem]
		var/counter = 0
		for(var/atom/O in world)
			if(istype(O, hsbitem))
				counter++
				qdel(O)
			CHECK_TICK
		log_admin("[key_name(src)] has deleted all ([counter]) instances of [hsbitem].")
		message_admins("[key_name_admin(src)] has deleted all ([counter]) instances of [hsbitem].", 0)
	SSstatistics.add_field_details("admin_verb","Delete All") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_debug_make_powernets()
	set category = "Debug"
	set name = "Make Powernets"
	SSmachines.makepowernets()
	log_admin("[key_name(src)] has remade the powernet. makepowernets() called.")
	message_admins("[key_name_admin(src)] has remade the powernets. makepowernets() called.", 0)
	SSstatistics.add_field_details("admin_verb","MPWN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_grantfullaccess(var/mob/M in SSmobs.mob_list)
	set category = "Admin"
	set name = "Grant Full Access"

	if (GAME_STATE < RUNLEVEL_GAME)
		alert("Wait until the game starts")
		return
	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/card/id/id = H.GetIdCard()
		if(id)
			id.icon_state = "gold"
			id.access = get_all_accesses()
		else
			id = new/obj/item/card/id(M);
			id.icon_state = "gold"
			id.access = get_all_accesses()
			id.registered_name = H.real_name
			id.assignment = "Captain"
			id.SetName("[id.registered_name]'s ID Card ([id.assignment])")
			H.equip_to_slot_or_del(id, slot_wear_id)
			H.update_inv_wear_id()
	else
		alert("Invalid mob")
	SSstatistics.add_field_details("admin_verb","GFA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_and_message_admins("has granted [M.key] full access.")

/client/proc/cmd_assume_direct_control(var/mob/M in SSmobs.mob_list)
	set category = "Admin"
	set name = "Assume direct control"
	set desc = "Direct intervention"

	if(!check_rights(R_DEBUG|R_ADMIN))	return
	if(M.ckey)
		if(alert("This mob is being controlled by [M.ckey]. Are you sure you wish to assume control of it? [M.ckey] will be made a ghost.",,"Yes","No") != "Yes")
			return
		else
			var/mob/observer/ghost/ghost = new/mob/observer/ghost(M,1)
			ghost.ckey = M.ckey
	log_and_message_admins("assumed direct control of [M].")
	var/mob/adminmob = src.mob
	M.ckey = src.ckey
	if(isghost(adminmob))
		qdel(adminmob)
	SSstatistics.add_field_details("admin_verb","ADC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!







/client/proc/cmd_admin_areatest()
	set category = "Mapping"
	set name = "Test areas"

	var/list/areas_all = list()
	var/list/areas_with_APC = list()
	var/list/areas_with_air_alarm = list()
	var/list/areas_with_RC = list()
	var/list/areas_with_light = list()
	var/list/areas_with_LS = list()
	var/list/areas_with_intercom = list()
	var/list/areas_with_camera = list()

	for(var/area/A in world)
		if(!(A.type in areas_all))
			areas_all.Add(A.type)

	for(var/obj/machinery/power/apc/APC in world)
		var/area/A = get_area(APC)
		if(!(A.type in areas_with_APC))
			areas_with_APC.Add(A.type)

	for(var/obj/machinery/alarm/alarm in world)
		var/area/A = get_area(alarm)
		if(!(A.type in areas_with_air_alarm))
			areas_with_air_alarm.Add(A.type)

	for(var/obj/machinery/requests_console/RC in world)
		var/area/A = get_area(RC)
		if(!(A.type in areas_with_RC))
			areas_with_RC.Add(A.type)

	for(var/obj/machinery/light/L in world)
		var/area/A = get_area(L)
		if(!(A.type in areas_with_light))
			areas_with_light.Add(A.type)

	for(var/obj/machinery/light_switch/LS in world)
		var/area/A = get_area(LS)
		if(!(A.type in areas_with_LS))
			areas_with_LS.Add(A.type)

	for(var/obj/item/device/radio/intercom/I in world)
		var/area/A = get_area(I)
		if(!(A.type in areas_with_intercom))
			areas_with_intercom.Add(A.type)

	for(var/obj/machinery/camera/C in world)
		var/area/A = get_area(C)
		if(!(A.type in areas_with_camera))
			areas_with_camera.Add(A.type)

	var/list/areas_without_APC = areas_all - areas_with_APC
	var/list/areas_without_air_alarm = areas_all - areas_with_air_alarm
	var/list/areas_without_RC = areas_all - areas_with_RC
	var/list/areas_without_light = areas_all - areas_with_light
	var/list/areas_without_LS = areas_all - areas_with_LS
	var/list/areas_without_intercom = areas_all - areas_with_intercom
	var/list/areas_without_camera = areas_all - areas_with_camera

	log_debug("<b>AREAS WITHOUT AN APC:</b>")
	for(var/areatype in areas_without_APC)
		log_debug("* [areatype]")

	log_debug("<b>AREAS WITHOUT AN AIR ALARM:</b>")
	for(var/areatype in areas_without_air_alarm)
		log_debug("* [areatype]")

	log_debug("<b>AREAS WITHOUT A REQUEST CONSOLE:</b>")
	for(var/areatype in areas_without_RC)
		log_debug("* [areatype]")

	log_debug("<b>AREAS WITHOUT ANY LIGHTS:</b>")
	for(var/areatype in areas_without_light)
		log_debug("* [areatype]")

	log_debug("<b>AREAS WITHOUT A LIGHT SWITCH:</b>")
	for(var/areatype in areas_without_LS)
		log_debug("* [areatype]")

	log_debug("<b>AREAS WITHOUT ANY INTERCOMS:</b>")
	for(var/areatype in areas_without_intercom)
		log_debug("* [areatype]")

	log_debug("<b>AREAS WITHOUT ANY CAMERAS:</b>")
	for(var/areatype in areas_without_camera)
		log_debug("* [areatype]")

/client/proc/cmd_admin_dress(mob/H as mob in SSmobs.mob_list) //inf, was /datum/admins/proc/cmd_admin_dress(),
	set category = "Fun"
	set name = "Select equipment"

	if(!check_rights(R_FUN))
		return

//inf	var/mob/living/carbon/human/H = input("Select mob.", "Select equipment.") as null|anything in GLOB.human_mob_list
//inf	if(!H)
//inf		return

	var/decl/hierarchy/outfit/outfit = input("Select outfit.", "Select equipment.") as null|anything in outfits()
	if(!outfit)
		return

	var/reset_equipment = (outfit.flags&OUTFIT_RESET_EQUIPMENT)
	if(!reset_equipment)
		reset_equipment = alert("Do you wish to delete all current equipment first?", "Delete Equipment?","Yes", "No") == "Yes"

	SSstatistics.add_field_details("admin_verb","SEQ")
	dressup_human(H, outfit, reset_equipment)

/proc/dressup_human(var/mob/living/carbon/human/H, var/decl/hierarchy/outfit/outfit, var/undress = TRUE)
	if(!H || !outfit)
		return
	if(undress)
		H.delete_inventory(TRUE)
	outfit.equip(H)
	log_and_message_admins("changed the equipment of [key_name(H)] to [outfit.name].")

/client/proc/startSinglo()
	set category = "Debug"
	set name = "Start Singularity"
	set desc = "Sets up the singularity and all machines to get power flowing"

	if(alert("Are you sure? This will start up the engine. Should only be used during debug!",,"Yes","No") != "Yes")
		return

	for(var/obj/machinery/power/emitter/E in world)
		if(E.anchored)
			E.active = 1

	for(var/obj/machinery/field_generator/F in world)
		if(F.anchored)
			F.Varedit_start = 1
	spawn(30)
		for(var/obj/machinery/the_singularitygen/G in world)
			if(G.anchored)
				var/obj/singularity/S = new /obj/singularity(get_turf(G), 50)
				spawn(0)
					qdel(G)
				S.energy = 1750
				S.current_size = 7
				S.icon = 'icons/effects/224x224.dmi'
				S.icon_state = "singularity_s7"
				S.pixel_x = -96
				S.pixel_y = -96
				S.grav_pull = 0
				//S.consume_range = 3
				S.dissipate = 0
				//S.dissipate_delay = 10
				//S.dissipate_track = 0
				//S.dissipate_strength = 10

	for(var/obj/machinery/power/rad_collector/Rad in world)
		if(Rad.anchored)
			if(!Rad.P)
				var/obj/item/tank/phoron/Phoron = new/obj/item/tank/phoron(Rad)
				Phoron.air_contents.gas[GAS_PHORON] = 70
				Rad.drainratio = 0
				Rad.P = Phoron
				Phoron.forceMove(Rad)

			if(!Rad.active)
				Rad.toggle_power()

	for(var/obj/machinery/power/smes/SMES in world)
		if(SMES.anchored)
			SMES.input_attempt = 1

/client/proc/cmd_debug_mob_lists()
	set category = "Debug"
	set name = "Debug Mob Lists"
	set desc = "For when you just gotta know"

	switch(input("Which list?") in list("Players","Admins","Mobs","Living Mobs","Dead Mobs", "Ghost Mobs", "Clients"))
		if("Players")
			to_chat(usr, jointext(GLOB.player_list,","))
		if("Admins")
			to_chat(usr, jointext(GLOB.admins,","))
		if("Mobs")
			to_chat(usr, jointext(SSmobs.mob_list,","))
		if("Living Mobs")
			to_chat(usr, jointext(GLOB.living_mob_list_,","))
		if("Dead Mobs")
			to_chat(usr, jointext(GLOB.dead_mob_list_,","))
		if("Ghost Mobs")
			to_chat(usr, jointext(GLOB.ghost_mob_list,","))
		if("Clients")
			to_chat(usr, jointext(GLOB.clients,","))

// DNA2 - Admin Hax
/client/proc/cmd_admin_toggle_block(var/mob/M,var/block)
	if(GAME_STATE < RUNLEVEL_GAME)
		alert("Wait until the game starts")
		return
	if(istype(M, /mob/living/carbon))
		M.dna.SetSEState(block,!M.dna.GetSEState(block))
		domutcheck(M,null,MUTCHK_FORCED)
		M.update_mutations()
		var/state="[M.dna.GetSEState(block)?"on":"off"]"
		var/blockname=assigned_blocks[block]
		message_admins("[key_name_admin(src)] has toggled [M.key]'s [blockname] block [state]!")
		log_admin("[key_name(src)] has toggled [M.key]'s [blockname] block [state]!")
	else
		alert("Invalid mob")

/datum/admins/proc/view_runtimes()
	set category = "Debug"
	set name = "View Runtimes"
	set desc = "Open the Runtime Viewer"

	if(!check_rights(R_DEBUG))
		return

	GLOB.error_cache.show_to(usr.client)

/client/proc/cmd_analyse_health_panel()
	set category = "Debug"
	set name = "Analyse Health"
	set desc = "Get an advanced health reading on a human mob."

	var/mob/living/carbon/human/H = input("Select mob.", "Analyse Health") as null|anything in GLOB.human_mob_list
	if(!H)	return

	cmd_analyse_health(H)

/client/proc/cmd_analyse_health(var/mob/living/carbon/human/H)

	if(!check_rights(R_DEBUG))
		return

	if(!H)	return

	var/dat = display_medical_data(H.get_raw_medical_data(), SKILL_MAX)

	dat += text("<BR><A href='?src=\ref[];mach_close=scanconsole'>Close</A>", usr)
	show_browser(usr, dat, "window=scanconsole;size=430x600")

/client/proc/cmd_analyse_health_context(mob/living/carbon/human/H as mob in GLOB.human_mob_list)
	set category = null
	set name = "Analyse Human Health"

	if(!check_rights(R_DEBUG))
		return
	if(!ishuman(H))	return
	cmd_analyse_health(H)
	SSstatistics.add_field_details("admin_verb","ANLS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/obj/effect/debugmarker
	icon = 'icons/effects/lighting_overlay.dmi'
	icon_state = "transparent"
	layer = HOLOMAP_LAYER
	alpha = 127

/client/var/list/image/powernet_markers = list()
/client/proc/visualpower()
	set category = "Debug"
	set name = "Visualize Powernets"

	if(!check_rights(R_DEBUG)) return
	visualpower_remove()
	powernet_markers = list()

	for(var/datum/powernet/PN in SSmachines.powernets)
		var/netcolor = rgb(rand(100,255),rand(100,255),rand(100,255))
		for(var/obj/structure/cable/C in PN.cables)
			var/image/I = image('icons/effects/lighting_overlay.dmi', get_turf(C), "transparent")
			I.plane = DEFAULT_PLANE
			I.layer = EXPOSED_WIRE_LAYER
			I.alpha = 127
			I.color = netcolor
			I.maptext = "\ref[PN]"
			powernet_markers += I
	images += powernet_markers

/client/proc/visualpower_remove()
	set category = "Debug"
	set name = "Remove Powernets Visuals"

	images -= powernet_markers
	QDEL_NULL_LIST(powernet_markers)

/client/proc/toggle_planet_repopulating()
	set category = "Debug"
	set name = "Toggle Planet Mob Repopulating"

	GLOB.planet_repopulation_disabled = !GLOB.planet_repopulation_disabled
	log_and_message_admins("toggled planet mob repopulating [GLOB.planet_repopulation_disabled ? "OFF" : "ON"].")

/client/proc/spawn_exoplanet(exoplanet_type as anything in subtypesof(/obj/effect/overmap/visitable/sector/exoplanet))
	set category = "Debug"
	set name = "Create Exoplanet"

	var/budget = input("Ruins budget. Default is 5, a budget of 0 will not spawn any ruins, 5 will spawn around 3-5 ruins:", "Ruins Budget", 5) as num | null

	if (isnull(budget) || budget < 0)
		budget = 5

	var/theme = input("Choose a theme:", "Theme") as anything in typesof(/datum/exoplanet_theme/) | null

	if (!theme)
		theme = /datum/exoplanet_theme

	var/daycycle = alert("Should the planet have a day-night cycle?","Day Night Cycle", "Yes", "No")

	if (daycycle == "Yes")
		daycycle = TRUE
	else
		daycycle = FALSE

	var/last_chance = alert("Spawn exoplanet?", "Final Confirmation", "Yes", "Cancel")

	if (last_chance == "Cancel")
		return

	var/obj/effect/overmap/visitable/sector/exoplanet/new_planet = new exoplanet_type(null, world.maxx, world.maxy)
	new_planet.features_budget = budget
	new_planet.themes = list(new theme)
	new_planet.lightlevel = rand(5, 10)/10

	log_and_message_admins("is spawning [new_planet] at [new_planet.start_x],[new_planet.start_y], containing Z [english_list(new_planet.map_z)]")
	new_planet.build_level()
	message_admins("[new_planet] has completed generation.")



/datum/admins/proc/change_weather()
	set category = "Debug"
	set name = "Change Weather"
	set desc = "Changes the current weather."

	if(!check_rights(R_DEBUG))
		return

	var/datum/planet/planet = input(usr, "Which planet do you want to modify the weather on?", "Change Weather") in SSplanets.planets
	var/datum/weather/new_weather = input(usr, "What weather do you want to change to?", "Change Weather") as null|anything in planet.weather_holder.allowed_weather_types
	if(new_weather)
		planet.weather_holder.change_weather(new_weather)
		var/log = "[key_name(src)] changed [planet.name]'s weather to [new_weather]."
		message_admins(log)
		log_admin(log)

/datum/admins/proc/change_time()
	set category = "Debug"
	set name = "Change Planet Time"
	set desc = "Changes the time of a planet."

	if(!check_rights(R_DEBUG))
		return

	var/datum/planet/planet = input(usr, "Which planet do you want to modify time on?", "Change Time") in SSplanets.planets

	var/datum/time/current_time_datum = planet.current_time
	var/new_hour = input(usr, "What hour do you want to change to?", "Change Time", text2num(current_time_datum.show_time("hh"))) as null|num
	if(!isnull(new_hour))
		var/new_minute = input(usr, "What minute do you want to change to?", "Change Time", text2num(current_time_datum.show_time("mm")) ) as null|num
		if(!isnull(new_minute))
			var/type_needed = current_time_datum.type
			var/datum/time/new_time = new type_needed()
			new_time = new_time.add_hours(new_hour)
			new_time = new_time.add_minutes(new_minute)
			planet.current_time = new_time
			spawn(1)
				planet.update_sun()

			var/log = "[key_name(src)] changed [planet.name]'s time to [planet.current_time.show_time("hh:mm")]."
			message_admins(log)
			log_admin(log)
