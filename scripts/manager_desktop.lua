-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local _bInitialized = false;
local _wShortcuts;

local _rcStackOffset = { left = 5, top = 5, right = 5, bottom = 0 };

local _szStackButton = { w = 50, h = 30 };
local _rcStackButtonOffset = { left = 0, top = 0, right = 0, bottom = 0 };

local _rcDockOffset = { left = 5, top = 5, right = 5, bottom = 0 };

local _szDockCategory = { w = 150, h = 40 };
local _rcDockCategoryOffset = { left = 0, top = 0, right = 0, bottom = 0 };
local _szDockCategoryPadding = { w = 10, h = 10 };
local _nDockCategoryTextOffset = 5;

local _szDockButton = { w = 150, h = 40 };
local _rcDockButtonOffset = { left = 0, top = 0, right = 0, bottom = 0 };
local _szDockButtonIconPadding = { w = 5, h = 5 };
local _szDockButtonTextPadding = { w = 10, h = 10 };

local _cDockCategoryIconColor = "A3A29D";
local _cDockCategoryTextColor = "A3A29D";
local _cDockIconColor = "272727";
local _cDockTextColor = "272727";

local _tSidebarCategories = {};
local _tSidebarCategoriesExpanded = {};
local _tDefaultRecordTypeCategories = {
	["charsheet"] = "player",
	["charstarshipsheet"] = "player",
	["charship"] = "player",
	["note"] = "player",
	["advantages"] = "create",
	["archetype"] = "create",
	["archetypes"] = "create",
	["background"] = "create",
	["career"] = "create",
	["clan"] = "create",
	["class"] = "create",
	["discipline"] = "create",
	["enchantment"] = "create",
	["edge"] = "create",
	["exploit"] = "create",
	["extrasflaw"] = "create",
	["feat"] = "create",
	["hindrance"] = "create",
	["homeworld"] = "create",
	["lookupdata"] = "create",
	["merit"] = "create",
	["occupation"] = "create",
	["occupations"] = "create",
	["power"] = "create",
	["powers"] = "create",
	["powereffects"] = "create",
	["predator"] = "create",
	["profession"] = "create",
	["psionic"] = "create",
	["race"] = "create",
	["skill"] = "create",
	["skillgroup"] = "create",
	["skills"] = "create",
	["specialability"] = "create",
	["spell"] = "create",
	["spells"] = "create",
	["talent"] = "create",
	["talents"] = "create",
	["theme"] = "create",
	["trait"] = "create",
};

--
--	Initialization and Clean Up
--

function onInit()
	Interface.onDesktopInit = onDesktopInit;
	Interface.onDesktopClose = onDesktopClose;
end

function onDesktopInit()
	LibraryData.initialize();
	DesktopManager.initializeSidebar();
end

function onDesktopClose()
	DesktopManager.saveSidebarCategoryState();
end

--
--	Sidebar theming
--

function setSidebarStackOffset(l, t, r, b)
	_rcStackOffset.left = l;
	_rcStackOffset.top = t;
	_rcStackOffset.right = r;
	_rcStackOffset.bottom = b;
end

function getSidebarStackButtonSize()
	return _szStackButton;
end
function getSidebarStackButtonOffset()
	return _rcStackButtonOffset;
end
function setSidebarStackButtonSize(w, h)
	_szStackButton.w = w;
	_szStackButton.h = h;
end
function setSidebarStackButtonOffset(l, t, r, b)
	_rcStackButtonOffset.left = l;
	_rcStackButtonOffset.top = t;
	_rcStackButtonOffset.right = r;
	_rcStackButtonOffset.bottom = b;
end

function getSidebarDockWidth()
	local nDockCategoryWidth = _szDockCategory.w + (_rcDockCategoryOffset.left + _rcDockCategoryOffset.right);
	local nDockButtonWidth = _szDockButton.w + (_rcDockButtonOffset.left + _rcDockButtonOffset.right);
	return math.max(nDockCategoryWidth, nDockButtonWidth) + (_rcDockOffset.left + _rcDockOffset.right); 
