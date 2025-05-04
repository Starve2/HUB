local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "UniversalTeleportGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Основной фрейм
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 450)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.BackgroundTransparency = 0.7
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

-- Закругление углов
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Вкладки
local tabButtonsFrame = Instance.new("Frame")
tabButtonsFrame.Size = UDim2.new(0.9, 0, 0.08, 0)
tabButtonsFrame.Position = UDim2.new(0.05, 0, 0.02, 0)
tabButtonsFrame.BackgroundTransparency = 1
tabButtonsFrame.Parent = mainFrame

local enemyTabButton = Instance.new("TextButton")
enemyTabButton.Size = UDim2.new(0.48, 0, 1, 0)
enemyTabButton.Position = UDim2.new(0, 0, 0, 0)
enemyTabButton.Text = "Enemy tp"
enemyTabButton.TextColor3 = Color3.new(1, 1, 1)
enemyTabButton.BackgroundColor3 = Color3.fromRGB(30, 136, 229)
enemyTabButton.Font = Enum.Font.GothamBold
enemyTabButton.TextSize = 14
enemyTabButton.Parent = tabButtonsFrame

local oreTabButton = Instance.new("TextButton")
oreTabButton.Size = UDim2.new(0.48, 0, 1, 0)
oreTabButton.Position = UDim2.new(0.52, 0, 0, 0)
oreTabButton.Text = "Ore tp"
oreTabButton.TextColor3 = Color3.new(1, 1, 1)
oreTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
oreTabButton.Font = Enum.Font.Gotham
oreTabButton.TextSize = 14
oreTabButton.Parent = tabButtonsFrame

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 6)
tabCorner.Parent = enemyTabButton
tabCorner:Clone().Parent = oreTabButton

-- Контейнер для контента вкладок
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0.9, 0, 0.85, 0)
contentFrame.Position = UDim2.new(0.05, 0, 0.12, 0)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Enemy TP Content
local enemyContent = Instance.new("Frame")
enemyContent.Size = UDim2.new(1, 0, 1, 0)
enemyContent.BackgroundTransparency = 1
enemyContent.Visible = true
enemyContent.Parent = contentFrame

-- Ore TP Content
local oreContent = Instance.new("Frame")
oreContent.Size = UDim2.new(1, 0, 1, 0)
oreContent.BackgroundTransparency = 1
oreContent.Visible = false
oreContent.Parent = contentFrame

