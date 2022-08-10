#include <game.h>
#include "levelinfo.h"
#include <newer.h>

class PregameLytHandler {
	public:
		m2d::EmbedLayout_c layout;

		nw4r::lyt::Pane *rootPane;

		nw4r::lyt::TextBox
			*T_minus_00, *T_world_00, *T_worldNum_00,
			*T_pictureFont_00, *T_corseNum_00,
			*T_remainder_00, *T_remainder_01, *T_remainder_02, *T_remainder_03,
			*T_remainder_10, *T_remainder_11, *T_remainder_12, *T_remainder_13,
			*T_x_00, *T_x_01, *T_x_02, *T_x_03, *T_x_10, *T_x_11, *T_x_12, *T_x_13,
			*T_x_00_o, *T_x_10_o,
			*T_otasukePlay_00, *T_otasukePlay_01,
			*T_recommend_00, *T_remainder_00_o, *T_remainder_10_o;

		nw4r::lyt::Picture
			*P_Wx_00[9], *P_coin_00, *P_free_00,
			*P_batB_0x[4], *P_bat_00,
			*P_batB_1x[4], *P_bat_01,
			*P_batB_2x[4], *P_bat_02,
			*P_batB_3x[4], *P_bat_03,
			*P_luijiIcon_00_o, *P_luijiIcon_10_o, *P_coinStage_00;

		nw4r::lyt::Pane
			*N_mario_00, *N_luiji_00, *N_kinoB_01, *N_kinoY_00,
			*N_zankiPos_x[4], *N_zanki_00,
			*Null_battPosxP[4], *N_batt_x[4],
			*N_batt, *N_otasukePlay_00;

		u8 layoutLoaded, somethingHasBeenDone, isVisible, hasShownLuigiThing_orSomething;

		u32 currentStateID;

		u32 _2E8;

		u32 countdownToEndabilityCopy, activePlayerCountMultBy4_maybe;
		u32 batteryLevels[4];
		u32 pgCountdown;

		void hijack_loadLevelNumber(); // replaces 80B6BDD0
};

// Notes:
// Deleted; P_coinStage_00, T_recommend_00, T_worldNum_00,
// T_-_00, T_pictureFont_00, T_corseNum_00, T_world_00
// P_Wx_00, P_coin_00, P_free_00

extern char CurrentLevel;
extern char CurrentWorld;

void getNewerLevelNumberString(int world, int level, wchar_t *dest) {
	static const wchar_t *numberKinds[] = {
		// 0-19 are handled by code
		// To insert a picturefont character:
		// \x0B\x01YY\xZZZZ
		// YY is the character code, ZZZZ is ignored
		L"A", // 20, alternate
		L"\x0B\x012F\xBEEF",	// 21, Tower/Fortress
		L"\x0B\x0131\xF00D",	// 22, Ghost House
		L"\x0B\x012E\xCAFE",	// 23, Castle
		L"\x0B\x0131\xC0C0",	// 24, Cannon
		L"\x0B\x013D\xDEAD",	// 25, Final Castle
		L"\x0B\x013E\xFACE",	// 26, Ambush
		L"\x0B\x0132\xFADE",	// 27, Airship
		L"\x0B\x0137\xFEED",	// 28, Peach's Castle
		L"\x0B\x0133\xB105", 	// 29, Item House
		L"\x0B\x0138\x2BAD", 	// 30, Star House
		L"\x0B\x0139\xBABE", 	// 31, 1UP House
		L"\x0B\x013F\xBE11",	// 32, Anchor
		L"\x0B\x014D\xBA1D",	// 33, Coin
		L"B",					// 34, blternate
		L"C",					// 35, clternate
		L"Bonus",				// 36, Bonus
		// Any other one below is unused
		L"\x0B\x0133\xBEEF", // 37, shop
		L"\x0B\x0139\xBEEF", // 38, challenge house
		L"\x0B\x0151\xBEEF", // 39, red switch palace
		L"\x0B\x0152\xBEEF", // 40, blue switch palace
		L"\x0B\x0153\xBEEF", // 41, yellow switch palace
		L"\x0B\x0154\xBEEF", // 42, green switch palace
	};

	dest[0] = (world >= 10) ? (world-10+'A') : (world+'0');
	dest[1] = '-';
	if (level >= 20) { 
		wcscpy(&dest[2], numberKinds[level-20]);
	} else if (level >= 10) {
		dest[2] = '1';
		dest[3] = ('0' - 10) + level;
		dest[4] = 0;
	} else {
		dest[2] = '0' + level;
		dest[3] = 0;
	}
}

