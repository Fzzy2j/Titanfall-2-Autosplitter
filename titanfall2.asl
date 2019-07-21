state("Titanfall2") { 
	// I believe this has something to do with if the game is rendering anything or not, it stops the timer late
	int clframes : "materialsystem_dx11.dll", 0x1A9F4A8, 0x58C;
	
	// I dont know what this value is, all i know is it equals 0 during loading screens, it starts the timer early
	int thing : "server.dll", 0x105F678, 0xB0;
	
	// This is the last loaded level
	string20 level : "engine.dll", 0x13536498, 0x2C;
	
	// Current player position and velocity
	float x : "client.dll", 0x2172FF8, 0xDEC;
	float z : "client.dll", 0x2173B48, 0x2A0;
	float y : "client.dll", 0x216F9C0, 0xF4;
	float velocity : "client.dll", 0x2A9EEB8, 0x884;
}

startup {
	settings.Add("removeLoads", true, "Remove Loads");
}

init {
	vars.gameEnded = false;
	vars.resetLock = false;
	vars.wishReset = false;
}

start {
	if (old.clframes <= 0 && current.clframes > 0) {
		//Pilots Gauntlet
		if (current.level == "sp_training" && old.x > 10600 && old.x < 10700 && old.z > -10300 && old.z < -10100)
			return true;
		//BT-7274
		if (current.level == "sp_crashsite" && old.x > 0 && old.x < 100 && old.z > 200 && old.z < 300)
			return true;
		//Blood and Rust
		if (current.level == "sp_sewers1" && old.x > 9000 && old.x < 9100 && old.z > -14500 && old.z < -14300)
			return true;
		//ITA 1
		if (current.level == "sp_boomtown_start" && old.x > 13500 && old.x < 13700 && old.z > -8900 && old.z < -8700)
			return true;
		//ITA 2
		if (current.level == "sp_boomtown" && old.x > -4100 && old.x < -4000 && old.z > 11100 && old.z < 11300)
			return true;
		//ITA 3
		if (current.level == "sp_boomtown_end" && old.x > -15100 && old.x < -14900 && old.z > -5300 && old.z < -5100)
			return true;
		//E&C 1
		if (current.level == "sp_hub_timeshift" && old.x > 900 && old.x < 1100 && old.z > -7200 && old.z < -7000)
			return true;
		//E&C 2
		if (current.level == "sp_timeshift_spoke02" && old.x > -800 && old.x < -600 && old.z > -3400 && old.z < -3300)
			return true;
		//E&C 3
		if (current.level == "sp_hub_timeshift" && old.x > 1000 && old.x < 1100 && old.z > -7000 && old.z < -7200)
			return true;
		//Beacon 1
		if (current.level == "sp_beacon" && old.x > 14200 && old.x < 14400 && old.z > -10900 && old.z < -10800)
			return true;
		//Beacon 2
		if (current.level == "sp_beacon_spoke0" && old.x > -1150 && old.x < -1000 && old.z > -400 && old.z < -200)
			return true;
		//Beacon 3
		if (current.level == "sp_beacon" && old.x > 14200 && old.x < 14400 && old.z > 700 && old.z < 800)
			return true;
		//TBF
		if (current.level == "sp_tday" && old.x > 500 && old.x < 700 && old.z > -15600 && old.z < -15500)
			return true;
		//The Ark
		if (current.level == "sp_s2s" && old.x > -100 && old.x < 100 && old.z > 4000 && old.z < 4200)
			return true;
		//The Fold Weapon
		if (current.level == "sp_skyway_v1" && old.x > -11600 && old.x < -11400 && old.z > -7200 && old.z < -7100)
			return true;
	}
}

split {
	// End of game
	if (current.level == "sp_skyway_v1" && current.x < -11000 && current.z > 0 && current.velocity <= 0 && !vars.gameEnded) {
		vars.gameEnded = true;
		return true;
	} else if (current.level != "sp_skyway_v1" || current.x > -11000) {
		vars.gameEnded = false;
	}
	
	//Level change
	if (current.level != old.level) {
		return true;
	}
}

update {
	// Reset if you're at the location at the beginning of the game, are on the sp_training map, and the game is not rendering anything
	if (current.clframes <= 0 && current.level == "sp_training" && current.x == 10664 && current.y == -6056 && current.z == -10200) {
		if (!vars.resetLock) {
			vars.wishReset = true;
			vars.resetLock = true;
		} else {
			vars.wishReset = false;
		}
	} else {
		vars.resetLock = false;
	}
}

reset {
	if (vars.wishReset) {
		return true;
	}
}

isLoading {
	return (current.clframes <= 0 || current.thing == 0) && settings["removeLoads"];
}
