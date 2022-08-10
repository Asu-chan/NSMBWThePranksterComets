#include <common.h>
#include <game.h>
#include <g3dhax.h>
#include <sfx.h>
#include "boss.h"
#include "music.h"
#include "gameDisplay.h"


extern "C" bool SpawnEffect(const char*, int, Vec*, S16Vec*, Vec*);

const char* PSarcNameList [] = {
	"powerstar",
	NULL
};

class dCourseClear_c : public dBase_c {
public:
	m2d::EmbedLayout_c layout;
	u8 data[0x330 - 0x208];
	dStateWrapper_c<dCourseClear_c> acState;

	static dCourseClear_c *instance;

	int onCreate_orig();
	int newOnCreate();

	int onExecute_orig();
	int newOnExecute();
};

dStageActor_c *dPowerStar_c__instance = 0;

class dPowerStar_c : public dEn_c {
	int onCreate();
	int onExecute();
	int onDelete();
	int onDraw();

	mHeapAllocator_c allocator;
	nw4r::g3d::ResFile resFile;
	m3d::mdl_c bodyModel;
	m3d::anmChr_c animationChr;

	s32 timer;

	bool invisible;
	bool touched;
	bool eventRequired;
	bool eventTriggered;
	// bool soundStarted;
	bool doneSetup;
	bool doneAppearing;

	bool noCameraShift;
	bool isCastleStar;
	bool isGrandStar;
	bool noMusic;
	float cameraAppearYTiles;
	float cosTimer;
	float origY;
	u8 exiting;

	mEf::es2 glow;
	bool isGlowing;

	daPlBase_c *players[4];

	static dPowerStar_c *build();

	float getEffectiveScreenTop();
	void updateModelMatrices();
	void bindAnimChr_and_setUpdateRate(const char* name, int unk, float unk2, float rate);

	void playerCollision(ActivePhysics *apThis, ActivePhysics *apOther);
	void spriteCollision(ActivePhysics *apThis, ActivePhysics *apOther);
	void yoshiCollision(ActivePhysics *apThis, ActivePhysics *apOther);

	bool collisionCat7_GroundPound(ActivePhysics *apThis, ActivePhysics *apOther);
	bool collisionCat7_GroundPoundYoshi(ActivePhysics *apThis, ActivePhysics *apOther);
	bool collisionCatD_Drill(ActivePhysics *apThis, ActivePhysics *apOther);
	bool collisionCatA_PenguinMario(ActivePhysics *apThis, ActivePhysics *apOther);

	bool collisionCat1_Fireball_E_Explosion(ActivePhysics *apThis, ActivePhysics *apOther);
	bool collisionCat2_IceBall_15_YoshiIce(ActivePhysics *apThis, ActivePhysics *apOther);
	bool collisionCat9_RollingObject(ActivePhysics *apThis, ActivePhysics *apOther);
	bool collisionCat13_Hammer(ActivePhysics *apThis, ActivePhysics *apOther);
	bool collisionCat14_YoshiFire(ActivePhysics *apThis, ActivePhysics *apOther);
	bool collisionCat3_StarPower(ActivePhysics *apThis, ActivePhysics *apOther);

    USING_STATES(dPowerStar_c);
    DECLARE_STATE(Appear);
    DECLARE_STATE(AppearEnd);
    DECLARE_STATE(Wait);
    DECLARE_STATE(Touched);
    DECLARE_STATE(FakeTouched);
    DECLARE_STATE(Anim);
    DECLARE_STATE(FakeAnim);
    DECLARE_STATE(CastleWait);
    DECLARE_STATE(CastleFall);
    DECLARE_STATE(CastleFloat);
};

CREATE_STATE(dPowerStar_c, Appear);
CREATE_STATE(dPowerStar_c, AppearEnd);
CREATE_STATE(dPowerStar_c, Wait);
CREATE_STATE(dPowerStar_c, Touched);
CREATE_STATE(dPowerStar_c, FakeTouched);
CREATE_STATE(dPowerStar_c, Anim);
CREATE_STATE(dPowerStar_c, FakeAnim);
CREATE_STATE(dPowerStar_c, CastleWait);
CREATE_STATE(dPowerStar_c, CastleFall);
CREATE_STATE(dPowerStar_c, CastleFloat);

