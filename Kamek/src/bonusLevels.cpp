#include "bonusLevels.h"

dScBonusLevels_c *dScBonusLevels_c::instance = 0;

dScBonusLevels_c *dScBonusLevels_c::build() {
	void *buffer = AllocFromGameHeap1(sizeof(dScBonusLevels_c));
	dScBonusLevels_c *c = new(buffer) dScBonusLevels_c;

	instance = c;
	return c;
}


dScBonusLevels_c::dScBonusLevels_c() {
	yesNoWindow = (dYesNoWindow_c*)CreateParentedObject(YES_NO_WINDOW, this, 0, 0);
	CreateParentedObject(SELECT_CURSOR, this, 0, 0);
}

dScBonusLevels_c::~dScBonusLevels_c() {
}

extern "C" void MultiPlayCourseSelectDrawFunc();

extern "C" u32 currentHeap;
extern "C" void MakeScene(u32 heap, u32 unk);
extern "C" void LoadSceneLights(dScBonusLevels_c* bl, u32 unk);
extern "C" void LoadMapScene();

int dScBonusLevels_c::onCreate() {
	*CurrentDrawFunc = MultiPlayCourseSelectDrawFunc;
	if(!layoutLoaded) {
		// OSReport("loading...\n");
		if (!layout.loadArc("BonusCourseSelect.arc", false))
			return false;

		static const char *brlanNames[18] = {
			"BonusCourseSelect_inWindow.brlan",
			"BonusCourseSelect_inPause.brlan",
			"BonusCourseSelect_outPause.brlan",
			"BonusCourseSelect_inArrow.brlan",
			"BonusCourseSelect_onArrow.brlan",
			"BonusCourseSelect_offArrow.brlan",
			"BonusCourseSelect_loopArrow.brlan",
			"BonusCourseSelect_hitArrow.brlan",
			"BonusCourseSelect_outArrow.brlan",
			"BonusCourseSelect_toBefore.brlan",
			"BonusCourseSelect_toNext.brlan",
			"BonusCourseSelect_outWindow.brlan",
			"BonusCourseSelect_loopBG.brlan",
			"BonusCourseSelect_inButton.brlan",
			"BonusCourseSelect_onButton.brlan",
			"BonusCourseSelect_idleButton.brlan",
			"BonusCourseSelect_hitButton.brlan",
			"BonusCourseSelect_offButton.brlan",
		};

		static const char *groupNames[36] = {
			"A00_Window",
			"D00_Pause",
			"D00_Pause",
			"E00_arrowL", "E01_arrowR", "E02_arrowCL", "E03_arrowCR",
			"E00_arrowL", "E01_arrowR", "E02_arrowCL", "E03_arrowCR",
			"E00_arrowL", "E01_arrowR", "E02_arrowCL", "E03_arrowCR",
			"E00_arrowL", "E01_arrowR", "E02_arrowCL", "E03_arrowCR",
			"E00_arrowL", "E01_arrowR", "E02_arrowCL", "E03_arrowCR",
			"E00_arrowL", "E01_arrowR", "E02_arrowCL", "E03_arrowCR",
			"F00_page",
			"F00_page",
			"A00_Window",
			"C00_BG",
			"B02_centerButton",
			"B02_centerButton",
			"B02_centerButton",
			"B02_centerButton",
			"B02_centerButton",
		};

		static const int groupIDs[36] = {
			0,
			1,
			2,
			3, 3, 3, 3,
			4, 4, 4, 4,
			5, 5, 5, 5,
			6, 6, 6, 6,
			7, 7, 7, 7, 
			8, 8, 8, 8, 
			9,
			10,
			11,
			12,
			13,
			14,
			15,
			16,
			17,
		};

		layout.build("BonusCourseSelect.brlyt");

		layout.loadAnimations(brlanNames, 18);
		layout.loadGroups(groupNames, groupIDs, 36);
		layout.disableAllAnimations();

		// layout.drawOrder = 140;

		layoutLoaded = true;

		Samples[0] = layout.findPictureByName("P_LevelSample_00");
		Samples[1] = layout.findPictureByName("P_LevelSample_01");
		PFPs[0] = layout.findPictureByName("P_author_00");
		PFPs[1] = layout.findPictureByName("P_author_01");

		LevelNames[0] = layout.findTextBoxByName("T_titleMulti_00");
		LevelNames[1] = layout.findTextBoxByName("T_titleMulti_01");
		AuthorNames[0] = layout.findTextBoxByName("T_author_00");
		AuthorNames[1] = layout.findTextBoxByName("T_author_01");
		AuthorQuotes[0] = layout.findTextBoxByName("T_quote_00");
		AuthorQuotes[1] = layout.findTextBoxByName("T_quote_01");

		PropertiesContainers[0] = layout.findPaneByName("N_stuff_00");
		PropertiesContainers[1] = layout.findPaneByName("N_stuff_01");

		WriteBMGToTextBox(layout.findTextBoxByName("T_center_00"), GetBMG(), 0x3EA, 0, 0);
		WriteBMGToTextBox(layout.findTextBoxByName("T_center_01"), GetBMG(), 0x3EA, 0, 0);
		WriteBMGToTextBox(layout.findTextBoxByName("T_guideViewC_00"), GetBMG(), 2, 29, 0);

		// if (IsWideScreen()) {
		// 	N_flipbook_00->scale.x *= 1.372693726937269f;
		// }

		layout.enableLoopAnim(30);
		layout.enableNonLoopAnim(0); // inWindow
		layout.enableNonLoopAnim(31); // inButton


   		bonusLevelsFile = (BonusLevelsBinary*)LoadFile(&fileHandles[0], "/NewerRes/BonusLevels.bin");
		this->loadLevel(0, false);
		this->loadLevel(0, true);

		// MakeScene(currentHeap, 0x24);
		// LoadSceneLights(this, 1);
		LoadMapScene();
		GameSetup__LoadScene(0); // "lol, stolen from GAME_SETUP" -Ninji, before 2013 probably :p

		// OSReport("loaded!\n");
	}

	isVisible = true;

	return true;
}

