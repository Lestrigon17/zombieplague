local zm = zm or {};
zm.weapon = zm.weapon or {};

function zm:GetWeapon(wep_class)
	local toReturn = false;

	for _, class in pairs({"primary", "secondary"}) do
		if (toReturn) then continue; end;
		for wep, name in pairs(zm.cfg.weaponry[class]) do
			if (toReturn) then continue; end;
			if (name[1] == wep_class) then
				toReturn = name[2];
			end;
		end;
	end;

	return toReturn;
end;

if SERVER then
	local meta = FindMetaTable( "Player" );
	function meta:UnlockWeaponry()
		self.zm.CanTakeWeapon = true;
		self.zm.wepPrimary = false;
		self.zm.wepSecondary = false;
		self:SetNWBool("zm:canWeapon", true);
	end;

	function zm.weapon:OpenWeaponMenu(ply)
		if (!IsValid(ply) or !ply:IsPlayer() or !ply:Alive()) then return; end;
		ply:UnlockWeaponry();
		netstream.Start(ply, "zm:OpenWeaponMenu");
	end;

	netstream.Hook("zm:weapon:chooseprimary", function(ply, weapon)
		if (ply:Team() == TEAM_ZOMBIE) then ply.zm.CanTakeWeapon = false; ply:SetNWBool("zm:canWeapon", false); return; end;
		if (!ply.zm.CanTakeWeapon or ply.zm.wepPrimary) then return; end;
		if (!zm:GetWeapon(weapon)) then return; end;
		ply.zm.wepPrimary = true;
		ply:Give(weapon);
	end);

	netstream.Hook("zm:weapon:choosesecondary", function(ply, weapon)
		if (ply:Team() == TEAM_ZOMBIE) then ply.zm.CanTakeWeapon = false; ply:SetNWBool("zm:canWeapon", false); return; end;
		if (!ply.zm.CanTakeWeapon or ply.zm.wepSecondary) then return; end;
		if (!zm:GetWeapon(weapon)) then return; end;
		ply.zm.wepSecondary = true;
		ply.zm.CanTakeWeapon = false;

		ply:Give(weapon);
		ply:SetNWBool("zm:canWeapon", false);
	end);

else
	function zm.weapon:OpenSecondary()
		local weaponMenu = lsg_menu:CreateMenu()
		:SetExitButton(false)
		:SetHeader("%brown%Zombie Plague %twhite%"..zm.language:get("#MenuWeapon"))
		:SetSubHeader("#MenuWeaponSub%brown% [%twhite%#MenuWeaponSecond%brown%]");

		for k,v in pairs(zm.cfg.weaponry.secondary) do
			weaponMenu:AddButton(v[2])
			:SetCallback(function()
				netstream.Start("zm:weapon:choosesecondary", v[1]);
				lsg_menu:Close();
			end);
		end;
	end;

	function zm.weapon:OpenWeaponMenu()
		local weaponMenu = lsg_menu:CreateMenu()
		:SetExitButton(false)
		:SetHeader("%brown%Zombie Plague %twhite%"..zm.language:get("#MenuWeapon"))
		:SetSubHeader("#MenuWeaponSub%brown% [%twhite%#MenuWeaponFirst%brown%]");

		for k,v in pairs(zm.cfg.weaponry.primary) do
			weaponMenu:AddButton(v[2])
			:SetCallback(function()
				netstream.Start("zm:weapon:chooseprimary", v[1]);
				lsg_menu:Close();
				zm.weapon:OpenSecondary();
			end);
		end;
	end;

	netstream.Hook("zm:OpenWeaponMenu", function()
		zm.weapon:OpenWeaponMenu();
	end);
end