end
function setSidebarDockOffset(l, t, r, b)
	_rcDockOffset.left = l;
	_rcDockOffset.top = t;
	_rcDockOffset.right = r;
	_rcDockOffset.bottom = b;
end

function getSidebarDockCategorySize()
	return _szDockCategory;
end
function getSidebarDockCategoryOffset()
	return _rcDockCategoryOffset;
end
function getSidebarDockCategoryPadding()
	return _szDockCategoryPadding;
end
function getSidebarDockCategoryTextOffset()
	return _nDockCategoryTextOffset;
end
function setSidebarDockCategorySize(w, h)
	_szDockCategory.w = w;
	_szDockCategory.h = h;
end
function setSidebarDockCategoryOffset(l, t, r, b)
	_rcDockCategoryOffset.left = l;
	_rcDockCategoryOffset.top = t;
	_rcDockCategoryOffset.right = r;
	_rcDockCategoryOffset.bottom = b;
end
function setSidebarDockCategoryPadding(w, h)
	_szDockCategoryPadding.w = w;
	_szDockCategoryPadding.h = h;
end
function setSidebarDockCategoryTextOffset(n)
	_nDockCategoryTextOffset = n;
end

function getSidebarDockButtonSize()
	return _szDockButton;
end
function getSidebarDockButtonOffset()
	return _rcDockButtonOffset;
end
function getSidebarDockButtonIconPadding()
	return _szDockButtonIconPadding;
end
function getSidebarDockButtonTextPadding()
	return _szDockButtonTextPadding;
end
function setSidebarDockButtonSize(w, h)
	_szDockButton.w = w;
	_szDockButton.h = h;
end
function setSidebarDockButtonOffset(l, t, r, b)
	_rcDockButtonOffset.left = l;
	_rcDockButtonOffset.top = t;
	_rcDockButtonOffset.right = r;
	_rcDockButtonOffset.bottom = b;
end
function setSidebarDockButtonIconPadding(w, h)
	_szDockButtonIconPadding.w = w;
	_szDockButtonIconPadding.h = h;
end
function setSidebarDockButtonTextPadding(w, h)
	_szDockButtonTextPadding.w = w;
	_szDockButtonTextPadding.h = h;
end

function getSidebarDockCategoryIconColor()
	return _cDockCategoryIconColor;
end
function getSidebarDockCategoryTextColor()
	return _cDockCategoryTextColor;
end
function getSidebarDockIconColor()
	return _cDockIconColor;
end
function getSidebarDockTextColor()
	return _cDockTextColor;
end
function setSidebarDockCategoryIconColor(s)
	_cDockCategoryIconColor = s;
end
function setSidebarDockCategoryTextColor(s)
	_cDockCategoryTextColor = s;
end
function setSidebarDockIconColor(s)
	_cDockIconColor = s;
end
function setSidebarDockTextColor(s)
	_cDockTextColor = s;
end

--
--	Sidebar Initialization
--

function initializeSidebar()
	-- Set up references and theming
	_wShortcuts = Interface.findWindow("shortcuts", "");
	_wShortcuts.onSizeChanged = DesktopManager.onSidebarSizeChanged;
	
	-- Build sidebar
	DesktopManager.loadSidebarCategoryState();
    DesktopManager.configureSidebarTheming();
	DesktopManager.rebuildSidebar();

	_bInitialized = true;
end

function onSidebarSizeChanged()
	local wAnchor = Interface.findWindow("shortcutsanchor", "");
	wAnchor.setPosition(-DesktopManager.getSidebarDockWidth(), 0, true);
end

