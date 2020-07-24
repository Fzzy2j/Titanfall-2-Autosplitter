state("Titanfall2") { 
	// I believe this has something to do with if the game is rendering anything or not, it stops the timer late
	int clframes : "materialsystem_dx11.dll", 0x1A9F4A8, 0x58C;
	
	// I dont know what this value is, all i know is its > 0 during gameplay
	int thing : "server.dll", 0xC26B04;
	
	// This is the last loaded level
	string20 level : "engine.dll", 0x13536498, 0x2C;
	
	// This shows bits of text on the ui, including the Found x / x displayed when picking up helmets
	string20 menuText : "client.dll", 0x22BC680;
	
	// 1 when holding flag, 0 when not
	int flag : "engine.dll", 0x111E1B60;
	
	// Current player position and velocity
	float x : "client.dll", 0x2172FF8, 0xDEC;
	float z : "client.dll", 0x2173B48, 0x2A0;
	float y : "client.dll", 0x216F9C0, 0xF4;
	float angle : "engine.dll", 0x7B666C;
	float velocity : "client.dll", 0x2A9EEB8, 0x884;
	
	// This value is 0 before the button is pressed and jumps to roughly 1115125 after its pressed
	int bnrbutton1 : "engine.dll", 0x13B1E914;
	
	// These values are 33 before the button is pressed and go to 41 after
	int bnrbutton2 : "engine.dll", 0x7B9D48;
	int enc2button2 : "engine.dll", 0x7B9C98;
	int enc2button3 : "engine.dll", 0x7B9DF8;
	
	int b2button : "server.dll", 0x1506C00;
	
	// This value drops to 0 when the elevator triggers
	int arkElevator : "engine.dll", 0x139A4D38;
	
	// Viper kill
	int viper : "client.dll", 0xC0916C;
	
	// this = 1 when in a cutscene, it also = 2 when embarking/disembarking bt
	int inCutscene : "engine.dll", 0x111E1B58;
	
	// This value increments whenever you embark, it seems to reset to 0 when a new level is loaded
	int embarkCount : "engine.dll", 0x111E18D8;
	
	// Subtitle dialogue
	string30 dialogue : "engine.dll", 0x13987B68, 0x60, 0x0;
}

