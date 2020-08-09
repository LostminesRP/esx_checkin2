Config              = {}

Config.Locale       = 'en'

-- Optimization
Config.DrawDistance = 5 -- Keep this as low as possible for better optimization, 5 is recommended
Config.Optimization = 5 -- Keep this between 3-6, 4-5 is recommended, DON'T go over 6

Config.Location     = vector3(441.33, -981.12, 30.79) -- Check in location

Config.ChangeJob    = true 
Config.GiveArmor    = true 
Config.UseUniforms  = true 
Config.GiveWeapons  = true
Config.NotifyChat   = true

Config.CheckInTime  = 10000 -- 10 sec.

Config.Uniforms = {
	male = {
        tshirt_1 = 58,  tshirt_2 = 0,
        torso_1 = 55,   torso_2 = 0,
        decals_1 = 8,   decals_2 = 3,
        arms = 41,
        pants_1 = 25,   pants_2 = 0,
        shoes_1 = 25,   shoes_2 = 0,
        helmet_1 = -1,  helmet_2 = 0,
        chain_1 = 0,    chain_2 = 0,
        ears_1 = 2,     ears_2 = 0
	},
	female = {
        tshirt_1 = 35,  tshirt_2 = 0,
        torso_1 = 48,   torso_2 = 0,
        decals_1 = 7,   decals_2 = 3,
        arms = 44,
        pants_1 = 34,   pants_2 = 0,
        shoes_1 = 27,   shoes_2 = 0,
        helmet_1 = -1,  helmet_2 = 0,
        chain_1 = 0,    chain_2 = 0,
        ears_1 = 2,     ears_2 = 0
	}
}