//None;   Black;  Purple; Blue;   Red;    DBlue;  Brown
//000000; CDCDCD; BB19FF; 004F7A; FF191F; 0926FF; EFAA00
u16 tailRed[7] =	{0, 0xCD, 0xBB, 0x00, 0xFF, 0x09, 0xEF};
u16 tailGreen[7] =	{0, 0xCD, 0x19, 0x4F, 0x19, 0x26, 0xAA};
u16 tailBlue[7] =	{0, 0xCD, 0xFF, 0x7A, 0x1F, 0xFF, 0x00};
bool doPreGameCometAnim = false;

void LoadPregameStyleNameAndNumber(m2d::EmbedLayout_c *layout) {
	nw4r::lyt::TextBox
		*LevelNumShadow, *LevelNum,
		*LevelNameShadow, *LevelName;

	LevelNumShadow = layout->findTextBoxByName("LevelNumShadow");
	LevelNum = layout->findTextBoxByName("LevelNum");
	LevelNameShadow = layout->findTextBoxByName("LevelNameShadow");
	LevelName = layout->findTextBoxByName("LevelName");

	// work out the thing now
	char ActualLevel = (CurrentLevel == 38) ? 28 : CurrentLevel; // Temp. Toad Houses set ID 38
	dLevelInfo_c::entry_s *level = dLevelInfo_c::s_info.searchBySlot(CurrentWorld, ActualLevel);
	if (level) {
		// wchar_t convLevelName[160];
		const wchar_t *srcLevelName = dLevelInfo_c::s_info.getNameForLevel(level);
		// int i = 0;
		// while (i < 159 && srcLevelName[i]) {
		// 	convLevelName[i] = srcLevelName[i];
		// 	i++;
		// }
		// convLevelName[i] = 0;
		// OSReport("srcLevelName: %X %p\n", srcLevelName, srcLevelName);
		LevelNameShadow->SetString(srcLevelName);
		LevelName->SetString(srcLevelName);

		wchar_t levelNumber[32];
		wcscpy(levelNumber, GetBMGMessage(0x66, 0x1F));
		int worldTextLen = wcslen(levelNumber);
		levelNumber[worldTextLen] = L' ';
		getNewerLevelNumberString(level->displayWorld, level->displayLevel, &levelNumber[worldTextLen+1]);

		LevelNum->SetString(levelNumber);

		// make the picture shadowy
		int sidx = 0;
		while (levelNumber[sidx]) {
			if (levelNumber[sidx] == 11) {
				levelNumber[sidx+1] = 0x200 | (levelNumber[sidx+1]&0xFF);
				sidx += 2;
			}
			sidx++;
		}
		LevelNumShadow->SetString(levelNumber);

		nw4r::lyt::Picture* PicCometTail = (nw4r::lyt::Picture*)layout->findPaneByName("PicCometTail");

		PicCometTail->material->whiteBlendingR = tailRed[level->vignette];
		PicCometTail->material->whiteBlendingG = tailGreen[level->vignette];
		PicCometTail->material->whiteBlendingB = tailBlue[level->vignette];

		doPreGameCometAnim = !(DontShowPreGame || (level->vignette == 0));
	} else {
		LevelNameShadow->SetString(L"Not found in LevelInfo!");
		LevelName->SetString(L"Not found in LevelInfo!");
		doPreGameCometAnim = false;
	}
}

extern u32 isInItemBowling;

#include "fileload.h"
void PregameLytHandler::hijack_loadLevelNumber() {
	LoadPregameStyleNameAndNumber(&layout);

	WriteBMGToTextBox(layout.findTextBoxByName("TxtComet"), GetBMG(), 0x3EA, 11, 0);
	WriteBMGToTextBox(layout.findTextBoxByName("ShaComet"), GetBMG(), 0x3EA, 11, 0);

	nw4r::lyt::Picture *LevelSample;
	LevelSample = layout.findPictureByName("LevelSample");

	// this is not the greatest way to read a file but I suppose it works in a pinch
	char ActualLevel = (CurrentLevel == 38) ? 28 : CurrentLevel;
	char tplName[64];
	sprintf(tplName, "/LevelSamples/%02d-%02d.tpl", CurrentWorld+1, ActualLevel+1);
	static File tpl;
	if (tpl.open(tplName)) {
		LevelSample->material->texMaps[0].ReplaceImage((TPLPalette*)tpl.ptr(), 0);
	}

	// if((CurrentWorld == 0 || CurrentWorld == 4) && (CurrentLevel == 26 || CurrentLevel == 28)) {//Is in W1 or W5, slot 27 or 29
	// 	isInItemBowling = 1;
	// }
	// else {
	// 	isInItemBowling = 0;
	// }
}


void doShit() {
	// DVD_LoadFile(GetDVDClass(), "Sound/stream", "STRM_BGM_SABAKU", 0);
	s32 entryNum;
	DVDHandle info;
	if ((entryNum = DVDConvertPathToEntrynum("/Sound/stream/STRM_BGM_SABAKU.brstm")) >= 0) {
		if (DVDFastOpen(entryNum, &info)) {
			return;
		}
	}
}

