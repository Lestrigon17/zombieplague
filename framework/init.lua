--[[-------------------------------------------------------------------------
VARS
---------------------------------------------------------------------------]]
local localstore = zm or {};
zm = localstore or {};
zm.uniqueID = cookie.GetNumber(zm_uniqueid, 0);

--[[-------------------------------------------------------------------------
Logs functions
---------------------------------------------------------------------------]]
function zm:ConsoleLog(text)
	MsgC(Color(255,0,0), "["..zp_loading.jsonData["name"].."] ", Color(255,255,255), text, Color(255,0,0), ";", "\n");
end;

--[[-------------------------------------------------------------------------
GAMEMODE NAME
---------------------------------------------------------------------------]]
function GM:GetGameDescription()
	return zp_loading.jsonData["name"].." "..zp_loading.jsonData["version"];
end;

--[[-------------------------------------------------------------------------
Meta function
---------------------------------------------------------------------------]]
local meta = FindMetaTable( "Player" )
if (meta) then

	function meta:CreateIdle()
		if (timer.Exists(self:UniqueID().."ZombieIdle")) then timer.Destroy(self:UniqueID().."ZombieIdle"); end;

		timer.Create(self:UniqueID().."ZombieIdle", math.random(15, 90), 1, function()
			if (!IsValid(self) or !self:Alive() or self:Team() != TEAM_ZOMBIE) then return; end;
			self:EmitSound("zombieplague/zombies/idle"..math.random(1,6)..".wav");
			self:CreateIdle();
		end);
	end;

	function meta:MakeZombie(first)
		self:StripWeapons();
		self:StripAmmo();
		self:SetArmor(0);
		self:SetTeam(TEAM_ZOMBIE);

		self:EmitSound("zombieplague/zombies/infec"..math.random(1,4)..".wav")

		local zombieClass = zm.zombie.store[self.zm_data.class] and self.zm_data.class or zm.cfg.DefaultZMClass;
		local zombieData = zm.zombie.store[zombieClass];

		self:SetJumpPower(zombieData["JumpPower"]);
		self:SetRunSpeed(zombieData["Speed"]);
		self:SetWalkSpeed(zombieData["Speed"]);
		self:SetHealth(zombieData["Health"] + (first and 3000+zombieData["Health"]*.3 or 0));	// If first zombie then +3000 hp +30% from base
		self:SetModel(zombieData["Model"]);

		for k,v in pairs(zombieData["Weapons"]) do
			self:Give(v);
		end;

		self:CreateIdle();
	end;

	function meta:MakeHumansVars()
		self:SetJumpPower(200);
		self:SetRunSpeed(200);
		self:SetWalkSpeed(200);
	end;

	function meta:MakeSlowHumansVars()
		self:SetJumpPower(200);
		self:SetRunSpeed(125);
		self:SetWalkSpeed(125);
	end;

	function meta:MakeHuman()
		self:StripWeapons(); print(self:Name().."#Strip 2")
		self:StripAmmo();
		self:SetTeam(TEAM_HUMAN);
		self:SetArmor(0);
		self:MakeHumansVars();
		self:SetModel("models/jessev92/player/misc/edfsoldier.mdl");
		zm.weapon:OpenWeaponMenu(v);
	end;

	function meta:LoadAmmoPacks()
		local ammo = zm.sql:GetData("zp_ammo_"..self:SteamID64(), 0);
		self.zm.ammopacks = ammo;
		self:SetNWInt("zp_ammo", ammo);

		zm:ConsoleLog("Player "..self:Name().." have "..ammo.." ammo packs")
	end;

	function meta:AddAmmoPacks(num)
		local ammo = self.zm.ammopacks + num;
		zm.sql:SetData("zp_ammo_"..self:SteamID64(), ammo);
		self.zm.ammopacks = ammo;
		self:SetNWInt("zp_ammo", ammo);
	end;

	function meta:TakeAmmoPacks(num)
		local ammo = self.zm.ammopacks - num;
		zm.sql:SetData("zp_ammo_"..self:SteamID64(), ammo);
		self.zm.ammopacks = ammo;
		self:SetNWInt("zp_ammo", ammo);
	end;
end
/*---------------------------------------------------------------------------
Player Data
---------------------------------------------------------------------------*/
netstream.Hook("zm:localInfo", function(ply, data)
	for k,v in pairs(data) do 	// LUA Protection against injections
		if (!isstring(v)) then
			v:Kick("Hacking attempt!");
			return;
		end;
	end;
	
	ply.zm_data.class = data["defZombieClass"] or zm.cfg.DefaultZMClass;
end);

local WMeta = FindMetaTable( "Weapon" );
zm_oldPrimaryFunc = zm_oldPrimaryFunc or WMeta.TakePrimaryAmmo;

function WMeta:TakePrimaryAmmo( num )
	self.Owner:SetAmmo(300, self.Weapon:GetPrimaryAmmoType(), true);

	-- Doesn't use clips
	if ( self.Weapon:Clip1() <= 0 ) then

		if ( self:Ammo1() <= 0 ) then return end

		self.Owner:RemoveAmmo( num, self.Weapon:GetPrimaryAmmoType() )

	return end

	self.Weapon:SetClip1( self.Weapon:Clip1() - num )

	--return zm_oldPrimaryFunc(num);
end;

/*---------------------------------------------------------------------------
 _     ____  __  _____  ___   _   __    ___   _
| |   | |_  ( (`  | |  | |_) | | / /`_ / / \ | |\ |
|_|__ |_|__ _)_)  |_|  |_| \ |_| \_\_/ \_\_/ |_| \|	2017
---------------------------------------------------------------------------*/