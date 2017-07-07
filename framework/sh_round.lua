zm.round = zm.round or {}
zm.round.EndTimeScale = 15	-- Don't touch

ROUND_STATE  	= ROUND_STATE or 1

ROUND_NEW 		= 0
ROUND_PREPARE 	= 1
ROUND_ACTIVE 	= 2
ROUND_END 		= 3
ROUND_EXIT 		= 4

ROUND_FREE		= 5	-- Only 1 active player
ROUND_HOLD		= 6	-- No active players

ROUND_HOLD_TiME = {{"Initial", 20}}

ROUND_VARS = ROUND_VARS or {}
ROUND_VARS["StartRoundTime"] = ROUND_VARS["StartRoundTime"] or 0
ROUND_VARS["EndRoundTime"] = ROUND_VARS["EndRoundTime"] or  0
ROUND_VARS["RoundLenght"] = zm.cfg.roundlength
ROUND_VARS["RoundNum"] = ROUND_VARS["RoundNum"] or 0
ROUND_VARS["ShouldShowTime"] = ROUND_VARS["ShouldShowTime"] or false	-- Always shows 00:00 remaning
ROUND_VARS["HumansWins"] = ROUND_VARS["HumansWins"] or 0;
ROUND_VARS["ZombiesWins"] = ROUND_VARS["ZombiesWins"] or 0;


