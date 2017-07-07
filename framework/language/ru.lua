local lang = {};

lang["test"] = "test phrase";

lang["#human"] = "Люди";
lang["#zombie"] = "Зомби";
lang["#ammo"] = "Аммо";

--[[-------------------------------------------------------------------------
Weapon
---------------------------------------------------------------------------]]
lang["#WeaponPistol"] = "Пистолет";
lang["#WeaponSMG"] = "Полуавтомат";
lang["#WeaponShotgun"] = "Дробовик";
lang["#WeaponRifle"] = "Автомат";
lang["#WeaponRPM"] = "Пулемет";

--[[-------------------------------------------------------------------------
HUD
---------------------------------------------------------------------------]]
lang["#HUDClass"] = "Тип";
lang["#HUDHealth"] = "Жизни";
lang["#HUDArmor"] = "Броня";
lang["#HUDHumans"] = "Люди";
lang["#HUDZombie"] = "Зомби";
lang["#HUDRouns"] = "Раунд";
lang["#HUDTimer"] = "Внимание! Заражение через";
lang["#HUDWins"] = "Победы";

--[[-------------------------------------------------------------------------
MENU
---------------------------------------------------------------------------]]
lang["#Exit"] = "Выход";
lang["#Prev"] = "Предыдущая";
lang["#Next"] = "Следующая";

lang["#MenuHeader"] = "Главное меню";
lang["#MenuBuyHeader"] = "Магазин предметов";
lang["#MenuRank"] = "Ваш статус ";
lang["#MenuPage"] = "Страница";

lang["#MenuButtonWeapon"] = "Выбрать оружие";
lang["#MenuButtonShop"] = "Экстра предметы";
lang["#MenuButtonClass"] = "Выбрать класс зомби";
lang["#MenuButtonVip"] = "Способности";
lang["#MenuButtonAdmin"] = "*** Админ меню ***"; 
lang["#MenuButtonRespawn"] = "Возрадиться"; 
lang["#MenuButtonLaws"] = "Правила"; 

lang["#MenuWeapon"] = "Арсенал";
lang["#MenuWeaponSub"] = "Выберите оружие для игры";
lang["#MenuWeaponFirst"] = "Дополнительное";
lang["#MenuWeaponSecond"] = "Основное";
--[[-------------------------------------------------------------------------
ROUND
---------------------------------------------------------------------------]]
lang.round = {}
lang.round.round 		= "Раунд";
lang.round.new 			= "Инициализация.";
lang.round.start 		= "Раунд начался! Выживи, убей или УМРИ.";
lang.round.startH   	= "Ожидание игроков...";
lang.round.startF 		= "Свободный раунд.";
lang.round.out 			= "Раунд окончен, встретимся в следущий раз...";
lang.round.begin 		= "Идет подготовка, будтье на чеку!";
lang.round.remaning 	= "Раунд %a из %b!";
lang.round.outtime  	= "Раунд завершен, время вышло!";
lang.round.time			= "Времени осталось";
lang.round.endr 		= "КОНЕЦ";
lang.round.none 		= "Никто не выиграл";

lang.round.ErrorTimerInitialize = "Ошибка в инициализации таймера подготовки раунда!";


/*---------------------------------------------------------------------------
Register language
---------------------------------------------------------------------------*/
zm.language:RegisterLanguage("ru", "lestrigon17", lang);