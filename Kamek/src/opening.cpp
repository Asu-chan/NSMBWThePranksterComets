#include "opening.h"
void *EGG__Heap__alloc(unsigned long size, int unk, void *heap);
void EGG__Heap__free(void *ptr, void *heap);

dScOpening_c *dScOpening_c::instance = 0;

dScOpening_c *dScOpening_c::build() {
	// return new dScOpening_c;
	void *buffer = AllocFromGameHeap1(sizeof(dScOpening_c));
	dScOpening_c *c = new(buffer) dScOpening_c;

	instance = c;
	return c;
}

const char *CreditsFileList[] = {"CreditsBG", 0};
// extern "C" void dRes_c_LoadFileList(void* dvdclass, char* folder, const char* list[], u32 count, u32 unk);
// extern "C" ClassWithCameraInfo* CWCICT();

bool Opening_StartLoading(void*);
bool Opening_DoLoading(void*);
bool Opening_EndLoading(void*);

// bool* initFunctions[] = {
// 	(bool*)&Opening_StartLoading,
// 	(bool*)&Opening_DoLoading,
// 	(bool*)&Opening_EndLoading
// };

bool Opening_StartLoading() {
	DVD_Start();
	return true;
}

bool Opening_DoLoading() {
	DVD_LoadFile(GetDVDClass(), "Object", "OpeningPics", 0);
	DVD_LoadFile(GetDVDClass(), "Object", "CreditsBG", 0);
	return true;
}

bool Opening_EndLoading() {
	if (DVD_StillLoading(GetDVDClass2())) {
		return false;
	}

	DVD_End();
	return true;
}

dScOpening_c::dScOpening_c() {
	yesNoWindow = (dYesNoWindow_c*)CreateParentedObject(YES_NO_WINDOW, this, 0, 0);
	CreateParentedObject(SELECT_CURSOR, this, 0, 0);

	// dRes_c_LoadFileList(DVDClass, "Object", CreditsFileList, 1, 0);
	// ClassWithCameraInfo::instance = CWCICT();
	// initChain.setup(initFunctions, 2);

	// setInitChain(initChain);
}

// dScOpening_c::~dScOpening_c() {
// }



TPLPalette* lastLeft;
TPLPalette* lastRight;
TPLPalette* currLeft;
TPLPalette* currRight;

int dScOpening_c::onCreate() {

	if(currentFunc < 3) {
		switch(currentFunc) {
			case 0:
				if(Opening_StartLoading()) {
					currentFunc++;
				}
				break;
			case 1:
				if(Opening_DoLoading()) {
					currentFunc++;
				}
				break;
			case 2:
				if(Opening_EndLoading()) {
					currentFunc++;
				}
				break;
		}
		return false;
	}

	*CurrentDrawFunc = OpeningDrawFunc;
	if(!layoutLoaded) {
		if (!layout.loadArc("flipbook.arc", false))
			return false;

		static const char *brlanNames[9] = {
			"flipbook_artIdle.brlan",
			"flipbook_pageNext.brlan",
			"flipbook_pageBefore.brlan",
			"flipbook_textboxAppear.brlan",
			"flipbook_textboxIdle.brlan",
			"flipbook_textboxDisappear.brlan",
			"flipbook_buttonAppear.brlan",
			"flipbook_buttonIdle.brlan",
			"flipbook_buttonDisappear.brlan",
		};

		static const char *groupNames[9] = {
			"A00_flipbook", "A00_flipbook", "A00_flipbook",
			"B00_textBox", "B00_textBox", "B00_textBox",
			"C00_button", "C00_button", "C00_button",
		};

		static const int groupIDs[9] = {
			0, 1, 2,
			3, 4, 5,
			6, 7, 8,
		};

		layout.build("flipbook.brlyt");

		layout.loadAnimations(brlanNames, 9);
		layout.loadGroups(groupNames, groupIDs, 9);
		layout.disableAllAnimations();

		// layout.drawOrder = 140;

		layoutLoaded = true;

		N_flipbook_00 = layout.findPaneByName("N_flipbook_00");
		P_rightPage_00 = layout.findPictureByName("P_rightPage_00");
		P_leftPage_00 = layout.findPictureByName("P_leftPage_00");
		P_orightPage_00 = layout.findPictureByName("P_orightPage_00");
		P_oleftPage_00 = layout.findPictureByName("P_oleftPage_00");
		P_nrightPage_00 = layout.findPictureByName("P_nrightPage_00");
		P_nleftPage_00 = layout.findPictureByName("P_nleftPage_00");
		T_DialogueTxt_00 = layout.findTextBoxByName("T_DialogueTxt_00");
		T_DialogueSha_00 = layout.findTextBoxByName("T_DialogueSha_00");

		if (IsWideScreen()) {
			N_flipbook_00->scale.x *= 1.372693726937269f;
		}

		this->loadIdlePic();
		layout.enableNonLoopAnim(0);
		layout.enableNonLoopAnim(6);
	}

	isVisible = true;

	// renderer.allocator.setup(GameHeaps[0], 0x20);
	// bool result = renderer.setup(&renderer.allocator);

	// renderer.loadNewBG(1, false);

	// OSReport("created!\n");
    
    openingFile = (OpeningBinary*)LoadFile(&fileHandle, "/NewerRes/Opening.bin");

	return true;
}

