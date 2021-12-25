-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	Desktop.registerPublicNodes();
	
	Interface.onDesktopInit = onDesktopInit;
	User.onLogin = onUserLogin;
end

function onDesktopInit()
	if not Session.IsHost then
		Interface.openWindow("charselect_client", "");
	end
	
	Desktop.registerModuleSets();
	if not CampaignRegistry or not CampaignRegistry.setup then
		Interface.openWindow("setup", "");
	end
end

function onUserLogin(sUser, bActivated)
	if bActivated then
		local sMOTD = StringManager.trim(DB.getText("motd.text", ""));
		if sMOTD ~= "" then
			local bAlreadyOpen = true;
			local w = Interface.findWindow("motd", "motd");
			if not w then
				bAlreadyOpen = false;
				w = Interface.openWindow("motd", "motd");
			end
			if w then
				w.share(sUser);
			end
			if not bAlreadyOpen then
				w.close();
			end
		end
	end
end

function registerPublicNodes()
	if Session.IsHost then
		DB.createNode("motd").setPublic(true);
		DB.createNode("options").setPublic(true);
		DB.createNode("partysheet").setPublic(true);
		DB.createNode("calendar").setPublic(true);
		DB.createNode("combattracker").setPublic(true);
		DB.createNode("modifiers").setPublic(true);
		DB.createNode("effects").setPublic(true);
	end
end

function addDataModuleSet(sMode, vDataModuleSet)
	if not aDataModuleSet[sMode] then
		return;
	end
	table.insert(aDataModuleSet[sMode], vDataModuleSet);
end

function addTokenPackSet(sMode, vTokenModuleSet)
	Debug.console("Desktop.addTokenPackSet - DEPRECATED - 2021-10-15");
end

function registerModuleSets()
	if Session.IsHost then
		DesktopManager.addDataModuleSets(aDataModuleSet["host"]);
	else
		DesktopManager.addDataModuleSets(aDataModuleSet["client"]);
	end
end

aCoreDesktopStack = 
{
	["host"] =
	{
		{
			icon="button_ct",
			icon_down="button_ct_down",
			tooltipres="sidebar_tooltip_ct",
			class="combattracker_host",
			path="combattracker",
		},
		{
			icon="button_partysheet",
			icon_down="button_partysheet_down",
			tooltipres="sidebar_tooltip_ps",
			class="partysheet_host",
			path="partysheet",
		},
		{
			icon="button_calendar",
			icon_down="button_calendar_down",
			tooltipres="sidebar_tooltip_calendar",
			class="calendar",
			path="calendar",
		},
		{
			icon="button_color",
			icon_down="button_color_down",
			tooltipres="sidebar_tooltip_colors",
			class="pointerselection",
		},
		{
			icon="button_modifiers",
			icon_down="button_modifiers_down",
			tooltipres="sidebar_tooltip_modifiers",
			class="modifiers",
			path="modifiers",
		},
		{
			icon="button_effects",
			icon_down="button_effects_down",
			tooltipres="sidebar_tooltip_effects",
			class="effectlist",
			path="effects",
		},
		{
			icon="button_options",
			icon_down="button_options_down",
			tooltipres="sidebar_tooltip_options",
			class="options",
		},
	},
	["client"] =
	{
		{
			icon="button_ct",
			icon_down="button_ct_down",
			tooltipres="sidebar_tooltip_ct",
			class="combattracker_client",
			path="combattracker",
		},
		{
			icon="button_partysheet",
			icon_down="button_partysheet_down",
			tooltipres="sidebar_tooltip_ps",
			class="partysheet_client",
			path="partysheet",
		},
		{
			icon="button_calendar",
			icon_down="button_calendar_down",
			tooltipres="sidebar_tooltip_calendar",
			class="calendar",
			path="calendar",
		},
		{
			icon="button_color",
			icon_down="button_color_down",
			tooltipres="sidebar_tooltip_colors",
			class="pointerselection",
		},
		{
			icon="button_modifiers",
			icon_down="button_modifiers_down",
			tooltipres="sidebar_tooltip_modifiers",
			class="modifiers",
			path="modifiers",
		},
		{
			icon="button_effects",
			icon_down="button_effects_down",
			tooltipres="sidebar_tooltip_effects",
			class="effectlist",
			path="effects",
		},
		{
			icon="button_options",
			icon_down="button_options_down",
			tooltipres="sidebar_tooltip_options",
			class="options",
		},
	},
};

aCoreDesktopDockV4 = 
{
	["live"] =
	{
		{
			icon="button_assets",
			icon_down="button_assets_down",
			tooltipres="sidebar_tooltip_assets",
			class="tokenbag",
			subdock = true,
		},
		{
			icon="button_library",
			icon_down="button_library_down",
			tooltipres="sidebar_tooltip_library",
			class="library",
			subdock = true,
		},
	},
};

aDataModuleSet = 
{
	["host"] =
	{
	},
	["client"] =
	{
	},
};