static nw4r::snd::StrmSoundHandle starHandle;
extern "C" void flagtest();

void dPowerStar_c::playerCollision(ActivePhysics *apThis, ActivePhysics *apOther) {
	// PlaySoundWithFunctionB4(SoundRelatedClass, &starHandle, SFX_PURPLE_COIN, 1);
	// OSReport("Collided: %d -> ", WLClass::instance->flags);
	// OSReport("%d\n", WLClass::instance->flags);

	if(!this->touched) {
		doStateChange(&StateID_Touched);
		this->touched = true;
	}

	// flagtest();
}


void dPowerStar_c::spriteCollision(ActivePhysics *apThis, ActivePhysics *apOther) {
}


void dPowerStar_c::yoshiCollision(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
}

bool dPowerStar_c::collisionCat7_GroundPound(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}
bool dPowerStar_c::collisionCat7_GroundPoundYoshi(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}
bool dPowerStar_c::collisionCatD_Drill(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}
bool dPowerStar_c::collisionCatA_PenguinMario(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}

bool dPowerStar_c::collisionCat1_Fireball_E_Explosion(ActivePhysics *apThis, ActivePhysics *apOther) {
	return true;
}
bool dPowerStar_c::collisionCat2_IceBall_15_YoshiIce(ActivePhysics *apThis, ActivePhysics *apOther) {
	return true;
}
bool dPowerStar_c::collisionCat9_RollingObject(ActivePhysics *apThis, ActivePhysics *apOther) {
	return true;
}
bool dPowerStar_c::collisionCat13_Hammer(ActivePhysics *apThis, ActivePhysics *apOther) {
	return false;
}
bool dPowerStar_c::collisionCat14_YoshiFire(ActivePhysics *apThis, ActivePhysics *apOther) {
	return false;
}

bool dPowerStar_c::collisionCat3_StarPower(ActivePhysics *apThis, ActivePhysics *apOther) {
	return false;
}



dPowerStar_c *dPowerStar_c::build() {
	void *buffer = AllocFromGameHeap1(sizeof(dPowerStar_c));
	dPowerStar_c *c = new(buffer) dPowerStar_c;

	dPowerStar_c__instance = (dStageActor_c*)c;
	return c;
}


void dPowerStar_c::bindAnimChr_and_setUpdateRate(const char* name, int unk, float unk2, float rate) {
	nw4r::g3d::ResAnmChr anmChr = this->resFile.GetResAnmChr(name);
	this->animationChr.bind(&this->bodyModel, anmChr, unk);
	this->bodyModel.bindAnim(&this->animationChr, unk2);
	this->animationChr.setUpdateRate(rate);
}

int dPowerStar_c::onCreate() {
	this->isGrandStar = (this->settings >> 2) & 1;

	allocator.link(-1, GameHeaps[0], 0, 0x20);

	this->resFile.data = getResource("powerstar", "g3d/powerstar.brres");
	nw4r::g3d::ResMdl mdl = resFile.GetResMdl(this->isGrandStar ? "GrandStar" : "PowerStar");
	bodyModel.setup(mdl, &allocator, 0x224, 1, 0);
	SetupTextures_MapObj(&bodyModel, 0);

	nw4r::g3d::ResAnmChr anmChr = this->resFile.GetResAnmChr("collected");
	this->animationChr.setup(mdl, anmChr, &this->allocator, 0);

	allocator.unlink();

	ActivePhysics::Info HitMeBaby;

	HitMeBaby.xDistToCenter = 0.0;
	HitMeBaby.yDistToCenter = 0.0;

	HitMeBaby.xDistToEdge = 6.5;
	HitMeBaby.yDistToEdge = 6.5;

	HitMeBaby.category = 0x5;
	HitMeBaby.attack = 0x0;
	HitMeBaby.categoryBitfield = 0x4F;
	HitMeBaby.attackBitfield = 0x200;
	HitMeBaby.miscFlags = 0;
	HitMeBaby.callback = &dEn_c::collisionCallback;

	this->aPhysics.initWithStruct(this, &HitMeBaby);
	this->aPhysics.addToList();

	this->scale = (Vec){1.0, 1.0, 1.0};

	this->pos.z = 300.0;
	this->invisible = true;
	this->noCameraShift = this->settings & 1;
	this->isCastleStar = (this->settings >> 1) & 1;
	this->noMusic = (this->settings >> 3) & 1;
	this->cameraAppearYTiles = (float)((this->settings) >> 4 & 0xF) * 16.0f;

	// OSReport("Power Star Spawned\n");

	bindAnimChr_and_setUpdateRate("collected", 1, 0.0, 0.8);
	if(!this->isCastleStar) 
		doStateChange(&StateID_Wait);
	else
		doStateChange(&StateID_CastleWait);

	this->onExecute();
	return true;
}

