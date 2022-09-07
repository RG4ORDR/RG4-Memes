/mob/living/silicon/spawn_gibs()
	new /obj/effect/gibspawner/robot(drop_location(), src)

/mob/living/silicon/spawn_dust()
	new /obj/effect/decal/remains/robot(loc)

/mob/living/silicon/(gibbed)
	if(!gibbed)
		emote("gasp")
	diag_hud_set_status()
	diag_hud_set_health()
	update_health_hud()
	return ..()
