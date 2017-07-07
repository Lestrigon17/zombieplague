local zm = zm or {};
zm.language = zm.language or {};

function zm.language:RegisterLanguage(name, author, data)
	data["__author"] = author;
	zm.language[name] = data;

	if (name == zm.cfg.lang) then
		zm:ConsoleLog(name.." language by "..author.." is loaded");
	end;
end;

function zm.language:GetPhrase(text)
	if (zm.language[zm.cfg.lang][text] != nil) then
		text = zm.language[zm.cfg.lang][text];
	end;
	return text;
end;

function zm.language:get(text)
	if (zm.language[zm.cfg.lang][text] != nil) then
		text = zm.language[zm.cfg.lang][text];
	end;
	return text;
end;

if CLIENT then
	local oldFunc = draw.SimpleText;

	draw.SimpleText = function(text, font, x, y, color, xa, ya) 
		if (zm.language[zm.cfg.lang][text] != nil) then
			text = zm.language[zm.cfg.lang][text];
		end;
		oldFunc(text, font, x, y, color, xa, ya);
	end;
end;

zm:ConsoleLog("Language core is loaded"); 
/*---------------------------------------------------------------------------
 _     ____  __  _____  ___   _   __    ___   _
| |   | |_  ( (`  | |  | |_) | | / /`_ / / \ | |\ |
|_|__ |_|__ _)_)  |_|  |_| \ |_| \_\_/ \_\_/ |_| \|	2017
---------------------------------------------------------------------------*/