static nw4r::snd::StrmSoundHandle starWSoundHandle;

int dPowerStar_c::onDelete() {
	// hijackSFX(1284);
	return true;
}

int dPowerStar_c::onDraw() {
	if(!this->invisible) {
		bodyModel.scheduleForDrawing();
		if(this->touched)
			bodyModel._vf1C();
	}
	
	return true;
}


void dPowerStar_c::updateModelMatrices() {
	matrix.translation(pos.x, pos.y, pos.z);
	matrix.applyRotationYXZ(&rot.x, &rot.y, &rot.z);

	bodyModel.setDrawMatrix(matrix);
	bodyModel.setScale(&scale);
	bodyModel.calcWorld(false);
}

extern "C" u32 ScreenUpThing; //8008226C

float dPowerStar_c::getEffectiveScreenTop() {
	ScreenUpThing = 0xC3C3003C;
	float f = ClassWithCameraInfo::instance->getEffectiveScreenLeft();
	ScreenUpThing = 0xC3C30038;
	// OSReport(" :");
	return f;
}

s16 starRotatingConstant;
extern u32 cosmicKillFlag;
bool cosmicTouch = false;

int dPowerStar_c::onExecute() {
	acState.execute();
	updateModelMatrices();

	starRotatingConstant += 0x280;

	if(this->doneSetup) {
		if(this->isGlowing) {
			Vec effectScale = (this->isGrandStar) ? (Vec){2.0f, 2.0f, 2.0f} : (Vec){1.0f, 1.0f, 1.0f};
			glow.spawn("Wm_ob_keywait", 0, &this->pos, 0, &effectScale);
		}

		if(!this->touched)
			this->rot.y = starRotatingConstant;

		// OSReport("eventRequired %d; eventTriggered: %d\n", this->eventRequired, this->eventTriggered);
		if(this->eventRequired && !this->eventTriggered) {
			// OSReport("Event not triggered yet\n");
			if((dFlagMgr_c::instance->flags & spriteFlagMask) != 0) {
				// OSReport("Power Star Starting appearing\n");
				this->addMyActivePhysics();
				this->eventTriggered = true;
				this->invisible = false;

				doStateChange(&StateID_Appear);
			}
		}

		if(((this->eventRequired && this->eventTriggered && this->doneAppearing) || !this->eventRequired) && this->doneSetup) {
			// PlaySoundWithFunctionB4(SoundRelatedClass, &starWSoundHandle, SFX_STAR_WAIT, 1); // StarWait
			// starWSoundHandle = PlaySound(this, 1851); // STRM_BGM_CHIKA
			// PlaySound(this, SFX_STAR_APPEAR); // STRM_BGM_CHIKA

			// if(!this->soundStarted) {
			// 	hijackSFX(SFX_STAR_WAIT);
			// 	this->soundStarted = true;
			// }

			Vec2 soundPos;
			ConvertStagePositionToScreenPosition(&soundPos, &this->pos);
			SoundPlayingClass::instance2->PlaySoundAtPosition(1851, &soundPos, 0);
			// this->soundStarted = true;
		}

		// OSReport("ClassWithCameraInfo: %f %f\n", ClassWithCameraInfo::instance->xOffset, ClassWithCameraInfo::instance->yOffsetForTagScroll);
		// OSReport("ClassWithCameraInfo: %f", ClassWithCameraInfo::instance->getEffectiveScreenLeft());
		// OSReport(" %f %f", ClassWithCameraInfo::instance->screenLeft, ClassWithCameraInfo::instance->screenTop);
		// OSReport(" %f %f\n", this->pos.x, this->pos.y);

		if(cosmicTouch && !this->touched) {
			this->touched = true;
			doStateChange(&StateID_FakeTouched);
		}
	}

	if(this->isCastleStar) this->onDraw();

	return true;
}


