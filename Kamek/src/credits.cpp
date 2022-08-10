#include "credits.h"
#include "creditsCam.h"


/****************/
/* Initializing */
/****************/

// Text processing states
CREATE_STATE(dScStaffCredits_c, Init);
CREATE_STATE(dScStaffCredits_c, HandleTextAppear);
CREATE_STATE(dScStaffCredits_c, SaveAndQuit);
// Scrolling states
CREATE_STATE_E(dScStaffCredits_c, Wait);
CREATE_STATE(dScStaffCredits_c, DoTextMovement);

// Instancing
dScStaffCredits_c *dScStaffCredits_c::instance = 0;

dScStaffCredits_c *dScStaffCredits_c::build() {
	void *buffer = AllocFromGameHeap1(sizeof(dScStaffCredits_c));
	dScStaffCredits_c *c = new(buffer) dScStaffCredits_c;

	instance = c;
	return c;
}

#include <profile.h>
Profile StaffCreditsProfile = Profile((buildFunc)&dScStaffCredits_c::build, ProfileId::STAFFCREDITS, 0, ProfileId::STAFFCREDITS, ProfileId::STAFFCREDITS, 0, "STAFFCREDITS", 0);

dScStaffCredits_c::dScStaffCredits_c() : acState(this, &StateID_Init), acState2(this, &StateID_Wait) {
	yesNoWindow = (dYesNoWindow_c*)CreateParentedObject(YES_NO_WINDOW, this, 0, 0);
	CreateParentedObject(SELECT_CURSOR, this, 0, 0);

	dCreditsCamera_c *cam = (dCreditsCamera_c*)CreateParentedObject(STAFFCREDITS_CAMERA, this, 0, 0);
	cam->currentX = 0;
	cam->currentY = 2385;
	cam->currentZ = 495;
	
	DVD_LoadFile(GetDVDClass(), "Object", "bgA_0104", 0);
	DVD_LoadFile(GetDVDClass(), "MovieDemo", "All", 0);
}

dScStaffCredits_c::~dScStaffCredits_c() {
}

/******************/
/* Main functions */
/******************/

extern "C" void MakeScene(u32 heap, u32 unk);
extern "C" void LoadMapScene();

