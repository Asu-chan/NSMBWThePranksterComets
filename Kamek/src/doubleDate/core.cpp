#include "doubleDate/core.h"


/****************/
/* Initializing */
/****************/

CREATE_STATE(dScDoubleDate_c, Init);
CREATE_STATE(dScDoubleDate_c, Outro);

// Instancing
dScDoubleDate_c *dScDoubleDate_c::instance = 0;

dScDoubleDate_c *dScDoubleDate_c::build() {
	void *buffer = AllocFromGameHeap1(sizeof(dScDoubleDate_c));
	dScDoubleDate_c *c = new(buffer) dScDoubleDate_c;

	instance = c;
	return c;
}

#include <profile.h>
Profile DoubleDateProfile = Profile((buildFunc)&dScDoubleDate_c::build, ProfileId::RH_DOUBLEDATE, 0, ProfileId::RH_DOUBLEDATE, ProfileId::RH_DOUBLEDATE, 0, "RH_DOUBLEDATE", 0);

dScDoubleDate_c::dScDoubleDate_c() : acState(this, &StateID_Init) {
	yesNoWindow = (dYesNoWindow_c*)CreateParentedObject(YES_NO_WINDOW, this, 0, 0);
	CreateParentedObject(SELECT_CURSOR, this, 0, 0);

	rhBackground = (dRHBackground_c*)CreateParentedObject(RH_BG, this, 0, 0);
	rhBoy = (dRHBoy_c*)CreateParentedObject(RH_BOY, this, 0, 0);
	rhGirl = (dRHGirl_c*)CreateParentedObject(RH_GIRL, this, 0, 0);
	rhBench = (dRHBench_c*)CreateParentedObject(RH_BENCH, this, 0, 0);

	for(int i = 0; i < 5; i++) rhFootball[i] = (dRHFootball_c*)CreateParentedObject(RH_FOOTBALL, this, 0, 0);
	for(int i = 0; i < 5; i++) rhBasketball[i] = (dRHBasketball_c*)CreateParentedObject(RH_BASKETBALL, this, 0, 0);
	for(int i = 0; i < 5; i++) rhRugby[i] = (dRHRugby_c*)CreateParentedObject(RH_RUGBY, this, 0, 0);

	for(int i = 0; i < 5; i++) rhFootball[i]->shadow = (dRHShadow_c*)CreateParentedObject(RH_SHADOW, rhFootball[i], 0, 0);
	for(int i = 0; i < 5; i++) rhBasketball[i]->shadow = (dRHShadow_c*)CreateParentedObject(RH_SHADOW, rhBasketball[i], 0, 0);
	for(int i = 0; i < 5; i++) rhRugby[i]->shadow = (dRHShadow_c*)CreateParentedObject(RH_SHADOW, rhRugby[i], 0, 0);

	for(int i = 0; i < 5; i++) rhFootball[i]->leaves = (dRHLeaves_c*)CreateParentedObject(RH_LEAVES, rhFootball[i], 0, 0);
	for(int i = 0; i < 5; i++) rhBasketball[i]->leaves = (dRHLeaves_c*)CreateParentedObject(RH_LEAVES, rhBasketball[i], 0, 0);
	for(int i = 0; i < 5; i++) rhRugby[i]->leaves = (dRHLeaves_c*)CreateParentedObject(RH_LEAVES, rhRugby[i], 0, 0);
}

dScDoubleDate_c::~dScDoubleDate_c() {
}

/******************/
/* Main functions */
/******************/

int fbb = 48; // 75BPM -> 1 beat each 48 frames [1/(48/3600)]

extern "C" void MakeScene(u32 heap, u32 unk);
extern "C" void LoadMapScene();

