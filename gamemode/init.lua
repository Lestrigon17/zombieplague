/*---------------------------------------------------------------------------
Created by
 __        ________   ______   ________  _______   ______   ______    ______   __    __
/  |      /        | /      \ /        |/       \ /      | /      \  /      \ /  \  /  |
$$ |      $$$$$$$$/ /$$$$$$  |$$$$$$$$/ $$$$$$$  |$$$$$$/ /$$$$$$  |/$$$$$$  |$$  \ $$ |
$$ |      $$ |__    $$ \__$$/    $$ |   $$ |__$$ |  $$ |  $$ | _$$/ $$ |  $$ |$$$  \$$ |
$$ |      $$    |   $$      \    $$ |   $$    $$<   $$ |  $$ |/    |$$ |  $$ |$$$$  $$ |
$$ |      $$$$$/     $$$$$$  |   $$ |   $$$$$$$  |  $$ |  $$ |$$$$ |$$ |  $$ |$$ $$ $$ |
$$ |_____ $$ |_____ /  \__$$ |   $$ |   $$ |  $$ | _$$ |_ $$ \__$$ |$$ \__$$ |$$ |$$$$ |
$$       |$$       |$$    $$/    $$ |   $$ |  $$ |/ $$   |$$    $$/ $$    $$/ $$ | $$$ |
$$$$$$$$/ $$$$$$$$/  $$$$$$/     $$/    $$/   $$/ $$$$$$/  $$$$$$/   $$$$$$/  $$/   $$/

SITE: http://lestrigon.PW/		AUTHOR: Lestrigon
E-Mail: lestrigon17@yandex.ru 	AUTHOR-STEAM: https://steamcommunity.com/profiles/76561198033633013

in 2017 year
---------------------------------------------------------------------------*/

local storgate = zp_loading or {};
zp_loading = storgate or {};      
zp_loading.loaded = zp_loading.loaded or false;

zp_loading.startTime = os.clock();	// Loading start time
// JSON DATA
zp_loading.jsonData = file.Read("gamemodes/zombieplague/zombieplague.json", "GAME");
zp_loading.jsonData = util.JSONToTable(zp_loading.jsonData);

// START
if (!zp_loading.loaded) then
	MsgC(Color(255,0,0), "================= ", Color(255,255,255), " LOADING ", Color(255,0,0), " =================", "\n");
	MsgC(Color(255,0,0), "["..zp_loading.jsonData["name"].."] ", Color(255,255,255), "Start loading...", "\n");
	MsgC(Color(255,0,0), "["..zp_loading.jsonData["name"].."] ", Color(255,255,255), "Current version ", Color(255,0,0), zp_loading.jsonData["version"], "\n");
	hook.Add("Think", "zm:version", function()
		if (zp_loading.checkversion) then return; end;
		zp_loading.checkversion = true;
		http.Fetch("https://raw.githubusercontent.com/Lestrigon17/zombieplague/dev/zombieplague.json",
			function( body, len, headers, code )
				local jsonData = util.JSONToTable(body);
				if (jsonData["version"] != zp_loading.jsonData["version"]) then
					MsgC(Color(255,255,0), "["..zp_loading.jsonData["name"].."] ", Color(255,255,255), "Your version is out of date ", "\n");
					MsgC(Color(255,255,0), "[LESTRIGON] ", Color(255,255,255), "New version: https://github.com/Lestrigon17/zombieplague/", "\n");
				else
					MsgC(Color(255,255,0), "["..zp_loading.jsonData["name"].."] ", Color(255,255,255), "The local version is the same as the repository ", "\n");
				end;
			end, function() end
		)
	end)
else
	MsgC(Color(255,0,0), "================= ", Color(255,255,255), " REFRESHING ", Color(255,0,0), " =================", "\n");
end 

// CLIENT
AddCSLuaFile("cl_init.lua");

// LIBS
AddCSLuaFile("libs/pon.lua");
AddCSLuaFile("libs/netstream2.lua");

include("libs/pon.lua");
include("libs/netstream2.lua");

// CORE
AddCSLuaFile("zombieplague/framework/cl_init.lua");
AddCSLuaFile("zombieplague/framework/core.lua");

include("zombieplague/framework/init.lua"); 
include("zombieplague/framework/core.lua");	// SHARED

/*---------------------------------------------------------------------------
Time took loaded
---------------------------------------------------------------------------*/
zp_loading.endTime = os.clock();	// Loading end time

local diff = zp_loading.endTime - zp_loading.startTime;	// Loading time
zp_loading.lastLoadingTime = diff; // Insert to table
diff = math.Round(diff, 3); // round

if (zp_loading.loaded) then
	MsgC(Color(255,0,0), "["..zp_loading.jsonData["name"].."] ", Color(255,255,255), "The gamemode is re-loaded in ", diff," seconds.", "\n");
	MsgC(Color(255,0,0), "================= ================= =================", "\n");
else 
	zp_loading.loaded = true;
	MsgC(Color(255,0,0), "["..zp_loading.jsonData["name"].."] ", Color(255,255,255), "The gamemode is loaded in ", diff," seconds.", "\n");
	MsgC(Color(255,0,0), "================= ================= =================", "\n");
end


RunConsoleCommand("sv_gravity", 800);
RunConsoleCommand("sv_allowcslua","0");