int dScStaffCredits_c::onCreate() {
	*CurrentDrawFunc = CreditsDrawFunc;
	if(!layoutLoaded) {
		/*************************/
		/* Layout Initialization */
		/*************************/

		OSReport("loading...\n");
		if (!layout.loadArc("credits.arc", false))
			return false;
		if (!bgLoader.load("/Object/Credits.brres"))
			return false;
		if (DVD_StillLoading(GetDVDClass2()))
			return false;

		static const char *brlanNames[2] = {
			"credits_starMove.brlan",
			"credits_theEnd.brlan",
		};

		static const char *groupNames[9] = {
			"A00_TitleRtoL", "B00_TitleLtoR", "C00_ContentRtoL", "C01_ContentRtoL", "C02_ContentRtoL", "D00_ContentLtoR", "D01_ContentLtoR", "D02_ContentLtoR",
			"E00_End",
		};

		static const int groupIDs[9] = {
			0, 0, 0, 0, 0, 0, 0, 0,
			1,
		};

		layout.build("credits.brlyt");

		layout.loadAnimations(brlanNames, 2);
		layout.loadGroups(groupNames, groupIDs, 9);
		layout.disableAllAnimations();

		layoutLoaded = true;

		N_credits_00 = layout.findPaneByName("N_credits_00");
		N_end_00 = layout.findPaneByName("N_end_00");
		N_end_00->SetVisible(false);

		/**************************************/
		/* Pane getting & TextWriters reation */
		/**************************************/

		N_titleRtoL_00 = layout.findPaneByName("N_titleRtoL_00");
		N_titleLtoR_00 = layout.findPaneByName("N_titleLtoR_00");
		T_titleRtoL_00 = layout.findTextBoxByName("T_titleRtoL_00");
		T_titleLtoR_00 = layout.findTextBoxByName("T_titleLtoR_00");
		textWriterTitle.font = T_titleRtoL_00->font;
		textWriterTitle.SetFontSize(T_titleRtoL_00->fontSizeX, T_titleRtoL_00->fontSizeY);
		textWriterTitle.lineSpace = T_titleRtoL_00->lineSpace;
		textWriterTitle.charSpace = T_titleRtoL_00->charSpace;
		if (T_titleRtoL_00->tagProc != 0)
			textWriterTitle.tagProcessor = T_titleRtoL_00->tagProc;

		RtoLContents[0] = layout.findPaneByName("N_contentRtoL_00");
		RtoLContents[1] = layout.findPaneByName("N_contentRtoL_01");
		RtoLContents[2] = layout.findPaneByName("N_contentRtoL_02");
		LtoRContents[0] = layout.findPaneByName("N_contentLtoR_00");
		LtoRContents[1] = layout.findPaneByName("N_contentLtoR_01");
		LtoRContents[2] = layout.findPaneByName("N_contentLtoR_02");
		RtoLContentsT[0] = layout.findTextBoxByName("T_contentRtoL_00");
		RtoLContentsT[1] = layout.findTextBoxByName("T_contentRtoL_01");
		RtoLContentsT[2] = layout.findTextBoxByName("T_contentRtoL_02");
		LtoRContentsT[0] = layout.findTextBoxByName("T_contentLtoR_00");
		LtoRContentsT[1] = layout.findTextBoxByName("T_contentLtoR_01");
		LtoRContentsT[2] = layout.findTextBoxByName("T_contentLtoR_02");
		textWriterContent.font = RtoLContentsT[0]->font;
		textWriterContent.SetFontSize(RtoLContentsT[0]->fontSizeX, RtoLContentsT[0]->fontSizeY);
		textWriterContent.lineSpace = RtoLContentsT[0]->lineSpace;
		textWriterContent.charSpace = RtoLContentsT[0]->charSpace;
		if (RtoLContentsT[0]->tagProc != 0)
			textWriterContent.tagProcessor = RtoLContentsT[0]->tagProc;

		/*****************************************/
		/* Binary loading + scene initialization */
		/*****************************************/
   		staffCreditsFile = (StaffCreditsBinary*)LoadFile(&fileHandle, "/NewerRes/StaffCredits.bin");

		LoadMapScene();
		GameSetup__LoadScene(0);

		this->doneWithTextMovement = true;

		/*******************/
		/* 3D Models stuff */
		/*******************/

		bgPos = (Vec){-12.0f, 0.0f, 165.0f};

		peachPos = (Vec){4.0f, 218.0f, -356.0f};
		peachRot = (S16Vec){0, -0x320, 0};

		playerPos[0] = (Vec){-56.6f, 135.9f, -58.0f};
		playerPos[1] = (Vec){-18.2f, 136.2f, -57.0f};
		playerPos[2] = (Vec){18.8f, 136.2f, -55.4f};
		playerPos[3] = (Vec){53.7f, 135.2f, -54.6f};

		// playerRot[0] = (S16Vec){0x4A0, 0x460, 0};
		// playerRot[1] = (S16Vec){0x240, 0x1B0, 0};
		// playerRot[2] = (S16Vec){0x5B0, -0x80, 0};
		// playerRot[3] = (S16Vec){0x430, -0x350, 0};

		playerRot[0] = (S16Vec){0, 0x460, 0};
		playerRot[1] = (S16Vec){0, 0x1B0, 0};
		playerRot[2] = (S16Vec){0, -0x80, 0};
		playerRot[3] = (S16Vec){0, -0x350, 0};

		allocator.link(-1, GameHeaps[0], 0, 0x20);

		// BG

    	nw4r::g3d::ResFile rf(bgLoader.buffer);
		rf.CheckRevision();
		rf.Init();
		rf.Bind(rf);

		nw4r::g3d::ResMdl bgModelRes = rf.GetResMdl("Model");
		nw4r::g3d::ResAnmChr anmResChr = rf.GetResAnmChr("Model");
		nw4r::g3d::ResAnmTexSrt anmResSrt = rf.GetResAnmTexSrt("Model");
		nw4r::g3d::ResAnmClr anmResClr = rf.GetResAnmClr("Model");

		bgModel.setup(bgModelRes, &allocator, 0x32C, 1, 0);

		bgChrAnm.setup(bgModelRes, anmResChr, &allocator, 0);
		bgChrAnm.bind(&bgModel, anmResChr, 0);
		bgModel.bindAnim(&bgChrAnm, 0.0f);

		bgSrtAnm.setup(bgModelRes, anmResSrt, &allocator, 0, 1);
		bgSrtAnm.bindEntry(&bgModel, anmResSrt, 0, 0);
		bgModel.bindAnim(&bgSrtAnm, 0.0f);

		bgClrAnm.setup(bgModelRes, anmResClr, &allocator, 0, 1);
		bgClrAnm.bind(&bgModel, anmResClr, 0, 0);
		bgModel.bindAnim(&bgClrAnm, 0.0f);

		// Peach

    	nw4r::g3d::ResFile rf2(getResource("bgA_0104", "g3d/bgA_0104.brres"));
		rf2.CheckRevision();
		rf2.Init();
		rf2.Bind(rf2);

		nw4r::g3d::ResMdl peachRes = rf2.GetResMdl("bgA_0104");
		nw4r::g3d::ResAnmTexSrt peachAnmResSrt = rf2.GetResAnmTexSrt("bgA_0104");

		peachModel.setup(peachRes, &allocator, 0x32C, 1, 0);
		SetupTextures_Map(&peachModel, 0);

		peachSrtAnm.setup(peachRes, peachAnmResSrt, &allocator, 0, 1);
		peachSrtAnm.bindEntry(&peachModel, peachAnmResSrt, 0, 0);
		peachModel.bindAnim(&peachSrtAnm, 0.0f);

		// Players

		this->playersResFile = getResource("All", "g3d/model.brres");
		this->playersResFile.CheckRevision();
		this->playersResFile.Init();
		this->playersResFile.Bind(playersResFile);

		for(int i = 0; i < 4; i++) {
			nw4r::g3d::ResMdl playerRes = this->playersResFile.GetResMdl(playerMovieNames[i]);
			nw4r::g3d::ResAnmChr playerAnmResChr = this->playersResFile.GetResAnmChr(playerAnimNames[0][i]);

			playerModel[i].setup(playerRes, &allocator, 0x32C, 1, 0);
			SetupTextures_Player(&playerModel[i], 0);

			playerChrAnm[i].setup(playerRes, playerAnmResChr, &allocator, 0);
			this->bindAnimationToPlayer(i, 0);
		}

		allocator.unlink();
	}

	isVisible = true;

	return true;
}

