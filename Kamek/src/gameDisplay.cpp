#include <game.h>
#include <common.h>
#include <sdk/nwc24.h>
#include <sdk/vf.h>
#include "gameDisplay.h"
#include "timekeeper.h"


//None;   Black;  Purple; Blue;   Red;    DBlue;  Brown
//000000; 000000; 3D007B; 004F7A; 77000B; 0009C4; 5A4704
u16 red[7] =	{0, 0, 0x3D, 0x00, 0x77, 0x00, 0x5A};
u16 green[7] =	{0, 0, 0x00, 0x4F, 0x00, 0x09, 0x47};
u16 blue[7] =	{0, 0, 0x7B, 0x7A, 0x0B, 0xC4, 0x04};


extern char CurrentLevel;
extern char CurrentWorld;
extern u8 TimeStopFlag;
extern int purplecoins;
float circleTimer;

extern bool enableSpeedy;
extern u32 speedyTimer;
extern u8 silverstarCollected[8];
int speedyFrameCounter = 0;
bool hasSpeedyStarted = false;

// extern u8 purplecoinsCollected[32];
// extern u8 purplecoinsCollected_checkpoint[32];

int dGameDisplay_c::newOnCreate() {
	int orig_val = this->onCreate_orig();

	if(speedyTimer > 0 && this->P_TxtTick_00) {
		float currentSecs = 60.0f-(float)(speedyTimer % 60) + ((float)speedyFrameCounter / 60.0f);
		this->P_TxtTick_00->rotate.z = (currentSecs / 60.0f) * 360.0f;
	}

	circleTimer = 0.0f;
	if(silverstarCollected[7] && orig_val) {
		Vec marioPos = GetSpecificPlayerActor(0)->pos;
		for(int i = 0; i < 5; i++) {
			if(silverstarCollected[i]) {
				CreateActor(384, 0x100 + i, marioPos, 0, 0);
			}
		}
	}
	
	if(purplecoins >= 100) {
		dFlagMgr_c::instance->flags |= ((u64)1 << (45 - 1));
	}

	return orig_val;
}

extern bool enableDebugMode;
bool enablePlayerDebug;
Vec playerPos;

extern "C" void *MEMAllocFromAllocator(mHeapAllocator_c* alloc, u32 size);
extern "C" void MEMFreeToAllocator(mHeapAllocator_c* alloc, void* unk);

u32 error = 0;

