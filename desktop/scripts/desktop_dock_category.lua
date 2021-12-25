-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local _sCategory;

--
--	Data
--

function setCategory(sCategory)
	_sCategory = sCategory;
	local sLabel = LibraryData.getCategoryDisplayText(_sCategory);
    label.setValue(sLabel);

    updateTheming();
    updateStateIcon();
end
function getCategory()
	return _sCategory;
end

function updateTheming()
	local szArea = DesktopManager.getSidebarDockCategorySize();
	local rcOffset = DesktopManager.getSidebarDockCategoryOffset();

	local szPadding = DesktopManager.getSidebarDockCategoryPadding();
	local nTextOffset = DesktopManager.getSidebarDockCategoryTextOffset();
	local sIconColor = DesktopManager.getSidebarDockCategoryIconColor();
	local sTextColor = DesktopManager.getSidebarDockCategoryTextColor();

	local nIconSize = math.min(szArea.w - (szPadding.w * 2), szArea.h - (szPadding.h * 2));

	spacer.setAnchoredWidth(szArea.w + (rcOffset.left + rcOffset.right));
	spacer.setAnchoredHeight(szArea.h + (rcOffset.top + rcOffset.bottom));

	base.setAnchor("left", "", "left", "absolute", rcOffset.left);
	base.setAnchor("top", "", "top", "absolute", rcOffset.top);
	base.setAnchoredWidth(szArea.w);
	base.setAnchoredHeight(szArea.h);
	icon.setAnchor("left", "", "left", "absolute", rcOffset.left + math.min(szPadding.w, szArea.w));
	icon.setAnchor("top", "", "top", "absolute", rcOffset.top + math.min(szPadding.h, szArea.h));
	icon.setAnchoredWidth(math.max(nIconSize, 0));
	icon.setAnchoredHeight(math.max(nIconSize, 0));
	label.setAnchor("left", "", "left", "absolute", rcOffset.left + math.min(szPadding.w + nIconSize + nTextOffset, szArea.w));
	label.setAnchor("top", "", "top", "absolute", rcOffset.top + math.min(szPadding.h, szArea.h));
	label.setAnchoredWidth(math.max(szArea.w - nIconSize - nTextOffset - (szPadding.w * 2), 0));
	label.setAnchoredHeight(math.max(szArea.h - (szPadding.h * 2), 0));

	icon.setColor(sIconColor);
	label.setColor(sTextColor);
end

--
--	UI Events
--

function updateFrame(bPressed)
	if bPressed then
		base.setFrame("sidebar_dock_category_down");
	else
		base.setFrame("sidebar_dock_category");
	end		
end

function updateStateIcon()
	if DesktopManager.getSidebarCategoryState(_sCategory) then
		icon.setIcon("sidebar_dock_category_expanded");
	else
		icon.setIcon("sidebar_dock_category_collapsed");
	end
end

function onClickDown()
	updateFrame(true);
	return true;
end
function onClickRelease()
    DesktopManager.toggleSidebarCategoryState(_sCategory);
    updateStateIcon();
	updateFrame(false);
    return true;
end

function onDragStart(button, x, y, draginfo)
	return true;
end
function onDragEnd(draginfo)
	updateFrame(false);
end