if SERVER then
	function zm.round:AddHoldTime(hookName, time)
		table.insert(ROUND_HOLD_TiME, {hookName, tonumber(time)})
	end

	function zm.round:StartRound(STATE)
		STATE = STATE or ROUND_NEW

		game.CleanUpMap()

		ROUND_VARS["StartRoundTime"] = 0
		ROUND_VARS["EndRoundTime"] = 0
		if STATE == ROUND_NEW then
			ROUND_VARS["RoundNum"] = ROUND_VARS["RoundNum"] + 1
		end

		--MSG of round State
		local msg = STATE == ROUND_NEW and zm.language[zm.cfg.lang].round.new or STATE == ROUND_HOLD and zm.language[zm.cfg.lang].round.startH or zm.language[zm.cfg.lang].round.startF
		zm:SendMessage(_, {msg}, 7)

		--MSG of round State
		msg = zm.language[zm.cfg.lang].round.remaning
		msg = string.Replace(msg,"%a",ROUND_VARS["RoundNum"])
		msg = string.Replace(msg,"%b","9999")
		zm:SendMessage(_, {msg}, 3)

		ROUND_STATE = STATE
		netstream.Start(_, "zm:round:stream", STATE)
		hook.Call("zm:round:change", zm, STATE)
	end

	function zm.round:PrepareRound()
		for k,v in pairs(zm:playerGetAll()) do
			if (v:Team() != TEAM_HUMAN) then
				v:MakeHuman();
			end
			v.CanRespawn = true;
		end;

		for k,v in pairs(zm:playerGetAll()) do
			if (v:Alive()) then v:Spawn(); continue; end;
			v:Spawn();
			GAMEMODE:PlayerLoadout(v);
		end
		netstream.Start(_, "zm:hud:notification", "%brown%T-Virus %twhite% был выпущен в воздух");

		for k, v in pairs(zm:playerGetAll()) do
			zm.weapon:OpenWeaponMenu(v);
			v:MakeHumansVars();
		end;

		--MSG of round State
		local msg = zm.language[zm.cfg.lang].round.begin
		zm:SendMessage(_, {msg}, 1)

		ROUND_STATE = ROUND_PREPARE
		netstream.Start(_, "zm:round:stream", ROUND_PREPARE)
		hook.Call("zm:round:change", zm, ROUND_PREPARE)
	end

	function zm.round:GoRound()
		for k,v in pairs(zm:playerGetAll()) do
			if v:Alive() then 
				v:MakeHumansVars();
				v:UnLock();
				continue; 
			end;
			if !v.CanRespawn then continue; end;
			v:Spawn();
		end;

		death = table.Random(zm:playerGetAll(true));
		death:MakeZombie(true);
		netstream.Start(_, "zm:hud:notification", "%brown%T-Virus %twhite%поглотил мозги %brown%"..death:Name().."");

		for k,v in pairs(zm:playerGetAll()) do
			v.DeathBlock = math.Clamp((v.DeathBlock or 0) - 1, 0, 10);
		end;

		death.DeathBlock = (death.DeathBlock or 0) + 1;

		ROUND_VARS["StartRoundTime"] = CurTime();
		ROUND_VARS["ShouldShowTime"] = true;

		--MSG of round State
		local msg = zm.language[zm.cfg.lang].round.start;
		zm:SendMessage(_, {msg}, 1);

		ROUND_STATE = ROUND_ACTIVE;
		netstream.Start(_, "zm:round:stream", ROUND_ACTIVE);
		hook.Call("zm:round:change", zm, ROUND_ACTIVE);
	end;

	function zm.round:EndRound(winTeam)
		winTeam = winTeam or TEAM_SPECTATOR
		ROUND_VARS["ShouldShowTime"] = false

		--MSG of round State
		local msg = ""
		if winTeam == TEAM_SPECTATOR then
			msg = zm.language[zm.cfg.lang].round.none
		else
			if (winTeam == TEAM_ZOMBIE) then
				msg = "zombie win"
				ROUND_VARS["ZombiesWins"] = ROUND_VARS["ZombiesWins"] + 1;
			else
				for k, v in pairs(zm:playerGetAll()) do
					if (v:Team() == TEAM_ZOMBIE and v:Alive()) then
						v:Kill();
					end;
				end;
				msg = "humans win"
				ROUND_VARS["HumansWins"] = ROUND_VARS["HumansWins"] + 1;
			end
		end

		zm:SendMessage(_, (istable(msg) and {unpack(msg)} or {msg}), 2)

		msg = zm.language[zm.cfg.lang].round.out
		zm:SendMessage(_, {msg}, 5)

		game.SetTimeScale(1)
		timer.Simple(zm.round.EndTimeScale/1, function() game.SetTimeScale(1) end)

		ROUND_STATE = ROUND_END
		netstream.Start(_, "zm:round:stream", {ROUND_END, {winTeam}})
		hook.Call("zm:round:change", zm, ROUND_END, {winTeam})
	end

	function zm.round:ExitRound()
		for k,v in pairs(zm:playerGetAll()) do
			v:SetHealth(100);
		end

		ROUND_VARS["ShouldShowTime"] = false

		ROUND_STATE = ROUND_EXIT
		netstream.Start(_, "zm:round:stream", ROUND_EXIT)
		hook.Call("zm:round:change", zm, ROUND_EXIT)
	end

	function zm.round:GetState()
		return ROUND_STATE
	end

	concommand.Add("zm_GetRoundState", function(ply,cmd,args)
		if IsValid(ply) then return end
		print(zm.round:GetState())
	end)
	concommand.Add("zm_GetRoundActivePlayers", function(ply,cmd,args)
		if IsValid(ply) then return end
		print(#zm:playerGetAll())
	end)

	function zm.round:Controller()
		local plyForFree = (#zm:playerGetAll() > 0 and #zm:playerGetAll() < 2) and true or false
		local plyForStart = #zm:playerGetAll() >= 2 and true or false
		/*---------------------------------------------------------------------------
		FreeRound
		---------------------------------------------------------------------------*/
		if ROUND_STATE == ROUND_FREE then
			for k,v in pairs(zm:playerGetAll()) do
				if v:Alive() then continue end
				v:Spawn()
				game.CleanUpMap()
			end
		end
		/*---------------------------------------------------------------------------
		Round Game Controller
		---------------------------------------------------------------------------*/
		if ROUND_STATE == ROUND_ACTIVE and CurTime() > (ROUND_VARS["StartRoundTime"] + ROUND_VARS["RoundLenght"]) then
			self:EndRound(TEAM_HUMAN);
			ROUND_VARS["EndRoundTime"] = CurTime();

			--MSG of round State
			local msg = zm.language[zm.cfg.lang].round.outtime;
			zm:SendMessage(_, {msg}, 1);
		end

		if ROUND_STATE == ROUND_END and (CurTime() - zm.round.EndTimeScale/1) > ROUND_VARS["EndRoundTime"] then
			self:ExitRound();
			if not plyForStart then
				if not plyForFree then
					self:StartRound(ROUND_HOLD);
				else
					self:StartRound(ROUND_FREE);
				end;
			else
				self:StartRound(ROUND_NEW);
			end;
		end;

		local AZombie = 0;
		local AHuman = 0;
		for k,v in pairs(zm:playerGetAll()) do
			if v:Team() == TEAM_ZOMBIE and v:Alive() then
				AZombie = AZombie + 1;
			elseif v:Team() == TEAM_HUMAN and v:Alive() then
				AHuman = AHuman + 1;
			end;
		end;
		if AZombie == 0 and AHuman == 0 and ROUND_STATE == ROUND_ACTIVE then
			ROUND_VARS["EndRoundTime"] = CurTime()
			self:EndRound(TEAM_SPECTATOR)
		end;
		if AZombie == 0 and ROUND_STATE == ROUND_ACTIVE then
			ROUND_VARS["EndRoundTime"] = CurTime()
			self:EndRound(TEAM_HUMAN)
		end;
		if AHuman == 0 and ROUND_STATE == ROUND_ACTIVE then
			ROUND_VARS["EndRoundTime"] = CurTime()
			self:EndRound(TEAM_ZOMBIE)
		end;
		/*---------------------------------------------------------------------------
		Round Prepare Controller
		---------------------------------------------------------------------------*/
		if ROUND_STATE == ROUND_NEW then
			for k,v in pairs(player.GetAll()) do
				if v:Team() != TEAM_SPECTATOR and v.ChangeToNormal != true then continue end
				v:SetTeam(TEAM_HUMAN)
			end
			self:PrepareRound()
			if timer.Exists("zm:round:PrepareTimer") then timer.Remove("zm:round:PrepareTimer") end
			local maxTime = 0
			for k,v in pairs(ROUND_HOLD_TiME) do
				timer.Simple(v[2], function()
					hook.Call("zm:round:preapreState:"..v[1], zm)
					netstream.Start(_,"zm:round:preapreState", v[1])
				end)
				maxTime = maxTime + v[2]
			end
			netstream.Start(_,"zm:round:PrepareTimer", maxTime)
			hook.Call("zm:round:PrepareTimer", zm, data)
			timer.Create("zm:round:PrepareTimer", maxTime+1, 1, function()
				if ROUND_STATE != ROUND_PREPARE then return end
				for k,v in pairs(zm:playerGetAll()) do
					if v:Alive() then continue end
					if !v.CanRespawn then continue end
					v:Spawn()
				end
				self:GoRound()
			end)
		end
		/*---------------------------------------------------------------------------
		Round Hold Controller
		---------------------------------------------------------------------------*/
		if ROUND_STATE > ROUND_NEW and ROUND_STATE < ROUND_EXIT then
			if not plyForStart then
				self:ExitRound()
				if not plyForFree then
					self:StartRound(ROUND_HOLD)
				else
					self:StartRound(ROUND_FREE)
				end
			end
		elseif ROUND_STATE == ROUND_HOLD and plyForFree then
			self:ExitRound()
			self:StartRound(ROUND_FREE)
		elseif ROUND_STATE == ROUND_FREE and plyForStart then
			self:ExitRound()
			self:StartRound(ROUND_NEW)
		end
	end

	hook.Add("Think", "zm:round:controller", function() zm.round:Controller() end)

	netstream.Hook("zm:GetRoundInfo", function(ply, data)
		netstream.Start(ply, "zm:ReciveRoundInfo", {ROUND_VARS, ROUND_STATE})
	end)
else
	/*---------------------------------------------------------------------------
	Prepare hooks
	---------------------------------------------------------------------------*/
	netstream.Hook("zm:round:preapreState", function(name)
		if !isstring(name) then zm:PrintMessage({zm.language[zm.cfg.lang]["round"].ErrorTimerInitialize}, 5) return end
		hook.Call("zm:round:preapreState:"..name, zm)
	end)
	/*---------------------------------------------------------------------------
	Round Info
	---------------------------------------------------------------------------*/
	netstream.Hook("zm:ReciveRoundInfo", function(data)
		ROUND_VARS = data[1]
		ROUND_STATE = data[2]
	end)

	netstream.Hook("zm:round:stream", function(data)
		if istable(data) then
			ROUND_STATE = data[1]
			hook.Call("zm:round:change", zm, data[1], data[2])
		else
			ROUND_STATE = data
			hook.Call("zm:round:change", zm, data)
		end
		netstream.Start("zm:GetRoundInfo")
	end)

	netstream.Hook("zm:round:PrepareTimer", function(data)
		hook.Call("zm:round:PrepareTimer", zm, data)
	end)
	/*---------------------------------------------------------------------------
	Controller
	---------------------------------------------------------------------------*/
	ROUND_INFO_LOADED = ROUND_INFO_LOADED or false
	function zm.round:Controller()
		--[[-------------------------------------------------------------------------
		First Load
		---------------------------------------------------------------------------]]
		if not ROUND_INFO_LOADED then
			-- Request to get info
			netstream.Start("zm:GetRoundInfo")
			ROUND_INFO_LOADED = true
		end
	end

	hook.Add("Think", "zm:round:controller", function() zm.round:Controller() end)
end

hook.Call("zm:module:rounds", zm) -- Says that round module is initialized (for func[AddHoldTime])