int dGameDisplay_c::newOnExecute() {
	int orig_val = this->onExecute_orig();

	if(circleTimer >= 4.0f)
		circleTimer -= 4.0f;
	circleTimer += 0.030f;

	if(!silverstarCollected[6] && silverstarCollected[7] == 5) {
		silverstarCollected[6] = 1;
	}

	if(speedyTimer > 0 && !TimeKeeper::instance->paused && !QueryGlobal5758(0xFFFFFFFF)) {
		speedyFrameCounter++;
		if(speedyFrameCounter >= 60) {
			speedyFrameCounter = 0;
			speedyTimer--;
		}

		if(this->P_TxtTick_00) {
			float currentSecs = 60.0f-(float)(speedyTimer % 60) + ((float)speedyFrameCounter / 60.0f);
			this->P_TxtTick_00->rotate.z = (currentSecs / 60.0f) * 360.0f;
		}
	}

	int nowPressed = Remocon_GetPressed(GetActiveRemocon());

	/*if(nowPressed & WPAD_A) {
		char* TestSubject = (char*)"Test Message";
		char* TestMsgText =
		    (char*)"Hello WiiConnect24 World!!\x0d\x0a"
		    "This is a test mail.\x0d\x0a"
		    "Thank you.\x0d\x0a";

		VFInit();

		mHeapAllocator_c allocator;

		allocator.link(-1, GameHeaps[0], 0, 0x20);

    	void* libWorkMem = MEMAllocFromAllocator(&allocator, NWC24_WORK_MEM_SIZE);
    	// void* libWorkMem = AllocFromGameHeap1(NWC24_WORK_MEM_SIZE);
    	OSReport("NWC24OpenLib: %d\n", NWC24OpenLib(libWorkMem));
    	// OSReport("NWC24Check: %d\n", NWC24Check(NWC24_USE_MESSAGES));

    	NWC24MsgObj msgObj;
    	OSReport("NWC24InitMsgObj: %d\n", NWC24InitMsgObj(&msgObj, NWC24_MSGTYPE_WII));
    	NWC24UserId TestIdTo;
    	NWC24GetMyUserId(&TestIdTo);
    	OSReport("NWC24SetMsgToId: %d\n", NWC24SetMsgToId(&msgObj, TestIdTo));
    	OSReport("NWC24SetMsgSubject: %d\n", NWC24SetMsgSubject(&msgObj, TestSubject, (u32)strlen(TestSubject)));
    	OSReport("NWC24SetMsgText: %d\n", NWC24SetMsgText(&msgObj, TestMsgText, (u32)strlen(TestMsgText), NWC24_US_ASCII, NWC24_ENC_7BIT));
    	error = NWC24CommitMsg(&msgObj);
    	OSReport("NWC24CommitMsg: %d %p\n", error, &error);

    	OSReport("NWC24CloseLib: %d\n", NWC24CloseLib());
    	MEMFreeToAllocator(&allocator, libWorkMem);
    	// FreeFromGameHeap1(libWorkMem);

		// allocator.unlink();
	}*/

	if(nowPressed & WPAD_B) {
		enableDebugMode = !enableDebugMode;
		playerPos = GetSpecificPlayerActor(0)->pos;
		enablePlayerDebug = !enablePlayerDebug;
		if(enablePlayerDebug) {
			this->updateCometStuff(10);
		}
	}

	if(enablePlayerDebug) {
		int nowHeld = Remocon_GetButtons(GetActiveRemocon());
		int mult = (nowHeld & WPAD_ONE) ? 8 : 4;
		if(nowHeld & WPAD_UP) {
			playerPos.y += mult;
		}
		else if(nowHeld & WPAD_DOWN) {
			playerPos.y -= mult;
		}

		if(nowHeld & WPAD_RIGHT) {
			playerPos.x += mult;
		}
		else if(nowHeld & WPAD_LEFT) {
			playerPos.x -= mult;
		}

		TimeKeeper::instance->setTime(TimeKeeper::instance->time);

		GetSpecificPlayerActor(0)->pos = playerPos;
	}

	return orig_val;
}

// extern u8 purplecoinsExists[200];

int dGameDisplay_c::newOnDelete() {
	int orig_val = this->onDelete_orig();

	// for(int i = 0; i < 200; i++) {
	// 	purplecoinsExists[i] = 0;
	// }

	return orig_val;
}

void dGameDisplay_c::updateCometStuff(int toAdd) {
	purplecoins += toAdd;

	char countString[3];
	wchar_t wcountString_t[4];

	sprintf(countString, "%03d", purplecoins);

	wcountString_t[0] = countString[0] + 19;
	wcountString_t[1] = countString[1] + 19;
	wcountString_t[2] = countString[2] + 19;
	wcountString_t[3] = 0;

	this->layout.findTextBoxByName("TxtNumber")->SetString(wcountString_t, 3);
	this->layout.findTextBoxByName("ShaNumber")->SetString(wcountString_t, 3);

	if(purplecoins >= 100) {
		dFlagMgr_c::instance->flags |= ((u64)1 << (45 - 1));
	}

	if(toAdd == 0) {
		nw4r::lyt::Picture* vignette = this->layout.findPictureByName("P_vignette_00");
		// OSReport("VignettePtr: %p\n", vignette->material);

		// OSReport("OGColor: %02X%02X%02X%02X\n", vignette->material->blackBlendingR, vignette->material->blackBlendingG, vignette->material->blackBlendingB, vignette->material->blackBlendingA);

		dLevelInfo_c::entry_s *level = dLevelInfo_c::s_info.searchBySlot(CurrentWorld, CurrentLevel);

		if(level->vignette) { 
			vignette->material->blackBlendingR = red[level->vignette];
			vignette->material->blackBlendingG = green[level->vignette];
			vignette->material->blackBlendingB = blue[level->vignette];
			// OSReport("NewColor: %02X%02X%02X%02X\n", vignette->material->blackBlendingR, vignette->material->blackBlendingG, vignette->material->blackBlendingB, vignette->material->blackBlendingA);
		}
		else {
			vignette->SetVisible(false);
		}

		if(level->vignette != 2) {
			this->layout.findPaneByName("PCoinCounter")->SetVisible(false);
		}

		if(level->vignette != 4) {
			this->layout.findPaneByName("TimeLimit")->SetVisible(false);
		}
		if(level->vignette == 4 || (level->flags >> 8) & 1) {
			nw4r::lyt::Pane *N_time_00 = this->layout.findPaneByName("N_time_00");
			N_time_00->SetVisible(false);
			this->layout.findPaneByName("N_score_00")->trans.x = 57.0f;

			this->layout.findPaneByName("P_timer_00")->SetVisible(false);
			this->layout.findPaneByName("T_time_00")->SetVisible(false);

			this->P_TxtTick_00 = this->layout.findPaneByName("P_TxtTick_00");
		}
	}
	else {
		nw4r::lyt::Picture* PicCoin = this->layout.findPictureByName("PicCoin");
		Vec effectPos = (Vec){PicCoin->effectiveMtx[0][3], PicCoin->effectiveMtx[1][3], 0.0};
		// OSReport("opos= %f %f %f\n", effectPos.x, effectPos.y, effectPos.z);
		GetPosForLayoutEffect(&effectPos, false);
		// OSReport("npos= %f %f %f\n", effectPos.x, effectPos.y, effectPos.z);
		SpawnEffect("Wm_2d_purplecoin", 0, &effectPos, 0, 0);

		this->layout.enableNonLoopAnim(1, false);
	}
}