int dScBonusLevels_c::onDelete() {
	FreeScene(0);
	FreeScene(1);

	CleanUpEffectThings();
	FreeEffects(1);
	FreeBreff(1);
	FreeBreft(1);
	
	for(int i = 0; i < 5; i++)
		FreeFile(&fileHandles[i]);

	return layout.free();
}

extern void callBonusLevelsState(dScBonusLevels_c* handler, u32 state);
int dScBonusLevels_c::onExecute() {
	int nowPressed = Remocon_GetPressed(GetActiveRemocon());
	// int nowHeld = Remocon_GetButtons(GetActiveRemocon());

	switch (yesNoStage) {
		case 1:
			// Opening
			if (!yesNoWindow->animationActive)
				yesNoStage = 2;
			return true;
		case 2:
			// Opened
			if (nowPressed & WPAD_LEFT)
				yesNoWindow->current = 1;
			else if (nowPressed & WPAD_RIGHT)
				yesNoWindow->current = 0;
			else if (Wiimote_TestButtons(GetActiveWiimote(), WPAD_A | WPAD_TWO)) {
				yesNoWindow->close = true;

				if (yesNoWindow->current != 1)
					yesNoWindow->hasBG = true;
				yesNoStage = 3;

			} else {
				// Cancel using B or 1
				if (CheckIfMenuShouldBeCancelledForSpecifiedWiimote(0)) {
					yesNoWindow->cancelled = true;
					yesNoWindow->current = 1;
					yesNoStage = 3;
				}
			}
			return true;
		case 3:
			// Closing
			if (!yesNoWindow->visible) {
				if (yesNoWindow->current == 1) {
					yesNoStage = 0;
					for (int i = 0; i < 40; i++)
						if (handle.Exists()) {
							handle.Pause(false, 3);
						}
				} else {
					yesNoStage = 4;
					this->finish(false);
				}

				UpdateSelectCursor(this->layout.findPaneByName("N_buttonO_00"), 0, false);
			}
			return true;
		case 4:
			// Waiting for exit transition
			return true;
	}

	// REMOVE THIS BEFORE RELEASE

	if(nowPressed & WPAD_B) {
		DoSceneChange(RH_DOUBLEDATE, 0, 0);
	}

	if (yesNoWindow->layoutLoaded && (nowPressed & WPAD_ONE)) {
		HideSelectCursor((void*)SelectCursorPointer, 0);
		yesNoStage = 1;
		yesNoWindow->type = 3;
		yesNoWindow->visible = true;

		if (handle.Exists()) {
			handle.Pause(true, 3);
		}
		return true;
	}

	callBonusLevelsState(this, currentStateID);

	// hmm
	
	layout.execAnimations();
	layout.update();

	return true;
}

void dScBonusLevels_c::state0_whatever() {
	if(!layout.isAnimOn(0) && !layout.isAnimOn(31)) {
		layout.enableNonLoopAnim(32);
		currentStateID++;
	}
}

void dScBonusLevels_c::state1_whatever() {
	if(!layout.isAnimOn(32)) {
		layout.enableNonLoopAnim(33);
		UpdateSelectCursor(this->layout.findPaneByName("N_buttonO_00"), 0, false);
		currentStateID++;
	}
}