-- Enemy TP Script
do
    -- Полный список врагов с разделением по локациям
    local enemiesByLocation = {
        ["Main Forest"] = {"Cubey Bandit", "Cylindery", "Cubey", "Wedgey", "Field Mousey", "Flying Goldfish", "Wooden Mimic"},
        ["Cave"] = {"Cavey", "Spidey", "Bonezo", "Cave Spidey"},
        ["Forest"] = {"Mini Cubey", "Cubey Mage", "Ghostey"},
        ["Redwood Forest"] = {"Mini Leafy", "Buney", "Cublin", "Cublin Warrior", "Cublin Brute", "Angry Wasp", "Redwood Mimic"},
        ["Flowey Fields"] = {"Rogue Cubey", "Stoney", "Flowey", "Blooming Flowey", "Fire Flowey", "Cubee", "Bumblecubee", "Buney", "Ghostey", "Flying Goldfish", "Bloom Mimic", "Honey Mimic"},
        ["Ballzone"] = {"Rustey", "Ballzo", "Ballzo Warrior", "Flying Goldfish", "Frogey", "Mushey", "Browncapey", "Swamp Hydrey", "Lilypadey", "Ghostey"},
        ["Mushey Hills"] = {"Mushmasher", "Bluecapey", "Big Mushman", "Mystic Mimic"},
        ["Cherry Falls"] = {"Flying Goldfish", "Blossom Keeper", "Petalith", "Floral Turtley"},
        ["Glimmering Tundra"] = {"Icy Snail", "Frost Buney", "Snowdeerey", "Ice Lizardey"},
        ["Wretched Woods"] = {"Parawalker", "Watchstalker", "Pestililypadey", "Ghostey"},
        ["Desert Of Shadows"] = {"Scorpion", "Rustey", "Solar Elemental", "Vampiric Druid", "Wraithhorn", "Tumblezo", "Mousey", "Vampiric Outlaw"},
        ["Cacti Forest"] = {"Prickley", "El Espinoso"},
        ["Coconut Bay"] = {"Moai"}
    }

    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0.06, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.Text = "Телепорт к врагам"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Parent = enemyContent

    -- Фрейм для вкладок биомов
    local biomeTabsFrame = Instance.new("Frame")
    biomeTabsFrame.Size = UDim2.new(1, 0, 0.1, 0)
    biomeTabsFrame.Position = UDim2.new(0, 0, 0.06, 0)
    biomeTabsFrame.BackgroundTransparency = 1
    biomeTabsFrame.Parent = enemyContent

    -- Список врагов
    local enemiesScrollFrame = Instance.new("ScrollingFrame")
    enemiesScrollFrame.Size = UDim2.new(1, 0, 0.72, 0)
    enemiesScrollFrame.Position = UDim2.new(0, 0, 0.16, 0)
    enemiesScrollFrame.BackgroundTransparency = 1
    enemiesScrollFrame.ScrollBarThickness = 6
    enemiesScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    enemiesScrollFrame.Parent = enemyContent

    -- Контейнеры для каждого биома
    local biomeContents = {}
    local biomeButtons = {}

    -- Функция создания контента для биома
    local function createBiomeContent(biomeName, enemies)
        local contentFrame = Instance.new("Frame")
        contentFrame.Size = UDim2.new(1, 0, 1, 0)
        contentFrame.BackgroundTransparency = 1
        contentFrame.Visible = false
        contentFrame.Parent = enemiesScrollFrame

        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1, 0, 1, 0)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.ScrollBarThickness = 6
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        scrollFrame.Parent = contentFrame

        -- Сортировка врагов по алфавиту
        table.sort(enemies)

        -- Создаем кнопки для врагов
        local buttonHeight = 32
        local spacing = 5
        local totalHeight = 0

        for _, enemyName in ipairs(enemies) do
            local enemyButton = Instance.new("TextButton")
            enemyButton.Size = UDim2.new(1, -10, 0, buttonHeight)
            enemyButton.Position = UDim2.new(0, 5, 0, totalHeight)
            enemyButton.Text = enemyName
            enemyButton.TextColor3 = Color3.new(1, 1, 1)
            enemyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            enemyButton.Font = Enum.Font.Gotham
            enemyButton.TextSize = 12
            enemyButton.TextXAlignment = Enum.TextXAlignment.Left
            enemyButton.Parent = scrollFrame
            
            enemyButton.MouseButton1Click:Connect(function()
                if not player.Character then
                    enemyButton.Text = "Нет персонажа!"
                    task.wait(1)
                    enemyButton.Text = enemyName
                    return
                end
                
                local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPart then
                    enemyButton.Text = "Нет HRP!"
                    task.wait(1)
                    enemyButton.Text = enemyName
                    return
                end
                
                enemyButton.Text = "Поиск "..enemyName.."..."
                task.wait(0.1)
                
                local enemy = findNearestEnemy(enemyName)
                if enemy then
                    humanoidRootPart.CFrame = enemy.CFrame + Vector3.new(0, 3, 0)
                    enemyButton.Text = enemyName.." ✓"
                    task.wait(1)
                    enemyButton.Text = enemyName
                else
                    enemyButton.Text = enemyName.." не найден!"
                    task.wait(1)
                    enemyButton.Text = enemyName
                end
            end)
            
            totalHeight = totalHeight + buttonHeight + spacing
        end

        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
        return contentFrame
    end

    -- Функция поиска ближайшего врага по имени
    local function findNearestEnemy(enemyName)
        local areas = workspace:FindFirstChild("Areas")
        if not areas then return nil end
        
        local nearestEnemy = nil
        local shortestDistance = math.huge
        
        for _, area in ipairs(areas:GetChildren()) do
            local enemiesFolder = area:FindFirstChild("Enemies")
            if enemiesFolder then
                for _, enemy in ipairs(enemiesFolder:GetDescendants()) do
                    if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") then
                        local displayName = enemy.Name
                        
                        if enemy:FindFirstChild("DisplayName") then
                            displayName = enemy.DisplayName.Value
                        elseif enemy:FindFirstChild("NameTag") then
                            displayName = enemy.NameTag.Text
                        end
                        
                        if string.lower(displayName) == string.lower(enemyName) then
                            local distance = (enemy.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                nearestEnemy = enemy.HumanoidRootPart
                            end
                        end
                    end
                end
            end
        end
        
        return nearestEnemy
    end

    -- Создаем вкладки для каждого биома
    local biomeNames = {}
    for biomeName in pairs(enemiesByLocation) do
        table.insert(biomeNames, biomeName)
    end
    table.sort(biomeNames)

    local buttonWidth = 1 / #biomeNames
    for i, biomeName in ipairs(biomeNames) do
        local biomeButton = Instance.new("TextButton")
        biomeButton.Size = UDim2.new(buttonWidth - 0.02, 0, 1, 0)
        biomeButton.Position = UDim2.new((i-1)*buttonWidth + 0.01, 0, 0, 0)
        biomeButton.Text = biomeName
        biomeButton.TextColor3 = Color3.new(1, 1, 1)
        biomeButton.BackgroundColor3 = i == 1 and Color3.fromRGB(30, 136, 229) or Color3.fromRGB(60, 60, 60)
        biomeButton.Font = Enum.Font.Gotham
        biomeButton.TextSize = 11
        biomeButton.TextWrapped = true
        biomeButton.Parent = biomeTabsFrame

        local biomeContent = createBiomeContent(biomeName, enemiesByLocation[biomeName])
        biomeContents[biomeName] = biomeContent

        biomeButton.MouseButton1Click:Connect(function()
            for name, content in pairs(biomeContents) do
                content.Visible = false
            end
            biomeContent.Visible = true

            for _, btn in ipairs(biomeTabsFrame:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = btn == biomeButton and Color3.fromRGB(30, 136, 229) or Color3.fromRGB(60, 60, 60)
                end
            end
        end)

        if i == 1 then
            biomeContent.Visible = true
        end
    end

    -- Кнопка обновления
    local refreshButton = Instance.new("TextButton")
    refreshButton.Size = UDim2.new(1, 0, 0.08, 0)
    refreshButton.Position = UDim2.new(0, 0, 0.92, 0)
    refreshButton.Text = "Обновить список врагов"
    refreshButton.TextColor3 = Color3.new(1, 1, 1)
    refreshButton.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
    refreshButton.Font = Enum.Font.Gotham
    refreshButton.TextSize = 14
    refreshButton.Parent = enemyContent

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = refreshButton

    refreshButton.MouseButton1Click:Connect(function()
        -- Можно добавить логику обновления при необходимости
    end)
end

-- Ore TP Script (оставляем без изменений)
do
    -- Полный список руд (включая Gravel и Sand)
    local oreList = {
        "Amethyst", "Iron", "Rock", "Blood Stone", "Salt Rock",
        "Emerald", "Sapphire", "Obsidian", "Diamond", "Gold",
        "Tin", "Magnetite", "Valerion", "Dark Geode", "Gravel", "Sand"
    }

    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0.08, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.Text = "Телепорт к ресурсам"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Parent = oreContent

    -- Список руд
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 0.8, 0)
    scrollFrame.Position = UDim2.new(0, 0, 0.1, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.Parent = oreContent

    -- Функция поиска ближайшей руды указанного типа
    local function findNearestOre(oreType)
        local resourceSpawns = workspace:FindFirstChild("ResourceSpawns")
        if not resourceSpawns then return nil end
        
        local nearestOre = nil
        local shortestDistance = math.huge
        
        for _, zone in ipairs(resourceSpawns:GetChildren()) do
            for _, child in ipairs(zone:GetDescendants()) do
                if child.Name == "CurrentResources" then
                    local ore = child:FindFirstChild(oreType)
                    if ore then
                        local center = ore:FindFirstChild("Center") or ore
                        if center:IsA("BasePart") then
                            local distance = (center.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                nearestOre = center
                            end
                        end
                    end
                end
            end
        end
        
        return nearestOre
    end

    -- Создаем кнопки для всех видов руд
    local buttonHeight = 35
    local spacing = 5
    local totalHeight = 0

    for _, oreName in ipairs(oreList) do
        local oreButton = Instance.new("TextButton")
        oreButton.Size = UDim2.new(1, -10, 0, buttonHeight)
        oreButton.Position = UDim2.new(0, 5, 0, totalHeight)
        oreButton.Text = oreName
        oreButton.TextColor3 = Color3.new(1, 1, 1)
        oreButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        oreButton.Font = Enum.Font.Gotham
        oreButton.TextSize = 14
        oreButton.TextXAlignment = Enum.TextXAlignment.Left
        oreButton.Parent = scrollFrame
        
        oreButton.MouseButton1Click:Connect(function()
            if not player.Character then
                oreButton.Text = "Нет персонажа!"
                task.wait(1)
                oreButton.Text = oreName
                return
            end
            
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then
                oreButton.Text = "Нет HRP!"
                task.wait(1)
                oreButton.Text = oreName
                return
            end
            
            oreButton.Text = "Поиск "..oreName.."..."
            task.wait(0.1)
            
            local ore = findNearestOre(oreName)
            if ore then
                humanoidRootPart.CFrame = ore.CFrame + Vector3.new(0, 3, 0)
                oreButton.Text = oreName.." ✓"
                task.wait(1)
                oreButton.Text = oreName
            else
                oreButton.Text = oreName.." не найдена!"
                task.wait(1)
                oreButton.Text = oreName
            end
        end)
        
        totalHeight = totalHeight + buttonHeight + spacing
    end

    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)

    -- Кнопка обновления
    local refreshButton = Instance.new("TextButton")
    refreshButton.Size = UDim2.new(1, 0, 0.08, 0)
    refreshButton.Position = UDim2.new(0, 0, 0.9, 0)
    refreshButton.Text = "Обновить список руд"
    refreshButton.TextColor3 = Color3.new(1, 1, 1)
    refreshButton.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
    refreshButton.Font = Enum.Font.Gotham
    refreshButton.TextSize = 14
    refreshButton.Parent = oreContent

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = refreshButton
end

-- Переключение вкладок
enemyTabButton.MouseButton1Click:Connect(function()
    enemyContent.Visible = true
    oreContent.Visible = false
    enemyTabButton.BackgroundColor3 = Color3.fromRGB(30, 136, 229)
    oreTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    enemyTabButton.Font = Enum.Font.GothamBold
    oreTabButton.Font = Enum.Font.Gotham
end)

oreTabButton.MouseButton1Click:Connect(function()
    enemyContent.Visible = false
    oreContent.Visible = true
    enemyTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    oreTabButton.BackgroundColor3 = Color3.fromRGB(30, 136, 229)
    enemyTabButton.Font = Enum.Font.Gotham
    oreTabButton.Font = Enum.Font.GothamBold
end)