function configureSidebarTheming()
	-- Apply sidebar size
	local sidebarWidth = DesktopManager.getSidebarDockWidth();
	_wShortcuts.shortcutbar.setAnchoredWidth(sidebarWidth);
	local wAnchor = Interface.findWindow("shortcutsanchor", "");
	wAnchor.setPosition(-sidebarWidth, 0, true);

	-- Configure theming support
	_wShortcuts.shortcutbar.subwindow.list_stack.setAnchor("top", "anchor", "bottom", "relative", _rcStackOffset.top);
	_wShortcuts.shortcutbar.subwindow.list_stack.setAnchor("left", "", "left", "absolute", _rcStackOffset.left);
	_wShortcuts.shortcutbar.subwindow.list_stack.setAnchoredWidth(sidebarWidth - (_rcStackOffset.left + _rcStackOffset.right));
	_wShortcuts.shortcutbar.subwindow.list_stack.setColumnWidth(_szStackButton.w + (_rcStackButtonOffset.left + _rcStackButtonOffset.right));

	_wShortcuts.shortcutbar.subwindow.list_dock.setAnchor("top", "anchor", "bottom", "relative", _rcStackOffset.bottom + _rcDockOffset.top);
	_wShortcuts.shortcutbar.subwindow.list_dock.setAnchor("left", "", "left", "absolute", _rcDockOffset.left);
	_wShortcuts.shortcutbar.subwindow.list_dock.setAnchor("bottom", "", "bottom", "absolute", -_rcDockOffset.bottom);
	_wShortcuts.shortcutbar.subwindow.list_dock.setAnchoredWidth(sidebarWidth - (_rcDockOffset.left + _rcDockOffset.right));

	local scrollbarAnchorOffset = math.min(0, -(20 - _rcDockOffset.right));
	_wShortcuts.shortcutbar.subwindow.scrollbar_list_dock.setAnchor("left", "list_dock", "right", "absolute", scrollbarAnchorOffset);
end

function rebuildSidebar()
	-- Clear any previous windows
	_wShortcuts.shortcutbar.subwindow.list_stack.closeAll();
	_wShortcuts.shortcutbar.subwindow.list_dock.closeAll();

    -- Build stack button list
    local tStackButtons = {};

    local tStack;
    if Session.IsHost then
    	tStack = Desktop.aCoreDesktopStack["host"];
    else
    	tStack = Desktop.aCoreDesktopStack["client"];
    end
    for i,vButton in ipairs(tStack) do
    	table.insert(tStackButtons, { sLabelRes = vButton.tooltipres, sClass = vButton.class, sPath = vButton.path, sIcon = vButton.icon, sIconPressed = vButton.icon_down });
    end

    -- Add stack buttons
    for _,vButton in ipairs(tStackButtons) do
		local w = _wShortcuts.shortcutbar.subwindow.list_stack.createWindow();
		w.setData(vButton);
    end

    -- Build dock button list
    local tDockButtons = {};

	local sLibraryCategory = DesktopManager.getSidebarLibraryCategory();
    for _,vButton in ipairs(Desktop.aCoreDesktopDockV4["live"]) do
    	table.insert(tDockButtons, { sCategory = sLibraryCategory, sLabelRes = vButton.tooltipres, sClass = vButton.class, sPath = vButton.path });
    end

    local aRecords = LibraryData.getRecordTypes();
    for _,sRecordType in pairs(aRecords) do
        local tRecordTypeInfo = LibraryData.getRecordTypeInfo(sRecordType);
        if not tRecordTypeInfo.bHidden then
	        local sRecordCategory = tRecordTypeInfo.sSidebarCategory or DesktopManager.getSidebarDefaultCategoryByRecordType(sRecordType);
	        table.insert(tDockButtons, { sCategory = sRecordCategory, sRecordType = sRecordType });
	    end
    end

    -- Build dock category list
    _tSidebarCategories = DesktopManager.getSidebarDefaultCategories();
    local tButtonsByCategory = { };

	for _,vButton in ipairs(tDockButtons) do
		if not StringManager.contains(_tSidebarCategories, vButton.sCategory) then
			table.insert(_tSidebarCategories, vButton.sCategory);
		end
		if not tButtonsByCategory[vButton.sCategory] then
			tButtonsByCategory[vButton.sCategory] = {};
		end
		table.insert(tButtonsByCategory[vButton.sCategory], vButton);
	end

	-- Add dock buttons
	for _,sCategory in ipairs(_tSidebarCategories) do
		local w = _wShortcuts.shortcutbar.subwindow.list_dock.createWindowWithClass("sidebar_dock_category");
		w.setCategory(sCategory);

		table.sort(tButtonsByCategory[sCategory], sortSidebarAlphaWithinCategory);
		for _,vButton in ipairs(tButtonsByCategory[sCategory]) do
			local w = _wShortcuts.shortcutbar.subwindow.list_dock.createWindow();
			w.setData(vButton);
		end
	end