void dScStaffCredits_c::bindAnimationToPlayer(u8 player, u8 id) {
	if(id > 1) return;
	nw4r::g3d::ResAnmChr anmChr = this->playersResFile.GetResAnmChr(playerAnimNames[id][player]);
	this->playerChrAnm[player].bind(&this->playerModel[player], anmChr, 1);
	this->playerModel[player].bindAnim(&this->playerChrAnm[player], 0);
	this->playerChrAnm[player].setUpdateRate(1.0f);
}

int dScStaffCredits_c::onDelete() {
	FreeScene(0);
	FreeScene(1);

	CleanUpEffectThings();
	FreeEffects(1);
	FreeBreff(1);
	FreeBreft(1);

	DVD_FreeFile(GetDVDClass2(), "bgA_0104");
	DVD_FreeFile(GetDVDClass2(), "All");

	FreeFile(&fileHandle);

	return layout.free();
}

bool doRot = false;
u8 currPlay = 0;

int dScStaffCredits_c::onExecute() {
	/********************/
	/* Model processing */
	/********************/

	// BG

	bgChrAnm.process();
	bgSrtAnm.process();
	bgClrAnm.process();
	
	bgMatrix.translation(bgPos.x, bgPos.y, bgPos.z);
	bgModel.setDrawMatrix(bgMatrix);
	bgModel.setScale(1.0f, 1.0f, 1.0f);
	bgModel.calcWorld(false);

	if(bgChrAnm.isAnimationDone())
		bgChrAnm.setCurrentFrame(0.0);

	// Peach

	peachSrtAnm.process();

	peachMatrix.translation(peachPos.x, peachPos.y, peachPos.z);
	peachMatrix.applyRotationYXZ(&peachRot.x, &peachRot.y, &peachRot.z);
	peachModel.setDrawMatrix(peachMatrix);
	peachModel.setScale(1.0f, 1.0f, 1.0f);
	peachModel.calcWorld(false);

	// Players

	for(int i = 0; i < 4; i++) {
		playerChrAnm[i].process();

		if(playerChrAnm[i].isAnimationDone()) {
			this->bindAnimationToPlayer(i, currentPlayerAnimID[i]);

			if(currentPlayerAnimID[i] == 1) 
				currentPlayerAnimID[i]++;
		}

		playerMatrix[i].translation(playerPos[i].x, playerPos[i].y, playerPos[i].z);
		playerMatrix[i].applyRotationYXZ(&playerRot[i].x, &playerRot[i].y, &playerRot[i].z);
		playerModel[i].setDrawMatrix(playerMatrix[i]);
		playerModel[i].setScale(1.0f, 1.0f, 1.0f);
		playerModel[i].calcWorld(false);
	}

	/********************/
	/* Skipping credits */
	/********************/

	int nowPressed = Remocon_GetPressed(GetActiveRemocon());
	
	/*int nowHeld = Remocon_GetButtons(GetActiveRemocon());

	if(nowPressed & WPAD_PLUS) {
		doRot = !doRot;
	}
	if(nowPressed & WPAD_MINUS) {
		currPlay++;
		if(currPlay > 3) currPlay -= 4;
	}

	Vec *ppos = &playerPos[currPlay];
	S16Vec *prot = &playerRot[currPlay];

	if(doRot) {
		if(nowHeld & WPAD_RIGHT) {
			prot->x += 0x10;
		}
		else if(nowHeld & WPAD_LEFT) {
			prot->x -= 0x10;
		}

		if(nowHeld & WPAD_UP) {
			prot->y += 0x10;
		}
		else if(nowHeld & WPAD_DOWN) {
			prot->y -= 0x10;
		}

		if(nowHeld & WPAD_A) {
			prot->z += 0x10;
		}
		else if(nowHeld & WPAD_B) {
			prot->z -= 0x10;
		}
	}
	else {
		if(nowHeld & WPAD_RIGHT) {
			ppos->x += 0.1f;
		}
		else if(nowHeld & WPAD_LEFT) {
			ppos->x -= 0.1f;
		}

		if(nowHeld & WPAD_UP) {
			ppos->y += 0.1f;
		}
		else if(nowHeld & WPAD_DOWN) {
			ppos->y -= 0.1f;
		}

		if(nowHeld & WPAD_A) {
			ppos->z += 0.1f;
		}
		else if(nowHeld & WPAD_B) {
			ppos->z -= 0.1f;
		}
	}

	OSReport("player: %d\n", currPlay);
	OSReport("playerPos.x: %f, playerPos.y: %f, playerPos.z: %f\n", ppos->x, ppos->y, ppos->z);
	OSReport("playerRot.x: %04X, playerRot.y: %04X, playerRot.z: %04X\n", prot->x, prot->y, prot->z);
	*/

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
					acState.setState(&StateID_SaveAndQuit);
				}

				// UpdateSelectCursor(this->layout.findPaneByName("N_buttonO_00"), 0, false);
				HideSelectCursor((void*)SelectCursorPointer, 0);
			}
			return true;
		case 4:
			// Waiting for exit transition
			acState.execute();
			return true;
	}

	if (yesNoWindow->layoutLoaded && (nowPressed & WPAD_PLUS)) {
		HideSelectCursor((void*)SelectCursorPointer, 0);
		yesNoStage = 1;
		yesNoWindow->type = 3;
		yesNoWindow->visible = true;

		for (int i = 0; i < 40; i++)
			if (handle.Exists()) {
				handle.Pause(true, 3);
			}
		return true;
	}

	/****************/
	/* BG Scrolling */
	/****************/

	if(!this->reachedBottom && currentPage > 0) {
		if (dCreditsCamera_c::instance->currentY > 190.0f) {
			float slowness = 1.0f;

			if(dCreditsCamera_c::instance->currentY < 250.0f) {
				slowness = (dCreditsCamera_c::instance->currentY - 190.0f) / 60.0f;
			}

			dCreditsCamera_c::instance->currentY -= (2195.0f / ((float)staffCreditsFile->totalFrameCount + (150.0f * staffCreditsFile->pageCount))) * slowness + 0.01f;
		}
		else {
			this->reachedBottom = true;
		}
	}

	/****************************/
	/* State & Layout execution */
	/****************************/

	acState.execute();
	acState2.execute();
	
	layout.execAnimations();
	layout.update();

	return true;
}

