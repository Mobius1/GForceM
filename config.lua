Config = {}

Config.Enabled          = true      -- Enable / disable
Config.ShowGrid         = true
Config.ShowBackground   = true
Config.ShowGridLines    = true
Config.ShowLabels       = false     -- Performance hit
Config.Tick             = 0

Config.Grid = {
    Pos = { x = 0.085, y = 0.4 },
    Width = 0.1,
    Height = 0.1,
    BackgroundColor = { r = 0, g = 0, b = 0, a = 150 },
}

Config.Pointer = {
    Size = 0.004,
    BackgroundColor = { r = 35, g = 132, b = 255, a = 255 },
    BorderColor = { r = 255, g = 255, b = 255, a = 255 }
}

Config.MaxG = {
    x = 5.0,
    y = 5.0
}