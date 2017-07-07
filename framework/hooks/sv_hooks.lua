/*---------------------------------------------------------------------------
InitPostEntity
---------------------------------------------------------------------------*/
function GM:InitPostEntity()
	RunConsoleCommand("sv_alltalk", "1");
	RunConsoleCommand("sv_kickerrornum", "0");
end;

/*---------------------------------------------------------------------------
Player spawn
---------------------------------------------------------------------------*/
function GM:PlayerLoadout( ply )

/*	ply:StripWeapons();
	ply:StripAmmo(); print(ply:Name().."Strip #1")*/

	ply:Give( "weapon_crowbar" );

	-- run speeds and jump powah
	ply:SetRunSpeed( 200 );
	ply:SetWalkSpeed( 200 );
	ply:SetJumpPower( 200 );
	ply:DrawViewModel( true );

	ply:SetupHands( ply );

	return self.BaseClass:PlayerLoadout( ply );
end;

function GM:PlayerInitialSpawn(ply)
	if !ply or !IsValid(ply) then return; end;
	ply:SetTeam(TEAM_SPECTATOR);
	ply.ChangeToNormal = true;
	if ROUND_STATE == ROUND_ACTIVE then
		ply.CanRespawn = false;
	end;
	ply.CanRespawn = true;
	ply.zm = {};
	ply.zm_data = {};
	ply:LoadAmmoPacks();

	player_manager.SetPlayerClass( ply, "human" );

	self:PlayerSetModel(ply);
	timer.Simple(0,function()
		ply:KillSilent();
		ply:Spectate(OBS_MODE_ROAMING);
	end);
end;

