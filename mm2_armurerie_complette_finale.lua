--[========================================================================]
-- ⚡ MM2 ARMURERIE COMPLÈTE FINALE - TOUTES LES VRAIES ARMES
-- Give All Weapons + Porter visuellement + Système réel MM2
--[========================================================================]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local localChar = localPlayer.Character or localPlayer.CharacterAdded:Wait()

--[========================================================================]
-- BASE DE DONNÉES COMPLÈTE MM2 - VRAIES ARMES
--[========================================================================]

local WEAPONS_DATABASE = {
	-- COUTEAUX COMMON
	CommonKnives = {
		"Bioblade", "Bit", "Camo", "Checker", "Cinder", "Knife", "Deep Sea",
		"Denim", "Elf", "Fall Camo", "Fade", "Gold", "Graffiti", "Horse",
		"Korn", "Pine", "Prism", "Shaded", "Scratch", "Sketch", "Snowy",
		"Steel", "Sub", "Whiteout"
	},
	
	-- COUTEAUX UNCOMMON
	UncommonKnives = {
		"Big Kill", "Clown", "Copper", "Ducc", "Flare", "Green", "Hazmat",
		"Juice", "Leaves", "Orange", "Puma", "Shiny", "Soda", "Squire",
		"Vino", "Warn", "Yellow"
	},
	
	-- COUTEAUX RARE
	RareKnives = {
		"Alex", "Bleached", "Corrupt", "Dennis", "Etch", "Fallout", "Ketchup",
		"Laser", "Marble", "Molten", "Missing", "Mummy", "Night", "Phaser",
		"Plasma", "Snowflake", "Spectrum", "Stretch", "Tree", "Vampire"
	},
	
	-- COUTEAUX GODLY
	GodlyKnives = {
		"BattleAxe", "Candy", "Clockwork", "Darkbringer", "Deathshard",
		"Eternal", "Fang", "Green Luger", "Hallowscythe", "Heartblade",
		"Heat", "Icebreaker", "Ice Dragon", "Ice Shard", "Luger",
		"Lightbringer", "Nightblade", "Peppermint", "Seer", "Shark",
		"Slasher", "Spider", "Sugar", "Tides", "Winter's Edge", "Xmas"
	},
	
	-- GUNS COMMON
	CommonGuns = {
		"Big Kill", "Cold", "Fallout", "Iron", "Engraved", "Infiltrator",
		"Juice", "Star", "Bit", "HL2", "News", "Pea"
	},
	
	-- GUNS UNCOMMON
	UncommonGuns = {
		"Cane", "Frosty", "Jingle", "Cocoa", "Candle"
	},
	
	-- GUNS RARE
	RareGuns = {
		"Laser", "Lightbringer", "Darkbringer", "Blaster", "Ginger", "Shark"
	},
	
	-- GUNS GODLY
	GodlyGuns = {
		"Traveler's Gun", "Evergun", "Vampire's Gun", "Constellation",
		"Evergreen", "Turkey", "Swirly Gun", "Swirly Blaster", "Iceblaster",
		"Minty", "Luger", "Ew Revolver"
	},
	
	-- GUNS ANCIENT (Event exclusive)
	AncientGuns = {
		"Gingerscope", "Harvester", "Icepiercer"
	}
}

--[========================================================================]
-- SYSTÈME DE CRÉATION D'ARMES VISUELLES
--[========================================================================]

local function createWeaponModel(weaponName, weaponType)
	local model = Instance.new("Model")
	model.Name = weaponName
	
	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Shape = Enum.PartType.Cylinder
	handle.CanCollide = false
	
	-- Style selon le type
	if weaponType == "Knife" then
		handle.Size = Vector3.new(0.4, 0.4, 2.5)
		handle.Color = Color3.fromRGB(200, 50, 50)
		handle.Material = Enum.Material.SmoothPlastic
	else -- Gun
		handle.Size = Vector3.new(0.5, 0.5, 1.5)
		handle.Color = Color3.fromRGB(40, 40, 40)
		handle.Material = Enum.Material.Metal
	end
	
	handle.Parent = model
	model.Parent = localChar
	
	return model
end

local function addWeaponSound(weaponModel, soundName)
	local sound = Instance.new("Sound")
	sound.Name = "WeaponSound"
	
	-- Sons authentiques MM2
	if string.find(soundName, "Knife") then
		sound.SoundId = "rbxassetid://9114340017" -- Son de couteau
	elseif string.find(soundName, "Gun") then
		sound.SoundId = "rbxassetid://131070686" -- Son de tir
	else
		sound.SoundId = "rbxassetid://133903093"
	end
	
	sound.Volume = 0.7
	sound.Parent = weaponModel:FindFirstChild("Handle") or weaponModel
	return sound
