local zm = zm or {};
zm.hud = zm.hud or {};
zm.hud.store = zm.hud.store or {};


local textSize = math.Clamp(ScreenScale(7), 14, 65);
local textSize2 = math.Clamp(ScreenScale(9), 17, 65);
local textSize3 = math.Clamp(ScreenScale(11), 20, 65);
local textSize4 = math.Clamp(ScreenScale(13), 20, 65);
surface.CreateFont( "zm:hud:small", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = true,
	size = textSize,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	shadow = true,
} )
surface.CreateFont( "zm:hud:normal", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = true,
	size = textSize2,
	weight = 900,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	shadow = true,
} )
surface.CreateFont( "zm:hud:big", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = true,
	size = textSize3,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	shadow = true,
} )
surface.CreateFont( "zm:hud:big2", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = true,
	size = textSize4,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	shadow = true,
} )

function zm.hud:AlphaColor(color, alpha)
	return Color(color.r, color.g, color.b, alpha);
end;

function zm.hud:DrawLastDamage(lply, x, y)
	local lastTime, lastValue = self.store["lastDMGTime"], self.store["lastDMGValue"];
	lastTime = lastTime or 0;
	lastValue = lastValue or 0;

	draw.SimpleText("-"..lastValue, "zm:hud:small", x/2, y/2, self:AlphaColor(zm.colors.dodgerblue, 150/2*math.Clamp(lastTime+3-CurTime(), 0, 5)), 1, 1);
end;	

function zm.hud:DrawInfoBar(lply, x, y)
	if (lply:Armor() > 0) then
		draw.SimpleParsedText("[%#HUDArmor%: "..lply:Armor().."]", "zm:hud:normal", 25, y-25-textSize3-5, self:AlphaColor(zm.colors.turquoise, 150), 0, 4);
	end;
	draw.SimpleParsedText("[%#HUDHealth%: "..lply:Health().."] [%#HUDClass%: %"..(lply:Team() == TEAM_HUMAN and "#human" or "#zombie").."%] [%#ammo%: "..lply:GetNWInt("zp_ammo").."]", "zm:hud:normal", 25, y-25, self:AlphaColor(zm.colors.limegreen, 200), 0, 4);
	if (ROUND_VARS["ShouldShowTime"]) then
		draw.SimpleParsedText("...::: "..string.FormattedTime(math.Round(ROUND_VARS["StartRoundTime"]+ROUND_VARS["RoundLenght"]-CurTime()), "%02i:%02i").." :::...", "zm:hud:big", x/2, y-25, self:AlphaColor(zm.colors.turquoise, 200), 2, 4);
	end;

	draw.SimpleParsedText("%#human% "..(#zm:GetAlives(TEAM_HUMAN)).." [ "..ROUND_VARS["RoundNum"].." ] "..(#zm:GetAlives(TEAM_ZOMBIE)).." %#zombie%", "zm:hud:big2", x/2, 25, self:AlphaColor(zm.colors.turquoise, 150), 2, 0);
	local w, h = draw.SimpleParsedText("%#HUDWins%", "zm:hud:big2", x/2-10, 25+textSize4+5, self:AlphaColor(zm.colors.turquoise, 150), 2, 0);
	
	draw.SimpleParsedText(ROUND_VARS["HumansWins"], "zm:hud:big2", x/2-w/2-12, 25+textSize4+5, self:AlphaColor(zm.colors.turquoise, 150), 3, 0);
	draw.SimpleParsedText(ROUND_VARS["ZombiesWins"], "zm:hud:big2", x/2+w/2-10, 25+textSize4+5, self:AlphaColor(zm.colors.turquoise, 150), 0, 0);
end;

function zm.hud:DrawRoundBar(lply, x, y)
	local lastTime = self.store["lastTVIRUSTime"] or 0;
	local time = self.store["lastTVIRUSTimer"] or 0;
	local timerstart = self.store["lastTVIRUSTimerStart"] or 0;
	draw.SimpleText("T-Virus попал в воздух", "zm:hud:big2", x/2, y*.3, self:AlphaColor(zm.colors.dodgerblue, 150/5*math.Clamp(lastTime+8-CurTime(), 0, 5)), 1, 1);

	if (ROUND_STATE == ROUND_PREPARE) then
		draw.SimpleParsedText("%brown%До первого инфецирования осталось "..math.ceil(math.Clamp(timerstart+time-CurTime(),0,time)), "zm:hud:big2", x/2, y*.3+textSize3+5, Color(255,255,255), 2, 1);	
	end;
end;

hook.Add("HUDPaint", "zm:hud", function()
	local lply, x, y = LocalPlayer(), ScrW(), ScrH();

	if (lply:Alive() and lply:Team() == TEAM_HUMAN) then
		zm.hud:DrawLastDamage(lply, x, y);
	end;

	zm.hud:DrawInfoBar(lply, x, y);
	zm.hud:DrawRoundBar(lply, x, y);
end);

--[[-------------------------------------------------------------------------
HOOKS
---------------------------------------------------------------------------]]
local toHide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudCommentary = true
};
hook.Add( "HUDShouldDraw", "zm:hud", function( name )
	if (toHide[name]) then return false; end;
end )

hook.Add( "zm:round:change", "zm:hud:tvirus", function(round, data)
	if (round == ROUND_PREPARE) then
		zm.hud.store["lastTVIRUSTime"] = CurTime();
	end;
end); 

hook.Add("zm:round:PrepareTimer", "zm:hud:timer", function(data)
	zm.hud.store["lastTVIRUSTimer"] = data;
	zm.hud.store["lastTVIRUSTimerStart"] = CurTime();
	surface.PlaySound("zombieplague/anouncer/start"..math.random(1,3)..".mp3");

	if (timer.Exists("zm:countdownTimer")) then timer.Destroy("zm:countdownTimer"); end;

	local startTime = 10;
	timer.Create("zm:countdownTimer", data-11, 1, function()
		timer.Create("zm:countdownTimer", 1, 10, function()
			if (ROUND_STATE != ROUND_PREPARE) then return; end;
			surface.PlaySound("zombieplague/anouncer/"..startTime..".wav");
			startTime = startTime - 1;
		end);
	end);
end);
 
netstream.Hook("zm:hud:damage", function(damage)
	zm.hud.store["lastDMGTime"] = CurTime();
	zm.hud.store["lastDMGValue"] = damage;
end);