function GM:PlayerSelectSpawn( ply )
	local spawns = ents.FindByClass("info_player_start");
	return spawns[math.random(#spawns)];
end

function GM:PlayerSpawn(ply)
	if ply:Team() == TEAM_SPECTATOR and ply.ChangeToNormal == false then
		ply:Spectate(OBS_MODE_ROAMING);
		return;
	end;

	if ply.CanRespawn == false and zm.round:GetState() != ROUND_FREE then
		ply:Spectate(OBS_MODE_ROAMING);
		return;
	end;

	if ply:Team() == TEAM_SPECTATOR and ply.ChangeToNormal == true then
		ply:SetTeam(TEAM_HUMAN);
		ply.ChangeToNormal = false;
	end;
	self.BaseClass:PlayerSpawn( ply );

	ply:CrosshairEnable();
	ply:SetAvoidPlayers(false);
	ply:SetupHands();
	ply:Give("weapon_crowbar");
	ply:UnSpectate();

	local mdl = hook.Call( "ChangePlayerModel", GAMEMODE, ply ) or false;

	ply:SetModel(mdl or "models/jessev92/player/misc/edfsoldier.mdl");
end

function GM:PlayerSetModel(ply)
	player_manager.RunClass( ply, "SetModel" )
end


/*---------------------------------------------------------------------------
Player Death
---------------------------------------------------------------------------*/

function GM:GetFallDamage(ply, flFallSpeed)
	return flFallSpeed / 9
end

function GM:PlayerDeath(victim, weapon, killer)
	if ( victim:IsOnFire() ) then
		victim:Extinguish()
	end

	if (victim:Team() == TEAM_ZOMBIE) then
		local zombieClass = zm.zombie.store[victim.zm_data.class] and victim.zm_data.class or zm.cfg.DefaultZMClass;
		local zombieData = zm.zombie.store[zombieClass];

		if (zombieData["CustomDies"]) then
			victim:EmitSound("zombieplague/zombies/"..zombieData["UniqueID"].."/die"..math.random(1,zombieData["NumDies"])..".wav");
		else
			victim:EmitSound("zombieplague/zombies/"..(zm.cfg.DefaultZMClass).."/die"..math.random(1,zombieData["NumDies"])..".wav");
		end;
	end;

	--timer.Simple(0,function()
	if ROUND_STATE == ROUND_ACTIVE then
		victim.CanRespawn = false
		victim:Spectate(OBS_MODE_ROAMING)
		victim:CrosshairDisable()
	end
	--end)
	netstream.Start(_, "dr:deathnotice", {victim, killer})
end

function GM:PlayerDeathThink( ply )
	return false
end

hook.Add("DoPlayerDeath", "dr:deathhook:reciver", function(ply, killer, dmg)
	netstream.Start(ply, "dr:deathhook:listener", killer)
end)

hook.Add("PlayerSpawn", "dr:spawnhook:reciver", function(ply)
	netstream.Start(ply, "dr:spawnhook:listener")
end)

/*---------------------------------------------------------------------------
Player suicide
---------------------------------------------------------------------------*/
function GM:CanPlayerSuicide( ply )
	return false;
end;

/*---------------------------------------------------------------------------
Player voice
---------------------------------------------------------------------------*/
hook.Add( "PlayerCanHearPlayersVoice", "dr:AliveCanHearDeath", function( listener, talker )
	--if listener:Alive() and !talker:Alive() then return false; end;
end);

/*---------------------------------------------------------------------------
Footsteps
---------------------------------------------------------------------------*/
/*
function GM:PlayerFootstep( ply, pos, foot, sound, volume, rf )
	if ply:Team() == TEAM_ZOMBIE then
		ply:EmitSound("zombieplague/zombies/classic/footstep"..math.random(1,12)..".mp3");
		return true;
	end;
end
*/
/*---------------------------------------------------------------------------
Damage
---------------------------------------------------------------------------*/
function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
	if (ply:Team() == TEAM_HUMAN and dmginfo:GetAttacker():Team() == TEAM_ZOMBIE and #zm:GetAlives(TEAM_HUMAN) > 1 and ply:Armor() <= 0) then
		ply:MakeZombie(); 
		netstream.Start(_, "zm:hud:notification", "%twhite%Зомби сожрали мозг %brown%"..death:Name().."");
		return;
	end;

	if (dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker():Team() == TEAM_HUMAN) then
		if ( hitgroup == HITGROUP_HEAD ) then
			dmginfo:ScaleDamage(1)
			if (ply:Team() == TEAM_ZOMBIE) then
				dmginfo:GetAttacker().zm.headshots = (dmginfo:GetAttacker().zm.headshots or 0) + 1;
				if (dmginfo:GetAttacker().zm.headshots > 35) then
					dmginfo:GetAttacker():AddAmmoPacks(1);
					dmginfo:GetAttacker().zm.headshots = 0;
				end;
				ply:EmitSound("physics/body/body_medium_break"..math.random(2,4)..".wav");
			end;
	 	else
			dmginfo:ScaleDamage(.3)
			if (ply:Team() == TEAM_ZOMBIE) then
				local zombieClass = zm.zombie.store[ply.zm_data.class] and ply.zm_data.class or zm.cfg.DefaultZMClass;
				local zombieData = zm.zombie.store[zombieClass];

				dmginfo:GetAttacker().zm.damage = (dmginfo:GetAttacker().zm.damage or 0) + dmginfo:GetDamage();
				if (dmginfo:GetAttacker().zm.damage >= 650) then
					dmginfo:GetAttacker():AddAmmoPacks(1);
					dmginfo:GetAttacker().zm.damage = 0;
				end;

				if (zombieData["CustomDamage"]) then
					ply:EmitSound("zombieplague/zombies/"..zombieData["UniqueID"].."/pain_0"..math.random(1,zombieData["NumDamage"])..".wav");
				else
					ply:EmitSound("zombieplague/zombies/"..(zm.cfg.DefaultZMClass).."/pain_0"..math.random(1,zombieData["NumDamage"])..".wav");
				end;
			end;
		end;
		
		if (ply:Team() == TEAM_ZOMBIE) then
			netstream.Start(dmginfo:GetAttacker(), "zm:hud:damage", math.ceil(dmginfo:GetDamage()));
		end;
	end;

	if (dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker():Team() == TEAM_ZOMBIE and ply:Team() == TEAM_HUMAN) then
		if (timer.Exists(ply:UniqueID().."ZombieHit")) then timer.Remove(ply:UniqueID().."ZombieHit"); end;
		ply:MakeSlowHumansVars();
		timer.Create(ply:UniqueID().."ZombieHit", 3, 1, function()
			if (!IsValid(ply) or !ply:Alive() or ply:Team() != TEAM_HUMAN) then return; end;
			ply:MakeHumansVars()
		end);

		if (ply:Armor() > 0) then
			print("asda")
			ply:SetArmor(ply:Armor() - dmginfo:GetDamage());
			ply:EmitSound("player/bhit_helmet-1.wav");
			dmginfo:ScaleDamage(0);
		end;
	end;
end

function GM:EntityTakeDamage( target, dmginfo )
	local pl1, pl2 = target, dmginfo:GetAttacker();
	if ( pl1:IsPlayer() and pl2:IsPlayer() ) then
		if (pl1:Team() == pl2:Team()) then
			dmginfo:ScaleDamage(0)
		else
			if (pl1:Team() == TEAM_ZOMBIE) then
				local zombieClass = zm.zombie.store[pl1.zm_data.class] and pl1.zm_data.class or zm.cfg.DefaultZMClass;
				local zombieData = zm.zombie.store[zombieClass];

				if (timer.Exists(pl1:UniqueID().."zombiePain")) then timer.Destroy(pl1:UniqueID().."zombiePain"); end;
				timer.Create(pl1:UniqueID().."zombiePain",3,1, function()
					if (IsValid(pl1) and pl1:Alive() and pl1:Team() == TEAM_ZOMBIE) then
						pl1:EmitSound("zombieplague/zombies/pain"..math.random(1,3)..".wav");
					end;
				end);
			end;
		end;
	end

end

/*---------------------------------------------------------------------------
Unique ID
---------------------------------------------------------------------------*/
hook.Add("PlayerInitialSpawn", "zm:SendID", function(ply)
	netstream.Start(ply, "zm:uniqueID", zm.sql:GetData("zm_uniqueid"));
end);