int dScDoubleDate_c::onCreate() {
	*CurrentDrawFunc = DoubleDateDrawFunc;
	if(!loaded) {
		beatTimer = 1;
		currentFrame = 0;
		elapsedFrames = 0;
		
   		rhdd = (u8*)LoadFile(&rhddFHandle, "/NewerRes/RHDD.bin");
   		rhddLength = rhddFHandle.length * 2;

   		this->playMusic();
   		this->pauseMusic(true);

   		// this->nextBeatSample = -1;
   		// sampleWaiting = 0,

		loaded = true;

	}

	return true;
}
int dScDoubleDate_c::onDelete() {
	FreeFile(&rhddFHandle);
	return true;
}


int dScDoubleDate_c::onExecute() {
	quarBeat = false;
	halfBeat = false;
	quar3Beat = false;
	fullBeat = false;

	// if(this->nextBeatSample >= 0) {
	// 	if(sampleWaiting > 46) {
	// 		if(this->getMusicSample() >= this->nextBeatSample) {
	// 			fullBeat = true;
	// 			this->nextBeatSample += 25632;
	// 			OSReport("Beat, took %d frames\n", sampleWaiting);
	// 			sampleWaiting = 0;
	// 		}
	// 	}
	// 	sampleWaiting++;
	// }
	// else {
		// if(beatTimer > fbb) beatTimer = 1;
		if(beatTimer >= fbb) {
			fullBeat = true;
			beatTimer = 0;
		}
	// 	if(beatTimer == fbb/2) halfBeat = true;
	// 	if(beatTimer == fbb/4) quarBeat = true;
	// 	if(beatTimer == (fbb/4)*3) quar3Beat = true;
	// }

	if(elapsedFrames % 800 == 0 && elapsedFrames > 0) beatTimer++; // Skip a frame every 800 frame to account for music playing too fast
	beatTimer++;

	if(fullBeat && acState.getCurrentState() == &StateID_Init) {
		this->beat();
		// OSReport("Sample: %d\n", this->getMusicSample());
	}


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
						if (yesnoSHandle.Exists()) {
							yesnoSHandle.Pause(false, 3);
						}
				} else {
					yesNoStage = 4;
					this->finish();
				}

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

		if (yesnoSHandle.Exists()) {
			yesnoSHandle.Pause(true, 3);
		}
		return true;
	}

	/****************************/
	/* State & Layout execution */
	/****************************/

	acState.execute();

	elapsedFrames++;

	return true;
}

int dScDoubleDate_c::onDraw() {
	return true;
}

void dScDoubleDate_c::beat() {
	rhBoy->beat();
	rhGirl->beat();
}

void dScDoubleDate_c::football() {
	for(int i = 0; i < 5; i++) {
		if(!rhFootball[i]->busy) {
			rhFootball[i]->act();
			break;
		}
	}
}

void dScDoubleDate_c::basketball() {
	for(int i = 0; i < 5; i++) {
		if(!rhBasketball[i]->busy) {
			rhBasketball[i]->act();
			break;
		}
	}
}

void dScDoubleDate_c::rugby() {
	for(int i = 0; i < 5; i++) {
		if(!rhRugby[i]->busy) {
			rhRugby[i]->act();
			break;
		}
	}
}

bool dScDoubleDate_c::anyoneBusy() {
	for(int i = 0; i < 5; i++) {
		if(rhFootball[i]->busy) 
			return true;
		if(rhBasketball[i]->busy) 
			return true;
		if(rhRugby[i]->busy) 
			return true;
	}
	return false;
}

int dScDoubleDate_c::lookForShooting() {
	for(int i = 0; i < 5; i++) {
		int val = rhFootball[i]->canBeShoot();
		if(val) return val;

		val = rhBasketball[i]->canBeShoot();
		if(val) return val;

		val = rhRugby[i]->canBeShoot();
		if(val) return val;
	}
	return 4;
}

/**************************/
/* Text processing states */
/**************************/

// Init State

void dScDoubleDate_c::beginState_Init() {
	OSReport("Init DDCore.\n");
	currentFrame = 0;
	outroTimer = 0;
}