end

function sortSidebarAlphaWithinCategory(a,b)
	local sLabelA;
	if a.sRecordType then
		sLabelA = LibraryData.getDisplayText(a.sRecordType);
	elseif a.sLabelRes then
		sLabelA = Interface.getString(a.sLabelRes);
	else
		sLabelA = "";
	end

	local sLabelB;
	if b.sRecordType then
		sLabelB = LibraryData.getDisplayText(b.sRecordType);
	elseif b.sLabelRes then
		sLabelB = Interface.getString(b.sLabelRes);
	else
		sLabelB = "";
	end

	return sLabelA < sLabelB;
end

--
--  One-Off Stack and Dock Registration
--

function registerSidebarStackButton(tButton, bFront)
    local tStack;
    if Session.IsHost then
    	tStack = Desktop.aCoreDesktopStack["host"];
    else
    	tStack = Desktop.aCoreDesktopStack["client"];
    end
    if bFront then
	    table.insert(tStack, 1, tButton);
	else
	    table.insert(tStack, tButton);
	end

	if _bInitialized then
		DesktopManager.rebuildSidebar();
	end
end

--
--	Sidebar Categories
--

function getSidebarDefaultCategory()
	return "campaign";
end
function getSidebarDefaultCategoryByRecordType(sRecordType)
	if _tDefaultRecordTypeCategories[sRecordType] then
		return _tDefaultRecordTypeCategories[sRecordType];
	end
	return DesktopManager.getSidebarDefaultCategory();
end
function getSidebarDefaultCategories()
	return { "library", "player", "campaign" };
end
function getSidebarLibraryCategory()
	return "library";
end

--
--	Sidebar Collapse/Expand
--

function loadSidebarCategoryState()
    if type(CampaignRegistry.sidebarexpand) ~= "table" or #CampaignRegistry.sidebarexpand == 0 then
		CampaignRegistry.sidebarexpand = nil;
	end
	_tSidebarCategoriesExpanded = {};
	if CampaignRegistry.sidebarexpand then
		for _,v in ipairs(CampaignRegistry.sidebarexpand) do
			table.insert(_tSidebarCategoriesExpanded, v);
		end
	end
	for _,w in ipairs(_wShortcuts.shortcutbar.subwindow.list_dock.getWindows()) do
		if w.updateStateIcon then
			w.updateStateIcon();
		end
	end
	_wShortcuts.shortcutbar.subwindow.list_dock.applyFilter();
end
function saveSidebarCategoryState()
	CampaignRegistry.sidebarexpand = {};
	for _,v in ipairs(_tSidebarCategoriesExpanded) do
		if StringManager.contains(_tSidebarCategories, v) then
			table.insert(CampaignRegistry.sidebarexpand, v);
		end
	end
end
function getSidebarCategoryState(sCategory)
	return StringManager.contains(_tSidebarCategoriesExpanded, sCategory);
end
function toggleSidebarCategoryState(sCategory)
	for k,v in ipairs(_tSidebarCategoriesExpanded) do
		if v == sCategory then
			table.remove(_tSidebarCategoriesExpanded, k);
			_wShortcuts.shortcutbar.subwindow.list_dock.applyFilter();
			return;
		end
	end
	table.insert(_tSidebarCategoriesExpanded, sCategory);
	_wShortcuts.shortcutbar.subwindow.list_dock.applyFilter();
end

--
--	Sidebar Actions
--