int dScStaffCredits_c::onDraw() {
	bgModel.scheduleForDrawing();
	peachModel.scheduleForDrawing();

	for(int i = 0; i < 4; i++)
		playerModel[i].scheduleForDrawing();

	if (isVisible) {
		layout.scheduleForDrawing();
	}

	return true;
}

/******************/
/* Misc functions */
/******************/

void dScStaffCredits_c::setPositionsAndTexts() {
	/********************/
	/* Resetting arrays */
	/********************/

	// Creating array of pane pointers to store the panes to use in the correct order
	nw4r::lyt::Pane *firstTitle;
	nw4r::lyt::Pane *secondTitle;
	nw4r::lyt::Pane *firstContent[3];
	nw4r::lyt::Pane *secondContent[3];

	nw4r::lyt::TextBox *firstTitleT;
	nw4r::lyt::TextBox *secondTitleT;
	nw4r::lyt::TextBox *firstContentT[3];
	nw4r::lyt::TextBox *secondContentT[3];

	// Assigning them depending of the current direction
	if(currentDir) {
		firstTitle = N_titleLtoR_00;
		firstTitleT = T_titleLtoR_00;
		for(int i = 0; i < 3; i++) firstContent[i] = LtoRContents[i];
		for(int i = 0; i < 3; i++) firstContentT[i] = LtoRContentsT[i];

		secondTitle = N_titleRtoL_00;
		secondTitleT = T_titleRtoL_00;
		for(int i = 0; i < 3; i++) secondContent[i] = RtoLContents[i];
		for(int i = 0; i < 3; i++) secondContentT[i] = RtoLContentsT[i];
	}
	else {
		firstTitle = N_titleRtoL_00;
		firstTitleT = T_titleRtoL_00;
		for(int i = 0; i < 3; i++) firstContent[i] = RtoLContents[i];
		for(int i = 0; i < 3; i++) firstContentT[i] = RtoLContentsT[i];

		secondTitle = N_titleLtoR_00;
		secondTitleT = T_titleLtoR_00;
		for(int i = 0; i < 3; i++) secondContent[i] = LtoRContents[i];
		for(int i = 0; i < 3; i++) secondContentT[i] = LtoRContentsT[i];
	}
	currentDir = !currentDir;

	nw4r::lyt::Pane *content[6];
	for(int i = 0; i < 6; i += 2) {
		content[i+1] = firstContent[i/2];
		content[i] = secondContent[i/2];
	}

	nw4r::lyt::TextBox *contentT[6];
	for(int i = 0; i < 6; i += 2) {
		contentT[i+1] = firstContentT[i/2];
		contentT[i] = secondContentT[i/2];
	}

	// Making panes invisible & resetting utility arrays

	firstTitle->SetVisible(false);
	secondTitle->SetVisible(false);
	for(int i = 0; i < 3; i++) firstContent[i]->SetVisible(false);
	for(int i = 0; i < 3; i++) secondContent[i]->SetVisible(false);
	for(int i = 0; i < 8; i++) doSkip[i] = true;
	for(int i = 0; i < 8; i++) currentTitleChar[i] = 0;
	for(int i = 0; i < 8; i++) letterCountChanged[i] = false;


	/**********************************/
	/* Text getting & Pane properties */
	/**********************************/

	// NOTE: RtoL = Right to Left; LtoR = Left to Right
	//
	// There's two title pane sets (one with the star going RtoL and one with the star going LtoR)
	// and six content pane sets (three with the star going RtoL and three with the star going LtoR)
	//
	// The first piece of text will always change between each page, meaning that if Page 0's first title was going RtoL, Page 1's first title will go LtoR.
	// Textbox panes are disalligned due to their text alignment being requiredly set to left or right so it can appear properly behind the star
	// so we need to center them by hand.
	//
	// Depending of their use order, pane pointers are stored in arrays to be used in the HandleTextAppear state
	//
	// Arrays: doSkip serves as a "is this pane useful?" array, so it can be ignored or not in the HandleTextAppear state
	//         strings stores the text to be put in the textbox corresponding to a pane set
	//         AllTheTextboxes stores the pointers to the relevant text boxes
	//         All of these three arrays use the exact same IDs for indexes so they're "synchronised"
	// Variables: currentTrans stores the Y position a pane set will have, since they're 60 units apart from each other
	//            currentContentCount keeps track of the amount of placed content pane sets so the first and second part can be optimized accordingly
	//
	// For information about the binary file format the text and counts are being took from, please check the comments in the header

	int currentTrans = 0;
	u8 currentContentCount = 0;

	// First title
	const wchar_t* title1Txt = this->getTitle(currentPage, 0);
	strings[0] = title1Txt;
	doSkip[0] = false;
	AllTheTextboxes[0] = firstTitleT;

	float align = firstTitleT->IsHAlignment(HALIGN_LEFT) ? 2.0f : -2.0f;
	firstTitleT->trans.x = (540.0f - textWriterTitle.CalcStringWidth(title1Txt, wcslen(title1Txt))) / align; // 540 represents the pane's X size, I know it could be gotten in another way but doing it like this takes less instructions
	firstTitle->trans.y = (float)currentTrans; // I think it's less processor-expensive to cast an int than doing float subtractions?
	currentTrans -= 60;

	firstTitle->SetVisible(true);
	firstTitleT->SetString(L"");

	// First content part
	u8 contentCount1 = this->getContentCount(currentPage, 0);
	for(int i = 0; i < contentCount1; i++) {
		u8 pID = 2 + currentContentCount; // ID in arrays is the content number padded by two because the first two entries are for titles

		const wchar_t* content1Txt = this->getContent(currentPage, currentContentCount);
		strings[pID] = content1Txt;
		doSkip[pID] = false;
		AllTheTextboxes[pID] = contentT[i];

		align = contentT[i]->IsHAlignment(HALIGN_LEFT) ? 2.0f : -2.0f;
		contentT[i]->trans.x = (540.0f - textWriterContent.CalcStringWidth(content1Txt, wcslen(content1Txt))) / align;
		content[i]->trans.y = (float)currentTrans;
		currentTrans -= 60;

		content[i]->SetVisible(true);
		contentT[i]->SetString(L"");

		currentContentCount++;
	}

	// Check if there is a second part
	u8 contentCount2 = this->getContentCount(currentPage, 1);
	if(contentCount2) {
		// Second title
		const wchar_t* title2Txt = this->getTitle(currentPage, 1);
		strings[1] = title2Txt;
		doSkip[1] = false;
		AllTheTextboxes[1] = secondTitleT;

		align = secondTitleT->IsHAlignment(HALIGN_LEFT) ? 2.0f : -2.0f;
		secondTitleT->trans.x = (540.0f - textWriterTitle.CalcStringWidth(title2Txt, wcslen(title2Txt))) / align;
		secondTitle->trans.y = (float)currentTrans;
		currentTrans -= 60;

		secondTitle->SetVisible(true);
		secondTitleT->SetString(L"");

		// Second content part
		for(int i = 0; i < contentCount2; i++) {
			u8 pID = 2 + currentContentCount;
			int it = i + currentContentCount + 1; // Index to use for arrays needs the already used content counts added to it, plus one to take for the second title

			const wchar_t* content2Txt = this->getContent(currentPage, currentContentCount);
			strings[pID] = content2Txt;
			doSkip[pID] = false;
			AllTheTextboxes[pID] = contentT[it];


			align = contentT[it]->IsHAlignment(HALIGN_LEFT) ? 2.0f : -2.0f;
			contentT[it]->trans.x = (540.0f - textWriterContent.CalcStringWidth(content2Txt, wcslen(content2Txt))) / align;
			content[it]->trans.y = (float)currentTrans;
			currentTrans -= 60;

			content[it]->SetVisible(true);
			contentT[it]->SetString(L"");

			currentContentCount++;
		}
	}

	// Centering everything 
	float half = (float)(currentTrans / 2);

	firstTitle->trans.y -= half; // Since out pane sets' Y pos goes from 0 to 60*x, to center them we need to subtract half the total of 60*x to all of them
	secondTitle->trans.y -= half;
	for(int i = 0; i < 3; i++) firstContent[i]->trans.y -= half;
	for(int i = 0; i < 3; i++) secondContent[i]->trans.y -= half;
}

