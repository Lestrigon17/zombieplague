/*---------------------------------------------------------------------------
Spectate
---------------------------------------------------------------------------*/

function GM:PlayerBindPress( pl, bind, down )
	// Redirect binds to the spectate system
	if ( pl:IsObserver() && down ) then

		if ( bind == "+jump" ) then 	RunConsoleCommand( "spec_mode" )	end
		if ( bind == "+attack" ) then	RunConsoleCommand( "spec_next" )	end
		if ( bind == "+attack2" ) then	RunConsoleCommand( "spec_prev" )	end

	end

	return false
end

/*---------------------------------------------------------------------------
Countdown announcer
---------------------------------------------------------------------------*/

function zm:EnableAnnouncer()

end;

/*---------------------------------------------------------------------------
Round End Sound
---------------------------------------------------------------------------*/

hook.Add("zm:round:change", "zm:res", function(round, data)
	if (round == ROUND_END) then
		if (data[1] == TEAM_ZOMBIE) then
			surface.PlaySound("zombieplague/wins/win_zombie"..math.random(1, zm.cfg.countWinsZombie).."."..zm.cfg.extWinsZombie);
		elseif (data[1] == TEAM_HUMAN) then
			surface.PlaySound("zombieplague/wins/win_humans"..math.random(1, zm.cfg.countWinsHumans).."."..zm.cfg.extWinsHumans);
		end;
	end;
end);

/*---------------------------------------------------------------------------
Unique ID
---------------------------------------------------------------------------*/

netstream.Hook("zm:uniqueID", function(uniqueID)
	zm.uniqueID = uniqueID;
	zm:ConsoleLog("Unique server ID is " .. uniqueID);
	zm:SendLocalData();
end);