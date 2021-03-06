-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local srcnode = nil;
local srcnodename = "";

local cycleindex = 0;

local labels = {};
local values = {};
local defaultval = "-";

local sFont = "sheettext";
local sFontColor = "";
local widgetText = nil;

function onInit()
	-- GET PARAMETERS
	if font then
		sFont = font[1];
	end
	if color then
		sFontColor = color[1];
	end

	local sLabels = "";
	local sValues = "";
	local sDefaultLabel = "";
	if parameters then
		if parameters[1].labelsres then
			sLabels = parameters[1].labelsres[1];
			if sLabels then
				local tSplitLabelRes = StringManager.split(sLabels, "|");
				local tLabels = {};
				for k,v in ipairs(tSplitLabelRes) do
					tLabels[k] = Interface.getString(v);
				end
				sLabels = table.concat(tLabels, "|");
			end
		elseif parameters[1].labels then
			sLabels = parameters[1].labels[1];
		end
		if parameters[1].values then
			sValues = parameters[1].values[1];
		end
		if parameters[1].defaultlabelres then
			sDefaultLabel = Interface.getString(parameters[1].defaultlabelres[1]);
		elseif parameters[1].defaultlabel then
			sDefaultLabel = parameters[1].defaultlabel[1];
		end
	end
	initialize(sLabels, sValues, sDefaultLabel);

	-- SET ACCESS RIGHTS
	local bLocked = false;
	
	-- SET UP DATA CONNECTION
	if not sourceless then
		srcnodename = getName();
		if source and source[1] and source[1].name then
			srcnodename = source[1].name[1];
		end
	end
	if srcnodename ~= "" then
		-- DETERMINE DB READ-ONLY STATE
		local node = window.getDatabaseNode();
		if node.isReadOnly() then
			bLocked = true;
		end

		-- LINK TO DATABASE NODE, AND FUTURE UPDATES
		srcnode = node.createChild(srcnodename, "string");
		if srcnode then
			srcnode.onUpdate = update;
		elseif node then
			node.onChildAdded = registerUpdate;
		end
		
		-- SYNCHRONIZE DATA VALUES
		synchData();
	end

	-- Set the correct read only value
	if bLocked then
		setReadOnly(bLocked);
	end
	
	-- SET UP TEXT WIDGET
	widgetText = addTextWidget(sFont, "");
	widgetText.setPosition("center", 0, 0);
	if sFontColor and sFontColor ~= "" then
		widgetText.setColor(sFontColor);
	end

	-- UPDATE DISPLAY
	updateDisplay();
end

function registerUpdate(nodeSource, nodeChild)
	if nodeChild.getName() == srcnodename then
		nodeSource.onChildAdded = function () end;
		nodeChild.onUpdate = update;
		srcnode = nodeChild;
		update();
	end
end

function initialize(sLabels, sValues, sDefaultLabel, sInitialValue)
	if sLabels then
		labels = StringManager.split(sLabels, "|");
	end
	
	if sValues then
		values = StringManager.split(sValues, "|");
	end
	
	if sDefaultLabel then
		defaultval = sDefaultLabel;
	end
	
	if sInitialValue then
		matchData(sInitialValue);
	end
end

function initialize2(sLabels, sValues, sDefaultLabel, sInitialValue)
	if sLabels then
		labels = StringManager.split(sLabels, "|");
		for k,v in ipairs(labels) do
			labels[k] = Interface.getString(v);
		end
	end
	
	if sValues then
		values = StringManager.split(sValues, "|");
	end
	
	if sDefaultLabel then
		defaultval = Interface.getString(sDefaultLabel);
	end
	
	if sInitialValue then
		matchData(sInitialValue);
	end
end

function matchData(sValue)
	local nMatch = 0;
	for k,v in pairs(values) do
		if v == sValue then
			nMatch = k;
		end
	end

	if nMatch > 0 then
		cycleindex = nMatch;
	else
		cycleindex = 0;
	end
end

function synchData()
	local srcval = "";
	if srcnode then
		srcval = srcnode.getValue();
	end
	
	matchData(srcval);
end

function updateDisplay()
	if cycleindex > 0 and cycleindex <= #labels then
		widgetText.setText(labels[cycleindex]);
	else
		widgetText.setText(defaultval);
	end
	if alignleft then
		local w,_ = widgetText.getSize();
		widgetText.setPosition("left", math.floor(w/2), 0);
	elseif alignright then
		local w,_ = widgetText.getSize();
		widgetText.setPosition("right", -math.floor(w/2), 0);
	end
end

function update()
	synchData();
	updateDisplay();

	if self.onValueChanged then
		self.onValueChanged();
	end
end

function getDatabaseNode()
	return srcnode;
end

function setStringValue(srcval)
	if srcnode then
		srcnode.setValue(srcval);
	else
		matchData(srcval);
		updateDisplay();
		if self.onValueChanged then
			self.onValueChanged();
		end
	end
end

function getValue()
	if cycleindex > 0 and cycleindex <= #labels then
		return labels[cycleindex];
	end
	
	return defaultval;
end

function getStringValue()
	if cycleindex > 0 and cycleindex <= #values then
		return values[cycleindex];
	end
	
	return "";
end

function setDisplayColor(sColor)
	widgetText.setColor(sColor);
end

function setDisplayFont(sFont)
	widgetText.setFont(sFont);
end

function cycleLabel(bBackward)
	if bBackward then
		if cycleindex > 0 then
			cycleindex = cycleindex - 1;
		else
			cycleindex = #labels;
		end
	else
		if cycleindex < #labels then
			cycleindex = cycleindex + 1;
		else
			cycleindex = 0;
		end
	end

	if srcnode then
		srcnode.setValue(getStringValue());
	else
		updateDisplay();
		if self.onValueChanged then
			self.onValueChanged();
		end
	end
end

function onClickDown(button, x, y)
	return true;
end

function onClickRelease(button, x, y)
	if not isReadOnly() then
		cycleLabel(Input.isControlPressed());
	end
	return true;
end
