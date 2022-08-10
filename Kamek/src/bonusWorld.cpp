#include <game.h>
#include <common.h>

extern "C" void GoToSpecificWorld(u32 worldNum, bool isSubworld, u32 unk2);
extern "C" u8 CurrentWorldNumForWorldMap;
extern "C" bool currentWorldMapSubmapMaybe;
extern "C" u32 W9StrmMusic;
extern "C" u32 W9SeqMusic;

extern bool playerFuckeryEnabled;
extern u32 PlayerActiveBackup[4];
extern u32 PlayerIDBackup[4];

class dScWorldMap_c : public dActor_c {
	int onCreate_orig();
	int newOnCreate();

	int onExecute_orig();
	int newOnExecute();
};

int dScWorldMap_c::newOnCreate() {
	int orig_val = this->onCreate_orig();

	if(playerFuckeryEnabled) {
		for(int i = 0; i < 4; i++) {
			Player_Active[i] = PlayerActiveBackup[i];
			Player_ID[i] = PlayerIDBackup[i];
		}
		playerFuckeryEnabled = false;
	}

	return orig_val;
}

int dScWorldMap_c::newOnExecute() {
	int orig_val = this->onExecute_orig();


	int nowPressed = Remocon_GetPressed(GetActiveRemocon());

	if (nowPressed & WPAD_B && CurrentWorldNumForWorldMap == 8) {
		if(currentWorldMapSubmapMaybe) {
			W9StrmMusic = 0x747;
			W9SeqMusic = 0x7AD;
		}
		else {
			W9StrmMusic = 0x73A;
			W9SeqMusic = 0x790;
		}
		ActivateWipe(5);
		SaveBlock *save = GetSaveFile()->GetBlock(-1);
		save->current_path_node = 0;
		GoToSpecificWorld(8, !currentWorldMapSubmapMaybe, 0);
	}

	return orig_val;
}