int dScOpening_c::onDelete() {
	FreeFile(&fileHandle);
	DVD_FreeFile(GetDVDClass2(), "OpeningPics");
	return layout.free();
}

extern void callOpeningState(dScOpening_c* handler, u32 state);
int dScOpening_c::onExecute() {
	// OSReport("executing! %d %d %d\n", layout.isAnimOn(0), layout.isAnimOn(1), layout.isAnimOn(2));

	// renderer.execute();

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
						if (handles[i].Exists()) {
							handles[i].Pause(false, 3);
						}
				} else {
					yesNoStage = 4;
					this->finish();
				}
			}
			return true;
		case 4:
			// Waiting for exit transition
			return true;
	}

	if (yesNoWindow->layoutLoaded && (nowPressed & WPAD_PLUS)) {
		yesNoStage = 1;
		yesNoWindow->type = 25;
		yesNoWindow->visible = true;

		for (int i = 0; i < 40; i++)
			if (handles[i].Exists()) {
				handles[i].Pause(true, 3);
			}
		return true;
	}

	// Let's get our shit started

	callOpeningState(this, currentStateID);

	if (!layout.isAnimOn(0) && !layout.isAnimOn(1) && !layout.isAnimOn(2)) {
		// OSReport("loop!\n");
		layout.enableNonLoopAnim(0);
	}
	
	layout.execAnimations();
	layout.update();

	return true;
}

wchar_t *dScOpening_c::getTextForPage(int page) {
	return (wchar_t *)((u32)this->openingFile + this->openingFile->openingInfo[page].textOffset);
}

void dScOpening_c::state0_whatever() {
	if (!layout.isAnimOn(1) && !layout.isAnimOn(2)) {
		u16 musicID = this->openingFile->openingInfo[currentPicture].musicID;
		if(this->currentMusicID != musicID) {
			if(handles[musicHandleID].Exists()) {
				handles[musicHandleID].Stop(1);
			}
			musicHandleID = (musicHandleID == 1) ? 2 : 1;
			PlaySoundWithFunctionB4(SoundRelatedClass, &handles[musicHandleID], musicID, 1);
			this->currentMusicID = musicID;
		}

		u16 sfxID = this->openingFile->openingInfo[currentPicture].sfxID;
		if(sfxID != 0) {
			PlaySoundWithFunctionB4(SoundRelatedClass, &handles[3], sfxID, 1);
		}

		T_DialogueTxt_00->SetString(L"\u0000");
		T_DialogueSha_00->SetString(L"\u0000");

		layout.disableAllAnimations();
		layout.enableNonLoopAnim(3);

		currentStateID++;
	}
}

