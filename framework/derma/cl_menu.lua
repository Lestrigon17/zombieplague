local function CreateMenu()
	local test_menu = lsg_menu:CreateMenu()
	:SetHeader("%brown%Zombie Plague %twhite%"..zm.language:get("#MenuHeader"))
	--:ReplaceExitButton("Пососать хуй", function() lsg_menu:Close() end)
	--:SetSubHeader(zm.language:get("#MenuRank").."%firebrick%[%sienna%"..LocalPlayer():GetUserGroup().."%firebrick%]");

	local weaponButton = test_menu:AddButton("#MenuButtonWeapon")
	:SetCallback(function()
		zm.weapon:OpenWeaponMenu();
	end);
	if (!LocalPlayer():GetNWBool("zm:canWeapon", true)) then weaponButton:SetDisabled(true); end;

	test_menu:AddButton("#MenuButtonShop");
	test_menu:AddButton("#MenuButtonClass");
	test_menu:AddButton("#MenuButtonVip% %twhite%[%brown%VIP/ADMIN%twhite%]");
	test_menu:AddButton("#MenuButtonRespawn")
	test_menu:AddButton("#MenuButtonLaws"):AddBorder(3);

	// VIP\ADMIN MENU
	test_menu:AddButton("#MenuButtonAdmin");
end;

--[[-------------------------------------------------------------------------
Menu open
---------------------------------------------------------------------------]]
hook.Remove("Think", "zp_menu")
hook.Add("lsg:ButtonPress", "zp_menu", function(btn)
	if (!lsg_menu.active and btn == KEY_M and !gui.IsGameUIVisible() and !gui.IsConsoleVisible()) then
		CreateMenu();
	end;
end);