startup {
	settings.Add("altTabPauseRemove", false, "Modify the game to make it not pause when alt tabbed");
	settings.Add("flagSplit", false, "Start timer on flag pickup, split on flag capture, and pause when not holding flag (multiplayer)");
	settings.Add("levelChangeSplit", true, "Split on level change");
	settings.Add("helmetSplit", false, "Split on helmet pickup");
	settings.Add("endSplit", true, "Split at the end of escape (end of run)");
	settings.Add("removeLoads", true, "Remove Loads");
	settings.Add("ignoreArk", false, "Ignore Ark Level Change Split (For Speedmod)");
	
	settings.Add("btSplits", false, "BT-7274");
	settings.Add("btBattery1", true, "Split on first battery", "btSplits");
	settings.Add("btBattery2", true, "Split on second battery", "btSplits");
	
	settings.Add("bnrSplits", false, "Blood and Rust");
	settings.Add("bnrButton1", true, "Split on first button", "bnrSplits");
	settings.Add("bnrDoor", true, "Split at door", "bnrSplits");
	settings.Add("bnrButton2", true, "Split on second button", "bnrSplits");
	settings.Add("bnrEmbark", true, "Split on embark BT", "bnrSplits");
	
	settings.Add("ita3Splits", false, "Into the Abyss 3");
	settings.Add("ita3Embark", true, "Split on embark BT", "ita3Splits");
	
	settings.Add("enc1Splits", false, "Effect and Cause 1");
	settings.Add("enc1Helmet", true, "Split on helmet cutscene", "enc1Splits");
	
	settings.Add("enc2Splits", false, "Effect and Cause 2");
	settings.Add("enc2Button2", true, "Split on second button", "enc2Splits");
	settings.Add("enc2Button3", true, "Split on third button", "enc2Splits");
	settings.Add("enc2Dialogue", true, "Split during second dialogue", "enc2Splits");
	settings.Add("enc2Hellroom", true, "Split at hellroom entrance", "enc2Splits");
	settings.Add("enc2Vents", true, "Split at bottom of vents", "enc2Splits");
	
	settings.Add("b2Splits", false, "The Beacon 2");
	settings.Add("b2Warp", true, "Split on death warp", "b2Splits");
	settings.Add("b2Button1", true, "Split on first button (livesplit will freeze upon enter beacon 2 for the first time)", "b2Splits");
	settings.Add("b2Trigger", true, "Split when you touch heatsink trigger", "b2Splits");
	
	settings.Add("b3Splits", false, "The Beacon 3");
	settings.Add("b3Module1", true, "Split on retrieve module", "b3Splits");
	settings.Add("b3Module2", true, "Split on insert module", "b3Splits");
	
	settings.Add("tbfSplits", false, "Trial by Fire");
	settings.Add("tbfElevator", true, "Split when you get on the elevator (requires subtitles to be on)", "tbfSplits");
	
	settings.Add("arkSplits", false, "The Ark");
	settings.Add("arkElevator", true, "Split when you get on the elevator", "arkSplits");
	settings.Add("arkGatesShot", true, "Split when Gates shoots her gun after the fight (requires subtitles to be on)", "arkSplits");
	
	settings.Add("foldSplits", false, "The Fold Weapon");
	settings.Add("foldDataCore", true, "Split when you insert the data core", "foldSplits");
	settings.Add("foldEscape", true, "Split when escape starts", "foldSplits");
	
	settings.Add("ilSettings", false, "IL Settings");
	settings.Add("BnRpause", false, "Blood and Rust IL pause", "ilSettings");
	settings.Add("enc3pause", false, "Effect and Cause 3 IL pause", "ilSettings");
	settings.Add("Arkpause", false, "The Ark IL pause", "ilSettings");
	settings.Add("loadReset", false, "Reset after load screens (IL resets)", "ilSettings");
}

init {
	vars.isLoading = false;
	vars.isLoadingOld = false;
	vars.splitTimer = 0;
	vars.splitTimerTimestamp = 0;
	vars.enc2Dialogue = false;
	
	vars.bnrdoorsplit = false;
	vars.hellroomsplit = false;
	vars.bnrIlPause = false;
	vars.enc3IlPause = false;
	vars.b2buttonTimestamp = 0;
	vars.b3IlPause = false;
	vars.arkIlPause = false;
	vars.arkIlPausePrep = false;
	
	vars.resetLock = false;
	vars.wishReset = false;
	
	vars.altTabPauseRemoved = false;
}

