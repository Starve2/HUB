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

-- Контейнер для контента
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

-- Ore TP Content (оставляем без изменений)
-- ...

-- Enemy TP Script
do
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

    -- Контейнер для вкладок биомов
    local biomeTabsScroll = Instance.new("ScrollingFrame")
    biomeTabsScroll.Size = UDim2.new(1, 0, 0.1, 0)
    biomeTabsScroll.Position = UDim2.new(0, 0, 0.06, 0)
    biomeTabsScroll.BackgroundTransparency = 1
    biomeTabsScroll.ScrollBarThickness = 0
    biomeTabsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    biomeTabsScroll.Parent = enemyContent

    -- Контейнер для контента биомов
    local biomeContent = Instance.new("Frame")
    biomeContent.Size = UDim2.new(1, 0, 0.8, 0)
    biomeContent.Position = UDim2.new(0, 0, 0.17, 0)
    biomeContent.BackgroundTransparency = 1
    biomeContent.Parent = enemyContent

    local tabButtons = {}
    local biomeFrames = {}

    -- Создаем вкладки для каждого биома
    local tabWidth = 120
    local tabSpacing = 5
    local totalWidth = 0

    for biomeName, enemies in pairs(enemiesByLocation) do
        -- Кнопка вкладки
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(0, tabWidth, 1, 0)
        tabButton.Position = UDim2.new(0, totalWidth, 0, 0)
        tabButton.Text = biomeName
        tabButton.TextColor3 = Color3.new(1, 1, 1)
        tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 12
        tabButton.Parent = biomeTabsScroll

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = tabButton

        -- Фрейм контента биома
        local biomeFrame = Instance.new("ScrollingFrame")
        biomeFrame.Size = UDim2.new(1, 0, 1, 0)
        biomeFrame.Position = UDim2.new(0, 0, 0, 0)
        biomeFrame.BackgroundTransparency = 1
        biomeFrame.Visible = false
        biomeFrame.ScrollBarThickness = 6
        biomeFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        biomeFrame.Parent = biomeContent

        -- Заполнение контента биома
        local buttonHeight = 32
        local spacing = 5
        local totalHeight = 0

        table.sort(enemies)
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
            enemyButton.Parent = biomeFrame

            local function findAndTeleport()
                if not player.Character then return end
                local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPart then return end
                
                local enemy = findNearestEnemy(enemyName)
                if enemy then
                    humanoidRootPart.CFrame = enemy.CFrame + Vector3.new(0, 3, 0)
                end
            end

            enemyButton.MouseButton1Click:Connect(function()
                enemyButton.Text = "Поиск..."
                task.wait(0.1)
                findAndTeleport()
                enemyButton.Text = enemyName
            end)

            totalHeight += buttonHeight + spacing
        end

        biomeFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
        table.insert(biomeFrames, biomeFrame)
        table.insert(tabButtons, tabButton)

        -- Обработчик переключения вкладок
        tabButton.MouseButton1Click:Connect(function()
            for _, frame in ipairs(biomeFrames) do
                frame.Visible = false
            end
            for _, btn in ipairs(tabButtons) do
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end
            biomeFrame.Visible = true
            tabButton.BackgroundColor3 = Color3.fromRGB(30, 136, 229)
        end)

        totalWidth += tabWidth + tabSpacing
    end

    biomeTabsScroll.CanvasSize = UDim2.new(0, totalWidth, 0, 0)

    -- Активируем первую вкладку
    if #tabButtons > 0 and #biomeFrames > 0 then
        tabButtons[1].BackgroundColor3 = Color3.fromRGB(30, 136, 229)
        biomeFrames[1].Visible = true
    end

    -- Функция поиска врага (остается без изменений)
    local function findNearestEnemy(enemyName)
        -- ... (прежняя реализация функции)
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
end

-- ... (остальная часть скрипта остается без изменений) -- Ore TP Content (исправленная версия)
local oreContent = Instance.new("Frame")
oreContent.Size = UDim2.new(1, 0, 1, 0)
oreContent.BackgroundTransparency = 1
oreContent.Visible = false
oreContent.Parent = contentFrame

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

    -- Функция поиска ближайшей руды
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

    -- Создаем кнопки для руд
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

-- Исправленные обработчики переключения вкладок
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
