/*
 * Contains:
 *		Fire protection
 *		Bomb protection
 *		Radiation protection
 */

/*
 * Fire protection
 */

/obj/item/clothing/suit/fire
	name = "firesuit"
	desc = "A suit that protects against fire and heat."
	icon_state = "firesuit"
	item_state_slots = list(
		slot_l_hand_str = "firefighter",
		slot_r_hand_str = "firefighter",
	)
	w_class = ITEM_SIZE_LARGE

	body_parts_covered = UPPER_TORSO | LOWER_TORSO| ARMS
	armor = list(laser = ARMOR_LASER_MINOR, energy = ARMOR_ENERGY_MINOR, bomb = ARMOR_BOMB_MINOR)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank/emergency,/obj/item/extinguisher,/obj/item/crowbar/emergency_forcing_tool,/obj/item/clothing/head)

	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	heat_protection = UPPER_TORSO | LOWER_TORSO | ARMS
	cold_protection = UPPER_TORSO | LOWER_TORSO | ARMS

	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/fire/Initialize()
	. = ..()
	slowdown_per_slot[slot_wear_suit] = 0.5

/obj/item/clothing/suit/fire/firefighter
	icon_state = "firesuit"
	item_state_slots = list(
		slot_l_hand_str = "firefighter",
		slot_r_hand_str = "firefighter",
	)


/obj/item/clothing/suit/fire/heavy
	name = "firesuit"
	desc = "A suit that protects against extreme fire and heat."
	//icon_state = "thermal"
	item_state_slots = list(
		slot_l_hand_str = "ro_suit",
		slot_r_hand_str = "ro_suit",
	)
	w_class = ITEM_SIZE_HUGE//bulky item

/obj/item/clothing/suit/fire/heavy/Initialize()
	..()
	slowdown_per_slot[slot_wear_suit] = 0.5

/*
 * Bomb protection
 */
/obj/item/clothing/head/bomb_hood
	name = "bomb hood"
	desc = "Use in case of bomb."
	icon_state = "bombsuit"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_SHIELDED
		)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	siemens_coefficient = 0
	tint = 2

/obj/item/clothing/suit/bomb_suit
	name = "bomb suit"
	desc = "A suit designed for safety when handling explosives."
	icon_state = "bombsuit"
	w_class = ITEM_SIZE_HUGE//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_SHIELDED
		)
	flags_inv = HIDEJUMPSUIT|HIDETAIL
	heat_protection = UPPER_TORSO|LOWER_TORSO
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/suit/bomb_suit/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 2

/obj/item/clothing/head/bomb_hood/security
	icon_state = "bombsuitsec"
	body_parts_covered = HEAD

/obj/item/clothing/suit/bomb_suit/security
	icon_state = "bombsuitsec"
	allowed = list(/obj/item/gun/energy,/obj/item/melee/baton,/obj/item/handcuffs)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS

/*
 * Radiation protection
 */
/obj/item/clothing/head/radiation
	name = "radiation hood"
	icon_state = "rad"
	desc = "A hood with radiation protective properties. Label: Made with lead, do not eat insulation."
	flags_inv = BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	armor = list(
		bio = ARMOR_BIO_RESISTANT,
		rad = ARMOR_RAD_SHIELDED
		)
	tint = 1 //INF

/obj/item/clothing/suit/radiation
	name = "radiation suit"
	desc = "A suit that protects against radiation. Label: Made with lead, do not eat insulation."
	icon_state = "rad"
	item_state_slots = list(
		slot_l_hand_str = "rad_suit",
		slot_r_hand_str = "rad_suit",
	)
	w_class = ITEM_SIZE_HUGE//bulky item

	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	min_cold_protection_temperature = T0C - 20
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	allowed = list(/obj/item/device/flashlight,/obj/item/tank/emergency,/obj/item/clothing/head/radiation,/obj/item/clothing/mask/gas,/obj/item/device/geiger)
	armor = list(
		bio = ARMOR_BIO_RESISTANT,
		rad = ARMOR_RAD_SHIELDED
		)
	flags_inv = HIDEJUMPSUIT|HIDETAIL|HIDEGLOVES|HIDESHOES

/obj/item/clothing/suit/radiation/New()
	..()
	slowdown_per_slot[slot_shoes] = 1.5


/obj/item/clothing/suit/bomb_suit/bombsuit
	icon = 'icons/stalker/d2k5/mob/suit.dmi'
	icon_state = "rad1"
	item_state = "bombsuit"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = 60,
		rad = ARMOR_RAD_SHIELDED
		)
	body_parts_covered = UPPER_TORSO | LOWER_TORSO| ARMS | HEAD| HANDS| LEGS| FEET

/obj/item/clothing/suit/bomb_suit/rad/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 2


