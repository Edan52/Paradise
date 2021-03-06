SUBSYSTEM_DEF(fires)
	name = "Fires"
	priority = FIRE_PRIOTITY_BURNING
	flags = SS_NO_INIT|SS_BACKGROUND
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/currentrun = list()
	var/list/processing = list()

/datum/controller/subsystem/fires/stat_entry()
	..("P:[processing.len]")


/datum/controller/subsystem/fires/fire(resumed = 0)
	if(!resumed)
		src.currentrun = processing.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/obj/O = currentrun[currentrun.len]
		currentrun.len--
		if(!O || QDELETED(O))
			processing -= O
			if(MC_TICK_CHECK)
				return
			continue

		if(O.burn_state == ON_FIRE)
			if(O.burn_world_time < world.time)
				O.burn()
		else
			processing -= O

		if(MC_TICK_CHECK)
			return
