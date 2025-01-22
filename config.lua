Config = {}
Config.PedModel = "a_m_m_soucent_02"
Config.PedPos = vec4(1960.9634, 5184.9712, 47.9369, 271.1460)
Config.VehSpawnPoint = vec4(1970.5115, 5180.8286, 47.8876, 145.6312)
Config.ESXVersion = "newESX"
Config.GofastRefeal = 30 -- temps en minutes avant un nouveau gofast disponible
Config.TimeToDeleteMission = 30 -- temps maximum pour faire la mission en minutes

Config.Vehicles = {
    "sultan",
    "banshee",
}

Config.rewards = {
    ['small'] = 1000,
    ['medium'] = 2000,
    ['big'] = 3000,
}

Config.Blip = {
    time = 15, -- temps qu'il reste en secondes,
    sprite = 42,
    color = 1,
    text = "Attention, on me signale un GoFast en cours, soyez attentif !"
}

Config.AlertJobs = {
    "hayes",
}

Config.trajets = {
    ['small'] = {
        vec3(-269.3150, 2194.6628, 129.8297),
    },

    ['medium'] = {
        vec3(20.8759, 81.5734, 74.6553),
    },

    ['big'] = {
        vec3(-444.7987, -2791.4521, 6.0004),
    }
}

Config.Markers = {
    color = {255, 255, 255},
    id = 27,
	opacity = 70,
    size = 3,
    animate = false,
    turn = true
}