// Appear State
Vec careful[4] = {{0, 0, 0},
				  {0, 0, 0},
				  {0, 0, 0},
				  {0, 0, 0}};
static nw4r::snd::StrmSoundHandle starSoundHandle;
extern "C" u8 NextStageActorDisableFlags;
extern void centerCameraOnObject(Vec3 pos, bool doX, bool doY);

void dPowerStar_c::beginState_Appear() {
	// OSReport("Power Star Appearing\n");
	this->timer = 0;

	if(!this->noCameraShift) {
		// MakeMarioEnterDemoMode();
		StopBGMMusic();
	}
	hijackMusicWithSongName("new/StarWaiting", 100, false, 2, 1, 0, true, true);

	for(int i = 0; i < 4; i++) {
		if(daPlBase_c* player = GetPlayerOrYoshi(i)) {
			this->players[i] = player;
			careful[i] = player->pos;
		}
	}

	if(!this->noCameraShift) {
		StageC4::instance->_1D = 1;

		Vec3 centerPos = (Vec3){this->pos.x, this->pos.y + this->cameraAppearYTiles, this->pos.z};
		centerCameraOnObject(centerPos, true, true);
		// ClassWithCameraInfo::instance->xOffset = this->pos.x - ClassWithCameraInfo::instance->getEffectiveScreenLeft() - (ClassWithCameraInfo::instance->screenWidth / 2);
		// ClassWithCameraInfo::instance->yOffsetForTagScroll = this->pos.y - ClassWithCameraInfo::instance->screenTop + (ClassWithCameraInfo::instance->screenHeight / 2) + 24 + this->cameraAppearYTiles;

		this->disableFlagMask = 0;
		NextStageActorDisableFlags |= 0xF;
	}
}

void dPowerStar_c::executeState_Appear() {
	if(this->timer == 90) {
		bindAnimChr_and_setUpdateRate("appear", 1, 0.0, 1.0);
		PlaySoundWithFunctionB4(SoundRelatedClass, &starSoundHandle, SFX_STAR_APPEAR, 1); // StarAppear
		this->touched = true;
	}

	if(this->timer == 250) {
		this->isGlowing = true;
		this->touched = false;
	}

	for(int i = 0; i < 4; i++) {
		if(this->players[i]) {
			this->players[i]->pos = careful[i];
		}
	}

	if(this->timer < 370) {
		if(!this->noCameraShift) {
			Vec3 centerPos = (Vec3){this->pos.x, this->pos.y + this->cameraAppearYTiles, this->pos.z};
			centerCameraOnObject(centerPos, true, true);
			// ClassWithCameraInfo::instance->xOffset = this->pos.x - ClassWithCameraInfo::instance->getEffectiveScreenLeft() - (ClassWithCameraInfo::instance->screenWidth / 2);
			// ClassWithCameraInfo::instance->yOffsetForTagScroll = this->pos.y - ClassWithCameraInfo::instance->screenTop + (ClassWithCameraInfo::instance->screenHeight / 2) + 24 + this->cameraAppearYTiles;
		}
	}
	else if(this->timer == 370) {
		if(!this->noCameraShift) {
			ClassWithCameraInfo::instance->xOffset = 0;
			ClassWithCameraInfo::instance->yOffsetForTagScroll = 0;
		}
		this->doneAppearing = true;
		if(!this->noMusic) StartBGMMusic();
		doStateChange(&StateID_AppearEnd);
	}

	/*int held = Remocon_GetButtons(GetActiveRemocon());
	int multiplier = 1;
	if(held & WPAD_B) {
		multiplier = 3;
	}

	if(held & WPAD_RIGHT) {
		ClassWithCameraInfo::instance->xOffset += multiplier;
	}
	else if(held & WPAD_LEFT) {
		ClassWithCameraInfo::instance->xOffset -= multiplier;
	}

	if(held & WPAD_UP) {
		ClassWithCameraInfo::instance->yOffsetForTagScroll += multiplier;
	}
	else if(held & WPAD_DOWN) {
		ClassWithCameraInfo::instance->yOffsetForTagScroll -= multiplier;
	}*/


	this->timer++;
}

