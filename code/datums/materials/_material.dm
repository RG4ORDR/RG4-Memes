/*! Material datum

Simple datum which is instanced once per type and is used for every object of said material. It has a variety of variables that define behavior. Subtyping from this makes it easier to create your own materials.

*/


/datum/material
	var/name = "material"
	var/desc = "It's...stuff." // I'm stuff :stuff:
	///Var that's mostly used by science machines to identify specific materials, should most likely be phased out at some point
	var/id = "mat"
	///Base color of the material, is used for greyscale. Item isn't changed in color if this is null.
	var/color
	///Base alpha of the material, is used for greyscale icons.
	var/alpha
	///Materials "Traits". its a map of key = category | Value = Bool. Used to define what it can be used for.gold
	var/list/categories = list()
	///The type of sheet this material creates. This should be replaced as soon as possible by greyscale sheets.
	var/sheet_type
	///The type of coin this material spawns. This should be replaced as soon as possible by greyscale coins.
	var/coin_type
	///This is a modifier for force, and resembles the strength of the material
	var/strength_modifier = 1
	///This is a modifier for integrity, and resembles the strength of the material
	var/integrity_modifier = 1

///This proc is called when the material is added to an object.
/datum/material/proc/on_applied(atom/source, amount, material_flags)
	if(!(material_flags & MATERIAL_NO_COLOR)) //Prevent changing things with pre-set colors, to keep colored toolboxes their looks for example
		if(color) //Do we have a custom color?
			source.add_atom_colour(color, FIXED_COLOUR_PRIORITY)
		if(alpha)
			source.alpha = alpha

	if(istype(source, /obj)) //objs
		on_applied_obj(source, amount, material_flags)
	
	source.mat_update_desc(src)

///This proc is called when a material updates an object's description
/atom/proc/mat_update_desc(datum/material/mat)
	return

///This proc is called when the material is added to an object specifically.
/datum/material/proc/on_applied_obj(obj/o, amount, material_flags)
	var/new_max_integrity = CEILING(o.max_integrity * integrity_modifier, 1)
	// This is to keep the same damage relative to the max integrity of the object
	o.obj_integrity = (o.obj_integrity / o.max_integrity) * new_max_integrity
	o.max_integrity = new_max_integrity
	o.force *= strength_modifier
	o.throwforce *= strength_modifier


///This proc is called when the material is removed from an object.
/datum/material/proc/on_removed(atom/source, material_flags)
	if(!(material_flags & MATERIAL_NO_COLOR)) //Prevent changing things with pre-set colors, to keep colored toolboxes their looks for example
		if(color)
			source.remove_atom_colour(FIXED_COLOUR_PRIORITY, color)
		source.alpha = initial(source.alpha)

	if(istype(source, /obj)) //objs
		on_removed_obj(source, material_flags)

///This proc is called when the material is removed from an object specifically.
/datum/material/proc/on_removed_obj(obj/o, amount, material_flags)
	var/new_max_integrity = initial(o.max_integrity)
	// This is to keep the same damage relative to the max integrity of the object
	o.obj_integrity = (o.obj_integrity / o.max_integrity) * new_max_integrity

	o.max_integrity = new_max_integrity
	o.force = initial(o.force)
	o.throwforce = initial(o.throwforce)

/** Returns the composition of this material.
  *
  * Mostly used for alloys when breaking down materials.
  *
  * Arguments:
  * - amount: The amount of the material to break down.
  * - breakdown_flags: Some flags dictating how exactly this material is being broken down.
  */
/datum/material/proc/return_composition(amount=1, breakdown_flags=NONE)
	return list((src) = amount) // Yes we need the parenthesis, without them BYOND stringifies src into "src" and things break.

/**
  *	This proc is called when the mat is found in an item that's consumed by accident. see /obj/item/proc/on_accidental_consumption.
  * Arguments
  * * M - person consuming the mat
  * * S - (optional) item the mat is contained in (NOT the item with the mat itself)
  */
/datum/material/proc/on_accidental_mat_consumption(mob/living/carbon/M, obj/item/S)
	return FALSE