end

local function giveWeapon(weaponName, weaponType)
	local weaponModel = createWeaponModel(weaponName, weaponType)
	local sound = addWeaponSound(weaponModel, weaponType)
	
	print("✅ Arme donnée: " .. weaponName .. " (" .. weaponType .. ")")
	
	return {
		model = weaponModel,
		sound = sound,
		name = weaponName,
		type = weaponType
	}
end

--[========================================================================]
-- ARMURERIE - DONNER TOUTES LES ARMES PAR CATÉGORIE
--[========================================================================]

local allWeapons = {}
local weaponsByRarity = {}

local function loadAllWeapons()
	print("\n🔫 ====== CHARGEMENT ARMURERIE COMPLÈTE MM2 ======")
	
	-- COMMON KNIVES
	print("\n🔪 COUTEAUX COMMON:")
	for _, name in ipairs(WEAPONS_DATABASE.CommonKnives) do
		local weapon = giveWeapon(name, "Knife")
		table.insert(allWeapons, weapon)
		if not weaponsByRarity["CommonKnives"] then weaponsByRarity["CommonKnives"] = {} end
		table.insert(weaponsByRarity["CommonKnives"], weapon)
	end
	
	-- UNCOMMON KNIVES
	print("\n🔪 COUTEAUX UNCOMMON:")
	for _, name in ipairs(WEAPONS_DATABASE.UncommonKnives) do
		local weapon = giveWeapon(name, "Knife")
		table.insert(allWeapons, weapon)
		if not weaponsByRarity["UncommonKnives"] then weaponsByRarity["UncommonKnives"] = {} end
		table.insert(weaponsByRarity["UncommonKnives"], weapon)
	end
	
	-- RARE KNIVES
	print("\n🔪 COUTEAUX RARE:")
	for _, name in ipairs(WEAPONS_DATABASE.RareKnives) do
		local weapon = giveWeapon(name, "Knife")
		table.insert(allWeapons, weapon)
		if not weaponsByRarity["RareKnives"] then weaponsByRarity["RareKnives"] = {} end
		table.insert(weaponsByRarity["RareKnives"], weapon)
	end
	
	-- GODLY KNIVES
	print("\n🔪 COUTEAUX GODLY:")
	for _, name in ipairs(WEAPONS_DATABASE.GodlyKnives) do
		local weapon = giveWeapon(name, "Knife")
		table.insert(allWeapons, weapon)
		if not weaponsByRarity["GodlyKnives"] then weaponsByRarity["GodlyKnives"] = {} end
		table.insert(weaponsByRarity["GodlyKnives"], weapon)
	end
	
	-- COMMON GUNS
	print("\n🔫 GUNS COMMON:")
	for _, name in ipairs(WEAPONS_DATABASE.CommonGuns) do
		local weapon = giveWeapon(name, "Gun")
		table.insert(allWeapons, weapon)
		if not weaponsByRarity["CommonGuns"] then weaponsByRarity["CommonGuns"] = {} end
		table.insert(weaponsByRarity["CommonGuns"], weapon)
	end
	
	-- UNCOMMON GUNS
	print("\n🔫 GUNS UNCOMMON:")
	for _, name in ipairs(WEAPONS_DATABASE.UncommonGuns) do
		local weapon = giveWeapon(name, "Gun")
		table.insert(allWeapons, weapon)
		if not weaponsByRarity["UncommonGuns"] then weaponsByRarity["UncommonGuns"] = {} end
		table.insert(weaponsByRarity["UncommonGuns"], weapon)
	end
	
	-- RARE GUNS
	print("\n🔫 GUNS RARE:")
	for _, name in ipairs(WEAPONS_DATABASE.RareGuns) do
		local weapon = giveWeapon(name, "Gun")
		table.insert(allWeapons, weapon)
		if not weaponsByRarity["RareGuns"] then weaponsByRarity["RareGuns"] = {} end
		table.insert(weaponsByRarity["RareGuns"], weapon)
	end
	
	-- GODLY GUNS
	print("\n🔫 GUNS GODLY:")
	for _, name in ipairs(WEAPONS_DATABASE.GodlyGuns) do
		local weapon = giveWeapon(name, "Gun")
		table.insert(allWeapons, weapon)
		if not weaponsByRarity["GodlyGuns"] then weaponsByRarity["GodlyGuns"] = {} end
		table.insert(weaponsByRarity["GodlyGuns"], weapon)
	end
	
	-- ANCIENT GUNS
	print("\n🔫 GUNS ANCIENT:")
	for _, name in ipairs(WEAPONS_DATABASE.AncientGuns) do
		local weapon = giveWeapon(name, "Gun")
		table.insert(allWeapons, weapon)
		if not weaponsByRarity["AncientGuns"] then weaponsByRarity["AncientGuns"] = {} end
		table.insert(weaponsByRarity["AncientGuns"], weapon)
	end
	
	print("\n✨ ARMURERIE CHARGÉE COMPLÈTE!")
	print("📊 Total armes: " .. #allWeapons)
end

--[========================================================================]
-- SYSTÈME D'ÉQUIPEMENT
--[========================================================================]

local currentEquippedWeapon = nil

local function equipWeapon(weaponIndex)
	if weaponIndex < 1 or weaponIndex > #allWeapons then
		print("❌ Index invalide!")
		return
	end
	
	if currentEquippedWeapon and currentEquippedWeapon.model and currentEquippedWeapon.model.Parent then
		currentEquippedWeapon.model.Parent = localChar
	end
	
	local weaponData = allWeapons[weaponIndex]
	if weaponData.model and weaponData.model.Parent then
		local rightHand = localChar:FindFirstChild("RightHand") or localChar:FindFirstChild("Right Arm")
		if rightHand then
			weaponData.model.Parent = rightHand
		end
		weaponData.sound:Play()
	end
	
	currentEquippedWeapon = weaponData
	print("⚔️  Équipé: " .. weaponData.name .. " (" .. weaponData.type .. ")")
end

--[========================================================================]
-- INTERFACE MENU RARITY
--[========================================================================]

local weaponsGui = nil
local currentCategory = nil

local function showWeaponsByRarity(rarityKey)
	if weaponsGui and weaponsGui.Parent then
		weaponsGui:Destroy()
	end
	
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "WeaponsRarityGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
	weaponsGui = screenGui
	
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 500, 0, 700)
	mainFrame.Position = UDim2.new(0.02, 0, 0.1, 0)
	mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screenGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 15)
	corner.Parent = mainFrame
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(100, 200, 255)
	stroke.Thickness = 2
	stroke.Parent = mainFrame
	
	-- TITRE
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, 0, 0, 50)
	title.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
	title.Text = "🔫 " .. rarityKey:gsub("Knives", "Couteaux"):gsub("Guns", "Guns")
	title.TextColor3 = Color3.fromRGB(255, 200, 100)
	title.TextSize = 18
	title.Font = Enum.Font.GothamBold
	title.BorderSizePixel = 0
	title.Parent = mainFrame
	
	-- SCROLLING FRAME
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "WeaponsScroll"
	scrollFrame.Size = UDim2.new(1, -20, 1, -80)
	scrollFrame.Position = UDim2.new(0, 10, 0, 60)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.ScrollBarThickness = 5
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #(weaponsByRarity[rarityKey] or {}) * 45)
	scrollFrame.Parent = mainFrame
	
	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 5)
	listLayout.Parent = scrollFrame
	
	-- CRÉER LES BOUTONS D'ARMES
	if weaponsByRarity[rarityKey] then
		for idx, weaponData in ipairs(weaponsByRarity[rarityKey]) do
			local weaponBtn = Instance.new("TextButton")
			weaponBtn.Name = "Weapon_" .. idx
			weaponBtn.Size = UDim2.new(1, -10, 0, 40)
			weaponBtn.BackgroundColor3 = (weaponData.type == "Knife") and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(50, 100, 200)
			weaponBtn.Text = "  " .. weaponData.name .. " [" .. weaponData.type .. "]"
			weaponBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			weaponBtn.TextSize = 13
			weaponBtn.Font = Enum.Font.GothamSemibold
			weaponBtn.TextXAlignment = Enum.TextXAlignment.Left
			weaponBtn.BorderSizePixel = 0
			weaponBtn.LayoutOrder = idx
			weaponBtn.Parent = scrollFrame
			
			local btnCorner = Instance.new("UICorner")
			btnCorner.CornerRadius = UDim.new(0, 8)
			btnCorner.Parent = weaponBtn
			
			-- TROUVER L'INDEX RÉEL DANS allWeapons
			local realIndex = nil
			for i, w in ipairs(allWeapons) do
				if w.name == weaponData.name and w.type == weaponData.type then
					realIndex = i
					break
				end
			end
			
			weaponBtn.MouseButton1Click:Connect(function()
				if realIndex then
					equipWeapon(realIndex)
				end
			end)
			
			weaponBtn.MouseEnter:Connect(function()
				weaponBtn.BackgroundTransparency = 0.3
			end)
			
			weaponBtn.MouseLeave:Connect(function()
				weaponBtn.BackgroundTransparency = 0
			end)
		end
	end