start {
	if (settings["flagSplit"] && old.flag == 0 && current.flag == 1) return true;
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
		if (current.level == "sp_hub_timeshift" && ((old.x > 1000 && old.x < 1100 && old.z > -7000 && old.z < -7200) || (old.x > 1350 && old.x < 1400 && old.z < -2700 && old.z > -2750)))
			return true;
		//Beacon 1
		if (current.level == "sp_beacon" && old.x > 14200 && old.x < 14400 && old.z > -10900 && old.z < -10800)
			return true;
		//Beacon 2
		if (current.level == "sp_beacon_spoke0" && old.x > -1150 && old.x < -1000 && old.z > -400 && old.z < -200)
			return true;
		//Beacon 3
		if (current.level == "sp_beacon" && ((old.x > 14200 && old.x < 14400 && old.z > -10900 && old.z < -10800) || (old.x > 12300 && old.x < 12400 && old.z > -1050 && old.z < -950)))
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

update {

	if (settings["altTabPauseRemove"]) {
		var deepClient = new DeepPointer("engine.dll", 0x1A1B04, new int[] {  });
		IntPtr pointerClient;
		deepClient.DerefOffsets(game, out pointerClient);
		game.WriteBytes(pointerClient, new byte[] { 0x88, 0xA1 });

		var deepServer = new DeepPointer("engine.dll", 0x1C8C02, new int[] { });
		IntPtr pointerServer;
		deepServer.DerefOffsets(game, out pointerServer);
		game.WriteBytes(pointerServer, new byte[] { 0xEB });
	} else {
		var deepClient = new DeepPointer("engine.dll", 0x1A1B04, new int[] {  });
		IntPtr pointerClient;
		deepClient.DerefOffsets(game, out pointerClient);
		game.WriteBytes(pointerClient, new byte[] { 0x88, 0x81 });

		var deepServer = new DeepPointer("engine.dll", 0x1C8C02, new int[] { });
		IntPtr pointerServer;
		deepServer.DerefOffsets(game, out pointerServer);
		game.WriteBytes(pointerServer, new byte[] { 0x75 });
	}

	if (vars.isLoading) {
		vars.splitTimer = 0;
	}

	// Reset if you're at the location at the beginning of the game, are on the sp_training map, and the game is not rendering anything
	if (vars.isLoading && current.level == "sp_training" && current.x == 10664 && current.y == -6056 && current.z == -10200) {
		if (!vars.resetLock) {
			vars.wishReset = true;
			vars.resetLock = true;
		} else {
			vars.wishReset = false;
		}
	} else {
		vars.resetLock = false;
	}
	
	if (vars.isLoading) {
		vars.bnrdoorsplit = false;
		vars.hellroomsplit = false;
	
		vars.bnrIlPause = false;
		vars.enc3IlPause = false;
		vars.arkIlPause = false;
		vars.arkIlPausePrep = false;
	}
	
	vars.isLoadingOld = vars.isLoading;
	vars.isLoading = current.clframes <= 0 || current.thing == 0;
}

split {
	// Add up all the characters in the current dialogue (used for foreign language splits)
	var dialogueCount = 0;
	if (current.dialogue != null) {
		for (int i = 0; i < current.dialogue.Length; i++) {
			dialogueCount += current.dialogue[i];
		}
	}
	if (settings["flagSplit"] && old.flag == 1 && current.flag == 0) return true;
	
	if (settings["helmetSplit"] && ((current.menuText.StartsWith("Found ")) || current.menuText.StartsWith("尋獲 ")) && current.menuText != old.menuText) return true;
	
	// This is used for delaying splits
	var timePassed = Environment.TickCount - vars.splitTimerTimestamp;
	vars.splitTimerTimestamp = Environment.TickCount;
	if (vars.splitTimer > 0) {
		var adjustment = vars.splitTimer - timePassed;
		if (adjustment <= 0) {
			vars.splitTimer = 0;
			return true;
		} else {
			vars.splitTimer = adjustment;
		}
	}
	
	// End of game
	if (current.level == "sp_skyway_v1" && current.x < -10000 && current.z > 0 && old.inCutscene == 0 && current.inCutscene == 1 && settings["endSplit"]) {
		return true;
	}
	
	//Level change
	if (current.level != old.level && settings["levelChangeSplit"]) {
		if (current.level == "sp_s2s" && settings["ignoreArk"]) return false;
		return true;
	}
	
	// BT-7274
	if (current.level == "sp_crashsite") {
	
		//Battery 1
		if (settings["btBattery1"]) {
			var x = -4568 - current.x;
			var z = -3669 - current.z;
			var distanceSquared = x * x + z * z;
			if (distanceSquared < 25000 && old.inCutscene == 0 && current.inCutscene == 1) {
				return true;
			}
		}
		
		//Battery 2
		if (settings["btBattery2"]) {
			var x = -4111 - current.x;
			var z = 4583 - current.z;
			var distanceSquared = x * x + z * z;
			if (distanceSquared < 25000 && old.inCutscene == 0 && current.inCutscene == 1) {
				return true;
			}
		}
	}
	
	// Blood and Rust
	if (current.level == "sp_sewers1") {
	
		// Button 1
		if (settings["bnrButton1"]) {
			if (old.bnrbutton1 == 0 && current.bnrbutton1 > 0 && !vars.isLoading) {
				return true;
			}
		}
	
		// Door trigger
		if (settings["bnrDoor"]) {
			if ((current.z <= -226 && current.x <= -827 && current.y > 450) && !vars.bnrdoorsplit && !vars.isLoading) {
				vars.bnrdoorsplit = true;
				return true;
			}
		}
	
		// Button 2
		if (settings["bnrButton2"]) {
			if (old.bnrbutton2 == 33 && current.bnrbutton2 == 41 && !vars.isLoading) {
				return true;
			}
		}
	
		// BT embark
		if (settings["bnrEmbark"]) {
			if (old.embarkCount == 0 && current.embarkCount == 1) {
				return true;
			}
		}
	}
	
	//Embark on ITA3
	if (current.level == "sp_boomtown_end" && settings["ita3Embark"]) {
		if (old.embarkCount == 0 && current.embarkCount == 1) {
			return true;
		}
	}
	
	//Helmet on E&C1
	if (current.level == "sp_hub_timeshift" && settings["enc1Helmet"]) {
		var x = 997 - current.x;
		var z = -2718 - current.z;
		var distanceSquared = x * x + z * z;
		if (distanceSquared < 25000 && old.inCutscene == 0 && current.inCutscene == 1) {
			vars.splitTimer = 1800;
		}
	}
	
	//E&C 2
	if (current.level == "sp_timeshift_spoke02") {
	
		// Dialogue
		if (settings["enc2Dialogue"]) {
			if (current.x > 8755 && current.x < 9655 && current.z < -4528 && current.y > 5000) {
				if (!vars.enc2Dialogue) {
					vars.splitTimer = 3000;
					vars.enc2Dialogue = true;
				}
			} else if (vars.isLoading)
				vars.enc2Dialogue = false;
		}
	
		// Button 2
		if (settings["enc2Button2"]) {
			if (old.enc2button2 == 33 && current.enc2button2 == 41 && !vars.isLoading) {
				return true;
			}
		}
		
		// Button 3
		if (settings["enc2Button3"]) {
			if (old.enc2button3 == 33 && current.enc2button3 == 41 && !vars.isLoading) {
				return true;
			}
		}
	
		// Hellroom
		if (settings["enc2Hellroom"]) {
			var x = 10708 - current.x;
			var z = -2263 - current.z;
			var distanceSquared = x * x + z * z;
			if (distanceSquared < 15000 && !vars.hellroomsplit && !vars.isLoading) {
				vars.hellroomsplit = true;
				return true;
			}
		}
	
		//Enc2 vents
		if (settings["enc2Vents"]) {
			if (current.y < -1200 && old.inCutscene == 0 && current.inCutscene == 1 && !vars.isLoading) {
				return true;
			}
		}
	}
	
	// Beacon 2
	if (current.level == "sp_beacon_spoke0") {
	
		// Death warp
		if (settings["b2Warp"]) {
			var destinationX = 4019 - current.x;
			var destinationZ = 4233 - current.z;
			var destinationDistanceSquared = destinationX * destinationX + destinationZ * destinationZ;
			var warpX = old.x - current.x;
			var warpZ = old.z - current.z;
			var warpDistanceSquared = warpX * warpX + warpZ * warpZ;
			if (destinationDistanceSquared < 500 && warpDistanceSquared > 20000 && !vars.isLoadingOld) {
				return true;
			}
		}
	
		// Button 1
		if (settings["b2Button1"]) {
			if (current.b2button != old.b2button && Environment.TickCount - vars.b2buttonTimestamp > 1000) {
				vars.b2buttonTimestamp = Environment.TickCount;
				if (old.x > 2350 && current.x < 3000 && current.z > 10200 && current.z < 10550 && current.y > 1110) {
					return true;
				}
			}
		}
	
		// Heatsink trigger
		if (settings["b2Trigger"]) {
			if (old.x > -2113 && current.x <= -2113 && current.z < 11800 && current.z > 10100) {
				return true;
			}
		}
	}
	
	// Beacon 3
	if (current.level == "sp_beacon") {
		
		// Module retrieve
		if (settings["b3Module1"]) {
			var x = -10670 - current.x;
			var z = 9523 - current.z;
			var distanceSquared = x * x + z * z;
			if (distanceSquared < 25000 && old.inCutscene == 0 && current.inCutscene == 1) {
				vars.splitTimer = 1900;
			}
		}
			
		//Module 2
		if (settings["b3Module2"]) {
			var x = 3797 - current.x;
			var z = -1905 - current.z;
			var distanceSquared = x * x + z * z;
			if (distanceSquared < 25000 && old.inCutscene == 0 && current.inCutscene == 1) {
				vars.splitTimer = 1850;
			}
		}
	}
	
	//TBF Elevator
	if (current.level == "sp_tday" && settings["tbfElevator"]) {
		if (old.dialogue != current.dialogue && (current.dialogue.StartsWith("Sarah: (radio) Here ") || dialogueCount == 396581)) {
			return true;
		}
	}
	
	// The Ark
	if (current.level == "sp_s2s") {
	
		// Elevator
		if (settings["arkElevator"] && old.arkElevator > 0 && current.arkElevator == 0 && current.y > -3000) {
			vars.splitTimer = 1600;
		}
		
		// Gates shot
		if (settings["arkGatesShot"] && old.dialogue != current.dialogue && (current.dialogue.StartsWith("Bear: Hold your fire") || dialogueCount == 354581)) {
			return true;
		}
	}
	
	// The Fold Weapon
	if (current.level == "sp_skyway_v1") {
	
		// Datacore
		if (settings["foldDataCore"]) {
			var x = 5252 - current.x;
			var z = -5776 - current.z;
			var distanceSquared = x * x + z * z;
			if (distanceSquared < 25000 && old.inCutscene == 0 && current.inCutscene == 1) {
				vars.splitTimer = 7950;
			}
		}
	
		// Escape land
		if (settings["foldEscape"]) {
			var x1 = 535 - current.x;
			var z1 = 6549 - current.z;
			var distanceSquared1 = x1 * x1 + z1 * z1;
			if (distanceSquared1 < 25000 && old.angle == 0 && current.angle != 0) {
				return true;
			}
		}
	}
}

reset {
	if (settings["loadReset"] && vars.isLoadingOld && !vars.isLoading) {
		return true;
	}
	if (vars.wishReset) {
		vars.wishReset = false;
		return true;
	}
}

isLoading {
	if (settings["flagSplit"]) {
		if (current.flag == 0) 
			return true; 
		else 
			return false;
	}
	if (vars.isLoading) {
		vars.bnrIlPause = false;
		vars.enc3IlPause = false;
		vars.arkIlPause = false;
	}
	if (settings["BnRpause"]) {
		if (old.inCutscene == 0 && current.inCutscene == 1 && current.level == "sp_sewers1" && current.x > -9000) vars.bnrIlPause = true;
		if (vars.bnrIlPause) return true;
	}
	if (settings["Arkpause"]) {
		// Add up all the characters in the current dialogue (used for foreign language splits)
		var dialogueCount = 0;
		if (current.dialogue != null) {
			for (int i = 0; i < current.dialogue.Length; i++) {
				dialogueCount += current.dialogue[i];
			}
		}
		if (old.dialogue != current.dialogue && (dialogueCount == 96009 || dialogueCount == 1640)) vars.arkIlPausePrep = true;
		if (current.level == "sp_s2s" && current.viper == 1 && old.viper == 0 && vars.arkIlPausePrep) {
			vars.arkIlPause = true;
			vars.arkIlPausePrep = false;
		}
		if (vars.arkIlPause) return true;
	}
	if (settings["enc3pause"]) {
		if (old.inCutscene == 0 && current.inCutscene == 1 && current.level == "sp_hub_timeshift" && current.z > 4000) vars.enc3IlPause = true;
		if (vars.enc3IlPause) return true;
	}
	return vars.isLoading;
}