static nw4r::snd::StrmSoundHandle timerHandle;

void dGameDisplay_c::newUpdateTimer(u32 toSet) {
	if(enableSpeedy) {
		if(!TimeKeeper::instance->paused && !QueryGlobal5758(0xFFFFFFFF)) {
			if(this->timer != speedyTimer) {
				this->timer = speedyTimer;

				int secs = (speedyTimer % 60);
				int mins = (speedyTimer - secs) / 60;

				char timerString[5];
				wchar_t wtimerString_t[6];

				sprintf(timerString, "%02dX%02d", mins, secs);

				wtimerString_t[0] = timerString[0] + 30;
				wtimerString_t[1] = timerString[1] + 30;
				wtimerString_t[2] = timerString[2];
				wtimerString_t[3] = timerString[3] + 30;
				wtimerString_t[4] = timerString[4] + 30;
				wtimerString_t[5] = 0;

				this->layout.findTextBoxByName("TimerTxtNumber")->SetString(wtimerString_t, 5);
				this->layout.findTextBoxByName("TimerShaNumber")->SetString(wtimerString_t, 5);

				if(speedyTimer % 30 == 0 && speedyTimer != 0 && hasSpeedyStarted) {
					PlaySoundWithFunctionB4(SoundRelatedClass, &timerHandle, SFX_TIMERSIGNAL, 1);
					this->layout.enableNonLoopAnim(6, false);
				}

				if(speedyTimer == 10) {
					this->layout.enableNonLoopAnim(8, false);
					PlaySoundWithFunctionB4(SoundRelatedClass, &timerHandle, SFX_TIMERLASTSIGNAL, 1);
				}
				else if(speedyTimer < 10 && speedyTimer > 6) {
					PlaySoundWithFunctionB4(SoundRelatedClass, &timerHandle, SFX_TIMERALARM1, 1);
				}
				else if(speedyTimer < 7 && speedyTimer > 2) {
					PlaySoundWithFunctionB4(SoundRelatedClass, &timerHandle, SFX_TIMERALARM2, 1);
				}
				else if(speedyTimer < 3 && speedyTimer > 0) {
					PlaySoundWithFunctionB4(SoundRelatedClass, &timerHandle, SFX_TIMERALARM3, 1);
				}
			}

			if(speedyTimer <= 10 && !this->isRed) {
				this->layout.enableLoopAnim(4);
				this->isRed = true;
			}
			else if(speedyTimer > 10 && this->isRed) {
				this->layout.resetAnim(4, true);
				this->isRed = false;
			}

			if(!hasSpeedyStarted && speedyFrameCounter == 20) {
				this->layout.enableNonLoopAnim(7, false);
				PlaySoundWithFunctionB4(SoundRelatedClass, &timerHandle, SFX_TIMERSIGNAL, 1);

				hasSpeedyStarted = true;
			}

			if(speedyTimer == 0) {
				this->layout.disableAllAnimations();
			}
		}

		// GetSpecificPlayerActor(0)->scale = (Vec){0, 0, 0};
	}
	else {
		if(this->timer != toSet) {
			this->timer = toSet;
			u32 _3 = 3;
			WriteNumberToTextBox(&this->timer, &_3, this->timerBox, true);
		}
	}
}