end

local function createMainMenu()
	if weaponsGui and weaponsGui.Parent then
		weaponsGui:Destroy()
	end
	
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "WeaponsMainGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
	weaponsGui = screenGui
	
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 400, 0, 500)
	mainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
	mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screenGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 15)
	corner.Parent = mainFrame
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(100, 200, 255)
	stroke.Thickness = 2
	stroke.Parent = mainFrame
	
	-- TITRE
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, 0, 0, 50)
	title.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
	title.Text = "🔫 ARMURERIE MM2"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 22
	title.Font = Enum.Font.GothamBold
	title.BorderSizePixel = 0
	title.Parent = mainFrame
	
	-- CATÉGORIES
	local categories = {
		"CommonKnives", "UncommonKnives", "RareKnives", "GodlyKnives",
		"CommonGuns", "UncommonGuns", "RareGuns", "GodlyGuns", "AncientGuns"
	}
	
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "CategoriesScroll"
	scrollFrame.Size = UDim2.new(1, -20, 1, -80)
	scrollFrame.Position = UDim2.new(0, 10, 0, 60)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.ScrollBarThickness = 5
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #categories * 55)
	scrollFrame.Parent = mainFrame
	
	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 8)
	listLayout.Parent = scrollFrame
	
	for _, category in ipairs(categories) do
		local catBtn = Instance.new("TextButton")
		catBtn.Name = "Cat_" .. category
		catBtn.Size = UDim2.new(1, -10, 0, 50)
		catBtn.BackgroundColor3 = Color3.fromRGB(40, 50, 100)
		catBtn.Text = "📦 " .. category:gsub("Knives", "Couteaux"):gsub("Guns", "Guns") .. " (" .. #(weaponsByRarity[category] or {}) .. ")"
		catBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		catBtn.TextSize = 14
		catBtn.Font = Enum.Font.GothamBold
		catBtn.BorderSizePixel = 0
		catBtn.Parent = scrollFrame
		
		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 8)
		btnCorner.Parent = catBtn
		
		catBtn.MouseButton1Click:Connect(function()
			showWeaponsByRarity(category)
		end)
		
		catBtn.MouseEnter:Connect(function()
			catBtn.BackgroundColor3 = Color3.fromRGB(60, 80, 150)
		end)
		
		catBtn.MouseLeave:Connect(function()
			catBtn.BackgroundColor3 = Color3.fromRGB(40, 50, 100)
		end)
	end
