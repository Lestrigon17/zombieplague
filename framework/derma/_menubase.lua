if CLIENT then
	-------------------------------------------------------------------------
local storegate = lsg_menu or {};
lsg_menu = storegate or {};

lsg_menu.active = lsg_menu.active or nil;
--[[-------------------------------------------------------------------------
FONTS
---------------------------------------------------------------------------]]
local textSize = math.Clamp(ScreenScale(7), 17, 50);
surface.CreateFont( "lsg_menu", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = true,
	size = textSize,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	shadow = true,
} )
surface.CreateFont( "lsg_menu_small", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = true,
	size = math.Clamp(ScreenScale(6), 14, 50),
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	shadow = true,
} )

--[[-------------------------------------------------------------------------
META menu
---------------------------------------------------------------------------]]
local lsg_meta = {
	btn_exit = true,
	btn_movement = false,
	header = "%r%[%w%LESTRIGON%r%]%w% Base menu",
	buttons = {},
	btn_exit_data = {name = "#Exit", callBack = function() lsg_menu:Close() end},
	page = 1
};

function lsg_meta:SetExitButton(state)
	self["btn_exit"] = state;
	return self;
end;

function lsg_meta:SetMovementButton(state)
	self["btn_movement"] = state;
	return self;
end;

function lsg_meta:SetHeader(header)
	self["header"] = header;
	return self;
end;

function lsg_meta:SetSubHeader(header)
	self["sub_header"] = header;
	return self;
end;

function lsg_meta:ReplaceExitButton(name, callBack)
	self["btn_exit_data"] = {name = name, callBack = callBack};
	return self;
end;

