#include "soundtest.h"

dScSoundTest_c *dScSoundTest_c::instance = 0;

dScSoundTest_c *dScSoundTest_c::build() {
	// return new dScSoundTest_c;
	void *buffer = AllocFromGameHeap1(sizeof(dScSoundTest_c));
	dScSoundTest_c *c = new(buffer) dScSoundTest_c;

	instance = c;
	return c;
}



dScSoundTest_c::dScSoundTest_c() {

}

dScSoundTest_c::~dScSoundTest_c() {

}


int dScSoundTest_c::onCreate() {
	*CurrentDrawFunc = SoundTestDrawFunc;

	if(!layoutLoaded) {
		if (!layout.loadArc("soundtest.arc", false))
			return false;

		static const char *brlanNames[4] = {
			"soundtest_asuAppear.brlan",
			"soundtest_upText.brlan",
			"soundtest_idleText.brlan",
			"soundtest_downText.brlan",
		};

		static const char *groupNames[4] = {
			"A00_asu", 
			"B00_textBox", "B00_textBox", "B00_textBox",
		};

		static const int groupIDs[4] = {
			0,
			1, 2, 3,
		};

		layout.build("soundtest.brlyt");

		layout.loadAnimations(brlanNames, 4);
		layout.loadGroups(groupNames, groupIDs, 4);
		layout.disableAllAnimations();

		// layout.drawOrder = 140;

		layoutLoaded = true;

		T_SFXTxt_00 = layout.findTextBoxByName("T_SFXTxt_00");
		T_SFXSha_00 = layout.findTextBoxByName("T_SFXSha_00");
		T_SFXNumTxt_00 = layout.findTextBoxByName("T_SFXNumTxt_00");
		T_SFXNumSha_00 = layout.findTextBoxByName("T_SFXNumSha_00");

		WriteBMGToTextBox(layout.findTextBoxByName("T_WelcomeTxt_00"), GetBMG(), 0x3EA, 19, 0);
		WriteBMGToTextBox(layout.findTextBoxByName("T_WelcomeSha_00"), GetBMG(), 0x3EA, 19, 0);
		WriteBMGToTextBox(layout.findTextBoxByName("T_InfosTxt_00"), GetBMG(), 0x3EA, 20, 0);
		WriteBMGToTextBox(layout.findTextBoxByName("T_InfosSha_00"), GetBMG(), 0x3EA, 20, 0);

		char sfxName[150];
		wchar_t text[150];
		sprintf(sfxName, "-> %s <-", sfxNames[this->selectedSFX]);
		mbstowcs(text, sfxName, 150);

		T_SFXTxt_00->SetString(text);
		T_SFXSha_00->SetString(text);

		PlaySoundWithFunctionB4(SoundRelatedClass, &handles[currentSFXHandle], this->selectedSFX, 1);
	}

	isVisible = true;

	return true;
}

int dScSoundTest_c::onDelete() {
	return layout.free();
}

extern void callSoundTestState(dScSoundTest_c* handler, u32 state);
extern "C" u32 GenerateRandomNumber(int max);

int dScSoundTest_c::onExecute() {
	globTimer++;
	latestTimer++;

	if(!handles[currentSFXHandle].Exists() || latestTimer > 600) {
		if(waitTimer == 0)
			// forceB = true;
		waitTimer++;
		if(waitTimer == 60) {
			waitTimer = 0;
			// forceUp = true;

			float gbTime = (float)globTimer;
			float seconds = gbTime / 60.0f;
			float minutes = seconds / 60.0f;
			float hours = minutes / 60.0f;

			int genuineSecs = (int)floor(seconds) % 60;
			int genuineMins = (int)floor(minutes) % 60;
			int genuineHours = (int)floor(hours) % 24;

			char sfxName[150];
			sprintf(sfxName, "%s", sfxNames[this->selectedSFX+1]);
			OSReport("%s: %d - ", sfxName, globTimer);
			if(genuineHours > 0) {
				OSReport("%d:%02d:%02d\n", genuineHours, genuineMins, genuineSecs);
			}
			else {
				OSReport("%d:%02d\n", genuineMins, genuineSecs);
			}
		}
	}

	int nowPressed = Remocon_GetPressed(GetActiveRemocon());

	// Let's get our shit started

	callSoundTestState(this, currentStateID);

	if(nowPressed & WPAD_A || forceA) {
		latestTimer = 0;
		// forceA = false;

		if(handles[currentSFXHandle].Exists()) {
			handles[currentSFXHandle].Stop(1);
		}
		currentSFXHandle = !currentSFXHandle;
		PlaySoundWithFunctionB4(SoundRelatedClass, &handles[currentSFXHandle], this->selectedSFX, 1);
	}

	if(nowPressed & WPAD_B || forceB) {
		// forceB = false;
		if(handles[currentSFXHandle].Exists()) {
			handles[currentSFXHandle].Stop(1);
		}
	}

	if(nowPressed & WPAD_ONE) {
		this->finish();
	}

	if(!layout.isAnimOn(0)) {
		if(GenerateRandomNumber(18000) == 1) {
			layout.enableNonLoopAnim(0);
		}
	}
	
	layout.execAnimations();
	layout.update();

	return true;
}

