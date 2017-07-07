local zm = zm or {};
zm.zombie = zm.zombie or {};

local class = zm.zombie:CreateClass("pudge")	// Unique id of class
:SetName("Толстяк")		// Name of class
:SetDesc("SPEED-- HP+++")	// Description
:SetModel("models/player/zombie_classic.mdl")	// Model
:SetWeapons({"weapon_crowbar", "weapon_pistol"})// Weapons
:SetSpeed(185)		// Speed
:SetJumpPower(200)	// Jump
:SetRecoil(1)		// Как сильно отлетает при попадание (1 стандартный коафицент)
:SetHealth(8500)	// Health
:Register();		// Register class