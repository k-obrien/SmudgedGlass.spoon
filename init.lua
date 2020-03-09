--- === SmudgedGlass ===
---
--- Assign hotkeys to manipulate the selected window.
---
--- Download: [https://github.com/k-obrien/smudged-glass/raw/master/SmudgedGlass.spoon.zip](https://github.com/k-obrien/smudged-glass/raw/master/SmudgedGlass.spoon.zip)

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "SmudgedGlass"
obj.version = "0.1"
obj.author = "Kieran O'Brien"
obj.homepage = "https://github.com/k-obrien/smudged-glass"
obj.license = "GPLv3 - https://opensource.org/licenses/GPL-3.0"

obj.gridSize = hs.geometry.size(4, 4)

obj.windowMargins = hs.geometry.size(0, 0)

obj.windowGeoMaxCentre = hs.geometry.rect(1, 0, 2, 4)
obj.windowGeoLeft = hs.geometry.rect(0, 0, 2, 4)
obj.windowGeoLeftTop = hs.geometry.rect(0, 0, 2, 2)
obj.windowGeoLeftBottom = hs.geometry.rect(0, 2, 2, 2)
obj.windowGeoRight = hs.geometry.rect(2, 0, 2, 4)
obj.windowGeoRightTop = hs.geometry.rect(2, 0, 2, 2)
obj.windowGeoRightBottom = hs.geometry.rect(2, 2, 2, 2)

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
function obj:bindHotKeys(map)
	local partial = hs.fnutils.partial
	local def = {
		toggleGrid = hs.grid.toggleShow,
		windowMaximise = hs.grid.maximizeWindow,
		windowMaximiseCentre = partial(self.withFocusedWindow, partial(self.setGrid, self.windowGeoMaxCentre)),
		windowLeft = partial(self.withFocusedWindow, partial(self.setGrid, self.windowGeoLeft)),
		windowLeftTop = partial(self.withFocusedWindow, partial(self.setGrid, self.windowGeoLeftTop)),
		windowLeftBottom = partial(self.withFocusedWindow, partial(self.setGrid, self.windowGeoLeftBottom)),
		windowRight = partial(self.withFocusedWindow, partial(self.setGrid, self.windowGeoRight)),
		windowRightTop = partial(self.withFocusedWindow, partial(self.setGrid, self.windowGeoRightTop)),
		windowRightBottom = partial(self.withFocusedWindow, partial(self.setGrid, self.windowGeoRightBottom)),
		windowCentre = partial(self.withFocusedWindow, self.centreWindow),
		windowNorth = partial(self.withFocusedWindow, self.moveWindowNorth),
		windowSouth = partial(self.withFocusedWindow, self.moveWindowSouth),
		windowWest = partial(self.withFocusedWindow, self.moveWindowWest),
		windowEast = partial(self.withFocusedWindow, self.moveWindowEast)
	}
    hs.spoons.bindHotkeysToSpec(def, map)
end

--- SmudgedGlass:start()
--- Method
--- Set the grid size for window management
---
--- Parameters:
---  * None
function obj:start()
	hs.grid.setGrid(self.gridSize)
	hs.grid.setMargins(self.windowMargins)
    return self
end

function obj.withFocusedWindow(funcWithFocusedWindow)
	local focusedWindow = hs.window.focusedWindow()

	if (focusedWindow ~= nil) then
		funcWithFocusedWindow(focusedWindow)
	end
end

function obj.setGrid(cell, focusedWindow)
	hs.grid.set(focusedWindow, cell)
end

function obj.centreWindow(focusedWindow)
	focusedWindow:centerOnScreen(focusedWindow:screen(), true)
end

function obj.moveWindowNorth(focusedWindow)
	focusedWindow:moveOneScreenNorth(false, true)
end

function obj.moveWindowSouth(focusedWindow)
	focusedWindow:moveOneScreenSouth(false, true)
end

function obj.moveWindowWest(focusedWindow)
	focusedWindow:moveOneScreenWest(false, true)
end

function obj.moveWindowEast(focusedWindow)
	focusedWindow:moveOneScreenEast(false, true)
end

return obj