void dScDoubleDate_c::executeState_Init() {
	/******************/
	/* Action Playing */
	/******************/

	if(currentFrame < rhddLength) {
		u8 action = (currentFrame % 2) ? (rhdd[(currentFrame-1)/2] & ACT_ALL) : ((rhdd[currentFrame/2] >> 4) & ACT_ALL);
		// OSReport("act: %d, frame: %d-%d\n", action, currentFrame, elapsedFrames);

		if(action & ACT_FOOTBALL) 
			this->football();
		if(action & ACT_BASKETBALL) 
			this->basketball();
		if(action & ACT_RUGBY) 
			this->rugby();
		if(action & ACT_BEAT) {
			if(!fullBeat) currentFrame--;
			else {
				PlaySoundWithFunctionB4(SoundRelatedClass, &beatSHandle, SFX_RHDD_BEAT, 1);

				// if(musicPlaying) {
				// 	this->nextBeatSample = this->getMusicSample() + 25632;
				// }
			}
		}

		// if(currentFrame == 210) this->pauseMusic(false);
		if(elapsedFrames == 84) this->pauseMusic(false);

		currentFrame++;
	}
	else if(!this->anyoneBusy()) {
		if(outroTimer == 60) {
			acState.setState(&StateID_Outro);
		}
		outroTimer++;
	}

	/*******************/
	/* Player controls */
	/*******************/

	int nowPressed = Remocon_GetPressed(GetActiveRemocon());
	// if(nowPressed & WPAD_A) {
		if(rhBoy->canKick()) {
			switch(this->lookForShooting()) {
				default:
				case 0:
					rhBoy->kick(2, SFX_RHDD_KICK_SLAP);
					break;
				case 1:
					rhBoy->kick(2, SFX_RHDD_KICK_SUCCESS);
					rhBackground->leavesShake();
					break;
				case 2:
					rhBoy->kick(3, SFX_RHDD_KICK_MISS);
					break;
				case 3:
					rhBoy->kick(2, SFX_RHDD_KICK_RUGBY);
					break;
				case 4: // Debug purposes
					break;
			}
		}
	// }
}

void dScDoubleDate_c::endState_Init() {
	
}

// Outro State

void dScDoubleDate_c::beginState_Outro() {
	OSReport("Outro DDCore.\n");
	rhBoy->blush();
	rhGirl->blush();
}

void dScDoubleDate_c::executeState_Outro() {

}

void dScDoubleDate_c::endState_Outro() {
	
}

void dScDoubleDate_c::finish() {

}

static nw4r::snd::StrmSoundHandle s_handle;
void dScDoubleDate_c::playMusic() {
	int realStreamID;
	hijackMusicWithSongName("new/DoubleDate", -1, false, 4, 2, &realStreamID);

	PlaySoundWithFunctionB4(SoundRelatedClass, &s_handle, realStreamID, 1);

	musicPlaying = true;
}

void dScDoubleDate_c::pauseMusic(bool pause) {
	if(s_handle.Exists()) {
		s_handle.Pause(pause, 1);
		musicPlaying = !pause;
	}
}

void dScDoubleDate_c::stopMusic() {
	if(s_handle.Exists()) {
		s_handle.Stop(10);
		musicPlaying = false;
	}
}

bool dScDoubleDate_c::isMusic() {
	return s_handle.Exists();
}

long dScDoubleDate_c::getMusicSample() {
	if(s_handle.Exists()) 
		return s_handle.GetPlaySamplePosition();

	return -1;
}

// Stolen from cutscene.cpp
void DoubleDateDrawFunc() {
	Reset3DState();
	SetupLYTDrawing();
	DrawAllLayoutsBeforeX(0x81);
	RenderEffects(0, 3);
	RenderEffects(0, 2);
	GXDrawDone();
	RemoveAllFromScnRoot();
	Reset3DState();
	SetCurrentCameraID(1);
	DoSpecialDrawing1();
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



