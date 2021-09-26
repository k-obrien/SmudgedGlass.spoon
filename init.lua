--- === SmudgedGlass ===
---
--- Assign hotkeys to manipulate the selected window.
---
--- Download: [https://github.com/k-obrien/SmudgedGlass.spoon/archive/master.zip](https://github.com/k-obrien/SmudgedGlass.spoon/archive/master.zip)

hs.window.animationDuration = 0

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "SmudgedGlass"
obj.version = "0.3"
obj.author = "Kieran O'Brien"
obj.homepage = "https://github.com/k-obrien/SmudgedGlass.spoon"
obj.license = "GPLv3 - https://opensource.org/licenses/GPL-3.0"

obj.gridSize = hs.geometry.size(12, 4)
obj.windowMargins = hs.geometry.size(0, 0)
obj.windowCellCache = {}
obj.windowCells = {
	centreVertMax = hs.geometry.rect(3, 0, 6, 4),
	leftVertMax = hs.geometry.rect(0, 0, 6, 4),
	leftTop = hs.geometry.rect(0, 0, 6, 2),
	leftBottom = hs.geometry.rect(0, 2, 6, 2),
	rightVertMax = hs.geometry.rect(6, 0, 6, 4),
	rightTop = hs.geometry.rect(6, 0, 6, 2),
	rightBottom = hs.geometry.rect(6, 2, 6, 2)
}

--- SmudgedGlass:bindHotKeys(map)
--- Method
--- Binds hotkeys for SmudgedGlass
---
--- Parameters:
---	 * mapping - A table containing hotkey modifier/key details for the following items:
---   * toggleGrid - Show/Hide the interactive modal window management grid
---	  * windowMaximise - Maximise focused window
---   * windowMaximiseCentre - Move and resize focused window to occupy centre half of screen
---	  * windowLeft - Move and resize focused window to occupy left half of screen
---   * windowLeftTop - Move and resize focused window to occupy top left corner of screen
---   * windowLeftBottom - Move and resize focused window to occupy bottom left corner of screen
---	  * windowRight - Move and resize focused window to occupy right half of screen
---   * windowRightTop - Move and resize focused window to occupy top right corner of screen
---   * windowRightBottom - Move and resize focused window to occupy bottom right corner of screen
---	  * windowCentre - Centre focused window on screen
---	  * windowNorth - Move focused window to screen above current
---	  * windowSouth - Move focused window to screen below current
---	  * windowWest - Move focused window to screen left of current
---	  * windowEast - Move focused window to screen right of current
---   * undo - Undo last resize/move operation for focused window
function obj:bindHotKeys(map)
	local partial = hs.fnutils.partial
	local setCell = hs.grid.set
	local def = {
		toggleGrid = hs.grid.toggleShow,
		windowMaximise = partial(self.withFocusedWindow, true, hs.grid.maximizeWindow),
		windowMaximiseCentre = partial(self.withFocusedWindow, true, setCell, self.windowCells.centreVertMax),
		windowLeft = partial(self.withFocusedWindow, true, setCell, self.windowCells.leftVertMax),
		windowLeftTop = partial(self.withFocusedWindow, true, setCell, self.windowCells.leftTop),
		windowLeftBottom = partial(self.withFocusedWindow, true, setCell, self.windowCells.leftBottom),
		windowRight = partial(self.withFocusedWindow, true, setCell, self.windowCells.rightVertMax),
		windowRightTop = partial(self.withFocusedWindow, true, setCell, self.windowCells.rightTop),
		windowRightBottom = partial(self.withFocusedWindow, true, setCell, self.windowCells.rightBottom),
		windowCentre = partial(self.withFocusedWindow, true, self.centreWindow),
		windowNorth = partial(self.withFocusedWindow, false, self.moveWindowNorth),
		windowSouth = partial(self.withFocusedWindow, false, self.moveWindowSouth),
		windowWest = partial(self.withFocusedWindow, false, self.moveWindowWest),
		windowEast = partial(self.withFocusedWindow, false, self.moveWindowEast),
		undo = partial(self.withFocusedWindow, false, self.undo)
	}

    hs.spoons.bindHotkeysToSpec(def, map)
end

--- SmudgedGlass:start()
--- Method
--- Set the grid size and margins for window management
---
--- Parameters:
---  * None
function obj:start()
	hs.grid.setGrid(self.gridSize)
	hs.grid.setMargins(self.windowMargins)
    return self
end

function obj.pushWindowFrame(window)
	if #obj.windowCellCache >= 50 then table.remove(obj.windowCellCache) end
	local windowId = window:id()
	local windowCell = window:frame()
	table.insert(obj.windowCellCache, 1, { windowId, windowCell })
end

function obj.popWindowFrame(window)
	local windowId = window:id()

	for index, cachedCell in ipairs(obj.windowCellCache) do
		if cachedCell[1] == windowId then
			table.remove(obj.windowCellCache, index)
			return cachedCell[2]
		end
	end
end

function obj.withFocusedWindow(addToStack, windowFunc, ...)
	local focusedWindow = hs.window.focusedWindow() or hs.alert.show("No window has focus!")

	if focusedWindow then
		if addToStack then obj.pushWindowFrame(focusedWindow) end
		windowFunc(focusedWindow, ...)
	end
end

function obj.centreWindow(window)
	window:centerOnScreen(window:screen(), true)
end

function obj.moveWindowNorth(window)
	window:moveOneScreenNorth(true, true)
end

function obj.moveWindowSouth(window)
	window:moveOneScreenSouth(true, true)
end

function obj.moveWindowWest(window)
	window:moveOneScreenWest(true, true)
end

function obj.moveWindowEast(window)
	window:moveOneScreenEast(true, true)
end

function obj.undo(window)
	local cachedWindowCell = obj.popWindowFrame(window)
	if cachedWindowCell then window:setFrame(cachedWindowCell) end
end

return obj
