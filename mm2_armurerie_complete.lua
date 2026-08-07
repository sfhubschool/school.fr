--[========================================================================]
-- ⚡ MM2 ARMURERIE COMPLÈTE - GIVE ALL WEAPONS + SONS SPÉCIFIQUES
--[========================================================================]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local localChar = localPlayer.Character or localPlayer.CharacterAdded:Wait()

--[========================================================================]
-- DATABASE DES ARMES MM2 AVEC SONS SPÉCIFIQUES
--[========================================================================]

local WEAPONS_DATABASE = {
	-- COUTEAUX (Murderer)
	Knives = {
		{name = "Knife", sound = "rbxassetid://133903093", volume = 0.5}, -- Son classique
		{name = "CottonCandy", sound = "rbxassetid://138092017", volume = 0.6},
		{name = "Luger", sound = "rbxassetid://138092014", volume = 0.7},
		{name = "Hallows", sound = "rbxassetid://138092015", volume = 0.6},
		{name = "Peppermint", sound = "rbxassetid://138092016", volume = 0.6},
		{name = "Clown", sound = "rbxassetid://138092013", volume = 0.5},
		{name = "Timekeeper", sound = "rbxassetid://138092018", volume = 0.7},
		{name = "HeartBeat", sound = "rbxassetid://138092019", volume = 0.6},
	},
	
	-- GUNS/REVOLVERS (Sheriff)
	Guns = {
		{name = "Gun", sound = "rbxassetid://138092020", volume = 0.8}, -- Son de tir classique
		{name = "Revolver", sound = "rbxassetid://138092021", volume = 0.8},
		{name = "Luger", sound = "rbxassetid://138092022", volume = 0.8},
		{name = "Hallows", sound = "rbxassetid://138092023", volume = 0.8},
		{name = "Peppermint", sound = "rbxassetid://138092024", volume = 0.8},
		{name = "Clown", sound = "rbxassetid://138092025", volume = 0.8},
		{name = "Timekeeper", sound = "rbxassetid://138092026", volume = 0.8},
		{name = "HeartBeat", sound = "rbxassetid://138092027", volume = 0.8},
	},
	
	-- AUTRES ARMES SPÉCIALES
	Special = {
		{name = "Gun", sound = "rbxassetid://138092020", volume = 0.8},
		{name = "Knife", sound = "rbxassetid://133903093", volume = 0.5},
	}
}

--[========================================================================]
-- SYSTÈME DE CRÉATION D'ARMES VISUELLES
--[========================================================================]

local function createWeaponModel(weaponName, weaponType)
	-- Créer un modèle simple pour l'arme
	local model = Instance.new("Model")
	model.Name = weaponName
	
	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Shape = Enum.PartType.Cylinder
	handle.Size = Vector3.new(0.5, 0.5, 2)
	
	-- Couleurs selon le type
	if weaponType == "Knife" then
		handle.Color = Color3.fromRGB(200, 50, 50) -- Rouge pour couteau
		handle.Material = Enum.Material.SmoothPlastic
	else -- Gun
		handle.Color = Color3.fromRGB(50, 50, 50) -- Gris pour gun
		handle.Material = Enum.Material.Metal
	end
	
	handle.CanCollide = false
	handle.Parent = model
	
	model.Parent = localChar
	
	return model
end

local function addWeaponSound(weaponModel, soundId, volume)
	local sound = Instance.new("Sound")
	sound.Name = "WeaponSound"
	sound.SoundId = soundId
	sound.Volume = volume
	sound.Parent = weaponModel:FindFirstChild("Handle") or weaponModel
	return sound
end

local function giveWeapon(weaponName, weaponType, soundId, volume)
	-- Créer le modèle visuel
	local weaponModel = createWeaponModel(weaponName, weaponType)
	
	-- Ajouter le son
	local sound = addWeaponSound(weaponModel, soundId, volume)
	
	print("✅ Arme donnée: " .. weaponName .. " | Son: " .. soundId)
	
	return weaponModel, sound
end

--[========================================================================]
-- FONCTION POUR DONNER TOUTES LES ARMES
--[========================================================================]

local allWeapons = {}