/**************************/
/* Text processing states */
/**************************/

// Init State

void dScStaffCredits_c::beginState_Init() {
	OSReport("Init StaffCredits.\n");
	this->timer = 0;

	layout.disableAllAnimations();
	for(int i = 0; i < 8; i++) layout.resetAnim(i);
}

void dScStaffCredits_c::executeState_Init() {
	//this->timer++;
	if(this->doneWithTextMovement) {
		if(currentPage < staffCreditsFile->pageCount) {
			this->setPositionsAndTexts();
			for(int i = 0; i < 8; i++) layout.enableNonLoopAnim(i);
			this->frameC = this->getFrameDuration(currentPage);

			acState.setState(&StateID_HandleTextAppear);
			acState2.setState(&StateID_DoTextMovement);
		}
		else if(this->reachedBottom) {
			N_end_00->SetVisible(true);
			layout.enableNonLoopAnim(8);
			acState.setState(&StateID_SaveAndQuit);
		}
	}
}

void dScStaffCredits_c::endState_Init() {
	
}

static wchar_t somespace[8][32]; // Buffer for text writing

// HandleTextAppear State

void dScStaffCredits_c::beginState_HandleTextAppear() {
	OSReport("HandleTextAppear StaffCredits.\n");
	this->timer = 0;
}