void dPowerStar_c::endState_Appear() {
}


// Wait State

void dPowerStar_c::beginState_AppearEnd() {
	this->timer = 0;
}

void dPowerStar_c::executeState_AppearEnd() {
	for(int i = 0; i < 4; i++) {
		if(this->players[i]) {
			this->players[i]->pos = careful[i];
		}
	}

	if(this->timer == 30) {
		StageC4::instance->_1D = 0;
		doStateChange(&StateID_Wait);
	}

	this->timer++;
}

void dPowerStar_c::endState_AppearEnd() {
	if(!this->noCameraShift) {
		NextStageActorDisableFlags &= 0xF0;
		this->disableFlagMask = 8;
	}
	MakeMarioExitDemoMode();
}


// Wait State

void dPowerStar_c::beginState_Wait() {
	this->timer = 0;
}

void dPowerStar_c::executeState_Wait() {

	// OSReport("Power Star Waiting: %d\n", this->doneSetup);
	if(this->timer == 3) { //Apparently can't put that in the onCreate
		// OSReport("this->spriteFlagNum = %d\n", this->spriteFlagNum);
		if(this->spriteFlagNum > 0 && !this->eventRequired) {
			this->removeMyActivePhysics();
			this->eventRequired = true;
			this->isGlowing = false;
			this->invisible = true;
		}
		else {
			this->isGlowing = true;
			this->invisible = false;
		}

		this->doneSetup = true;
	}

	this->timer++;
}

void dPowerStar_c::endState_Wait() {
}


// Touched State

dCourseClear_c *dCourseClear_c::instance = 0;

void dPowerStar_c::beginState_Touched() {
	this->timer = 0;
	this->isGlowing = false;
	cosmicKillFlag = 1;

	// WLClass::instance->flags |= 4;
	WLClass::instance->_4 = 5;
	WLClass::instance->_8 = 0;
	dStage32C_c::instance->freezeMarioBossFlag = 1;

	// MakeMarioEnterDemoMode();
	StopBGMMusic();

	PlaySoundWithFunctionB4(SoundRelatedClass, &starSoundHandle, 767, 1); // SE_OBJ_BROOM_KEY_GET

	S16Vec nullRot = {0,0,0};
	Vec twoVec = {2.0f, 2.0f, 2.0f};
	SpawnEffect("Wm_ob_keyget01", 0, &this->pos, &nullRot, &twoVec);
}

void dPowerStar_c::executeState_Touched() {
	// if(this->scale.x > 0) {
	// 	this->scale = (Vec){this->scale.x - 0.02f, this->scale.y - 0.02f, this->scale.z - 0.02f};
	// 	this->rot.y += 0x300;
	// }
	// else {
	// 	this->invisible = true;
	// }
	if(this->animationChr.isAnimationDone()) {
		this->invisible = true;
	}
	else {
		this->rot.y += 0600;
	}

	bool isOnGround = true;
	for(int i = 0; i < 4; i++) {
		if(Player_Active[i] && Player_Lives[i] > 0) {
			if(!(GetPlayerOrYoshi(i)->collMgr.isOnTopOfTile())) {
				// OSReport("Player %d isn't on ground\n", i);
				isOnGround = false;
			}
		}
	}

	// OSReport("isOnGround: %d, invisible: %d\n", isOnGround, invisible);

	if(isOnGround && this->invisible) {
		this->timer++;
	}

	if(this->timer == 30) {
		doStateChange(&StateID_Anim);
	}
}

