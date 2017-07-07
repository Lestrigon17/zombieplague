DeriveGamemode("base");

GM.Name 	= "Zombie Plague";
GM.Author 	= "Letrigon";
GM.Email 	= "lestrigon17@yandex.ru";
GM.Website 	= "lestrigon.pw";

local zm = zm or {};

--[[-------------------------------------------------------------------------
Teams
---------------------------------------------------------------------------]]
TEAM_SPECTATOR 	= 0
TEAM_HUMAN		= 1
TEAM_ZOMBIE		= 2

function GM:CreateTeams()
	team.SetUp( TEAM_SPECTATOR, "#spectator", Color( 200, 200, 200 ), false )

	team.SetUp( TEAM_HUMAN, "#human", Color( 0, 150, 255 ), true )
	team.SetSpawnPoint( TEAM_HUMAN, "info_player_start" )
	team.SetClass( TEAM_HUMAN, { "human" } )

	team.SetUp( TEAM_ZOMBIE, "#zombie", Color( 165, 30, 30 ), false )
	team.SetSpawnPoint( TEAM_ZOMBIE, "info_player_start" )
	team.SetClass( TEAM_ZOMBIE, { "zombie" } )
end

--[[-------------------------------------------------------------------------
INCLUDING FUNCTIONS
---------------------------------------------------------------------------]] 
function zm:IncludeFile(fileName, folder)	-- SIMPLE FILE
	if (!folder) then folder = ""; end;
	if (folder and folder != "") then folder = folder.."/"; end;

	if SERVER then
		if (!file.Exists("zombieplague/framework/"..folder..fileName, "LUA")) then
			self:ConsoleLog("File `"..fileName.."` in `"..folder.."` doesn't exists");
		end;
	end;

	local fType = 0;	-- 0 - shared, 1 - cl, 2 - sv
	if (string.find(fileName, "cl_")) then fType = 1; end;	// For clientside
	if (string.find(fileName, "sv_")) then fType = 2; end;	// For serverside

	if (SERVER) then
		if (fType < 2) then AddCSLuaFile(folder..fileName); end;	// Download shared and client files
	else
		if (fType == 1) then include(folder..fileName); end;		// Include if clientside only
	end;
	if (SERVER and fType == 2) then include(folder..fileName); end;// Include if serverside only
	if (fType == 0) then include(folder..fileName); end;			// Include if shared
end;

function zm:IncludeFolder(folderName)	-- FOLDER 
	if SERVER then
		if (!file.IsDir("zombieplague/framework/"..folderName, "LUA")) then
			self:ConsoleLog("Folder `"..folderName.."` doesn't exists");
		end;
	end;

	for k,v in pairs(file.Find("zombieplague/framework/"..folderName.."/*.lua", "LUA")) do
		zm:IncludeFile(v, folderName);
	end;
end;

// Folder to include
zm:IncludeFolder("cfg"); 		// Configs
zm:IncludeFolder("language"); 	// Language

-------------------------------------------
-- ReCreate Function of logs

zm.oldLog = zm.oldLog or zm.ConsoleLog;
function zm:ConsoleLog(text)
	if (zm.language[zm.cfg.lang][text] != nil) then
		text = zm.language[zm.cfg.lang][text];
	end;
	zm:oldLog(text);
end;

-- End
-------------------------------------------

--[[-------------------------------------------------------------------------
META
---------------------------------------------------------------------------]]
local meta = FindMetaTable( "Player" )
if (meta) then
	function meta:IsObserver()
		return ( self:GetObserverMode() > OBS_MODE_NONE );
	end
end

--[[-------------------------------------------------------------------------
functions
---------------------------------------------------------------------------]]
function zm:playerGetAll(tBlock)
	local toSend = {}
	for k,v in pairs(player.GetAll()) do
		if v:Team() == TEAM_SPECTATOR and not v.ChangeToNormal then continue end
		if tBlock and (v.DeathBlock or 0) > 0 then continue end
		table.insert(toSend, 1, v)
	end
	return toSend
end

function zm:TextToReplaceAndColor(text, data)
	if not isstring(text) then return "error" end

	for k,v in pairs(data) do
		text = string.Replace(text, v[1], v[2])
	end

	local tbl = string.Explode("^", text)
	local toSend = {}
	for k,v in pairs(tbl) do
		v = tostring(v)
		if not zm.colors[string.lower(string.sub(v,1,1))] then table.insert(toSend, v) continue end
		table.insert(toSend, zm.colors[string.lower(string.sub(v,1,1))])
		table.insert(toSend, string.sub(v,2,string.len(v)))
	end
	return toSend
end

function zm:ePrintMessage(tbl)
	chat.AddText(zm.colors["red"], "[ZM] ", zm.colors["white"], unpack(tbl[2]))
	surface.PlaySound("garrysmod/ui_hover.wav")
end
if CLIENT then
	netstream.Hook("zm:message", function(table)
		zm:ePrintMessage(table)
	end)

	function zm:PrintMessage(tbl, st)
		MsgC(Color(255,0,0), "[Zombie Plague] ", Color(255,255,255), unpack(tbl), "\n")
	end
end

if SERVER then
	function zm:SendMessage(ply, tbl, st)
		netstream.Start(ply or _, "zm:message", {st, tbl})
		MsgC(Color(255,0,0), "[Zombie Plague] ", Color(255,255,255), unpack(tbl), "\n")
	end
end
-- End
-------------------------------------------

zm:IncludeFile("sv_classes.lua"); 	// Classes
zm:IncludeFile("sv_spectator.lua"); // Spectator mode
zm:IncludeFile("sh_weapons.lua"); 	// Weapon controller
zm:IncludeFile("sh_round.lua"); 	// Rounds controller
zm:IncludeFile("sv_sql.lua"); 	// Rounds controller
zm:IncludeFolder("hooks");			// Hooks
zm:IncludeFolder("derma");			// Client derma
zm:IncludeFolder("classes");		// Classes

--[[-------------------------------------------------------------------------
HOOKS
---------------------------------------------------------------------------]]
function GM:Initialize()
	
end;   

--[[-------------------------------------------------------------------------
ZM Functions
---------------------------------------------------------------------------]]

function zm:GetAlives(tm)
	local toReturn = {};
	for k, v in pairs(zm:playerGetAll()) do
		if (v:IsPlayer() and v:Team() == tm and v:Alive()) then
			table.insert(toReturn, 1, v);
		end;
	end;
	return toReturn;
end;

--[[-------------------------------------------------------------------------
UniqueID
---------------------------------------------------------------------------]]
if (SERVER) then
	if (!zm.sql:GetData("zm_uniqueid")) then
		MsgC(Color(255,0,0), "["..zp_loading.jsonData["name"].."] ", Color(255,255,255), "The unique identifier of the server is not installed!", "\n");
		MsgC(Color(255,0,0), "["..zp_loading.jsonData["name"].."] ", Color(255,255,255), "Setting the ID ...", "\n");
		zm.sql:SetData("zm_uniqueid", math.random(1, 99999));
	end

	MsgC(Color(255,0,0), "["..zp_loading.jsonData["name"].."] ", Color(255,255,255), "Unique server identifier ", Color(255,0,0), zm.sql:GetData("zm_uniqueid"), "\n");
end;
/*---------------------------------------------------------------------------
 _     ____  __  _____  ___   _   __    ___   _
| |   | |_  ( (`  | |  | |_) | | / /`_ / / \ | |\ |
|_|__ |_|__ _)_)  |_|  |_| \ |_| \_\_/ \_\_/ |_| \|	2017
---------------------------------------------------------------------------*/