void dScStaffCredits_c::executeState_HandleTextAppear() {
	this->timer++;
	float effectiveStarPosRtoL = ((float)this->timer * (1420.0f / 150.0f)) - 580.0f; // Position of the star by frames since its animations started

	// Itterate 8 times, because we got 2 titles + 6 contents to process
	for(int i = 0; i < 8; i++) {
		// If pane wasn't used, this should be set to true, avoids wasting processing power
		if(doSkip[i]) continue; 

		// Get the textbox we'll work on and its direction using its textalignment
		nw4r::lyt::TextBox *tb = AllTheTextboxes[i]; 
		bool isLtoR = tb->IsHAlignment(HALIGN_LEFT);

		// LtoR and RtoL star animations are the same but reversed
		float dir = isLtoR ? effectiveStarPosRtoL : -effectiveStarPosRtoL;

		// First two indexes of array are for the titles, decide of the TextWriter to use depending of this
		nw4r::ut::TextWriter *tw = (i < 2) ? &textWriterTitle :  &textWriterContent;

		// Get corresponding text
		const wchar_t* buf = strings[i];

		// Get & reset the buffer we'll work on
		wchar_t *rslt = somespace[i];
		for(int j = 0; j < 32; j++) rslt[j] = 0;

		// If we go from LtoR, we need the text to appear with first letters first, but in the opposite case we need the last letters to appear first
		if(isLtoR)
			wcsncpy(rslt, buf, currentTitleChar[i]);
		else
			moveEndOfWideChar(rslt, buf, currentTitleChar[i]);

		// Once we got the text, set it if a new letter was recently added
		if(letterCountChanged[i]) {
			tb->SetString(rslt);
			letterCountChanged[i] = false;
		}

		// Get the limit to the next character using the length of its text
		float length = 270.0f - tw->CalcStringWidth(rslt, wcslen(rslt)); // 270 = X size / 2 = 540 / 2
		float limit = (isLtoR) ? (tb->trans.x - length) : (tb->trans.x + length);

		// If the limit was reached, increment the letter count for current text, and tell that it was changed so it can be updated on next frame
		if((isLtoR) ? (dir > limit) : (dir < limit))  {
			currentTitleChar[i]++;
			letterCountChanged[i] = true;
		}

		// Once we're done with the whole text, stop processing the current pane set to save time and power
		if(currentTitleChar[i] > wcslen(buf)) {
			doSkip[i] = true;
		}
	}

	// We're done when each of the starMove animations in the layout are finished
	bool finished = true;
	for(int i = 0; i < 8; i++) if(layout.isAnimOn(i)) finished = false;
	// If we're done, go to the next page
	if(finished) {
		this->currentPage++;
		acState.setState(&StateID_Init);
	}
}

