local zm = zm or {};
zm.zombie = zm.zombie or {};

local class = zm.zombie:CreateClass("speedy")	// Unique id of class
:SetName("Быстрый")		// Name of class
:SetDesc("HP-- SPEED+++")	// Description
:SetModel("models/player/zombie_classic.mdl")	// Model
:SetWeapons({"weapon_crowbar", "weapon_pistol"})// Weapons
:SetSpeed(265)		// Speed
:SetJumpPower(200)	// Jump
:SetRecoil(1)		// Как сильно отлетает при попадание (1 стандартный коафицент)
:SetHealth(2000)	// Health
:Register();		// Register class