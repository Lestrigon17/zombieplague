local zm = zm or {};
zm.zombie = zm.zombie or {};

local class = zm.zombie:CreateClass("jumper")	// Unique id of class
:SetName("Прыгун")		// Name of class
:SetDesc("Jamp+++ HP- SPEED-")	// Description
:SetModel("models/player/zombie_classic.mdl")	// Model
:SetWeapons({"weapon_crowbar", "weapon_pistol"})// Weapons
:SetSpeed(225)		// Speed
:SetJumpPower(250)	// Jump
:SetRecoil(1)		// Как сильно отлетает при попадание (1 стандартный коафицент)
:SetHealth(3500)	// Health
:Register();		// Register class