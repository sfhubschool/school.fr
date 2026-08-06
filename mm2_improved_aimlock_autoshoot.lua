--[========================================================================]
-- ⚡ vbnx V2 - AIMLOCK + AUTO SHOOT UNIFIÉ + AUTO GRAB GUN OPTIMISÉ
--[========================================================================]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Camera = Workspace.CurrentCamera

local localPlayer = Players.LocalPlayer
local localChar = localPlayer.Character or localPlayer.CharacterAdded:Wait()

--[========================================================================]
-- CONFIGURATION AIMLOCK + AUTO SHOOT UNIFIÉ
--[========================================================================]

local AIM_CONFIG = {
	ENABLED = false,
	AUTO_SHOOT_ENABLED = false,
	
	-- Prédiction balistique
	BULLET_SPEED = 100, -- Vitesse de la balle
	GRAVITY = Vector3.new(0, -196.2, 0), -- Gravité du jeu
	
	-- Paramètres d'aim
	LEAD_MULTIPLIER = 1.2, -- Multiplicateur de prédiction
	SMOOTHING = 0.15, -- Lissage du mouvement de caméra (0-1, plus bas = plus fluide)
	FOV = 500, -- Champ de vision pour détecter les cibles
	
	-- Auto shoot
	SHOOT_DELAY = 0.1, -- Délai entre les tirs (en secondes)
	SHOOT_DISTANCE = 100, -- Distance max pour auto shoot
	
	-- Auto grab gun
	AUTO_GRAB_ENABLED = false,
	GRAB_SPEED = 200, -- Vitesse du TP sur le gun
	RETURN_SPEED = 250, -- Vitesse de retour à la position d'origine
}

--[========================================================================]
-- SYSTÈME DE PRÉDICTION BALISTIQUE AVANCÉ
--[========================================================================]

local function calculateBulletTrajectory(shooterPos, targetPos, targetVel, bulletSpeed, gravity)
	-- Calcul de la position future de la cible
	local relativePos = targetPos - shooterPos
	local a = gravity.Magnitude * gravity.Magnitude / 4
	local b = -2 * Vector3.new(gravity.X, gravity.Y, gravity.Z):Dot(targetVel)
	local c = targetVel:Dot(targetVel) - bulletSpeed * bulletSpeed
	
	-- Résoudre l'équation quadratique pour le temps de vol
	local discriminant = b * b - 4 * a * c
	if discriminant < 0 then
		return targetPos -- Impossible à atteindre, retourner position actuelle
	end
	
	local t = (-b - math.sqrt(discriminant)) / (2 * a)
	if t < 0 then t = (-b + math.sqrt(discriminant)) / (2 * a) end
	if t < 0 then t = 0.1 end
	
	-- Position prédite avec facteur de lead
	local predictedPos = targetPos + (targetVel * t * AIM_CONFIG.LEAD_MULTIPLIER)
	
	return predictedPos
end

local function getTargetData()
	local closestPlayer = nil
	local closestDistance = AIM_CONFIG.FOV
	local targetVelocity = Vector3.new(0, 0, 0)
	
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character then
			local char = player.Character
			local hum = char:FindFirstChildOfClass("Humanoid")
			local rootPart = char:FindFirstChild("HumanoidRootPart")
			
			if hum and hum.Health > 0 and rootPart then
				local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
				
				-- Vérifier si c'est un Murderer ou Sheriff
				local hasGun = false
				local hasKnife = false
				
				for _, item in ipairs(char:GetChildren()) do
					if item:IsA("Tool") then
						local name = item.Name:lower()
						if name == "gun" or name == "revolver" then hasGun = true
						elseif name == "knife" or name:find("couteau") then hasKnife = true end
					end
				end
				
				-- Cibler en priorité le Sheriff/Murderer à portée
				if distance < closestDistance then
					if hasGun or hasKnife then
						closestPlayer = player
						closestDistance = distance
						targetVelocity = rootPart.AssemblyLinearVelocity
					end
				end
			end
		end
	end
	
	return closestPlayer, closestDistance, targetVelocity
end

