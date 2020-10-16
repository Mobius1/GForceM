Config = {}

Config.Enabled          = true      -- Enable / disable the meter
Config.ShowGrid         = true      -- Show the main grid
Config.ShowBackground   = true      -- Show grid background
Config.ShowGridLines    = true      -- Show grid lines
Config.ShowLabels       = false     -- Show grid labels (performance hit!)
Config.Tick             = 0         -- Tick rate (Values > 0 will make it jerky)

Config.Grid = {                     -- Grid position
    Pos = {
        x = 0.085,
        y = 0.4
    },
    Width   = 0.1,         -- Grid width
    Height  = 0.1,         -- Grid height
    BackgroundColor = {    -- Grid background color
        r = 0,
        g = 0,
        b = 0, 
        a = 150
    },
}

Config.Pointer = {
    Size = 0.008,          -- Pointer radius
    BackgroundColor = {    -- Pointer color
        r = 35,
        g = 132,
        b = 255,
        a = 255
    },
    BorderColor = {        -- Pointer border color
        r = 255,
        g = 255,
        b = 255,
        a = 255
    }
}

Config.MaxG = {
    x = 5.0,        -- Max lateral G
    y = 5.0         -- Max longitudinal G
}