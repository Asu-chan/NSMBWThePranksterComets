#include <game.h>
#include <common.h>
#include <stage.h>
#include <actors.h>
#include "levelinfo.h"
#include "multiChooser.h"

class dScStage_c {
	int onCreate_orig();
	int newOnCreate();
};

extern char CurrentLevel;
extern char CurrentWorld;

bool enableDaredevil;
extern bool enableSpeedy;
bool isFastFoe = false;
bool doneWithCosmic = false;
bool didSpawnCosmicChooser = false;

extern bool playerFuckeryEnabled;
extern u32 realPlayer;

int dScStage_c::newOnCreate() {
	dLevelInfo_c::entry_s *level = dLevelInfo_c::s_info.searchBySlot(CurrentWorld, CurrentLevel);

	if(level) {
		if(level->vignette == 1) {
			enableDaredevil = true;
		}

		if(level->vignette == 4) {
			enableSpeedy = true;
		}

		if(level->vignette == 6) {
			isFastFoe = true;
		}
	}

	if(playerFuckeryEnabled) {
		Player_Active[0] = 1;
		Player_Active[1] = 0;
		Player_Active[2] = 0;
		Player_Active[3] = 0;
		Player_ID[0] = Player_ID[realPlayer];
	}

	// if(level->vignette == 5 && !doneWithCosmic) {
	// 	if(!didSpawnCosmicChooser) {
	// 		Vec tagpos = (Vec){0, 0, 0};
	// 		CreateActor(112, 0, tagpos, 0, 0); //TAG_THUNDER
	// 		didSpawnCosmicChooser = true;
	// 	}
	// 	return false;
	// }
	// else {
		return this->onCreate_orig();
	// }
}


void newStartLevel(GameMgr *gameMgr, StartLevelInfo *level) {
	dLevelInfo_c::entry_s *lvl = dLevelInfo_c::s_info.searchBySlot(level->world1, level->level1);
	if((lvl->vignette == 5 || level->level1 == 26 || level->level1 == 28) && GetActivePlayerCount() > 1) {
		daMultiChooser_c* chooser = (daMultiChooser_c*)CreateObject(665, 0, 0); //WM_GRID
		chooser->gameMgr = gameMgr;
		chooser->lvl = *level;
	}
	else {
		DoStartLevel(gameMgr, level);
	}
}