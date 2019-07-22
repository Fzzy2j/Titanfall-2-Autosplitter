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
	
	// This value increments whenever you embark, it seems to reset to 0 when a new level is loaded
	int embarkCount : "engine.dll", 0x111E18D8;
	
	// Subtitle dialogue
	string20 dialogue : "engine.dll", 0x13987B68, 0x60, 0x0;
}

startup {
	settings.Add("removeLoads", true, "Remove Loads");
	
	settings.Add("batterySplit", false, "Split on Batteries on BT-7274");
	settings.Add("ita3TitanSplit", false, "Split on Embark on Into the Abyss 3");
	settings.Add("helmetSplit", false, "Split on helmet grab on Effect and Cause 1");
	settings.Add("dialogueSplit", false, "Split on dialogue on Effect and Cause 2");
	settings.Add("moduleSplit", false, "Split on modules on Beacon 3");
	settings.Add("tbfElevatorSplit", false, "Split on elevator on Trial by Fire (Requires subtitles to be on)");
	settings.Add("arkElevatorSplit", false, "Split on elevator on The Ark (Requires subtitles to be on)");
	settings.Add("arkGatesShootSplit", false, "Split when Gates shoots the glass on The Ark (Requires subtitles to be on)");
	settings.Add("datacoreSplit", false, "Split when you insert BT's datacore on The Fold Weapon");
	settings.Add("escapeSplit", false, "Split when first land at escape (Also works for fast any% last load)");
}

init {
	vars.gameEnded = false;
	
	vars.resetLock = false;
	vars.wishReset = false;
	
	vars.battery1Split = false;
	vars.battery2Split = false;
	
	vars.helmetSplit = false;
	
	vars.dialogueSplitTimer = -1;
	
	vars.module1Split = false;
	vars.module2Split = false;
	
	vars.datacoreSplit = false;
	vars.escapeSplit = false;
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
		if (current.level == "sp_sewers1" && old.x > 9000 && old.x < 9100 && old.z > -14700 && old.z < -14300)
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
	
	//Batteries on BT
	if (current.level == "sp_crashsite" && settings["batterySplit"]) {
		//Battery 1
		if (current.x > -4590 && current.x < -4560 && current.y > 2100 && current.y < 2200 && current.z > -3670 && current.z < -3650) {
			if (!vars.battery1Split) {
				vars.battery1Split = true;
				return true;
			}
		} else if (current.clframes <= 0)
			vars.battery1Split = false;
			
		//Battery 2
		if (current.x > -4120 && current.x < -4108 && current.y > 2320 && current.y < 2330  && current.z > 4580 && current.z < 4585) {
			if (!vars.battery2Split) {
				vars.battery2Split = true;
				return true;
			}
		} else if (current.clframes <= 0)
			vars.battery2Split = false;
	}
	
	//Embark on ITA3
	if (current.level == "sp_boomtown_end" && settings["ita3TitanSplit"]) {
		if (old.embarkCount == 0 && current.embarkCount == 1) {
			return true;
		}
	}
	
	//Helmet on E&C1
	if (current.level == "sp_hub_timeshift" && settings["helmetSplit"]) {
		if (current.x > 1000 && current.x < 1009 && current.y > -859 && current.y < -847 && current.z > -2720 && current.z < -2718) {
			if (!vars.helmetSplit) {
				vars.helmetSplit = true;
				return true;
			}
		} else if (current.clframes <= 0)
			vars.helmetSplit = false;
	}
	
	//E&C 2 Dialogue
	//Waits 3 seconds after cutscene starts (thanks for making it more complicated than it had to be bry ;])
	if (current.level == "sp_timeshift_spoke02" && settings["dialogueSplit"]) {
		if (current.x > 8755 && current.x < 9655 && current.z < -4528 && current.y > 5000) {
			if (vars.dialogueSplitTimer == -1) {
				vars.dialogueSplitTimer = Environment.TickCount;
			}
		} else if (current.clframes <= 0)
			vars.dialogueSplitTimer = -1;
		
		if (vars.dialogueSplitTimer > 0 && Environment.TickCount - vars.dialogueSplitTimer >= 3000) {
			vars.dialogueSplitTimer = -2;
			return true;
		}
	}
	
	//Beacon 3 Module
	if (current.level == "sp_beacon" && settings["moduleSplit"]) {
		
		//Module 1
		if (current.x > -10670 && current.x < -10658  && current.y > 2220 && current.y < 2243 && current.z > 9536 && current.z < 9540) {
			if (!vars.module1Split) {
				vars.module1Split = true;
				return true;
			}
		} else if (current.clframes <= 0)
			vars.module1Split = false;
			
		//Module 2
		if (current.x > 3793 && current.x < 3794  && current.y > 4739 && current.y < 4740 && current.z > -1907 && current.z < -1906) {
			if (!vars.module2Split) {
				vars.module2Split = true;
				return true;
			}
		} else if (current.clframes <= 0)
			vars.module2Split = false;
	}
	
	//TBF Elevator
	if (current.level == "sp_tday" && settings["tbfElevatorSplit"]) {
		if (old.dialogue != current.dialogue && current.dialogue == "Sarah: (radio) Here ") {
			return true;
		}
	}
	
	//Ark Elevator
	if (current.level == "sp_s2s" && settings["arkElevatorSplit"]) {
		if (old.dialogue != current.dialogue && current.dialogue == "CPT Meas: (radio) Co") {
			return true;
		}
	}
	
	//Ark Gates Shot
	if (current.level == "sp_s2s" && settings["arkGatesShootSplit"]) {
		if (old.dialogue != current.dialogue && current.dialogue == "Bear: Hold your fire") {
			return true;
		}
	}
	
	//Fold Weapon Datacore
	if (current.level == "sp_skyway_v1" && settings["datacoreSplit"]) {
		if (current.x > 5293 && current.x < 5294 && current.y > 3577 && current.y < 3578 && current.z > -5749 && current.z < -5748) {
			if (!vars.datacoreSplit) {
				vars.datacoreSplit = true;
				return true;
			}
		} else if (current.clframes <= 0)
			vars.datacoreSplit = false;
	}
	
	//Escape Landing
	if (current.level == "sp_skyway_v1" && settings["escapeSplit"]) {
		if (current.x > 536 && current.x < 538 && current.y > 6244 && current.y < 6246 && current.z > 6551 && current.z < 6553) {
			if (!vars.escapeSplit) {
				vars.escapeSplit = true;
				return true;
			}
		} else if (current.clframes <= 0)
			vars.escapeSplit = false;
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