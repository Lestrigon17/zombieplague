/*---------------------------------------------------------------------------
Classes
---------------------------------------------------------------------------*/
DEFINE_BASECLASS( "player_default" )

local HUMAN = {}

HUMAN.WalkSpeed 			= 200
HUMAN.RunSpeed				= 200
HUMAN.Model					= ""
HUMAN.JumpPower				= 200
HUMAN.DropWeaponOnDie 		= false
HUMAN.TeammateNoCollide		= false

function HUMAN:Spawn()
	--
end

function HUMAN:SetModel()
	self.Player:SetModel("models/player/Group01/male_07.mdl")
end

function HUMAN:Loadout()
	self.Player:RemoveAllAmmo()
	--self.Player:StripWeapons() print(self.Player:Name().."Strip #3")

	self.Player:Give( "weapon_crowbar" )
end

player_manager.RegisterClass( "human", HUMAN, "player_default" )

local DEATH = {}

DEATH.WalkSpeed 			= 200
DEATH.RunSpeed				= 200
DEATH.Model					= ""
DEATH.JumpPower				= 200
DEATH.DropWeaponOnDie 		= false
DEATH.TeammateNoCollide		= false

function DEATH:Spawn()
	--
end

function DEATH:SetModel()
	self.Player:SetModel("models/player/zombie.mdl")
end

function DEATH:Loadout()
	self.Player:RemoveAllAmmo()
	self.Player:StripWeapons()

	self.Player:Give( "weapon_crowbar" )
end

player_manager.RegisterClass( "zombie", DEATH, "player_default" )
