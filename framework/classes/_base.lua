local zm = zm or {};
zm.zombie = zm.zombie or {};
zm.zombie.store = {};

--[[-------------------------------------------------------------------------
Class meta
---------------------------------------------------------------------------]]
local zm_classMeta = {
	["Name"]		= "Name of class",
	["Desc"]		= "Description of class",
	["Model"] 		= "models/error.mdl",
	["Weapons"] 	= {},
	["Speed"] 		= 225,
	["JumpPower"] 	= 200,
	["Recoil"]		= 1,
	["Health"]		= 1000,
	["CustomCheck"]	= function() return true; end,
	["NumDies"]		= 6,
	["CustomDies"] 	= false,
	["NumDamage"]	= 4,
	["CustomDamage"]= false,
	["UniqueID"] 	= "def"
};

local toAdd = {};
for k,v in pairs(zm_classMeta) do
	toAdd["Set"..k] = function(self, value)
		self[k] = value or self[k];
		return self;
	end;
end;
zm_classMeta = table.Merge(zm_classMeta,toAdd);

function zm_classMeta:Register()
	if (self["UniqueID"] == "def" or zm.zombie.store[self["UniqueID"]] != nil) then
		if (SERVER) then zm:ConsoleLog("[ERROR] Class with UniqueID: "..self["UniqueID"].." alredy registred!"); end;
		return;
	end

	zm.zombie.store[self["UniqueID"]] = self;
	if (SERVER) then zm:ConsoleLog("Zombie class is registered ["..self["UniqueID"].."]"); end;
end;
--[[-------------------------------------------------------------------------
Class functions
---------------------------------------------------------------------------]]
function zm.zombie:CreateClass(uniqueID)
	local toSend = table.Copy(zm_classMeta);
	toSend["UniqueID"] = uniqueID;
	return toSend;
end;

--[[-------------------------------------------------------------------------
Meta functions
---------------------------------------------------------------------------]]
local meta = FindMetaTable("Player");
if (meta) then
	function meta:GetActiveClass()
		if (self:Team() != TEAM_ZOMBIE) then return false; end;
		return self.zm.class;
	end;

	function meta:GetChoosenClass()
		return self.zm_data.class or zm.cfg.DefaultZMClass;
	end;
end;

zm:ConsoleLog("Zombie classes core is loaded"); 