void dScOpening_c::state1_whatever() {
	if (!layout.isAnimOn(3)) {
		int nowHeld = Remocon_GetButtons(GetActiveRemocon());
		int nowPressed = Remocon_GetPressed(GetActiveRemocon());
		if(nowPressed & WPAD_TWO) this->textTimer = 0;
		if(this->textTimer == ((nowHeld & WPAD_TWO) ? 2 : 5)) {
			this->currentChar++;

			wchar_t chars[150];
			wchar_t *txt = getTextForPage(this->currentPicture);

			while(txt[this->currentChar-1] == ' ' || txt[this->currentChar-1] == '\n') {
				this->currentChar++;
			}

			if((txt[this->currentChar-1] == '.' /*|| txt[this->currentChar-1] == '!'*/ || txt[this->currentChar-1] == '?') && txt[this->currentChar] != '.') 
				this->waitingTime = 50;
			else if(txt[this->currentChar-1] == ',' || txt[this->currentChar-1] == ':')
				this->waitingTime = 20;

			u32 chrCount = 0;
			u32 lineCount = 1;
			for(int i = 0; i < this->currentChar; i++) {
				chars[i] = txt[i];
				if(txt[i] == '\n') {
					lineCount++;
				}
				chrCount++;
			}

			for(int i = lineCount; i < this->openingFile->openingInfo[this->currentPicture].lineCount; i++) {
				chars[chrCount] = '\n';
				chrCount++;
			}

			chars[chrCount] = 0;

			T_DialogueTxt_00->SetString(chars);
			T_DialogueSha_00->SetString(chars);

			this->textTimer = 0;

			if(this->currentChar == this->openingFile->openingInfo[this->currentPicture].chrCount) {
				this->currentChar = 0;
				this->waitingTime = 0;
				currentStateID++;
			}
		}

		if(this->waitingTime) {
			this->waitingTime--;
		}
		else {
			this->textTimer++;
		}

	}
}

void dScOpening_c::state2_whatever() {
	if (!layout.isAnimOn(3)) {
		layout.disableAllAnimations();
		layout.enableNonLoopAnim(6);
		currentStateID++;
	}
}

void dScOpening_c::state3_whatever() {
	if (!layout.isAnimOn(6)) {
		layout.disableAllAnimations();
		layout.enableNonLoopAnim(7);
		currentStateID++;
	}
}

void dScOpening_c::state4_whatever() {
	if (!layout.isAnimOn(7)) {
		layout.enableNonLoopAnim(7);
	}

	int nowPressed = Remocon_GetPressed(GetActiveRemocon());
	if(nowPressed & WPAD_TWO) {
		layout.disableAllAnimations();
		layout.enableNonLoopAnim(8);
		if(this->currentPicture < this->openingFile->pagesCount-1) {
			PlaySoundWithFunctionB4(SoundRelatedClass, &handles[0], SFX_BUTTONPRESS, 1);
			currentStateID++;
		}
		else {
			currentStateID += 4;
		}
	}
	else if(nowPressed & WPAD_B && this->currentPicture > 0) {
		layout.enableNonLoopAnim(5);
		currentStateID += 3;
	}
}

void dScOpening_c::state5_whatever() {
	if (!layout.isAnimOn(8)) {
		layout.disableAllAnimations();
		layout.enableNonLoopAnim(5);
		currentStateID++;
	}
}

void dScOpening_c::state6_whatever() {
	if (!layout.isAnimOn(5)) {
		this->loadNextPic();
		// renderer.isEnabled = true;
		// renderer.flipFrame = 0;
		// renderer.scheduledBG = this->currentPicture;
		layout.disableAllAnimations();
		layout.enableNonLoopAnim(1);
		PlaySoundWithFunctionB4(SoundRelatedClass, &handles[0], SFX_PAGEFLIP, 1);
		currentStateID = 0;
	}
}

void dScOpening_c::state7_whatever() {
	if (!layout.isAnimOn(5)) {
		this->loadPrevPic();
		layout.disableAllAnimations();
		layout.enableNonLoopAnim(2);
		PlaySoundWithFunctionB4(SoundRelatedClass, &handles[0], SFX_PAGEFLIP, 1);
		currentStateID = 0;
	}
}

void dScOpening_c::state8_whatever() {
	if (!layout.isAnimOn(8) && !layout.isAnimOn(5)) {
		layout.disableAllAnimations();
		layout.enableNonLoopAnim(5);
		this->finish();
	}
}




int dScOpening_c::onDraw() {
	// renderer.scheduleForDrawing();
	if (isVisible) {
		layout.scheduleForDrawing();
	}

	return true;
}