void dPowerStar_c::endState_Touched() {
	// OSReport("Going to Anim\n");
}


// FakeTouched State

void dPowerStar_c::beginState_FakeTouched() {
	this->timer = 0;
	this->isGlowing = false;

	// WLClass::instance->flags |= 4;
	// WLClass::instance->_4 = 5;
	// WLClass::instance->_8 = 0;
	// dStage32C_c::instance->freezeMarioBossFlag = 1;

	MakeMarioEnterDemoMode();
	StopBGMMusic();

	PlaySoundWithFunctionB4(SoundRelatedClass, &starSoundHandle, 767, 1); // SE_OBJ_BROOM_KEY_GET

	S16Vec nullRot = {0,0,0};
	Vec twoVec = {2.0f, 2.0f, 2.0f};
	SpawnEffect("Wm_ob_keyget01", 0, &this->pos, &nullRot, &twoVec);
}

void dPowerStar_c::executeState_FakeTouched() {
	if(this->animationChr.isAnimationDone()) {
		this->invisible = true;
	}
	else {
		this->rot.y += 0600;
	}

	if(this->invisible) {
		this->timer++;
	}

	if(this->timer == 30) {
		doStateChange(&StateID_FakeAnim);
	}
}

void dPowerStar_c::endState_FakeTouched() {

}


// Anim State

void dPowerStar_c::beginState_Anim() {
	this->timer = 0;
	WLClass::instance->_4 = 5;
	WLClass::instance->_8 = 0;
	dStage32C_c::instance->freezeMarioBossFlag = 1;
	// WLClass::instance->flags |= 0xf;

	if(!this->isCastleStar) 
		PlaySoundWithFunctionB4(SoundRelatedClass, &starHandle, STRM_BGM_COURSE_CLEAR, 1);
	else
		PlaySoundWithFunctionB4(SoundRelatedClass, &starHandle, STRM_BGM_SHIRO_BOSS_CLEAR, 1);

	BossGoalForAllPlayers();
}

extern u32* GetCurrentPC();

void dPowerStar_c::executeState_Anim() {
	this->timer++;
	// OSReport("_4 & _8: %d %d\n", WLClass::instance->_4, WLClass::instance->_8);
	// OSReport("flags: %d %d\n", WLClass::instance->flags, *((u32*)(*((u32*)(WLClass::instance->flags)) + 0x10)));

	if(this->timer == 20) {
		WLClass::instance->_4 = 5;
		WLClass::instance->_8 = 0;
	}
	else if(this->timer == 50) {
		UpdateGameMgr();
		*((u8*)((u32)(dCourseClear_c::instance) + 0x375)) = 1;
	}
	else if(this->timer == 230) {
		dGameDisplay_c::instance->_44C = 1;
		*((u8*)((u32)(dCourseClear_c::instance) + 0x376)) = 1;
	}



	// OSReport("PC: %p\n", GetCurrentPC());

	if(this->exiting) {
		this->exiting++;
	}
	//else if(!strcmp(dGameDisplay_c::instance->state.getCurrentState()->getName(), "dGameDisplay_c::StateID_ProcGoalEnd")) { // For some reason, strcmp returns true if the string ISN'T what it was compared to; weird. EDIT: that's actually normal
	else if(dGameDisplay_c::instance->state.getCurrentState() == &dGameDisplay_c::StateID_ProcGoalEnd) {
		this->exiting = 1;
	}

	if(this->exiting == 60) {
		ExitStage(WORLD_MAP, 0, BEAT_LEVEL, MARIO_WIPE);
	}
}

void dPowerStar_c::endState_Anim() {

}


// FakeAnim State

extern "C" void HurtMarioBecauseOfBeingSquashed(void *mario, dStageActor_c *squasher, int type);

