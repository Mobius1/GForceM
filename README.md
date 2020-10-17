# GForceM
Vehicle G-Force meter for FiveM

## Table of contents
* [Demo Videos](#demo-videos)
* [Requirements](#requirements)
* [Download & Installation](#download--installation)
* [Configuration](#configuration)
* [Commands](#commands)

## Demo Videos
* [Demo](https://streamable.com/empza2)

## Requirements

* None!

## Download & Installation

* Download and extract the package: https://github.com/Mobius1/GForceM/archive/main.zip
* Drop the `GForceM` directory into you `resources` directory
* Add `ensure GForceM` in your `server.cfg`
* Edit `config.lua` to your liking
* Start your server and rejoice!

## Configuration

```lua
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
    Size = 0.004,          -- Pointer radius
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
```

## Commands

#### `/gshow` - Show the G-Meter
#### `/ghide` - Hide the G-Meter
#### `/gtoggle` - Toggle the G-Meter
```



## Contributing
Pull requests welcome.

## To Do
- [ ] Allow toggling of UI

## Legal

### License

GForceM - Vehicle G-Force meter for FiveM

Copyright (C) 2020 Karl Saunders

This program Is free software: you can redistribute it And/Or modify it under the terms Of the GNU General Public License As published by the Free Software Foundation, either version 3 Of the License, Or (at your option) any later version.

This program Is distributed In the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty Of MERCHANTABILITY Or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License For more details.

You should have received a copy Of the GNU General Public License along with this program. If Not, see http://www.gnu.org/licenses/.