local function updateAimlock()
	if not AIM_CONFIG.ENABLED and not AIM_CONFIG.AUTO_SHOOT_ENABLED then return end
	
	local target, distance, targetVel = getTargetData()
	if not target or not target.Character then return end
	
	local targetChar = target.Character
	local targetHead = targetChar:FindFirstChild("Head") or targetChar:FindFirstChild("HumanoidRootPart")
	
	if not targetHead then return end
	
	-- Calculer la position prédite avec balistique avancée
	local shooterPos = localChar:FindFirstChild("HumanoidRootPart").Position + Vector3.new(0, 1.5, 0)
	local predictedPos = calculateBulletTrajectory(shooterPos, targetHead.Position, targetVel, AIM_CONFIG.BULLET_SPEED, AIM_CONFIG.GRAVITY)
	
	-- Mode Aimlock : Tourner la caméra
	if AIM_CONFIG.ENABLED then
		local dirToTarget = (predictedPos - Camera.CFrame.Position).Unit
		local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, Camera.CFrame.Position + dirToTarget)
		Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, AIM_CONFIG.SMOOTHING)
	end
	
	-- Mode Auto Shoot : Tirer automatiquement
	if AIM_CONFIG.AUTO_SHOOT_ENABLED and distance < AIM_CONFIG.SHOOT_DISTANCE then
		local gun = localChar:FindFirstChild("Gun") or localChar:FindFirstChild("Revolver")
		if gun and gun:FindFirstChild("Fire") then
			gun.Fire:FireServer(predictedPos)
		end
	end
end

--[========================================================================]
-- AUTO GRAB GUN OPTIMISÉ
--[========================================================================]

local lastGrabTime = 0
local originalPosition = nil
local isReturning = false

local function autoGrabGun()
	if not AIM_CONFIG.AUTO_GRAB_ENABLED then return end
	
	local currentTime = tick()
	if currentTime - lastGrabTime < 0.5 then return end -- Anti-spam
	
	local gunInWorkspace = nil
	
	-- Chercher le gun dans le workspace
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj.Name == "Gun" or obj.Name == "Revolver" then
			if obj:IsA("Model") or obj:IsA("BasePart") then
				gunInWorkspace = obj
				break
			end
		end
	end
	
	if gunInWorkspace then
		lastGrabTime = currentTime
		
		-- Sauvegarder la position d'origine
		local rootPart = localChar:FindFirstChild("HumanoidRootPart")
		if rootPart then
			originalPosition = rootPart.CFrame
		end
		
		-- Étape 1 : TP sur le gun
		if rootPart then
			local gunPos = gunInWorkspace:IsA("Model") and gunInWorkspace:FindFirstChild("Handle") or gunInWorkspace
			if gunPos then
				rootPart.CFrame = gunPos.CFrame + Vector3.new(0, 3, 0)
				
				-- Attendre et prendre le gun
				task.wait(0.1)
				if gunInWorkspace.Parent then
					gunInWorkspace.Parent = localChar
				end
				
				-- Étape 2 : Retour à la position avec vitesse éclair
				isReturning = true
				local startTime = tick()
				local returnDuration = 0.3 -- 300ms pour le retour ultra-rapide
				
				while isReturning and tick() - startTime < returnDuration do
					if rootPart and originalPosition then
						local progress = (tick() - startTime) / returnDuration
						rootPart.CFrame = rootPart.CFrame:Lerp(originalPosition, progress)
						rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
					end
					task.wait()
				end
				
				if rootPart and originalPosition then
					rootPart.CFrame = originalPosition
				end
				isReturning = false
			end
		end
	end
end

--[========================================================================]
-- BOUCLE DE MISE À JOUR PRINCIPALE
--[========================================================================]

RunService.RenderStepped:Connect(function()
	pcall(function()
		if localPlayer.Character then
			localChar = localPlayer.Character
			
			-- Mise à jour aimlock + auto shoot (même calcul)
			updateAimlock()
			
			-- Auto grab gun
			autoGrabGun()
		end
	end)
end)

--[========================================================================]
-- TOUCHES DE CONTRÔLE
--[========================================================================]

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	-- [G] Toggle Aimlock
	if input.KeyCode == Enum.KeyCode.G then
		AIM_CONFIG.ENABLED = not AIM_CONFIG.ENABLED
		print("🎯 Aimlock: " .. (AIM_CONFIG.ENABLED and "ON" or "OFF"))
	end
	
	-- [H] Toggle Auto Shoot
	if input.KeyCode == Enum.KeyCode.H then
		AIM_CONFIG.AUTO_SHOOT_ENABLED = not AIM_CONFIG.AUTO_SHOOT_ENABLED
		print("💥 Auto Shoot: " .. (AIM_CONFIG.AUTO_SHOOT_ENABLED and "ON" or "OFF"))
	end
	
	-- [J] Toggle Auto Grab Gun
	if input.KeyCode == Enum.KeyCode.J then
		AIM_CONFIG.AUTO_GRAB_ENABLED = not AIM_CONFIG.AUTO_GRAB_ENABLED
		print("🔫 Auto Grab Gun: " .. (AIM_CONFIG.AUTO_GRAB_ENABLED and "ON" or "OFF"))
	end
end)

print("✅ Script chargé! Touches: [G]=Aimlock, [H]=AutoShoot, [J]=AutoGrabGun")