void dScStaffCredits_c::endState_HandleTextAppear() {
	
}

// SaveAndQuit State

void dScStaffCredits_c::beginState_SaveAndQuit() {
	OSReport("SaveAndQuit StaffCredits.\n");
	this->timer = 0;
}

void dScStaffCredits_c::executeState_SaveAndQuit() {
	this->timer++;
	if(!layout.isAnimOn(8)) {
		if (!savingForEnding) {
			savingForEnding = true;

			SaveGame(0, false);
		}
		else {
			if (!GetSaveFile()->CheckIfWriting()) {
				StartTitleScreenStage(false, 0);
			}
		}
	}

	if(this->timer == 80) {
		for(int i = 0; i < 4; i++)
			currentPlayerAnimID[i] = 1;

		MapSoundPlayer(SoundRelatedClass, SE_VOC_MA_CLEAR_MULTI, 1);
		MapSoundPlayer(SoundRelatedClass, SE_VOC_LU_CLEAR_MULTI, 1);
		MapSoundPlayer(SoundRelatedClass, SE_VOC_KO_CLEAR_MULTI, 1);
		MapSoundPlayer(SoundRelatedClass, SE_VOC_KO2_CLEAR_MULTI, 1);
	}
}

void dScStaffCredits_c::endState_SaveAndQuit() {
	
}

