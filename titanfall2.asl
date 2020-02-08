state("Titanfall2") { 
	// I believe this has something to do with if the game is rendering anything or not, it stops the timer late
	int clframes : "materialsystem_dx11.dll", 0x1A9F4A8, 0x58C;
	
	// I dont know what this value is, all i know is its > 0 during gameplay
	int thing : "server.dll", 0xC26B04;
	
	// This is the last loaded level
	string20 level : "engine.dll", 0x13536498, 0x2C;
	
	// This number changes to be not 0 when the player is dead
	int death : "client.dll", 0x02D57D28, 0x328, 0xB8, 0xC0;
	
	// Current player position and velocity
	float x : "client.dll", 0x2172FF8, 0xDEC;
	float z : "client.dll", 0x2173B48, 0x2A0;
	float y : "client.dll", 0x216F9C0, 0xF4;
	float angle : "engine.dll", 0x7B666C;
	float velocity : "client.dll", 0x2A9EEB8, 0x884;
	
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
	settings.Add("removeLoads", true, "Remove Loads");
	settings.Add("BnRpause", false, "Blood and Rust IL pause");
	settings.Add("enc3pause", false, "Effect and Cause 3 IL pause");
	settings.Add("Arkpause", false, "The Ark IL pause");
	settings.Add("b2splits", false, "Beacon 2 subsplits");
	settings.Add("speedmodMode", false, "Speedmod Mode");
	
	settings.Add("subSplits", false, "Sub Splits");
	settings.Add("batterySplit", false, "Split on Batteries on BT-7274", "subSplits");
	settings.Add("ita3TitanSplit", false, "Split on Embark on Into the Abyss 3", "subSplits");
	settings.Add("helmetSplit", false, "Split on helmet grab on Effect and Cause 1", "subSplits");
	settings.Add("dialogueSplit", false, "Split on dialogue on Effect and Cause 2", "subSplits");
	settings.Add("moduleSplit", false, "Split on modules on Beacon 3", "subSplits");
	settings.Add("tbfElevatorSplit", false, "Split on elevator on Trial by Fire (Requires subtitles to be on)", "subSplits");
	settings.Add("arkElevatorSplit", false, "Split on elevator on The Ark (Requires subtitles to be on)", "subSplits");
	settings.Add("arkGatesShootSplit", false, "Split when Gates shoots the glass on The Ark (Requires subtitles to be on)", "subSplits");
	settings.Add("datacoreSplit", false, "Split when you insert BT's datacore on The Fold Weapon", "subSplits");
	settings.Add("escapeSplit", false, "Split when first land at escape (Also works for fast any% last load)", "subSplits");
	
	vars.b2buttonScanTarget = new SigScanTarget(0, "?? 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 FF FF FF FF 00 00 80 3F 00 00 00 00 00 00 00 00 00 00 80 3F 00 00 00 00 77 BE 7F 3F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 CD CC CC 3D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 01 01 00 00 00 00 00 00 00 01 0E 00 70 05 00 00 00 00 00 00 D4 A6 70 50 F9 2D 88 4D 9E 70 F1 DC B6 5F DA 71 00 00 00 00 00 80 BB 44 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3F 3C 00 00 00 FF FF FF FF FF FF FF FF 00 00 00 00 00 00 00 00");
}

init {
	print("[Autosplitter] initialize");
	vars.b2button = null;
	vars.gameEnded = false;
	
	vars.bnrIlPause = false;
	vars.enc3IlPause = false;
	vars.b3IlPause = false;
	vars.arkIlPause = false;
	vars.arkIlPausePrep = false;
	
	vars.resetLock = false;
	vars.wishReset = false;
	
	vars.battery1Split = false;
	vars.battery2Split = false;
	
	vars.helmetSplit = false;
	
	vars.dialogueSplitTimer = -1;
	
	vars.arkElevatorSplitTimer = -1;
	
	vars.module1Split = false;
	vars.module2Split = false;
	
	vars.datacoreSplitTimer = -1;
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
	if (vars.b2button != null) { 
		vars.b2button.Update(game);
	} else if (current.level == "sp_beacon_spoke0" && settings["b2splits"]) {
		print("[Autosplitter] searching for pointer");
		
		var b2buttonPtr = IntPtr.Zero;
	
		foreach (var page in game.MemoryPages()) {
			var scanner = new SignatureScanner(game, page.BaseAddress, (int)page.RegionSize);
			if((b2buttonPtr = scanner.Scan(vars.b2buttonScanTarget)) != IntPtr.Zero)
				break;
		}
	
		if (b2buttonPtr != IntPtr.Zero) vars.b2button = new MemoryWatcher<int>(b2buttonPtr);
		print("[Autosplitter] Pointer found: 0x" + b2buttonPtr.ToString("x"));
	}

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
	
	if (current.clframes <= 0) {
		vars.battery1Split = false;
		vars.battery2Split = false;
	
		vars.helmetSplit = false;
	
		vars.dialogueSplitTimer = -1;
	
		vars.arkElevatorSplitTimer = -1;
	
		vars.module1Split = false;
		vars.module2Split = false;
	
		vars.datacoreSplitTimer = -1;
		vars.escapeSplit = false;
	
		vars.bnrIlPause = false;
		vars.enc3IlPause = false;
		vars.arkIlPause = false;
		vars.arkIlPausePrep = false;
	}
}

