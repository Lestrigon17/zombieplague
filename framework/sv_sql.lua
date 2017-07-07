local zm = zm or {};
zm.sql = zm.sql or {};


function zm.sql:CheckDataTable()
	if (!sql.TableExists("zp_data")) then
		sql.Query("CREATE TABLE zp_data (key TEXT, value LONGTEXT)");
		zm:ConsoleLog("Database `zp_data` are created");
	end;
end;

function zm.sql:SetData(key, value)
	zm.sql:CheckDataTable();

	if (!zm.sql:GetData(key)) then
		sql.Query([[INSERT INTO zp_data (`key`, `value`) VALUES ("]]..key..[[", "]]..value..[[");]]);
	else
		sql.Query([[UPDATE zp_data SET `value` = "]]..value..[[" WHERE `key` = "]]..key..[[";]]);
	end;
end;

function zm.sql:GetData(key, defValue)
	zm.sql:CheckDataTable();
	local query = sql.Query([[SELECT * FROM zp_data WHERE `key` = "]]..key..[[";]]);

	if (!query) then
		return defValue;
	else
		return query[1]["value"];
	end
end; 

zm.sql:CheckDataTable();
zm:ConsoleLog("SqlLite Core are loaded");