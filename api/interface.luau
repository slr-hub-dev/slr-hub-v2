-- WIP XUREL (4/17/26)
--!strict

local constructor = {}

local libraryMethods, libraryPrivate = {}, setmetatable({}, { __mode = "k" }) :: libraryPrivate
local pageMethods, pagePrivate = {}, setmetatable({}, { __mode = "k" }) :: pagePrivate
local libraryApi, pageApi = { __index = libraryMethods }, { __index = pageMethods }

-- enter documentation (strict; constructor exposes only .new(); invoking library/page methods through constructor.funcName(mt, ...) will result in an error)
type libraryArguments = { name: string, accent: Color3 } -- constructor.new() -> library
type pageArguments = { name: string, sectioned: boolean? } -- library:Page() -> page
type labelArguments = { text: string, right: boolean? } -- page:Label() -> ()
type buttonArguments = { name: string, right: boolean?, callback: (boolean) -> () } -- page:Button() -> ()
-- exit documentation

type propertyTypes = string | Color3 | number | EnumItem | Font | UDim2 | UDim | Vector2

type librarySpecific = { pages: Frame, pageBar: Frame, config: libraryArguments }
type libraryPrivate = { [any]: librarySpecific }

type pageSpecific = { library: library, main: ScrollingFrame?, left: ScrollingFrame?, right: ScrollingFrame? }
type pagePrivate = { [any]: pageSpecific }

export type library = typeof(setmetatable({}, libraryApi))
export type page = typeof(setmetatable({}, pageApi))

local cloneref = cloneref or function(...) return ... end

local Players 			= 	cloneref(game:GetService("Players"))																						:: Players
local Lighting 			= 	cloneref(game:GetService("Lighting"))																						:: Lighting
local RunService 		= 	cloneref(game:GetService("RunService"))																						:: RunService
local TweenService 		= 	cloneref(game:GetService("TweenService"))																					:: TweenService
local UserInputService 	=	cloneref(game:GetService("UserInputService")) 																				:: UserInputService
local CoreGui 			= 	RunService:IsStudio() and (Players.LocalPlayer :: Player):WaitForChild("PlayerGui") or cloneref(game:GetService("CoreGui"))	:: PlayerGui -- | CoreGui

local function new(className: string, properties: {[string]: propertyTypes}): Instance
	local instance = Instance.new(className)
	
	for i, v in pairs(properties) do
		instance[i] = v
	end
	
	return instance
end

function pageMethods:Label(args: labelArguments): ()
	
end

function libraryMethods:Page(args: pageArguments): page
	local first = next(libraryPrivate[self].pages:GetChildren()) == nil -- redundant
	
	local pageR = new("CanvasGroup", {Size = UDim2.new(1, 0, 1, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.6, 0), BackgroundTransparency = 1, GroupTransparency = 1, Parent = libraryPrivate[self].pages, Interactable = false}) :: CanvasGroup
	local pageSelector = new("TextButton", {Parent = libraryPrivate[self].pageBar, BorderSizePixel = 0, TextSize = 14, AutoButtonColor = false, Size = UDim2.new(0.97, 0, 0, 35), Text = "", BackgroundTransparency = 1, BackgroundColor3 = Color3.new(1,1,1)}) :: TextButton
	local pageSelectorCorner = new("UICorner", {Parent = pageSelector, CornerRadius = UDim.new(0, 4)})
	local pageSelectorTitle = new("TextLabel", {TextScaled = true, Parent = pageSelector, BorderSizePixel = 0, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, FontFace = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal), TextColor3 = Color3.new(1,1,1), AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0.9, 0, 0, 15), Position = UDim2.new(0.5, 0, 0.5, 0)})
	local pageSelectorIndicator = new("Frame", {Parent = pageSelector, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5,0.5), Size = UDim2.new(0, 2, 1, 0), Position = UDim2.new(1, -1, 0.5, 0), BackgroundTransparency = 1}) :: Frame
	
	local right, left, main
	
	if args.sectioned then
		left = new("ScrollingFrame", {Size = UDim2.new(0.49, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 0, ClipsDescendants = false, Parent = pageR, Position = UDim2.new(0.25, 0, 0.5, 0)}) :: ScrollingFrame
		right =	new("ScrollingFrame", {Size = UDim2.new(0.49, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 0, ClipsDescendants = false, Parent = pageR, Position = UDim2.new(0.75, 0, 0.5, 0)}) :: ScrollingFrame
		new("UIListLayout", {HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder, Parent = left})
		new("UIListLayout", {HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder, Parent = right})
	else
		main = new("ScrollingFrame", {Size = UDim2.new(0.99, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = pageR, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 0, ClipsDescendants = false}) :: ScrollingFrame
		new("UIListLayout", {HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder, Parent = main})
	end
	
	if first then
		pageR.GroupTransparency = 0
		pageR.Position = UDim2.new(0.5, 0, 0.5, 0)
		
		pageSelector.BackgroundTransparency = 0.95
		pageSelectorIndicator.BackgroundTransparency = 0.2
	end
	
	local page = setmetatable({}, pageApi)
	pagePrivate[page] = {library = self, main = main, left = left, right = right}
	
	return page
end

function constructor.new(args: libraryArguments): library
	local screenGui = new("ScreenGui", {ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true, ResetOnSpawn = false, Parent = CoreGui})
	local window = new("Frame", {Parent = screenGui, BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(21, 21, 21), AnchorPoint = Vector2.new(0.5,0.5), ClipsDescendants = true, Size = UDim2.new(0, 750, 0, 500), Position = UDim2.new(0.5,0,0.5,0), BackgroundTransparency = 0.2})
	local topBar = new("Frame", {Parent = window, BorderSizePixel = 0, BackgroundColor3 = Color3.new(1,1,1), AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(1, 0, 0, 40), Position = UDim2.new(0.5, 0, 0, 20), BackgroundTransparency = 0.95})
	local pageBar = new("Frame", {Parent = window, BorderSizePixel = 0, Size = UDim2.new(0, 152, 0, 453), Position = UDim2.new(0, 0, 0.092, 0), BackgroundTransparency = 1}) :: Frame
	local pages = new("Frame", {Parent = window, Size = UDim2.new(0, 584, 0, 454), Position = UDim2.new(0.21333, 0, 0.092, 0), BackgroundTransparency = 1}) :: Frame
	new("TextLabel", {Parent = topBar, TextScaled = true, BorderSizePixel = 0, FontFace = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal), BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5,0.5), Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0.5, 0, 0.5, 0), TextColor3 = Color3.new(1,1,1), Text = args.name})
	new("UIListLayout", {Parent = pageBar, HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder})
	
	local library = setmetatable({}, libraryApi)
	libraryPrivate[library] = { pages = pages, pageBar = pageBar, config = args }
	
	return library
end

return constructor