void OpeningDrawFunc() {
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

/*void NewerMapDrawFunc() {
	Reset3DState();
	SetCurrentCameraID(0);
	// DoSomethingCameraRelatedWithEGGScreen(0, &dWorldCamera_c::instance->screen);
	LinkScene(0);
	SceneCalcWorld(0);
	SceneCameraStuff(0);
	ChangeAlphaUpdate(false);
	DrawOpa();
	DrawXlu();
	UnlinkScene(0);
	// Something
	SetupLYTDrawing();
	DrawAllLayoutsBeforeX(0x81);
	RenderEffects(0, 3);
	RenderEffects(0, 2);
	GXDrawDone();
	RemoveAllFromScnRoot();
	Reset3DState();
	SetCurrentCameraID(1);
	DoSpecialDrawing1();
	LinkScene(1);
	SceneCalcWorld(1);
	SceneCameraStuff(1);
	CalcMaterial();
	DrawOpa();
	DrawXlu();
	UnlinkScene(1);
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
}*/

void dScOpening_c::loadIdlePic() {
	char leftName[32];
	char rightName[32];
	sprintf(leftName, "/Page%dleft.tpl.LZ", this->currentPicture);
	sprintf(rightName, "/Page%dright.tpl.LZ", this->currentPicture);
	OSReport("Getting %s and %s\n", leftName, rightName);

	u8 *leftBuf = getResource("OpeningPics", leftName);
	u32 leftBufSize = CXGetUncompressedSize(leftBuf);
	EGG__Heap__free(lastLeft, GameHeaps[2]);
	lastLeft = currLeft;
	currLeft = (TPLPalette*)EGG__Heap__alloc(leftBufSize, 0x20, GameHeaps[2]);
	CXUncompressLZ(leftBuf, currLeft);

	// TPLBind(currLeft);
	// TPLImage *image = TPLGet(currLeft, 0);
	// TPLTexHeader *tex = image->texture;
	// OSReport("Received TPLHeader %p; Data: %p; Size: %d x %d; Format; %d\n", tex, tex->data, tex->width, tex->height, tex->format);

	P_leftPage_00->material->texMaps[0].ReplaceImage(currLeft, 0);

	u8 *rightBuf = getResource("OpeningPics", rightName);
	u32 rightBufSize = CXGetUncompressedSize(rightBuf);
	EGG__Heap__free(lastRight, GameHeaps[2]);
	lastRight = currRight;
	currRight = (TPLPalette*)EGG__Heap__alloc(rightBufSize, 0x20, GameHeaps[2]);
	CXUncompressLZ(rightBuf, currRight);

	// TPLBind(currRight);
	// image = TPLGet(currRight, 0);
	// tex = image->texture;
	// OSReport("Received TPLHeader %p; Data: %p; Size: %d x %d; Format; %d\n", tex, tex->data, tex->width, tex->height, tex->format);

	P_rightPage_00->material->texMaps[0].ReplaceImage(currRight, 0);
}

extern "C" u32 AssembleDefaultScWorldMapSettings();

void dScOpening_c::loadNextPic() {
	this->currentPicture++;
	loadIdlePic();
	P_oleftPage_00->material->texMaps[0].ReplaceImage(lastLeft, 0);
	P_orightPage_00->material->texMaps[0].ReplaceImage(lastRight, 0);
	P_nleftPage_00->material->texMaps[0].ReplaceImage(currLeft, 0);
}

void dScOpening_c::loadPrevPic() {
	this->currentPicture--;
	loadIdlePic();
	P_oleftPage_00->material->texMaps[0].ReplaceImage(lastLeft, 0);
	P_orightPage_00->material->texMaps[0].ReplaceImage(lastRight, 0);
	P_nrightPage_00->material->texMaps[0].ReplaceImage(currRight, 0);
}


void dScOpening_c::finish() {
	// we're TOTALLY done!
	OSReport("playback complete\n");

	for (int i = 0; i < 40; i++)
		if (handles[i].Exists())
			handles[i].Stop(5);

	// So quick explanation, we make the save think we saw the W1 cutscene already and then write this save to memory, and then edit it to make the cutscene play but do not write it to memory this time.
	// This way, the animation plays but when exiting and coming back, it doesn't replay
	// Clever Nintendo, very clever...

	SaveFile* save = GetSaveFile();
	SaveBlock* saveBlock = save->GetBlock(-1);

	// Stolen from 80922ED0
	saveBlock->OrR5AgaginstByteFromWorldAvailableArrayAt0x32ofWorldData(0, 1);
	save->SaveCurrentData_Maybe();
	save->create_hash_for_savefile();
	save->WriteSavefileToRegularBuffer();

	// Stolen from 80922F80
	saveBlock->ClearR5FromByteInWorldAvailableArrayAt0x32ofWorldData(0, 1);

	ActivateWipe(WIPE_FADE);
	DoSceneChange(WORLD_MAP, (AssembleDefaultScWorldMapSettings()), 0);
}

/*
void *EGG__Heap__alloc(unsigned long size, int unk, void *heap);
void EGG__Heap__free(void *ptr, void *heap);

mTexture_c efbTexture;
bool getNextEFB = false;
int thing = 0;

extern "C" void GXPixModeSync();

void dFlipbookRenderer_c::execute() {
	if (flipFrame == 7) {
		loadNewBG(scheduledBG, true);
	}

	if (isEnabled) {
		flipFrame += 7;

		// ClassWithCameraInfo *cwci = ClassWithCameraInfo::instance;
		OSReport("cwci: %d\n", 100);
		if (flipFrame > 100) {
			loadNewBG(scheduledBG, false);
			// dCreditsMgr_c::instance->animComplete();

			// if (!dCreditsMgr_c::instance->endingMode)
			// 	MakeMarioExitDemoMode();
			isEnabled = false;
			OSReport("DONE!\n");
		}
	}
}


static void setupGXForDrawingCrap() {
	GXSetNumChans(0);
	GXSetChanCtrl(GX_COLOR0A0, GX_DISABLE, GX_SRC_REG, GX_SRC_REG, GX_LIGHTNULL, GX_DF_NONE, GX_AF_NONE);
	GXSetChanAmbColor(GX_COLOR0A0, (GXColor){255,255,255,255});
	GXSetChanMatColor(GX_COLOR0A0, (GXColor){255,255,255,255});
	GXSetNumTexGens(1);
	GXSetTexCoordGen2(GX_TEXCOORD0, GX_TG_MTX3x4, GX_TG_NRM, GX_IDENTITY, GX_FALSE, GX_DTTIDENTITY);

	GXSetNumTevStages(1);
	GXSetNumIndStages(0);
	for (int i = 0; i < 0x10; i++)
		GXSetTevDirect(i);

	GXSetTevOp(GX_TEVSTAGE0, GX_REPLACE);
	GXSetTevOrder(GX_TEVSTAGE0, GX_TEXCOORD0, GX_TEXMAP0, GX_COLORNULL);

	GXSetTevSwapModeTable(GX_TEV_SWAP0, GX_CH_RED, GX_CH_GREEN, GX_CH_BLUE, GX_CH_ALPHA);

	GXSetZCompLoc(GX_FALSE);
	GXSetBlendMode(GX_BM_BLEND, GX_BL_SRCALPHA, GX_BL_INVSRCALPHA, GX_LO_SET);
	//GXSetBlendMode(GX_BM_NONE, GX_BL_ZERO, GX_BL_ZERO, GX_LO_SET);
	GXSetZMode(GX_TRUE, GX_ALWAYS, GX_FALSE);
	GXSetAlphaCompare(GX_ALWAYS, 0, GX_AOP_OR, GX_ALWAYS, 0);

	GXSetFog(GX_FOG_NONE, 0, 0, 0, 0, (GXColor){0,0,0,0});
	GXSetFogRangeAdj(GX_FALSE, 0, 0);

	GXSetAlphaUpdate(GX_TRUE);

	GXSetCullMode(GX_CULL_NONE);

	GXSetDither(GX_TRUE);

	GXSetTevColor(GX_TEVREG0, (GXColor){255,255,255,255});
	GXSetTevColor(GX_TEVREG1, (GXColor){255,255,255,255});
	GXSetTevColor(GX_TEVREG2, (GXColor){255,255,255,255});

	GXSetZMode(GX_TRUE, GX_LEQUAL, GX_TRUE);

	nw4r::g3d::Camera cam(GetCameraByID(GetCurrentCameraID()));
	OSReport("cam: %p\n", &cam);
	Mtx matrix;
	cam.GetCameraMtx(&matrix);
	GXLoadPosMtxImm(matrix, 0);
	GXSetCurrentMtx(0);

	GXClearVtxDesc();

	GXSetVtxDesc(GX_VA_POS, GX_DIRECT);
	GXSetVtxDesc(GX_VA_NRM, GX_DIRECT);

	GXSetVtxAttrFmt(GX_VTXFMT0, GX_VA_POS, GX_POS_XYZ, GX_F32, 0);
	GXSetVtxAttrFmt(GX_VTXFMT0, GX_VA_NRM, GX_NRM_XYZ, GX_F32, 0);
}

void dFlipbookRenderer_c::drawXlu() {
	OSReport("xlu\n");
	if (!isEnabled || flipFrame < 2)
		return;

	setupGXForDrawingCrap();

	// ClassWithCameraInfo *cwci = ClassWithCameraInfo::instance;

	float screenTop = 100;
	float left = 0;
	float right = 200;

	float halfWidth = (200 * 0.5f);
	float midpoint = left + halfWidth;

	float value = (flipFrame / 200);
	float sinThing = 50.0f * sin(3.14159f * value);

	bool drawBackside = (flipFrame > halfWidth);

	float xformedFlipEdge = right - flipFrame;

	// EFB SPECIFIC VERTICAL VARIABLES
	float efbEffectiveHeight = 100;
	if (!IsWideScreen())
		efbEffectiveHeight *= 1.295f;

	float efbHalfHeight = (efbEffectiveHeight * 0.5f);

	float efbYCentre = screenTop - (100 * 0.5f);
	if (!IsWideScreen())
		efbYCentre += 1.0f;
	float efbTop = efbYCentre + efbHalfHeight;
	float efbBottom = efbYCentre - efbHalfHeight;

	float efbExCoord = (efbEffectiveHeight + sinThing + sinThing) * 0.5f;
	// TPL SPECIFIC VERTICAL VARIABLES
	float tplHalfHeight = 100 * 0.5f;
	float tplTop = screenTop;
	float tplBottom = screenTop - 100;

	float tplExCoord = (100 + sinThing + sinThing) * 0.5f;


	// EFB Left
	efbTexture.load(GX_TEXMAP0);

	GXBegin(GX_QUADS, GX_VTXFMT0, 4);
	{
		// Bottom Right
		GXPosition3f32(midpoint, efbBottom, 9990.0f);
		GXNormal3f32(0.5f, 1.0f, 1.0f);
		// Top Right
		GXPosition3f32(midpoint, efbTop, 9990.0f);
		GXNormal3f32(0.5f, 0.0f, 1.0f);
		// Top Left
		GXPosition3f32(left, efbTop, 9990.0f);
		GXNormal3f32(0.0f, 0.0f, 1.0f);
		// Bottom Left
		GXPosition3f32(left, efbBottom, 9990.0f);
		GXNormal3f32(0.0f, 1.0f, 1.0f);
	}
	GXEnd();

	// TPL Right
	GXLoadTexObj(&bgTexObj[1], GX_TEXMAP0);

	GXBegin(GX_QUADS, GX_VTXFMT0, 4);
	{
		// Bottom Right
		GXPosition3f32(right, tplBottom, 9990.0f);
		GXNormal3f32(1.0f, 1.0f, 1.0f);
		// Top Right
		GXPosition3f32(right, tplTop, 9990.0f);
		GXNormal3f32(1.0f, 0.0f, 1.0f);
		// Top Left
		GXPosition3f32(midpoint, tplTop, 9990.0f);
		GXNormal3f32(0.5f, 0.0f, 1.0f);
		// Bottom Left
		GXPosition3f32(midpoint, tplBottom, 9990.0f);
		GXNormal3f32(0.5f, 1.0f, 1.0f);

	}
	GXEnd();


	if (!drawBackside) {
		// Flipping right side: EFB

		efbTexture.load(GX_TEXMAP0);

		GXBegin(GX_QUADS, GX_VTXFMT0, 4);

		// EFB Right (Flipped)
		// Bottom Left
		GXPosition3f32(midpoint, efbBottom, 9990.0f);
		GXNormal3f32(efbHalfHeight * 0.5f, efbHalfHeight, efbHalfHeight);
		// Top Left
		GXPosition3f32(midpoint, efbTop, 9990.0f);
		GXNormal3f32(efbHalfHeight * 0.5f, 0.0f, efbHalfHeight);
		// Top Right
		GXPosition3f32(xformedFlipEdge, efbTop + sinThing, 9990.0f);
		GXNormal3f32(efbExCoord, 0.0f, efbExCoord);
		// Bottom Right
		GXPosition3f32(xformedFlipEdge, efbBottom - sinThing, 9990.0f);
		GXNormal3f32(efbExCoord, efbExCoord, efbExCoord);

		GXEnd();

	} else {
		// Flipping left side

		GXLoadTexObj(&bgTexObj[1], GX_TEXMAP0);

		GXBegin(GX_QUADS, GX_VTXFMT0, 4);

		// TPL Left (Flipped))
		// Bottom Left
		GXPosition3f32(xformedFlipEdge, tplBottom - sinThing, 9990.0f);
		GXNormal3f32(0.0f, tplExCoord, tplExCoord);
		// Top Left
		GXPosition3f32(xformedFlipEdge, tplTop + sinThing, 9990.0f);
		GXNormal3f32(0.0f, 0.0f, tplExCoord);
		// Top Right
		GXPosition3f32(midpoint, tplTop, 9990.0f);
		GXNormal3f32(tplHalfHeight * 0.5f, 0.0f, tplHalfHeight);
		// Bottom Right
		GXPosition3f32(midpoint, tplBottom, 9990.0f);
		GXNormal3f32(tplHalfHeight * 0.5f, tplHalfHeight, tplHalfHeight);

		GXEnd();
	}
}


void dFlipbookRenderer_c::drawOpa() {
	OSReport("opa\n");
	setupGXForDrawingCrap();

	GXLoadTexObj(&bgTexObj[0], GX_TEXMAP0);

	// ClassWithCameraInfo *cwci = ClassWithCameraInfo::instance;
	float left = 0;
	float right = 100;
	float top = 0;
	float bottom = 200;

	GXBegin(GX_QUADS, GX_VTXFMT0, 4);
	GXPosition3f32(right, bottom, -4000.0f);
	GXNormal3f32(1.0f, 1.0f, 1.0f);
	GXPosition3f32(right, top, -4000.0f);
	GXNormal3f32(1.0f, 0.0f, 1.0f);
	GXPosition3f32(left, top, -4000.0f);
	GXNormal3f32(0.0f, 0.0f, 1.0f);
	GXPosition3f32(left, bottom, -4000.0f);
	GXNormal3f32(0.0f, 1.0f, 1.0f);
	GXEnd();
}

void dFlipbookRenderer_c::loadNewBG(int bgID, bool isBackface) {
	OSReport("Will load BG: %d\n", bgID);

	int setID = isBackface ? 1 : 0;

	char bgName[32];
	sprintf(bgName, isBackface ? "/Back%d.tpl.LZ" : "/BG%d.tpl.LZ", bgID);
	OSReport("Getting %s\n", bgName);

	u8 *sourceBuf = getResource("CreditsBG", bgName);
	u32 bufSize = CXGetUncompressedSize(sourceBuf);

	if (tplBuffer[setID] && (tplBufferSize[setID] != bufSize)) {
		OSReport("Current TPL buffer (%p) is size %d (0x%x), freeing\n", tplBuffer[setID], tplBufferSize[setID], tplBufferSize[setID]);
		EGG__Heap__free(tplBuffer[setID], GameHeaps[2]);
		tplBuffer[setID] = 0;
	}

	if (!tplBuffer[setID]) {
		OSReport("Allocating TPL buffer of size %d (0x%x)\n", bufSize, bufSize);
		tplBuffer[setID] = (char*)EGG__Heap__alloc(bufSize, 0x20, GameHeaps[2]);
		tplBufferSize[setID] = bufSize;
	}

	CXUncompressLZ(sourceBuf, tplBuffer[setID]);
	OSReport("Butts. Decompressing %p to %p.\n", sourceBuf, tplBuffer[setID]);

	TPLBind((TPLPalette*)tplBuffer[setID]);
	TPLImage *image = TPLGet((TPLPalette*)tplBuffer[setID], 0);
	TPLTexHeader *tex = image->texture;
	OSReport("Received TPLHeader %p; Data: %p; Size: %d x %d; Format; %d\n", tex, tex->data, tex->width, tex->height, tex->format);

	GXInitTexObj(&bgTexObj[setID], tex->data, tex->width, tex->height,
			tex->format, tex->wrapS, tex->wrapT, GX_FALSE);
}

dFlipbookRenderer_c::dFlipbookRenderer_c() {
	scheduledBG = 0;
}

dFlipbookRenderer_c::~dFlipbookRenderer_c() {
	for (int setID = 0; setID < 2; setID++) {
		if (tplBuffer[setID]) {
			EGG__Heap__free(tplBuffer[setID], GameHeaps[2]);
			tplBuffer[setID] = 0;
		}
	}
}
*/