function toggleIndex(sRecordType)
	local sClass, sRecord = DesktopManager.getListLink(sRecordType);
	if not sClass then 
		return; 
	end
	Interface.toggleWindow(sClass, sRecord);
end

function getListLink(sRecordType)
	local rRecordType = LibraryData.getRecordTypeInfo(sRecordType);
	if not rRecordType then
		return;
	end
	
	if rRecordType.fGetLink then
		return rRecordType.fGetLink();
	end

	local sDisplayIndex = "masterindex";
	if rRecordType.sDisplayIndex then
		sDisplayIndex = rRecordType.sDisplayIndex;
	end
	
	local aMappings = LibraryData.getMappings(sRecordType);
	return sDisplayIndex, aMappings[1];
end

--
--  Data Module Sets for Campaign Setup
--

local _tDataModuleSets = {};

function addDataModuleSets(aDataModulesSetsValue)
	if not aDataModulesSetsValue then
		return;
	end
	for _,v in ipairs(aDataModulesSetsValue) do
		DesktopManager.addDataModuleSet(v.name, v.modules);
	end
end

function addDataModuleSet(sDataModuleSetNameValue, aDataModulesValue)
	table.insert(_tDataModuleSets, { sName=sDataModuleSetNameValue, aModules=aDataModulesValue });
end

function getDataModuleSets()
	return _tDataModuleSets;
end

--
--	DEPRECATED
--

function registerContainerWindow(w)
	Debug.console("DesktopManager.registerContainerWindow - DEPRECATED - 2021-10-15");
end
function processSidebar(sCommand, sParams)
	Debug.console("DesktopManager.processSidebar - DEPRECATED - 2021-10-15");
end
function resetSidebar(sMode)
	Debug.console("DesktopManager.resetSidebar - DEPRECATED - 2021-10-15");
end
function onSidebarOptionChanged(sRecordType, nValue)
	Debug.console("DesktopManager.onSidebarOptionChanged - DEPRECATED - 2021-10-15");
end

function setStackOffset(l, t, r, b)
	Debug.console("DesktopManager.setStackOffset - DEPRECATED - 2021-10-15 - Use DesktopManager.setSidebarStackOffset(l, t, r, b) instead.");
end
function setUpperDockOffset(l, t, r, b)
	Debug.console("DesktopManager.setUpperDockOffset - DEPRECATED - 2021-10-15 - Use DesktopManager.setSidebarDockOffset(l, t, r, b) instead.");
end
function setLowerDockOffset(l, t, r, b)
	Debug.console("DesktopManager.setLowerDockOffset - DEPRECATED - 2021-10-15");
end
function setStackIconSizeAndSpacing(iw, ih, sw, sh)
	Debug.console("DesktopManager.setStackIconSizeAndSpacing - DEPRECATED - 2021-10-15 - Use DesktopManager.setSidebarStackButtonSize(w, h) and DesktopManager.setSidebarStackButtonOffset(l, t, r, b) instead.");
end
function setDockButtonSizeAndPadding(iw, ih, sh)
	Debug.console("DesktopManager.setDockButtonSizeAndPadding - DEPRECATED - 2021-10-15 - Use DesktopManager.setSidebarDockButtonSize(w, h) and DesktopManager.setSidebarDockButtonOffset(l, t, r, b) instead.");
end

function updateControls()
	Debug.console("DesktopManager.updateControls - DEPRECATED - 2021-10-15");
end
function calcAreas(szWindow)
	Debug.console("DesktopManager.calcAreas - DEPRECATED - 2021-10-15");
end
function calcSectionHeight(aControls, nCols, szIcon, szSpacing)
	Debug.console("DesktopManager.calcSectionHeight - DEPRECATED - 2021-10-15");
end
function layoutArea(aControls, rcOffset, szIcon, rcFrameOffset, szSpacing, nCols, szArea, szBar)
	Debug.console("DesktopManager.layoutArea - DEPRECATED - 2021-10-15");
end
function layoutControl(c, szPlacement, szIcon, rcFrameOffset)
	Debug.console("DesktopManager.layoutControl - DEPRECATED - 2021-10-15");
