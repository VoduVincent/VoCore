--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

CAMPAIGN_CURRENCY_LIST = "currencies";
CAMPAIGN_CURRENCY_LIST_NAME = "name";

aCampaignCurrencies = {};
aCampaignCurrenciesUpper = {};

function onInit()
	if Session.IsHost then
		if DB.getChildCount(CAMPAIGN_CURRENCY_LIST) == 0 then
			bNewCampaign = true;
		end
		DB.createNode(CAMPAIGN_CURRENCY_LIST).setPublic(true);

		Interface.onDesktopInit = onDesktopInit;
	end
end

function onDesktopInit()
	if bNewCampaign and GameSystem.currencies then
		for _,vCurrency in ipairs(GameSystem.currencies) do
			local nodeCurrency = DB.createChild(CAMPAIGN_CURRENCY_LIST);
			DB.setValue(nodeCurrency, CAMPAIGN_CURRENCY_LIST_NAME, "string", vCurrency);
		end
	end
	
	CurrencyManager.addCampaignCurrencyHandlers();
end

function addCampaignCurrencyHandlers()
	CurrencyManager.refreshCampaignCurrencies();
	DB.addHandler(CAMPAIGN_CURRENCY_LIST, "onChildDeleted", refreshCampaignCurrencies);
	DB.addHandler(CAMPAIGN_CURRENCY_LIST .. ".*." .. CAMPAIGN_CURRENCY_LIST_NAME, "onUpdate", refreshCampaignCurrencies);
end

function refreshCampaignCurrencies()
	-- Rebuild the campaign currency dictionary for fast lookup
	aCampaignCurrencies = {};
	aCampaignCurrenciesUpper = {};
	for _,v in pairs(UtilityManager.getSortedTable(DB.getChildren(CAMPAIGN_CURRENCY_LIST))) do
		local sName = DB.getValue(v, CAMPAIGN_CURRENCY_LIST_NAME, "")
		sName = StringManager.trim(sName)
		if (sName or "") ~= "" then
			table.insert(aCampaignCurrencies, sName);
			table.insert(aCampaignCurrenciesUpper, sName:upper());
		end
	end
end

function getCurrencies()
	return aCampaignCurrencies;
end

function getCurrencyMatch(s)
	local sUpper = StringManager.trim(s):upper();
	for kCurrency,sCurrencyUpper in ipairs(aCampaignCurrenciesUpper) do
		if sUpper == sCurrencyUpper then
			return aCampaignCurrencies[kCurrency];
		end
	end
	return nil;
end
