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

local positions = {
	[1] = {0,-1},
	[4] = {1,0},
	[7] = {0,1},
	[10] = {-1,0},

	[11] = {-math.sin(45), -math.cos(45)},
	[5] = {math.sin(45), math.cos(45)},
	[3] = {math.sin(45), -math.cos(45)},
	[9] = {-math.sin(45), math.cos(45)},

	[8] = {-math.cos(45), math.sin(45)},
	[6] = {math.cos(45), math.sin(45)},
	[12] = {-math.cos(45), -math.sin(45)},
	[2] = {math.cos(45), -math.sin(45)},
};
local lastHits = {};
local notifications = {};

function draw.OutlinedBox( x, y, w, h, thickness, clr )
	surface.SetDrawColor( clr )
	for i=0, thickness - 1 do
		surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
	end
end

local colors = {
	function(lply, ent)
		if (ent:IsPlayer() and ent:Team() != lply:Team()) then
			return zm.colors.red
		end;
		if (ent:IsPlayer() and ent:Team() == lply:Team()) then
			return zm.colors.royalblue
		end;
		return false;
	end,
}

function zm.hud:DrawLastDamage(lply, x, y)
	local lSpeed = lply:GetVelocity():Length2D();
	local size1 = 10 + 6 / 1 * math.Clamp(lSpeed/lply:GetMaxSpeed(),0,1);
	local size2 = 2 - 2 / 1 * math.Clamp(lSpeed/lply:GetMaxSpeed(),0,1);

	for k,v in pairs(lastHits) do
		draw.SimpleText("-"..v[2], "zm:hud:small", x/2+55*positions[v[3]][1], y/2+55*positions[v[3]][2], self:AlphaColor(zm.colors.dodgerblue, 255/1*math.Clamp(v[1]+1-CurTime(), 0, 5)), 1, 1);
	end

	if (lply:Team() == TEAM_HUMAN and lply:Alive()) then
		local ent = lply:GetEyeTrace().Entity;
		local drawColor = zm.colors.twhite;
		for k,v in pairs(colors) do
			if (v(lply, ent)) then
				drawColor = v(lply, ent);
			end;
		end;
		surface.DrawCircle(x/2, y/2, size1, drawColor.r, drawColor.g, drawColor.b, 25-25*(lSpeed/lply:GetMaxSpeed()));
		draw.RoundedBox(size2/2, x/2-size2/2, y/2-size2/2, size2, size2, drawColor);
	end;
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

	local ent = lply:GetEyeTrace().Entity;
	if (ent:IsPlayer()) then
		if (ent:Team() == TEAM_HUMAN) then
			draw.SimpleParsedText(ent:Name().." -- "..ent:Health().." HP / "..ent:Armor().." AP", "zm:hud:normal", x/2+10, y/2+65, self:AlphaColor(zm.colors.royalblue, 150), 2, 0);
		else
			draw.SimpleParsedText(ent:Name().." // "..(zm.zombie.store[ent:GetNWString("zp_class")]["Name"]), "zm:hud:normal", x/2+10, y/2+65, self:AlphaColor(zm.colors.tomato, 150), 2, 0);
		end;
	end;
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

function zm.hud:DrawNotifications(lply, x, y)
	for k,v in pairs(notifications) do
		if (v[1] + v[2] < CurTime()) then notifications[k] = nil; continue; end;
		draw.SimpleParsedText("%twhite%[%white% "..v[3].." %twhite%]", "zm:hud:normal", x/2+10, y/2+65+textSize3+textSize2*(k-1), Color(255,255,255), 2, 0);
	end;
end;

hook.Add("HUDPaint", "zm:hud", function()
	local lply, x, y = LocalPlayer(), ScrW(), ScrH();

	if (lply:Alive() and lply:Team() == TEAM_HUMAN) then
		zm.hud:DrawLastDamage(lply, x, y);
	end;

	zm.hud:DrawInfoBar(lply, x, y);
	zm.hud:DrawRoundBar(lply, x, y);
	zm.hud:DrawNotifications(lply, x, y);
end);

--[[-------------------------------------------------------------------------
HOOKS
---------------------------------------------------------------------------]]
local toHide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudCommentary = true,
	CHudCrosshair = true,
	CHudMessage = true,
	CHudSuitPower = true
};

function GM:HUDDrawTargetID()
end;

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

local lastHitPos = 1;
 
netstream.Hook("zm:hud:damage", function(damage)
	lastHitPos = lastHitPos + 1;
	if (lastHitPos > #positions) then
		lastHitPos = 1;
	end;

	table.insert(lastHits, 1, {CurTime(), damage, lastHitPos});
	if (#lastHits > #positions) then
		for k,v in pairs(lastHits) do
			if (k > #positions) then
				lastHits[k] = nil;
			end;
		end;
	end;
end);

netstream.Hook("zm:hud:notification", function(text)
	table.insert(notifications, 1, {CurTime(), 5, text});
end);