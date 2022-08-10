#include <game.h>
#include <common.h>
#include <stage.h>


extern "C" u32 MultiplayerModeFlags_maybe;
extern char CurrentLevel;
extern char CurrentWorld;
extern bool enableDaredevil;

bool getSetting(u32 settingID) {
	return GetSaveFile()->GetBlock(-1)->pad[0x10 + settingID];
}


void QuickRestart() {
	LastPowerupStoreType = LOSE_LEVEL;

	if(getSetting(0)) {
		u32 playerHeld = 0;
		for(int i = 0; i < 4; i++) {
			playerHeld |= GetRemoconMng()->controllers[i]->heldButtons;
		}

		if(playerHeld & WPAD_TWO || playerHeld & WPAD_A) { // Holding 2 or A sends you back to the map
			ExitStage(WORLD_MAP, 0, LOSE_LEVEL, WIPE_BOWSER);
			return;		
		}

		if(((!Player_Lives[0]) || // If any player has a game over, send back to the map too
			((Player_Active[1]) && !Player_Lives[1]) ||
			((Player_Active[2]) && !Player_Lives[2]) ||
			((Player_Active[3]) && !Player_Lives[3]))) {
			ExitStage(WORLD_MAP, 0, LOSE_LEVEL, WIPE_BOWSER);
			return;
		}

		RESTART_CRSIN_LevelStartStruct.purpose = 0;
		RESTART_CRSIN_LevelStartStruct.world1 = CurrentWorld;
		RESTART_CRSIN_LevelStartStruct.world2 = CurrentWorld;
		RESTART_CRSIN_LevelStartStruct.level1 = CurrentLevel;
		RESTART_CRSIN_LevelStartStruct.level2 = CurrentLevel;
		RESTART_CRSIN_LevelStartStruct.areaMaybe = 0;
		RESTART_CRSIN_LevelStartStruct.entrance = 0xFF;
		RESTART_CRSIN_LevelStartStruct.unk4 = 0; // load replay
		DontShowPreGame = true;
		ExitStage(RESTART_CRSIN, 0, LOSE_LEVEL, WIPE_BOWSER);
	}
	else {
		ExitStage(WORLD_MAP, 0, LOSE_LEVEL, WIPE_BOWSER);
	}
}

u32 NoPowerupFreeze() {
	if(getSetting(1)) {
		return 0;
	}
	else {
		return (MultiplayerModeFlags_maybe & 2);
	}
}

u32 HardMode(u32 r0) {
	if(getSetting(2) || enableDaredevil) {
		return 0;
	}
	else {
		return r0;
	}
}