local function giveAllWeapons()
	print("🔫 Donnée de TOUTES les armes...")
	
	-- Donner tous les couteaux
	print("\n🔪 Couteaux:")
	for _, knife in ipairs(WEAPONS_DATABASE.Knives) do
		local model, sound = giveWeapon(knife.name, "Knife", knife.sound, knife.volume)
		table.insert(allWeapons, {model = model, sound = sound, name = knife.name, type = "Knife"})
		print("   ✅ " .. knife.name)
	end
	
	-- Donner tous les guns
	print("\n🔫 Guns/Revolvers:")
	for _, gun in ipairs(WEAPONS_DATABASE.Guns) do
		local model, sound = giveWeapon(gun.name, "Gun", gun.sound, gun.volume)
		table.insert(allWeapons, {model = model, sound = sound, name = gun.name, type = "Gun"})
		print("   ✅ " .. gun.name)
	end
	
	print("\n✨ Toutes les armes ont été données!")
	print("📊 Total: " .. #allWeapons .. " armes")
end

--[========================================================================]
-- SYSTÈME D'ÉQUIPEMENT/DÉSÉQUIPEMENT
--[========================================================================]

local currentEquippedWeapon = nil

local function equipWeapon(weaponIndex)
	if weaponIndex < 1 or weaponIndex > #allWeapons then
		print("❌ Index invalide!")
		return
	end
	
	-- Déséquiper l'arme actuelle
	if currentEquippedWeapon then
		if currentEquippedWeapon.model and currentEquippedWeapon.model.Parent then
			currentEquippedWeapon.model.Parent = localChar
		end
	end
	
	-- Équiper la nouvelle arme
	local weaponData = allWeapons[weaponIndex]
	if weaponData.model and weaponData.model.Parent then
		-- Attacher à la main
		local rightHand = localChar:FindFirstChild("RightHand") or localChar:FindFirstChild("Right Arm")
		if rightHand then
			weaponData.model.Parent = rightHand
		end
	end
	
	currentEquippedWeapon = weaponData
	print("⚔️  Arme équipée: " .. weaponData.name)
end

--[========================================================================]
-- SYSTÈME DE SON CONTEXTUEL
--[========================================================================]

local function playWeaponSound(weaponIndex)
	if weaponIndex < 1 or weaponIndex > #allWeapons then return end
	
	local weaponData = allWeapons[weaponIndex]
	if weaponData.sound then
		weaponData.sound:Play()
	end
end

--[========================================================================]
-- INTERFACE VISUELLE - AFFICHER LES ARMES
--[========================================================================]

local weaponsGui = nil

local function createWeaponsGui()
	if weaponsGui and weaponsGui.Parent then
		return -- GUI déjà créé
	end
	
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "WeaponsMenuGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
	weaponsGui = screenGui
	
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 400, 0, 600)
	mainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
	mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screenGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 15)
	corner.Parent = mainFrame
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(100, 200, 255)
	stroke.Thickness = 2
	stroke.Parent = mainFrame
	
	-- Titre
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, 0, 0, 50)
	title.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
	title.Text = "🔫 ARMURERIE MM2"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 20
	title.Font = Enum.Font.GothamBold
	title.BorderSizePixel = 0
	title.Parent = mainFrame
	
	-- ScrollingFrame pour les armes
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "WeaponsScroll"
	scrollFrame.Size = UDim2.new(1, -20, 1, -80)
	scrollFrame.Position = UDim2.new(0, 10, 0, 60)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.ScrollBarThickness = 5
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #allWeapons * 50)
	scrollFrame.Parent = mainFrame
	
	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 8)
	listLayout.Parent = scrollFrame
	
	-- Créer un bouton pour chaque arme
	for i, weaponData in ipairs(allWeapons) do
		local weaponBtn = Instance.new("TextButton")
		weaponBtn.Name = "Weapon_" .. i
		weaponBtn.Size = UDim2.new(1, -10, 0, 45)
		weaponBtn.BackgroundColor3 = Color3.fromRGB(40, 50, 80)
		weaponBtn.Text = (i) .. ". " .. weaponData.name .. " [" .. weaponData.type .. "]"
		weaponBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		weaponBtn.TextSize = 14
		weaponBtn.Font = Enum.Font.GothamSemibold
		weaponBtn.BorderSizePixel = 0
		weaponBtn.LayoutOrder = i
		weaponBtn.Parent = scrollFrame
		
		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 8)
		btnCorner.Parent = weaponBtn
		
		weaponBtn.MouseButton1Click:Connect(function()
			equipWeapon(i)
			playWeaponSound(i)
			weaponBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
			task.wait(0.2)
			weaponBtn.BackgroundColor3 = Color3.fromRGB(40, 50, 80)
		end)
		
		weaponBtn.MouseEnter:Connect(function()
			weaponBtn.BackgroundColor3 = Color3.fromRGB(60, 80, 120)
		end)
		
		weaponBtn.MouseLeave:Connect(function()
			weaponBtn.BackgroundColor3 = Color3.fromRGB(40, 50, 80)
		end)
	end
	
	-- Bouton fermer
	local closeBtn = Instance.new("TextButton")
	closeBtn.Name = "CloseButton"
	closeBtn.Size = UDim2.new(0, 80, 0, 35)
	closeBtn.Position = UDim2.new(0.5, -40, 1, -40)
	closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	closeBtn.Text = "FERMER"
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.TextSize = 12
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.BorderSizePixel = 0
	closeBtn.Parent = mainFrame
	
	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 8)
	closeCorner.Parent = closeBtn
	
	closeBtn.MouseButton1Click:Connect(function()
		screenGui:Destroy()
		weaponsGui = nil
	end)
end

--[========================================================================]
-- TOUCHES DE CONTRÔLE
--[========================================================================]

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	-- [K] Give All Weapons
	if input.KeyCode == Enum.KeyCode.K then
		giveAllWeapons()
	end
	
	-- [L] Ouvrir menu des armes
	if input.KeyCode == Enum.KeyCode.L then
		createWeaponsGui()
	end
	
	-- [Chiffres 1-9] Équiper rapidement
	local keyNum = tonumber(input.KeyCode.Name:match("%d"))
	if keyNum and keyNum >= 1 and keyNum <= 9 then
		equipWeapon(keyNum)
		playWeaponSound(keyNum)
	end
end)

--[========================================================================]
-- MISE À JOUR PERSONNAGE
--[========================================================================]

localPlayer.CharacterAdded:Connect(function(newChar)
	localChar = newChar
	allWeapons = {}
	currentEquippedWeapon = nil
end)

--[========================================================================]
-- MESSAGE DE BIENVENUE
--[========================================================================]

print("✅ Script Armurerie MM2 chargé!")
print("⌨️  Touches disponibles:")
print("   [K] = Donner TOUTES les armes")
print("   [L] = Ouvrir menu des armes")
print("   [1-9] = Équiper arme rapidement")
print("🔫 Prêt à combattre!")