/********************/
/* Scrolling states */
/********************/

// Wait State

void dScStaffCredits_c::executeState_Wait() {

}

// DoTextMovement State

void dScStaffCredits_c::beginState_DoTextMovement() {
	OSReport("DoTextMovement StaffCredits.\n");
	this->doneWithTextMovement = false;
	this->textTimer = 0;
}

void dScStaffCredits_c::executeState_DoTextMovement() {
	float frameF = (float)this->frameC;
	float textTimerF = (float)this->textTimer;

	float creditsPos = 0.0f;
	if(this->textTimer < frameC) {
		creditsPos = ((40.0f / frameF) * (textTimerF)) - 60.0f;
	}
	else if(this->textTimer < frameC+150) {
		this->textUPSpeed = (textTimerF-frameF) / 75.0f;
		creditsPos = ((436.0f / 150.0f) * this->textUPSpeed * (textTimerF-frameF)) - 20.0f;
	}
	else {
		this->doneWithTextMovement = true;
		acState2.setState(&StateID_Wait);
		return;
	}

	N_credits_00->trans.y = creditsPos;
	this->textTimer++;
}

void dScStaffCredits_c::endState_DoTextMovement() {
	
}

// Stolen from koopatlas/core.cpp
void CreditsDrawFunc() {
	Reset3DState();
	SetCurrentCameraID(0);
	DoSomethingCameraRelatedWithEGGScreen(0, &dCreditsCamera_c::instance->screen);
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
}