void dPowerStar_c::beginState_FakeAnim() {
	this->timer = 0;
	WLClass::instance->_4 = 5;
	WLClass::instance->_8 = 0;
	dStage32C_c::instance->freezeMarioBossFlag = 1;
	// WLClass::instance->flags |= 0xf;

	PlaySoundWithFunctionB4(SoundRelatedClass, &starHandle, SE_MG_IH_WIN_BR_OPEN, 1);

	u32* ptrToCourseTimeUp = (u32*)*(u32*)(((u32)StagePtr) + 0x11E4);
	*(u8*)(((u32)ptrToCourseTimeUp) + 0x379) = 1;
	*(u8*)(((u32)ptrToCourseTimeUp) + 0x388) = 1;
	// nw4r::lyt::TextBox* txtb = (nw4r::lyt::TextBox*)*(u32*)(((u32)ptrToCourseTimeUp) + 0x374);
	// txtb->SetString(L"Too Bad!");

	// BossGoalForAllPlayers();
}

void dPowerStar_c::executeState_FakeAnim() {
	this->timer++;

	if(this->timer == 100) {
		MakeMarioExitDemoMode();
		for(int i = 0; i < 4; i++) {
			if(Player_Active[i]) {
				HurtMarioBecauseOfBeingSquashed(GetPlayerOrYoshi(i), this, 4);
			}
		}
	}

}

void dPowerStar_c::endState_FakeAnim() {

}


// CastleWait State

void dPowerStar_c::beginState_CastleWait() {
	this->invisible = true;
	this->isGlowing = false;
	this->doneSetup = true;

	this->pos.y += 16.0f;
	this->removeMyActivePhysics();
}

void dPowerStar_c::executeState_CastleWait() {

}

void dPowerStar_c::endState_CastleWait() {

}


// CastleFall State

void dPowerStar_c::beginState_CastleFall() {
	this->invisible = false;
	this->visible = true;
	this->isGlowing = true;
	this->addMyActivePhysics();
	this->y_speed_inc = 0.185;
}

void dPowerStar_c::executeState_CastleFall() {
	Vec2 soundPos;
	ConvertStagePositionToScreenPosition(&soundPos, &this->pos);
	SoundPlayingClass::instance2->sub_801994D0(0x2FE, this->id, &soundPos, 0);

	this->pos.y -= 0.5f;
}

void dPowerStar_c::endState_CastleFall() {

}


// CastleFloat State

void dPowerStar_c::beginState_CastleFloat() {
	this->timer = 0;
	this->cosTimer = 2.0f;
	this->origY = this->pos.y;
}

void dPowerStar_c::executeState_CastleFloat() {
	Vec2 soundPos;
	ConvertStagePositionToScreenPosition(&soundPos, &this->pos);
	SoundPlayingClass::instance2->sub_801994D0(0x2FE, this->id, &soundPos, 0);

	if(this->cosTimer >= 4.0f) {
		this->cosTimer -= 4.0f;
	}

	this->pos.y = this->origY + (16 * (sin((M_PI/2) * this->cosTimer))); // cos((M_PI/2) basically forms a wave, then we ajust the speed using cosTimer's incrementation and the distance by 16 (=2 tiles)

	this->cosTimer += 0.01f;
}

void dPowerStar_c::endState_CastleFloat() {
	this->lookAtMode = 0;
}



int dCourseClear_c::newOnCreate() {
	int orig_val = this->onCreate_orig();

	instance = this;

	return orig_val;
}


class daEnGlpole_c : public dEn_c {
public:
	int onExecute_orig();
	int newOnExecute();
};

int daEnGlpole_c::newOnExecute() {
	int orig_val = this->onExecute_orig();

	// OSReport("GP State: %s\n", this->acState.getCurrentState()->getName());

	return orig_val;
}

class TowerBosses : public dActorMultiState_c {
public:
	void DemoFallEd();
};

void TowerBosses::DemoFallEd() {
	dFlagMgr_c::instance->flags |= ((u64)1 << (45 - 1));
}