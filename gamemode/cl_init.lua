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
if (!zp_loading.loaded) then
	MsgC(Color(255, 0, 0), "[Zombie Plague] ", Color(255,255,255), "Start loading...", "\n");
end

// LIBS
include("libs/pon.lua");
include("libs/netstream2.lua");

include("zombieplague/framework/cl_init.lua");
include("zombieplague/framework/core.lua"); // SHARED

/*---------------------------------------------------------------------------
Time took loaded
---------------------------------------------------------------------------*/
zp_loading.endTime = os.clock();	// Loading end time

local diff = zp_loading.endTime - zp_loading.startTime;	// Loading time
zp_loading.lastLoadingTime = diff; // Insert to table
diff = math.Round(diff, 3); // round

if (zp_loading.loaded) then
	MsgC(Color(255, 0, 0), "[Zombie Plague] ", Color(255,255,255), "The gamemode is re-loaded in ", diff," seconds.", "\n");
else 
	zp_loading.loaded = true;
	MsgC(Color(255, 0, 0), "[Zombie Plague] ", Color(255,255,255), "The gamemode is loaded in ", diff," seconds.", "\n");
end