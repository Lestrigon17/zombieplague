local zm = zm or {};
zm.cfg = zm.cfg or {};


zm.cfg.lang 		= "ru"			// Active language
zm.cfg.roundlength 	= 7.5*60		// Round lenght

zm.cfg.DefaultZMClass = "classic"	// Default zombie class

--[[-------------------------------------------------------------------------
Sounds
---------------------------------------------------------------------------]]
zm.cfg.countWinsHumans = 10;
zm.cfg.extWinsHumans = "mp3";

zm.cfg.countWinsZombie = 3;
zm.cfg.extWinsZombie = "wav";

--[[-------------------------------------------------------------------------
Weaponry
---------------------------------------------------------------------------]]

zm.cfg.weaponry = {
	["primary"] = {
		{"weapon_insurgencym1911", "M1911 %darkslateblue%[%royalblue%#WeaponPistol%darkslateblue%]"},
		{"weapon_insurgencym45", "M45A1 %darkslateblue%[%royalblue%#WeaponPistol%darkslateblue%]"},
		{"weapon_insurgencym9", "M9 %darkslateblue%[%royalblue%#WeaponPistol%darkslateblue%]"},
		{"weapon_insurgencymakarov", "Makarov %darkslateblue%[%royalblue%#WeaponPistol%darkslateblue%]"},
		{"weapon_insurgencymodel10", "Revolver 10 %darkslateblue%[%royalblue%#WeaponPistol%darkslateblue%]"},
	},
	["secondary"] = {
		{"weapon_insurgencymini14", "AC556 %darkslateblue%[%royalblue%#WeaponRifle%darkslateblue%]"},
		{"weapon_insurgencyak74", "AK47 %darkslateblue%[%royalblue%#WeaponRifle%darkslateblue%]"},
		{"weapon_insurgencym4a1", "M4A1 %darkslateblue%[%royalblue%#WeaponRifle%darkslateblue%]"},
		{"weapon_insurgencymp5", "MP5K %darkslateblue%[%royalblue%#WeaponSMG%darkslateblue%]"},
		{"weapon_insurgencyump45", "UMP45 %darkslateblue%[%royalblue%#WeaponSMG%darkslateblue%]"},
		{"weapon_insurgencytoz", "TOZ %darkslateblue%[%royalblue%#WeaponShotgun%darkslateblue%]"},
		{"weapon_insurgencym590", "M590 %darkslateblue%[%royalblue%#WeaponShotgun%darkslateblue%]"},
		{"weapon_insurgencyakm", "AKM %darkslateblue%[%royalblue%#WeaponRifle%darkslateblue%]"},
		{"weapon_insurgencyaks74u", "AKS-74U %darkslateblue%[%royalblue%#WeaponRifle%darkslateblue%]"},
		{"weapon_insurgencyfal", "FAL %darkslateblue%[%royalblue%#WeaponRifle%darkslateblue%]"},
		{"weapon_insurgencygalil", "Galil %darkslateblue%[%royalblue%#WeaponRifle%darkslateblue%]"},
		{"weapon_insurgencygalilsar", "Galil SAR %darkslateblue%[%royalblue%#WeaponRifle%darkslateblue%]"},
		{"weapon_insurgencyl1a1", "L1A1 SLR %darkslateblue%[%royalblue%#WeaponRifle%darkslateblue%]"},
		{"weapon_insurgencym1a1", "M1 Carbin %darkslateblue%[%royalblue%#WeaponRifle%darkslateblue%]"},
		{"weapon_insurgencym14", "M14 EBR %darkslateblue%[%royalblue%#WeaponRifle%darkslateblue%]"},
		{"weapon_insurgencym16a4", "M16A4 %darkslateblue%[%royalblue%#WeaponRifle%darkslateblue%]"},
		{"weapon_insurgencymk18", "MK18 %darkslateblue%[%royalblue%#WeaponRifle%darkslateblue%]"},
	}
}
