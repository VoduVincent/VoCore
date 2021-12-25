-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function setData(tButton)
	link.setIcons(tButton.sIcon, tButton.sIconPressed or tButton.sIcon);
	link.setValue(tButton.sClass, tButton.sPath);
	link.setTooltipText(Interface.getString(tButton.sLabelRes));

	updateTheming();
end

function updateTheming()
	local szArea = DesktopManager.getSidebarStackButtonSize();
	local rcOffset = DesktopManager.getSidebarStackButtonOffset();

	spacer.setAnchoredWidth(szArea.w + (rcOffset.left + rcOffset.right));
	spacer.setAnchoredHeight(szArea.h + (rcOffset.top + rcOffset.bottom));

	link.setAnchor("left", "", "left", "absolute", rcOffset.left);
	link.setAnchor("top", "", "top", "absolute", rcOffset.top);
	link.setAnchoredWidth(szArea.w);
	link.setAnchoredHeight(szArea.h);
end