end

--[========================================================================]
-- TOUCHES DE CONTRÔLE
--[========================================================================]

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	-- [K] Charger armurerie
	if input.KeyCode == Enum.KeyCode.K then
		print("⏳ Chargement armurerie...")
		loadAllWeapons()
	end
	
	-- [L] Ouvrir menu
	if input.KeyCode == Enum.KeyCode.L then
		createMainMenu()
	end
	
	-- [U] Fermer menu
	if input.KeyCode == Enum.KeyCode.U then
		if weaponsGui and weaponsGui.Parent then
			weaponsGui:Destroy()
			weaponsGui = nil
		end
	end
end)

--[========================================================================]
-- MISE À JOUR PERSONNAGE
--[========================================================================]

localPlayer.CharacterAdded:Connect(function(newChar)
	localChar = newChar
	allWeapons = {}
	weaponsByRarity = {}
	currentEquippedWeapon = nil
end)

--[========================================================================]
-- DÉMARRAGE
--[========================================================================]

print("✅ Script Armurerie MM2 COMPLÈTE chargé!")
print("\n⌨️  TOUCHES:")
print("   [K] = Charger TOUTES les armes (attendez 5 sec)")
print("   [L] = Ouvrir menu armurerie")
print("   [U] = Fermer menu")
print("\n📊 Armes disponibles:")
print("   - Couteaux Common/Uncommon/Rare/Godly")
print("   - Guns Common/Uncommon/Rare/Godly/Ancient")
print("\n🎮 Cliquez sur une arme pour l'équiper + son jouera!")
