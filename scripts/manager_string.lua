-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

-----------------------
--  EXISTENCE FUNCTIONS
-----------------------

function startsWith(s, sCheck)
	if not s then
		return false;
	end
	return (s:sub(1,#sCheck) == sCheck);
end

function isWord(sWord, vTarget)
	if not sWord then
		return false;
	end
	if type(vTarget) == "string" then
		if sWord ~= vTarget then
			return false;
		end
	elseif type(vTarget) == "table" then
		if not contains(vTarget, sWord) then
			return false;
		end
	else
		return false;
	end
	return true;
end

function isPhrase(aWords, nIndex, aPhrase)
	if not aPhrase or not aWords then
		return false;
	end
	if #aPhrase == 0 then
		return false;
	end
	
	local i = nIndex - 1;
	for j = 1, #aPhrase do
		if not StringManager.isWord(aWords[i+j], aPhrase[j]) then
			return false;
		end
	end
	return true;
end

function isNumberString(sWord)
	if sWord then
		if sWord:match("^[%+%-]?[%d%.]+$") then
			return true;
		end
	end
	return false;
end

function isDiceString(sWord)
	if sWord then
		if sWord:match("^[d%.%dF%+%-]+$") then
			return true;
		end
	end
	return false;
end

function isDiceMathString(sWord)
	if sWord then
		if sWord:match("^[ d%.%dF%*/%+%-%(%)]+$") then
			return true;
		end
	end
	return false;
end

-----------------------
-- SET FUNCTIONS
-----------------------

function contains(set, item)
	if not set or not item then
		return false;
	end
	for i = 1, #set do
		if set[i] == item then
			return true;
		end
	end
	return false;
end

function autoComplete(aSet, sItem, bIgnoreCase)
	if not aSet or not sItem then
		return nil;
	end
	if bIgnoreCase then
		for i = 1, #aSet do
			if sItem:lower() == string.lower(aSet[i]:sub(1, #sItem)) then
				return aSet[i]:sub(#sItem + 1);
			end
		end
	else
		for i = 1, #aSet do
			if sItem == aSet[i]:sub(1, #sItem) then
				return aSet[i]:sub(#sItem + 1);
			end
		end
	end

	return nil;
end

-----------------------
-- MODIFY FUNCTIONS
-----------------------

function capitalize(s)
	if not s then
		return nil;
	end
	local sNew = s:gsub("^%l", string.upper);
	return sNew;
end

function capitalizeAll(s)
	if not s then
		return nil;
	end
	local sNew = s:gsub("^%l", string.upper);
	sNew = sNew:gsub(" %l", string.upper);
	sNew = sNew:gsub(" %(%l", string.upper);
	return sNew;
end

function titleCase(s)
	if not s then
		return nil;
	end
	function titleCaseInternal(sFirst, sRemaining)
		return sFirst:upper() .. sRemaining:lower();
	end
	return s:gsub("(%a)([%w_']*)", titleCaseInternal);
end

function multireplace(s, aPatterns, sReplace)
	if not s or not sReplace then
		return s;
	end
	if type(aPatterns) == "string" then
		s = s:gsub(aPatterns, sReplace);
	elseif type(aPatterns) == "table" then
		for _,v in pairs(aPatterns) do
			s = s:gsub(v, sReplace);
		end
	end

	return s;
end

function addTrailing(s, c)
	if not s then
		return s;
	end
	if s:len() > 0 and s[-1] ~= c then
		s = s .. c;
	end
	return s;
end

function extract(s, nStart, nEnd)
	if not s or not nStart or not nEnd then
		return "", s;
	end
	
	local sExtract = s:sub(nStart, nEnd);
	local sRemainder;
	if nStart == 1 then
		sRemainder = s:sub(nEnd + 1);
	else
		sRemainder = s:sub(1, nStart - 1) .. s:sub(nEnd + 1);
	end

	return sExtract, sRemainder;
end

function extractPattern(s, sPattern)
	if not s or not sPattern then
		return "", s;
	end

	local nStart, nEnd = s:find(sPattern);
	if not nStart then
		return "", s;
	end
	
	local sExtract = s:sub(nStart, nEnd);
	local sRemainder;
	if nStart == 1 then
		sRemainder = s:sub(nEnd + 1);
	else
		sRemainder = s:sub(1, nStart - 1) .. s:sub(nEnd + 1);
	end

	return sExtract, sRemainder;
end

function combine(sSeparator, ...)
	local aCombined = {};

	for i = 1, select("#", ...) do
		local v = select(i, ...);
		if type(v) == "string" and v:len() > 0 then
			table.insert(aCombined, v);
		end
	end

	return table.concat(aCombined, sSeparator);
end

--
-- TRIM STRING
--
-- Strips any spacing characters from the beginning and end of a string.
--
-- The function returns the following parameters:
--   1. The trimmed string
--   2. The starting position of the trimmed string within the original string
--   3. The ending position of the trimmed string within the original string
--

function trim(s)
	if not s then
		return nil;
	end
	
	local pre_starts, pre_ends = s:find("^%s+");
	local post_starts, post_ends = s:find("%s+$");
	
	if pre_ends then
		s = s:gsub("^%s+", "");
	else
		pre_ends = 0;
	end
	if post_starts then
		s = s:gsub("%s+$", "");
	end
	
	return s, pre_ends + 1, pre_ends + #s;
end

function strip(s)
	if not s then
		return nil;
	end

	return trim(s:gsub("%s+", " "));
end

-----------------------
-- PARSE FUNCTIONS
-----------------------

function parseWords(s, extra_delimiters)
	local delim = "^%w%+%-'�";
	if extra_delimiters then
		delim = delim .. extra_delimiters;
	end
	return StringManager.split(s, delim, true); 
end

-- 
-- SPLIT CLAUSES
--
-- The source string is divided into substrings as defined by the delimiters parameter.  
-- Each resulting string is stored in a table along with the start and end position of
-- the result string within the original string.  The result tables are combined into
-- a table which is then returned.
--
-- NOTE: Set trimspace flag to trim any spaces that trail delimiters before next result 
-- string
--

function split(sToSplit, sDelimiters, bTrimSpace)
	if not sToSplit or not sDelimiters then
		return {}, {};
	end
	
	-- SETUP
	local aStrings = {};
	local aStringStats = {};
	
  	-- BUILD DELIMITER PATTERN
  	local sDelimiterPattern = "[" .. sDelimiters .. "]+";
  	if bTrimSpace then
  		sDelimiterPattern = sDelimiterPattern .. "%s*";
  	end
  	
  	-- DEAL WITH LEADING/TRAILING SPACES
  	local nStringStart = 1;
  	local nStringEnd = #sToSplit;
  	if bTrimSpace then
  		_, nStringStart, nStringEnd = StringManager.trim(sToSplit);
  	end
  	
  	-- SPLIT THE STRING, BASED ON THE DELIMITERS
   	local sNextString = "";
 	local nIndex = nStringStart;
  	local nDelimiterStart, nDelimiterEnd = sToSplit:find(sDelimiterPattern, nIndex);
  	while nDelimiterStart do
  		sNextString = sToSplit:sub(nIndex, nDelimiterStart - 1);
  		if sNextString ~= "" then
  			table.insert(aStrings, sNextString);
  			table.insert(aStringStats, {startpos = nIndex, endpos = nDelimiterStart});
  		end
  		
  		nIndex = nDelimiterEnd + 1;
  		nDelimiterStart, nDelimiterEnd = sToSplit:find(sDelimiterPattern, nIndex);
  	end
  	sNextString = sToSplit:sub(nIndex, nStringEnd);
	if sNextString ~= "" then
		table.insert(aStrings, sNextString);
		table.insert(aStringStats, {startpos = nIndex, endpos = nStringEnd + 1});
	end
	
	-- RESULTS
	return aStrings, aStringStats;
end

function splitByPattern(sToSplit, sPattern, bTrimSpace)
	if not sToSplit or not sPattern then
		return {};
	end
	
  	local nStringStart = 1;
  	local nStringEnd = #sToSplit;
  	if bTrimSpace then
  		_, nStringStart, nStringEnd = StringManager.trim(sToSplit);
  	end

	local aStrings = {};
	local sNonGreedyPatternMatch = "(.-)" .. sPattern;
 	local nIndex = nStringStart;
	local nPatternStart, nPatternEnd, sString = sToSplit:find(sNonGreedyPatternMatch, nIndex);
	while nPatternStart do
		table.insert(aStrings, sString);
  		nIndex = nPatternEnd + 1;
		nPatternStart, nPatternEnd, sString = sToSplit:find(sNonGreedyPatternMatch, nIndex);
	end
	local sFinalString = sToSplit:sub(nIndex, nStringEnd);
	if sFinalString ~= "" then
		table.insert(aStrings, sFinalString);
	end

	return aStrings;
end

-----------------------
--  CONVERSION FUNCTIONS
-----------------------

-- NOTE: Ignores negative dice references
function convertStringToDice(s)
	-- SETUP
	local aDice = {};
	local nMod = 0;
	
	-- PARSING
	if s then
		local aRulesetDice = Interface.getDice();
		
		for sSign, v in s:gmatch("([+-]?)([%d%.a-zA-Z]+)") do
			-- SIGN
			local nSignMult = 1;
			if sSign == "-" then
				nSignMult = -1;
			end

			-- Number
			if StringManager.isNumberString(v) then
				local n = tonumber(v) or 0;
				nMod = nMod + (nSignMult * n);
			else
				-- Die String
				local sDieCount, sDieNotation, sDieType = v:match("^([%d%.]*)([a-zA-Z])([%dF]+)");
				if sDieType then
					sDieNotation = sDieNotation:lower();
					sDieType = sDieNotation .. sDieType;
					if StringManager.contains(aRulesetDice, sDieType) or (sDieNotation == "d") then
						local nDieCount = math.floor(tonumber(sDieCount) or 1);
						
						local sDie;
						if sSign == "-" then
							sDie = sSign .. sDieType;
						else
							sDie = sDieType;
						end
						
						for i = 1, nDieCount do
							table.insert(aDice, sDie);
						end
					end
				end
			end
		end
	end
	
	-- RESULTS
	return aDice, nMod;
end

function convertDiceToString(aDice, nMod, bSign)
	local s = "";
	
	if aDice then
		local diecount = {};

		for _,v in ipairs(aDice) do
			-- Draginfo die data is two levels deep
			if type(v) == "table" then
				diecount[v.type] = (diecount[v.type] or 0) + 1;

			-- Database value die data is one level deep
			else
				diecount[v] = (diecount[v] or 0) + 1;
			end
		end

		-- Build string
		for k,v in pairs(diecount) do
			if k:sub(1,1) == "-" then
				s = s .. "-" .. v .. k:sub(2);
			else
				if s ~= "" then
					s = s .. "+";
				end
				s = s .. v .. k;
			end
		end
	end
	
	-- ADD OPTIONAL MODIFIER
	if nMod then
		if nMod > 0 then
			if s == "" and not bSign then
				s = s .. nMod
			else
				s = s .. "+" .. nMod;
			end
		elseif nMod < 0 then
			s = s .. nMod;
		end
	end
	
	-- RESULTS
	return s;
end

-----------------------
-- EVALUATION FUNCTIONS
-----------------------

--
-- EVAL DICE STRING
--
-- Evaluates a string that contains an arbitrary number of numerical terms and dice expressions
-- 
-- NOTE: Dice expressions are automatically evaluated randomly without rolling the 
-- physical dice on-screen, or ignored if the bAllowDice flag not set.
--

function evalDiceString(sDice, bAllowDice, bMaxDice)
	local nTotal = 0;
	
	for sSign, sVal, sDieType in sDice:gmatch("([%-%+]?)%s?(%d+)d?([%dF]*)") do
		local nVal = tonumber(sVal) or 0;
		local nSubtotal = 0;

		if sDieType ~= "" then
			if bAllowDice then
				local nDieSides;
				if sDieType == "F" then
					nDieSides = 3;
					if bMaxDice then
						nSubtotal = nSubtotal + (nVal * nDieSides);
					else
						for i = 1, nVal do
							local nRandom = math.random(3);
							if nRandom == 1 then
								nSubtotal = nSubtotal - 1;
							elseif nRandom == 3 then
								nSubtotal = nSubtotal + 1;
							end
						end
					end
				else
					nDieSides = tonumber(sDieType) or 0;
					if nDieSides > 0 then
						if bMaxDice then
							nSubtotal = nSubtotal + (nVal * nDieSides);
						else
							for i = 1, nVal do
								nSubtotal = nSubtotal + math.random(nDieSides);
							end
						end
					end
				end
			end
		else
			nSubtotal = nVal;
		end

		if sSign == "-" then
			nSubtotal = 0 - nSubtotal;
		end
		
		nTotal = nTotal + nSubtotal;
	end
	
	return nTotal;
end

function evalDice(aDice, nMod, bMax)
	local nTotal = 0;
	for _,sDie in pairs(aDice) do
		local sSign, sDieType = sDie:match("([%-%+]?)d([%dF]+)");
		local nDieSides;
		if sDieType == "F" then
			nDieSides = 3;
		else
			nDieSides = tonumber(sDieType) or 0;
		end
		
		local nSubtotal = 0;
		if nDieSides > 0 then
			if bMax then
				if sDieType == "F" then
					nSubtotal = 1;
				else
					nSubtotal = nDieSides;
				end
			else
				if sDieType == "F" then
					nSubtotal = math.random(-1, 1)
				else
					nSubtotal = math.random(nDieSides);
				end
			end
		end
		
		if sSign == "-" then
			nSubtotal = 0 - nSubtotal;
		end
		
		nTotal = nTotal + nSubtotal;
	end
	if nMod then
		nTotal = nTotal + nMod;
	end
	return nTotal;
end

function findDiceMathExpression(s, nStart)
	if not s then
		return;
	end
	
	return s:find("[d%dF%*/%+%-%(%)][ d%dF%*/%+%-%(%)]+", nStart);
end

function evalDiceMathExpression(sParam, bMaxDice)
	if not sParam then
		return 0;
	end
	
	local s = sParam:gsub(" ", "");
	
	-- Convert to post-fix array
	-- Note: Based on Shunting-Yard algorithm (modified for dice operator)
	local sOps = "-+*/";
	local aOpStack = {};
	local aPFArray = {};
	local sNonOp = "";
	
	for i = 1,#s do
		local c = s:sub(i, i);
		local nFind = sOps:find(c, 1, true);
		if nFind then
			if sNonOp ~= "" then
				table.insert(aPFArray, sNonOp);
				sNonOp = "";
			end
			while #aOpStack > 0 do
				if aOpStack[#aOpStack] == #sOps + 1 then
					table.insert(aPFArray, "d");
					table.remove(aOpStack);
				else
					local nPrec2 = (aOpStack[#aOpStack] - 1) / 2;
					local nPrec1 = (nFind - 1) / 2;
					if nPrec2 > nPrec1 then
						table.insert(aPFArray, sOps:sub(aOpStack[#aOpStack], aOpStack[#aOpStack]));
						table.remove(aOpStack);
					else
						break;
					end
				end
			end
			table.insert(aOpStack, nFind);
		elseif c == '(' then
			if sNonOp ~= "" then
				table.insert(aPFArray, sNonOp);
				sNonOp = "";
			end
			table.insert(aOpStack, -2);
		elseif c == ')' then
			if sNonOp ~= "" then
				table.insert(aPFArray, sNonOp);
				sNonOp = "";
			end
			while #aOpStack > 0 do
				if aOpStack[#aOpStack] == -2 then
					table.remove(aOpStack);
					break;
				else
					if aOpStack[#aOpStack] == #sOps + 1 then
						table.insert(aPFArray, "d");
					else
						table.insert(aPFArray, sOps:sub(aOpStack[#aOpStack], aOpStack[#aOpStack]));
					end
					table.remove(aOpStack);
				end
			end
		elseif c == 'd' then
			local bValidDieOperator = true;
			if i > 1 then
				if s:sub(i-1,i-1):match("%a") then
					bValidDieOperator = false;
				end
			end
			if i < #s then
				if s:sub(i+1,i+1):match("%a") then
					bValidDieOperator = false;
				end
			end
			
			if bValidDieOperator then
				if sNonOp == "" then
					sNonOp = "1";
				end
				table.insert(aPFArray, sNonOp);
				sNonOp = "";
				if s:sub(i+1, i+1) == 'F' then
					table.insert(aPFArray, 'F');
					table.insert(aPFArray, c);
				else
					table.insert(aOpStack, #sOps + 1);
				end
			else
				sNonOp = sNonOp .. c;
			end
		else
			sNonOp = sNonOp .. c;
		end
	end
	if sNonOp ~= "" then
		table.insert(aPFArray, sNonOp);
		sNonOp = "";
	end
	while #aOpStack > 0 do
		if aOpStack[#aOpStack] == #sOps + 1 then
			table.insert(aPFArray, "d");
		else
			table.insert(aPFArray, sOps:sub(aOpStack[#aOpStack], aOpStack[#aOpStack]));
		end
		table.remove(aOpStack);
	end

	-- Calculate result from post-fix array
	local aCalcStack = {};
	for _,v in ipairs(aPFArray) do
		if v == '*' then
			if #aCalcStack > 1 then
				local nTemp = (tonumber(aCalcStack[#aCalcStack - 1]) or 0) * (tonumber(aCalcStack[#aCalcStack]) or 0);
				table.remove(aCalcStack);
				table.remove(aCalcStack);
				table.insert(aCalcStack, nTemp);
			elseif #aCalcStack > 0 then
				table.remove(aCalcStack);
				table.insert(aCalcStack, 0);
			end
		elseif v == '/' then
			if #aCalcStack > 1 then
				local nTemp = 0;
				local nDividend = (tonumber(aCalcStack[#aCalcStack]) or 0);
				if nDividend ~= 0 then
					nTemp = (tonumber(aCalcStack[#aCalcStack - 1]) or 0) / nDividend;
				end
				table.remove(aCalcStack);
				table.remove(aCalcStack);
				table.insert(aCalcStack, nTemp);
			elseif #aCalcStack > 0 then
				table.remove(aCalcStack);
				table.insert(aCalcStack, 0);
			end
		elseif v == '-' then
			if #aCalcStack > 1 then
				local nTemp = (tonumber(aCalcStack[#aCalcStack - 1]) or 0) - (tonumber(aCalcStack[#aCalcStack]) or 0);
				table.remove(aCalcStack);
				table.remove(aCalcStack);
				table.insert(aCalcStack, nTemp);
			elseif #aCalcStack > 0 then
				local nTemp = (tonumber(aCalcStack[#aCalcStack]) or 0) * -1;
				table.remove(aCalcStack);
				table.insert(aCalcStack, nTemp);
			end
		elseif v == '+' then
			if #aCalcStack > 1 then
				local nTemp = (tonumber(aCalcStack[#aCalcStack - 1]) or 0) + (tonumber(aCalcStack[#aCalcStack]) or 0);
				table.remove(aCalcStack);
				table.remove(aCalcStack);
				table.insert(aCalcStack, nTemp);
			end
		elseif v == 'd' then
			if #aCalcStack > 0 then
				local nDieCount = 1;
				if #aCalcStack > 1 then
					nDieCount = math.max(tonumber(aCalcStack[#aCalcStack - 1]) or 1, 1);
				end
				local sDieType = aCalcStack[#aCalcStack];

				local nDieResultBase = 1;
				local nDieResultRange;
				if sDieType == "F" then
					nDieResultBase = -1;
					nDieResultRange = 3;
				else
					nDieResultRange = tonumber(sDieType) or 1;
				end
				
				local nTemp = 0;
				if bMaxDice then
					nTemp = nDieCount * (nDieResultBase + nDieResultRange - 1);
				else
					for i = 1, nDieCount do
						local nRoll = (nDieResultBase - 1 + math.random(nDieResultRange));
						nTemp = nTemp + nRoll;
					end
				end
				
				if #aCalcStack > 1 then
					table.remove(aCalcStack);
				end
				table.remove(aCalcStack);
				table.insert(aCalcStack, nTemp);
			end
		else
			table.insert(aCalcStack, v);
		end
	end

	local nTotal = 0;
	if #aCalcStack == 1 then
		nTotal = tonumber(aCalcStack[1]) or 0;
	end
	
	return nTotal;
end