split {
	// Add up all the characters in the current dialogue (used for foreign language splits)
	var dialogueCount = 0;
	if (current.dialogue != null) {
		for (int i = 0; i < current.dialogue.Length; i++) {
			dialogueCount += current.dialogue[i];
		}
	}
	
	// End of game
	if (current.level == "sp_skyway_v1" && current.x < -11000 && current.z > 0 && current.velocity <= 0 && !vars.gameEnded) {
		vars.gameEnded = true;
		return true;
	} else if (current.level != "sp_skyway_v1" || current.x > -11000) {
		vars.gameEnded = false;
	}
	
	//Level change
	if (current.level != old.level) {
		if (current.level == "sp_s2s" && settings["speedmodMode"]) return false;
		return true;
	}
	
	//Batteries on BT
	if (current.level == "sp_crashsite" && (settings["batterySplit"] || settings["speedmodMode"])) {
		//Battery 1
		if (current.x > -4598 && current.x < -4590 && current.y > 2110 && current.y < 2140 && current.z > -3650 && current.z < -3640) {
			if (!vars.battery1Split) {
				vars.battery1Split = true;
				return true;
			}
		} else if (current.clframes <= 0)
			vars.battery1Split = false;
			
		//Battery 2
		if (current.x > -4110 && current.x < -4090 && current.y > 2320 && current.y < 2335  && current.z > 4580 && current.z < 4590) {
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
		if (current.x > 1005 && current.x < 1011 && current.y > -850 && current.y < -847 && current.z > -2720 && current.z < -2718) {
			if (!vars.helmetSplit) {
				vars.helmetSplit = true;
				
				System.Diagnostics.Process[] tf2Processes = System.Diagnostics.Process.GetProcessesByName("Titanfall2");
				if (tf2Processes.Length > 0)
				{
					print("process found!");
					System.Diagnostics.Process process = tf2Processes[0];
					System.IntPtr h = process.MainWindowHandle;
					System.Windows.Forms.SendKeys.Send("`");
				}
				
				return true;
			}
		} else if (current.clframes <= 0)
			vars.helmetSplit = false;
	}
	
	//E&C 2 Dialogue
	//Waits 3 seconds after cutscene starts (thanks for making it more complicated than it had to be bry ;])
	if (current.level == "sp_timeshift_spoke02" && (settings["dialogueSplit"] || settings["speedmodMode"])) {
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
	if (current.level == "sp_beacon" && (settings["moduleSplit"] || settings["speedmodMode"])) {
		
		//Module 1
		if (current.x > -10661 && current.x < -10660  && current.y > 2224 && current.y < 2225 && current.z > 9537 && current.z < 9538) {
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
		if (old.dialogue != current.dialogue && (current.dialogue.StartsWith("Sarah: (radio) Here ") || dialogueCount == 396581)) {
			return true;
		}
	}
	
	//Ark Elevator
	if (current.level == "sp_s2s" && settings["arkElevatorSplit"]) {
		if (current.dialogue.StartsWith("CPT Meas: (radio) Co") || dialogueCount == 388777) {
			if (vars.arkElevatorSplitTimer == -1) {
				vars.arkElevatorSplitTimer = Environment.TickCount;
			}
		}
		
		if (vars.arkElevatorSplitTimer > 0 && Environment.TickCount - vars.arkElevatorSplitTimer >= 1100) {
			vars.arkElevatorSplitTimer = -2;
			return true;
		}
		
		if (current.clframes <= 0)
			vars.arkElevatorSplitTimer = -1;
	}
	
	//Ark Gates Shot
	if (current.level == "sp_s2s" && settings["arkGatesShootSplit"]) {
		if (old.dialogue != current.dialogue && (current.dialogue.StartsWith("Bear: Hold your fire") || dialogueCount == 354581)) {
			return true;
		}
	}
	
	//Fold Weapon Datacore
	if (current.level == "sp_skyway_v1" && (settings["datacoreSplit"] || settings["speedmodMode"])) {
		if (current.x > 5293 && current.x < 5294 && current.y > 3577 && current.y < 3578 && current.z > -5749 && current.z < -5748) {
			if (vars.datacoreSplitTimer == -1) {
				vars.datacoreSplitTimer = Environment.TickCount;
			}
		} else if (current.clframes <= 0)
			vars.datacoreSplitTimer = -1;
			
		if (vars.datacoreSplitTimer > 0 && Environment.TickCount - vars.datacoreSplitTimer >= 1500) {
			vars.datacoreSplitTimer = -2;
			return true;
		}
	}
	
	//Escape Landing
	if (current.level == "sp_skyway_v1" && (settings["escapeSplit"] || settings["speedmodMode"])) {
		if (current.x > 536 && current.x < 538 && current.y > 6244 && current.y < 6246 && current.z > 6551 && current.z < 6553) {
			if (!vars.escapeSplit) {
				vars.escapeSplit = true;
				return true;
			}
		} else if (current.clframes <= 0)
			vars.escapeSplit = false;
	}
	
	//Beacon 2 warp
	if (current.level == "sp_beacon_spoke0" && settings["b2splits"]) {
		if (current.x > 1100 && current.x < 2000 && current.z > 4300 && current.z < 4600) {
			if (current.death != 0 && old.death == 0) {
				return true;
			}
		}
	}
	
	//Beacon 2 button
	if (current.level == "sp_beacon_spoke0" && settings["b2splits"]) {
		if (vars.b2button.Old == 1 && vars.b2button.Current == 0) {
			if (old.x > 2350 && current.x < 3000 && current.z > 10200 && current.z < 10550 && current.y > 1110) {
				return true;
			}
		}
	}
	
	//Beacon 2 heatsink trigger
	if (current.level == "sp_beacon_spoke0" && settings["b2splits"]) {
		if (old.x > -2113 && current.x <= -2113 && current.z < 11800 && current.z > 10100) {
			return true;
		}
	}
}

reset {
	if (vars.wishReset) {
		return true;
	}
}

isLoading {
	var loading = current.clframes <= 0 || current.thing == 0;
	if (loading) {
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
	return loading;
}
