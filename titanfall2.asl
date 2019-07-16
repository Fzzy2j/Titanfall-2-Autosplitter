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
}

start {
	if (old.clframes <= 0 && current.clframes > 0) {
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

reset {
	// Reset if you're at the location at the beginning of the game, are on the sp_training map, and the game is not rendering anything
	if (current.clframes <= 0 && current.level == "sp_training" && current.x == 10664 && current.y == -6056 && current.z == -10200) {
		return true;
	}
}

isLoading {
	return (current.clframes <= 0 || current.thing == 0) && settings["removeLoads"];
}