end

function registerStackShortcuts(aShortcuts)
	Debug.console("DesktopManager.registerStackShortcuts - DEPRECATED - 2021-10-15 - Use DesktopManager.registerSidebarStackButton(tButton, bFront) instead.");
end
function registerStackShortcut(iconNormal, iconPressed, tooltipText, className, recordName)
	Debug.console("DesktopManager.registerStackShort - DEPRECATED - 2021-10-15 - Use DesktopManager.registerSidebarStackButton(tButton, bFront) instead.");
end
function registerStackShortcut2(iconNormal, iconPressed, sTooltipRes, className, recordName, bFront)
	Debug.console("DesktopManager.registerContainerWindow - DEPRECATED - 2021-10-15 - Use DesktopManager.registerSidebarStackButton(tButton, bFront) instead.");

    local tButton = { icon = iconNormal, iconPressed = iconPressed, tooltipres = sTooltipRes, class = className, path = recordName };
    DesktopManager.registerSidebarStackButton(tButton, bFront);
end
function createStackShortcut(iconNormal, iconPressed, tooltipText, className, recordName, bFront)
	Debug.console("DesktopManager.createStackShortcut - DEPRECATED - 2021-10-15");
end
function removeStackShortcut(recordName)
	Debug.console("DesktopManager.removeStackShortcut - DEPRECATED - 2021-10-15");
end

function registerDockShortcuts(aShortcuts)
	Debug.console("DesktopManager.registerDockShortcuts - DEPRECATED - 2021-10-15");
end
function registerDockShortcut(iconNormal, iconPressed, tooltipText, className, recordName, useSubdock)
	Debug.console("DesktopManager.registerDockShortcut - DEPRECATED - 2021-10-15");
end
function registerDockShortcut2(iconNormal, iconPressed, sTooltipRes, className, recordName, useSubdock, bFront)
	Debug.console("DesktopManager.registerDockShortcut2 - DEPRECATED - 2021-10-15");
end
function addDockRecordShortcut(sRecordType)
	Debug.console("DesktopManager.addDockRecordShortcut - DEPRECATED - 2021-10-15");
end
function createDockShortcut(iconNormal, iconPressed, tooltipText, className, recordName, useSubdock, bFront)
	Debug.console("DesktopManager.createDockShortcut - DEPRECATED - 2021-10-15");
end
function removeDockShortcut(recordName, useSubdock)
	Debug.console("DesktopManager.removeDockShortcut - DEPRECATED - 2021-10-15");
end

function addLibraryDockShortcut(sRecordType)
	Debug.console("DesktopManager.addLibraryDockShortcut - DEPRECATED - 2021-10-15");
end
function createLibraryDockShortcut(sRecordType)
	Debug.console("DesktopManager.createLibraryDockShortcut - DEPRECATED - 2021-10-15");
end
function removeLibraryDockShortcut(sRecordType)
	Debug.console("DesktopManager.removeLibraryDockShortcut - DEPRECATED - 2021-10-15");
end

function getSidebarButtonState(sRecordType)
	Debug.console("DesktopManager.getSidebarButtonState - DEPRECATED - 2021-10-15");
end
function setSidebarButtonState(sRecordType, bState)
	Debug.console("DesktopManager.setSidebarButtonState - DEPRECATED - 2021-10-15");
end
function setDefaultSidebarState(sMode, sNewDefaultState)
	Debug.console("DesktopManager.setDefaultSidebarState - DEPRECATED - 2021-10-15");
end
function appendDefaultSidebarState(sMode, sAppend)
	Debug.console("DesktopManager.appendDefaultSidebarState - DEPRECATED - 2021-10-15");
end

function addTokenPackSets(aTokenPacksSetsValue)
	Debug.console("DesktopManager.addTokenPackSets - DEPRECATED - 2021-10-15");
end
function addTokenPackSet(sTokenPackSetNameValue, aTokenPacksValue)
	Debug.console("DesktopManager.addTokenPackSet - DEPRECATED - 2021-10-15");
end