void dScBonusLevels_c::state2_whatever() {
	if(!layout.isAnimOn(33)) {
		int nowPressed = Remocon_GetPressed(GetActiveRemocon());
		if(nowPressed & WPAD_TWO) {
			layout.enableNonLoopAnim(34);
			PlaySoundWithFunctionB4(SoundRelatedClass, &handle, 0x639, 1);
			HideSelectCursor((void*)SelectCursorPointer, 0);
			currentStateID += 3;
		}
		else if(nowPressed & WPAD_RIGHT && currentPage < bonusLevelsFile->levelCount-1) {
			this->moveLevel();
			currentPage++;
			this->loadLevel(currentPage, true);

			PlaySoundWithFunctionB4(SoundRelatedClass, &handle, 0x7D, 1);
			HideSelectCursor((void*)SelectCursorPointer, 0);
			layout.enableNonLoopAnim(35);
			layout.enableNonLoopAnim(28);
			currentStateID++;
		}
		else if(nowPressed & WPAD_LEFT && currentPage > 0) {
			this->moveLevel();
			currentPage--;
			this->loadLevel(currentPage, true);

			PlaySoundWithFunctionB4(SoundRelatedClass, &handle, 0x7D, 1);
			HideSelectCursor((void*)SelectCursorPointer, 0);
			layout.enableNonLoopAnim(35);
			layout.enableNonLoopAnim(27);
			currentStateID++;
		}
	}
}

void dScBonusLevels_c::state3_whatever() {
	if(!layout.isAnimOn(27) && !layout.isAnimOn(28) && !layout.isAnimOn(35)) {
		layout.enableNonLoopAnim(32);
		currentStateID++;
	}
}

void dScBonusLevels_c::state4_whatever() {
	if(!layout.isAnimOn(32)) {
		UpdateSelectCursor(this->layout.findPaneByName("N_buttonO_00"), 0, false);
		layout.enableNonLoopAnim(33);
		currentStateID -= 2;
	}
}

void dScBonusLevels_c::state5_whatever() {
	if(!layout.isAnimOn(34) && !handle.Exists()) {
		this->finish(true);
		// layout.enableNonLoopAnim(35);
		currentStateID++;
	}
}

void dScBonusLevels_c::state6_whatever() {
	// if(!layout.isAnimOn(35)) {
	// 	currentStateID++;
	// }
}

void dScBonusLevels_c::state7_whatever() {

}

void dScBonusLevels_c::state8_whatever() {

}

void dScBonusLevels_c::moveLevel() {
	FreeFile(&fileHandles[1]);
	FreeFile(&fileHandles[3]);

	fileHandles[1].filePtr = fileHandles[2].filePtr;
	fileHandles[1].length = fileHandles[2].length;
	fileHandles[3].filePtr = fileHandles[4].filePtr;
	fileHandles[3].length = fileHandles[4].length;
	Samples[0]->material->texMaps[0].ReplaceImage((TPLPalette*)fileHandles[1].filePtr, 0);
	PFPs[0]->material->texMaps[0].ReplaceImage((TPLPalette*)fileHandles[3].filePtr, 0);
	PFPs[0]->trans.y = PFPs[1]->trans.y;

	LevelNames[0]->SetString(LevelNames[1]->stringBuf);
	AuthorNames[0]->SetString(AuthorNames[1]->stringBuf);
	AuthorQuotes[0]->SetString(AuthorQuotes[1]->stringBuf);

	AuthorNames[0]->colour1 = AuthorNames[1]->colour1;
	AuthorNames[0]->colour2 = AuthorNames[1]->colour2;

	LevelNames[0]->colour1 = LevelNames[1]->colour1;
	LevelNames[0]->colour2 = LevelNames[1]->colour2;

	PropertiesContainers[0]->trans.y = PropertiesContainers[1]->trans.y;
}

extern u32 *GetCurrentPC();