void dScSoundTest_c::state0_whatever() {
	int nowPressed = Remocon_GetPressed(GetActiveRemocon());
	int nowHeld = Remocon_GetButtons(GetActiveRemocon());

	if(nowHeld & WPAD_PLUS || nowHeld & WPAD_MINUS) {
		layout.enableNonLoopAnim(1);
		currentStateID++;
		return;
	}

	if((nowPressed & WPAD_UP || forceUp) && selectedSFX < 1977) {
		// forceUp = false;
		this->selectedSFX++;
		if(selectedSFX == 1847) selectedSFX = 1968;
		// forceA = true;
		layout.enableNonLoopAnim(1);
		currentStateID++;
	}
	else if(nowPressed & WPAD_DOWN && selectedSFX > 0) {
		this->selectedSFX--;
		layout.enableNonLoopAnim(1);
		currentStateID++;
	}
}

void dScSoundTest_c::state1_whatever() {
	if (!layout.isAnimOn(1)) {
		int nowHeld = Remocon_GetButtons(GetActiveRemocon());
		if(!layout.isAnimOn(2)) {
			layout.enableNonLoopAnim(2);
		}

		if(nowHeld & WPAD_PLUS) {
			if(selectedSFX < 1977) {
				this->selectedSFX++;
			}
		}
		else if(nowHeld & WPAD_MINUS) {
			if(selectedSFX > 0) {
				this->selectedSFX--;
			}
		}
		else {
			layout.disableAnim(2);
			layout.enableNonLoopAnim(3);
			currentStateID++;
		}

		char sfxName[150];
		char sfxNum[150];
		wchar_t text[150];
		wchar_t number[150];
		sprintf(sfxName, "-> %s <-", sfxNames[this->selectedSFX]);
		sprintf(sfxNum, "%04d:", this->selectedSFX);
		mbstowcs(text, sfxName, 150);
		mbstowcs(number, sfxNum, 150);

		T_SFXTxt_00->SetString(text);
		T_SFXSha_00->SetString(text);
		T_SFXNumTxt_00->SetString(number);
		T_SFXNumSha_00->SetString(number);
	}
}

void dScSoundTest_c::state2_whatever() {
	if (!layout.isAnimOn(3)) {
		currentStateID = 0;
	}
}

void dScSoundTest_c::state3_whatever() {

}

void dScSoundTest_c::state4_whatever() {

}

void dScSoundTest_c::state5_whatever() {

}

void dScSoundTest_c::state6_whatever() {

}

void dScSoundTest_c::state7_whatever() {
}

void dScSoundTest_c::state8_whatever() {

}




int dScSoundTest_c::onDraw() {
	if (isVisible) {
		layout.scheduleForDrawing();
	}

	return true;
}

void SoundTestDrawFunc() {
	Reset3DState();
	
	LinkScene(0);
	DrawOpa();
	DrawXlu();
	UnlinkScene(0);

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

extern "C" u32 AssembleDefaultScWorldMapSettings();

void dScSoundTest_c::finish() {

	for (int i = 0; i < 2; i++)
		if (handles[i].Exists())
			handles[i].Stop(5);

	ActivateWipe(WIPE_FADE);
	DoSceneChange(WORLD_MAP, (AssembleDefaultScWorldMapSettings()), 0);
}

