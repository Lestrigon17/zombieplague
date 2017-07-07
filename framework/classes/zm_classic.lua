local zm = zm or {};
zm.zombie = zm.zombie or {};

local class = zm.zombie:CreateClass("classic")	// Unique id of class
:SetName("Классический")		// Name of class
:SetDesc("= Balanced =")	// Description
:SetModel("models/player/zombie_classic.mdl")	// Model
:SetWeapons({"weapon_crowbar", "weapon_pistol"})// Weapons
:SetSpeed(250)		// Speed
:SetJumpPower(215)	// Jump
:SetRecoil(1)		// Как сильно отлетает при попадание (1 стандартный коафицент)
:SetHealth(3500)	// Health
:Register();		// Register class