void dScBonusLevels_c::loadLevel(u32 levelNum, bool isLeft) {
	// Sample
	u32 world = bonusLevelsFile->bonusLevelsInfo[levelNum].filenameW;
	u32 level = bonusLevelsFile->bonusLevelsInfo[levelNum].filenameL;
	char sampleName[64];
	sprintf(sampleName, "/LevelSamples/%02d-%02d.tpl", world+1, level+1);

	TPLPalette *sample = (TPLPalette*)LoadFile(&fileHandles[1+isLeft], sampleName);
	Samples[isLeft]->material->texMaps[0].ReplaceImage(sample, 0);

	// PFP
	char pfpName[64];
	sprintf(pfpName, "/Authors/%d.tpl", bonusLevelsFile->bonusLevelsInfo[levelNum].authorID);

	TPLPalette *pfp = (TPLPalette*)LoadFile(&fileHandles[3+isLeft], pfpName);
	OSReport("pfp: %p\n", pfp);
	OSReport("PC: %p\n", GetCurrentPC());
	PFPs[isLeft]->material->texMaps[0].ReplaceImage(pfp, 0);

	// Level Name
	dLevelInfo_c::entry_s *levelEntry = dLevelInfo_c::s_info.searchBySlot(world, level);
	if (levelEntry) {
		const wchar_t *srcLevelName = dLevelInfo_c::s_info.getNameForLevel(levelEntry);
		LevelNames[isLeft]->SetString(srcLevelName);
	}

	// Level Color
	LevelNames[isLeft]->colour1 = bonusLevelsFile->bonusLevelsInfo[levelNum].topLevelColor;
	LevelNames[isLeft]->colour2 = bonusLevelsFile->bonusLevelsInfo[levelNum].bottomLevelColor;

	// Author Name
	const wchar_t *authorName = (wchar_t*)((u32)bonusLevelsFile + bonusLevelsFile->bonusLevelsInfo[levelNum].authorNameOffset);
	AuthorNames[isLeft]->SetString(authorName);

	// Move Author PFP
	float transY = 0.0f;
	int nameIdx = 0;
	while(true) {
		wchar_t chr = authorName[nameIdx];
		if(chr == 0) break;
		if(chr == L'\n') transY -= 32.0f;
		nameIdx++;
	}
	PFPs[isLeft]->trans.y = transY;

	// Author Color
	AuthorNames[isLeft]->colour1 = bonusLevelsFile->bonusLevelsInfo[levelNum].topAuthorColor;
	AuthorNames[isLeft]->colour2 = bonusLevelsFile->bonusLevelsInfo[levelNum].bottomAuthorColor;

	// Author Quote
	const wchar_t *authorQuote = (wchar_t*)((u32)bonusLevelsFile + bonusLevelsFile->bonusLevelsInfo[levelNum].authorQuoteOffset);
	AuthorQuotes[isLeft]->SetString(authorQuote);
	OSReport("str%d: %s %p", levelNum, AuthorQuotes[isLeft]->name, authorQuote);
	OSReport(" %d\n", isLeft);
	// if(isLeft) AuthorQuotes[isLeft]->SetVisible(false);

	if(wcslen(authorQuote)) 
		PropertiesContainers[isLeft]->trans.y = 0.0f;
	else
		PropertiesContainers[isLeft]->trans.y = -32.0f;
}




int dScBonusLevels_c::onDraw() {
	if (isVisible) {
		layout.scheduleForDrawing();
	}

	return true;
}

void BonusLevelsDrawFunc() {
	Reset3DState();
	
	// LinkScene(0);
	// DrawOpa();
	// DrawXlu();
	// UnlinkScene(0);

	SetupLYTDrawing();
	DrawAllLayoutsBeforeX(0x81);
	RenderEffects(0, 3);
	RenderEffects(0, 2);
	GXDrawDone();
	RemoveAllFromScnRoot();
	Reset3DState();
	SetCurrentCameraID(1);
	DoSpecialDrawing1();

	// LinkScene(1);
	// DrawOpa();
	// DrawXlu();
	// UnlinkScene(1);

	SetCurrentCameraID(0);
	for (int i = 0; i < 4; i++)
		RenderEffects(0, 0xB+i);
	for (int i = 0; i < 4; i++)
		RenderEffects(0, 7+i);
	GXDrawDone();
	// Leaving out some stuff here
	DrawAllLayoutsAfterX(0x80);
	ClearLayoutDrawList();
	SetCurrentCameraID(0);
}


void dScBonusLevels_c::finish(bool startLevel) {
	if (handle.Exists())
		handle.Stop(5);

	ActivateWipe(WIPE_CIRCLE);

	if(startLevel) {
		for(int i = 0; i < 4; i++) {
			if(QueryPlayerAvailability(i)) {
				Player_Active[i] = 1;
				Player_Powerup[Player_ID[i]] = 0;
				Player_Flags[Player_ID[i]] = 0;
			}
		}



		u32 world = bonusLevelsFile->bonusLevelsInfo[currentPage].filenameW;
		u32 level = bonusLevelsFile->bonusLevelsInfo[currentPage].filenameL;

		StartLevelInfo sl;
		sl.replayTypeMaybe = 0;
		sl.entrance = 0xFF;
		sl.areaMaybe = 0;
		sl.unk4 = 0;
		sl.purpose = 0;

		sl.world1 = world;
		sl.world2 = world;
		sl.level1 = level;
		sl.level2 = level;

		DoStartLevel(GetGameMgr(), &sl);
	}
	else {
		DoSceneChange(GAME_SETUP, 1, 0);
	}

	// Level Stuff
}