function lsg_meta:AddButton(name)
	local btnNum = (#self["buttons"] or 0) + 1;

	self["buttons"][btnNum] = {name = name, callBack = function() lsg_menu:Close(); end, disabled = false, border = 0};

	self["buttons"][btnNum]["SetCallback"] = function(s, func)
		self["buttons"][btnNum]["callBack"] = func or function() lsg_menu:Close(); end;
		return self["buttons"][btnNum];
	end;
	self["buttons"][btnNum]["SetDisabled"] = function(s, state)
		self["buttons"][btnNum]["disabled"] = state or false;
		return self["buttons"][btnNum];
	end;
	self["buttons"][btnNum]["AddBorder"] = function(s, borderNums)
		if (!borderNums) then borderNums = 1; end;
		self["buttons"][btnNum]["border"] = self["buttons"][btnNum]["border"] + borderNums;
		return self["buttons"][btnNum];
	end;

	if (btnNum > 9) then
		self:SetMovementButton(true);
	end;

	return self["buttons"][btnNum];
end;

--[[-------------------------------------------------------------------------
Draw functions
---------------------------------------------------------------------------]]

function draw.SimpleParsedText(text, font, x, y, color, ax, ay)
	x = x or 0;
	local text_array = string.Explode("%", text);	// Парсим текст
	local textSizeAr = {};

	for k, v in pairs(text_array) do // Сортировка текста
		if (zm.colors[v]) then continue; end;
		textSizeAr[#textSizeAr+1] = zm.language:get(v) and zm.language:get(v) or v;
	end;
	local textSize = table.concat(textSizeAr, " "); // Готовый текст
	local startx = x; // Откуда начинается текст

	if (ax == 2) then // Центровка center
		surface.SetFont(font);
		local w, h = surface.GetTextSize(textSize);
		startx = startx - w / 2;
	end;

	if (ax == 3) then // Центровка right
		surface.SetFont(font);
		local w, h = surface.GetTextSize(textSize);
		startx = startx - w - 10;
	end;

	local nextColor = color; // Цвет следующего текста
	local sizex, sizey = 0, 0; // Размер который возвращаем
	for k, v in pairs(text_array) do
		if (zm.colors[v]) then nextColor = ax == 1 and nextColor or zm.colors[v]; continue; end; // Если это код цвета то прекращаем отображение

		v = zm.language:get(v) and zm.language:get(v) or v;

		draw.SimpleText(v, font, startx, y, nextColor, 0, ay); // отображаем текст

		surface.SetFont(font);
		local w, h = surface.GetTextSize(v);
		w = w or 0; h = h or 0;

		startx = startx + w; // Откуда начинается следующий символ
		sizex = sizex + w; // Размер текста в ширину
		sizey = h; // Размер текста в высоту
	end;

	return sizex, sizey; // Возвращаем ширину и высоту текста
end;

--[[-------------------------------------------------------------------------
Menu functions
---------------------------------------------------------------------------]]
function lsg_menu:CreateMenu()
	lsg_menu.active = table.Copy(lsg_meta);

	return lsg_menu.active;
end;

function lsg_menu:Close()
	lsg_menu.active = nil;
end;

--[[-------------------------------------------------------------------------
HOOKS
---------------------------------------------------------------------------]]

hook.Add("HUDPaint", "lsg_menu", function()
	local margin = 5;
	local zero = ScrH()/2-ScrH()/4;
	if (!lsg_menu.active) then return; end;

	local maxBtns = lsg_menu.active["btn_movement"] and 7 or 9;
	local nums = math.Clamp(#lsg_menu.active["buttons"] - (lsg_menu.active["page"]-1)*maxBtns, 0, maxBtns);
	local nextX = zero + textSize*2+margin*8;

	if (lsg_menu.active["sub_header"]) then
		if (lsg_menu.active["btn_movement"]) then
			local floor = math.floor(#lsg_menu.active["buttons"]/maxBtns)
			local allPages = floor + ((#lsg_menu.active["buttons"]/maxBtns) - floor == 0 and 0 or 1);
			
			draw.SimpleParsedText(lsg_menu.active["header"].." [" .. lsg_menu.active["page"] .. "-" .. allPages.."]", "lsg_menu", 20, zero+margin, Color(255,255,255), 0, 4);
			draw.SimpleParsedText(lsg_menu.active["sub_header"], "lsg_menu_small", 20, zero+margin*2, Color(255,255,255), 0, 0);	
		else	
			draw.SimpleParsedText(lsg_menu.active["header"], "lsg_menu", 20, zero+margin, Color(255,255,255), 0, 4);
			draw.SimpleParsedText(lsg_menu.active["sub_header"], "lsg_menu_small", 20, zero+margin*2, Color(255,255,255), 0, 0);	
		end;

		draw.SimpleParsedText(lsg_menu.active["header"], "lsg_menu", 20, zero+margin, Color(255,255,255), 0, 4);
		draw.SimpleParsedText(lsg_menu.active["sub_header"], "lsg_menu_small", 20, zero+margin*2, Color(255,255,255), 0, 0);	
	else
		if (lsg_menu.active["btn_movement"]) then
			local floor = math.floor(#lsg_menu.active["buttons"]/maxBtns)
			local allPages = floor + ((#lsg_menu.active["buttons"]/maxBtns) - floor == 0 and 0 or 1);
			
			draw.SimpleParsedText(lsg_menu.active["header"].." [" .. lsg_menu.active["page"] .. "-" .. allPages.."]", "lsg_menu", 20, zero+margin*3, Color(255,255,255), 0, 0);
		else	
			draw.SimpleParsedText(lsg_menu.active["header"], "lsg_menu", 20, zero+margin*3, Color(255,255,255), 0, 0);
		end;
	end;


	for i = 1, nums do
		local startBtn = (lsg_menu.active["page"]-1)*maxBtns;
		if (lsg_menu.active["buttons"][startBtn+i]["disabled"]) then
			draw.SimpleParsedText(i..". %" .. lsg_menu.active["buttons"][startBtn+i]["name"], "lsg_menu", 20, nextX, zm.colors.twhite, 1, 0);	
		else
			draw.SimpleParsedText("%brown%"..i..". %white%" .. lsg_menu.active["buttons"][startBtn+i]["name"], "lsg_menu", 20, nextX, Color(255,255,255), 0, 0);	
		end
		
		nextX = nextX + textSize + margin;

		if (lsg_menu.active["buttons"][startBtn+i]["border"] > 0) then
			nextX = nextX + (textSize/2 + margin/2) * lsg_menu.active["buttons"][startBtn+i]["border"];
		end;
	end;

	nextX = nextX + margin*3;

	if lsg_menu.active["btn_movement"] then
		draw.SimpleParsedText("%brown%8. %white%#Next", "lsg_menu", 20, nextX, Color(255,255,255), 0, 0);	
		draw.SimpleParsedText("%brown%9. %white%#Prev", "lsg_menu", 20, nextX+textSize+margin, Color(255,255,255), 0, 0);	

		nextX = nextX + textSize*2 + margin*2;
	end;
	if (lsg_menu.active["btn_exit"]) then
		draw.SimpleParsedText("%brown%0. %palegoldenrod%"..lsg_menu.active["btn_exit_data"]["name"], "lsg_menu", 20, nextX, Color(255,255,255), 0, 0);	
	end;
end);

--[[-------------------------------------------------------------------------
Action controller
---------------------------------------------------------------------------]]
hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if (name == "CHudWeaponSelection" and lsg_menu.active) then return false end
end )

local pressed = false;
local pressedKey = -1;
/*hook.Add("Think", "lsg_menu", function()
	if (lsg_menu.active) then
		local emptyFunc = function() end;
		local actions = {};
		local maxBtns = lsg_menu.active["btn_movement"] and 7 or 9;
		local startBtn = (lsg_menu.active["page"]-1)*maxBtns;
		local nums = math.Clamp(#lsg_menu.active["buttons"] - (lsg_menu.active["page"]-1)*maxBtns, 0, maxBtns);

		if (lsg_menu.active["btn_movement"]) then
			local floor = math.floor(#lsg_menu.active["buttons"]/maxBtns)
			local allPages = floor + ((#lsg_menu.active["buttons"]/maxBtns) - floor == 0 and 0 or 1);
			// PAGES
			actions[9] = function() lsg_menu.active["page"] = math.Clamp(lsg_menu.active["page"]+1, 1, allPages) end;
			actions[8] = function() lsg_menu.active["page"] = math.Clamp(lsg_menu.active["page"]-1, 1, allPages) end;
		end;

		for i = 1, maxBtns do
			if (!lsg_menu.active["buttons"][startBtn+i]) then continue; end;

			actions[i] = (lsg_menu.active["buttons"][startBtn+i] or {})["callBack"] or emptyFunc;
			if (lsg_menu.active["buttons"][startBtn+i]["disabled"]) then
				actions[i] = emptyFunc;
			end;
		end;

		actions[0] = lsg_menu.active["btn_exit_data"]["callBack"] or emptyFunc;	// Exit

		for i = 0, 9 do
			if (input.IsKeyDown(i+1) and !pressed and !gui.IsGameUIVisible() and !gui.IsConsoleVisible()) then
				pressed = true;
				pressedKey = i+1;
				actions[i]();
			elseif (!input.IsKeyDown(pressedKey) and pressed) then
				pressed = false;
			end;
		end;
	end;
end);*/

netstream.Hook("lsg_menu_btn", function(btn_enum)
	hook.Call("lsg:ButtonPress", GM, btn_enum);
	if (!lsg_menu.active) then return; end;

	local emptyFunc = function() end;
	local actions = {};
	local maxBtns = lsg_menu.active["btn_movement"] and 7 or 9;
	local startBtn = (lsg_menu.active["page"]-1)*maxBtns;
	local nums = math.Clamp(#lsg_menu.active["buttons"] - (lsg_menu.active["page"]-1)*maxBtns, 0, maxBtns);

	if (lsg_menu.active["btn_movement"]) then
		local floor = math.floor(#lsg_menu.active["buttons"]/maxBtns)
		local allPages = floor + ((#lsg_menu.active["buttons"]/maxBtns) - floor == 0 and 0 or 1);
		// PAGES
		actions[9] = function() print("asd") lsg_menu.active["page"] = math.Clamp(lsg_menu.active["page"]+1, 1, allPages); end;
		actions[10] = function() lsg_menu.active["page"] = math.Clamp(lsg_menu.active["page"]-1, 1, allPages); end;
	end;

	for i = 1, maxBtns do
		if (!lsg_menu.active["buttons"][startBtn+i]) then continue; end;

		actions[i+1] = (lsg_menu.active["buttons"][startBtn+i] or {})["callBack"] or emptyFunc;
		if (lsg_menu.active["buttons"][startBtn+i]["disabled"]) then
			actions[i+1] = emptyFunc;
		end;
	end;

	if (lsg_menu.active["btn_exit"]) then
		actions[1] = lsg_menu.active["btn_exit_data"]["callBack"] or emptyFunc;	// Exit
	else
		actions[1] = function() end;	// Exit
	end
	for i = 1, 10 do
		if (btn_enum == i) then
			pressedKey = i;
			(actions[i] or emptyFunc)();
		end;
	end;
end);


	-------------------------------------------------------------------------
else
	-------------------------------------------------------------------------

hook.Add("PlayerButtonDown", "lsg_menu_btn", function(ply, btn_enum)
	if (ply.lsg_lastsend or 0 < CurTime()) then
		ply.lsg_lastsend = CurTime() + .3;
		netstream.Start(ply, "lsg_menu_btn", btn_enum);
	end;
end);

	-------------------------------------------------------------------------
end;

//	TEST

/*do 	// TEST MENU
	local test_menu = lsg_menu:CreateMenu()
	:SetHeader("Title")
	--:SetSubHeader("Subtitle");

	local btns = {}; // btns table
	btns[1] = test_menu:AddButton("With callBack")
	:SetCallback(function()
		// ... ACTIONS
		// Use lsg_menu:Close() for close menu after action
		lsg_menu:Close();
	end);
	btns[5] = test_menu:AddButton("With border"):AddBorder();
	btns[5] = test_menu:AddButton("Disabled"):SetDisabled(true);
	btns[10] = test_menu:AddButton("With callBack")
	:SetCallback(function()
		...
		lsg_menu:Close(); -- don't remove, this closing menu after press on button
	end);
end*/

/*---------------------------------------------------------------------------
 _     ____  __  _____  ___   _   __    ___   _
| |   | |_  ( (`  | |  | |_) | | / /`_ / / \ | |\ |
|_|__ |_|__ _)_)  |_|  |_| \ |_| \_\_/ \_\_/ |_| \|	2017
---------------------------------------------------------------------------*/