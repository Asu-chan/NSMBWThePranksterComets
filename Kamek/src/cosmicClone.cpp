#include "cosmicClone.h"


extern "C" bool SpawnEffect(const char*, int, Vec*, S16Vec*, Vec*);
extern u32 cosmicKillFlag;
extern u32 cosmicBeginFlag;

const char* CCarcNameList [] = {
	"cosmicclone",
	NULL
};

class daCosmicClone_c : public dEn_c {
	int onCreate();
	int onExecute();
	int onDelete();
	int onDraw();

	mHeapAllocator_c allocator;
	m3d::mdl_c bodyModel;

	nw4r::g3d::ResFile resFileAnim;
	m3d::anmChr_c animationChr;
	m3d::anmChr_c subAnimationChr;
	m3d::anmChrPart_c chrPart;

	mEf::es2 dust;

	CosmicBuffer cosmicBuffer[511];

	s32 timer;
	s32 bufferTimer;
	s32 scaleTimer;
	u32 previousAnim;
	u32 previousAnim2;
	bool hasStarted;
	bool hasSpawned;
	bool doesBeginSound;
	bool doesEndSound;
	bool hasBeenScaled;

	u32 delay;

	dAcPy_c* player;
	dPlayerModelBase_c* model;

	static daCosmicClone_c *build();

	void updateModelMatrices();
	void playerCollision(ActivePhysics *apThis, ActivePhysics *apOther);
	void spriteCollision(ActivePhysics *apThis, ActivePhysics *apOther);

	void bindAnimChr_and_setUpdateRate(const char* name, int unk, float unk2, float rate);
	void bindSubAnimChr_and_setUpdateRate(const char* name, int unk, float unk2, float rate);

	void doCosmicScale();

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

};


void daCosmicClone_c::playerCollision(ActivePhysics *apThis, ActivePhysics *apOther) {
	this->_vf220(apOther->owner);
}


void daCosmicClone_c::spriteCollision(ActivePhysics *apThis, ActivePhysics *apOther) {

}

bool daCosmicClone_c::collisionCat7_GroundPound(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}
bool daCosmicClone_c::collisionCat7_GroundPoundYoshi(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}
bool daCosmicClone_c::collisionCatD_Drill(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}
bool daCosmicClone_c::collisionCatA_PenguinMario(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}

bool daCosmicClone_c::collisionCat1_Fireball_E_Explosion(ActivePhysics *apThis, ActivePhysics *apOther) {
	return true;
}
bool daCosmicClone_c::collisionCat2_IceBall_15_YoshiIce(ActivePhysics *apThis, ActivePhysics *apOther) {
	return true;
}
bool daCosmicClone_c::collisionCat9_RollingObject(ActivePhysics *apThis, ActivePhysics *apOther) {
	return true;
}
bool daCosmicClone_c::collisionCat13_Hammer(ActivePhysics *apThis, ActivePhysics *apOther) {
	return true;
}
bool daCosmicClone_c::collisionCat14_YoshiFire(ActivePhysics *apThis, ActivePhysics *apOther) {
	return true;
}

bool daCosmicClone_c::collisionCat3_StarPower(ActivePhysics *apThis, ActivePhysics *apOther) {
	return true;
}



daCosmicClone_c *daCosmicClone_c::build() {
	void *buffer = AllocFromGameHeap1(sizeof(daCosmicClone_c));
	return new(buffer) daCosmicClone_c;
}


void daCosmicClone_c::bindAnimChr_and_setUpdateRate(const char* name, int unk, float unk2, float rate) {
	nw4r::g3d::ResAnmChr anmChr = this->resFileAnim.GetResAnmChr(name);
	this->animationChr.bind(&this->bodyModel, anmChr, unk);
	this->bodyModel.bindAnim(&this->animationChr, unk2);
	this->animationChr.setUpdateRate(rate);
}


void daCosmicClone_c::bindSubAnimChr_and_setUpdateRate(const char* name, int unk, float unk2, float rate) {
	nw4r::g3d::ResAnmChr anmChr = this->resFileAnim.GetResAnmChr(name);
	this->subAnimationChr.bind(&this->bodyModel, anmChr, unk);
	this->bodyModel.bindAnim(&this->subAnimationChr, unk2);
	this->subAnimationChr.setUpdateRate(rate);
}

int daCosmicClone_c::onCreate() {
	player = dAcPy_c::findByID(0);

	allocator.link(-1, GameHeaps[0], 0, 0x20);

	// const char *BRRESs[4] = {
	// 	"g3d/mario.brres",
	// 	"g3d/luigi.brres",
	// 	"g3d/kinoB.brres",
	// 	"g3d/kinoY.brres"
	// };

	nw4r::g3d::ResFile rf(getResource("cosmicclone", "g3d/mario.brres" /*BRRESs[player->characterID]*/));
	nw4r::g3d::ResMdl mdl = rf.GetResMdl("CosmicClone");
	bodyModel.setup(mdl, &allocator, 0x224, 1, 0);
	SetupTextures_Player(&bodyModel, 0);


	this->resFileAnim.data = getResource("P_rcha", "g3d/model.brres");
	nw4r::g3d::ResAnmChr anmChr = this->resFileAnim.GetResAnmChr(PlayerAnimStates[0].regularAnim);
	this->animationChr.setup(mdl, anmChr, &this->allocator, 0);
	this->subAnimationChr.setup(mdl, anmChr, &this->allocator, 0);

	this->chrPart.setup(mdl, 2, &this->allocator, 0);
	this->chrPart.attachChr(0, this->animationChr, 1.0);
	this->chrPart.attachChr(1, this->subAnimationChr, 1.0);

	allocator.unlink();

	this->scale = (Vec){0.0, 0.0, 0.0};

	this->pos.x -= 120.0;
	this->pos.z = 3300.0;

	this->previousAnim = -1;
	this->previousAnim2 = -1;

	this->delay = this->settings & 0xFF;
	this->doesEndSound = (this->settings >> 8 & 0xF) & 1;
	this->doesBeginSound = !cosmicBeginFlag;
	cosmicBeginFlag = true;

	this->bufferTimer = this->delay;
	this->deleteForever = 1;
	this->base_type = 2;
	this->stageActorType = 3;

	model = (dPlayerModelBase_c*)player->modelClass;

	bindAnimChr_and_setUpdateRate(PlayerAnimStates[0].regularAnim, 1, 0.0, 1.0);
	bindSubAnimChr_and_setUpdateRate(PlayerAnimStates[0].regularAnim, 1, 0.0, 1.0);

	this->onExecute();
	return true;
}


int daCosmicClone_c::onDelete() {
	return true;
}

int daCosmicClone_c::onDraw() {
	bodyModel.scheduleForDrawing();
	bodyModel._vf1C();
	this->animationChr.process();
	this->subAnimationChr.process();
	return true;
}


void daCosmicClone_c::updateModelMatrices() {
	matrix.translation(pos.x, pos.y, pos.z);
	matrix.applyRotationYXZ(&rot.x, &rot.y, &rot.z);

	bodyModel.setDrawMatrix(matrix);
	bodyModel.setScale(&scale);
	bodyModel.calcWorld(false);
}

static nw4r::snd::StrmSoundHandle cloneSoundHandle;

Vec twoScale = (Vec){2.0, 2.0, 2.0};

int daCosmicClone_c::onExecute() {
	updateModelMatrices();

	if(cosmicKillFlag) {
		if(doesEndSound) {
			PlaySoundWithFunctionB4(SoundRelatedClass, &cloneSoundHandle, SFX_COSMICMARIO_DIE, 1);
		}

		// this->killedByLevelClear();
		Vec effectPos = (Vec){this->pos.x, this->pos.y + 16, this->pos.z};
		SpawnEffect("Wm_en_cloneburst_s", 0, &effectPos, 0, &twoScale);
		this->Delete(1);
	}

	if(hasStarted) {
		this->rot = cosmicBuffer[this->bufferTimer].rot;
		this->pos = cosmicBuffer[this->bufferTimer].pos;

		Vec effectPos = (Vec){this->pos.x, this->pos.y + 16, this->pos.z};
		Vec effectScale = (Vec){1.5, 1.5, 1.5};
		dust.spawn("Wm_mr_clonedust", 0, &effectPos, 0, &effectScale);

		// OSReport("player: %f %f", player->aPhysics.info.xDistToCenter, player->aPhysics.info.yDistToCenter);
		// OSReport(" %f %f\n", player->aPhysics.info.xDistToEdge, player->aPhysics.info.yDistToEdge);
		if(!hasSpawned &&this->bufferTimer == 3) {
			Vec effectPos = (Vec){cosmicBuffer[this->bufferTimer].pos.x, cosmicBuffer[this->bufferTimer].pos.y + 16, cosmicBuffer[this->bufferTimer].pos.z};
			SpawnEffect("Wm_en_cloneburst_s", 0, &effectPos, 0, &twoScale);

			hasSpawned = true;
		}

		int anim = cosmicBuffer[this->bufferTimer].anim;
		int subAnim = cosmicBuffer[this->bufferTimer].subAnim;
		if(previousAnim != anim) {
			previousAnim = anim;
			// OSReport("Anim changed to: %d: %s\n", anim, PlayerAnimStates[anim].regularAnim);
			bindAnimChr_and_setUpdateRate(PlayerAnimStates[anim].regularAnim, 1, 0.0, 1.0);
		}

		if(previousAnim2 != subAnim) {
			previousAnim2 = subAnim;
			// OSReport("SubAnim changed to: %d: %s\n", subAnim, PlayerAnimStates[subAnim].regularAnim);
			if(subAnim >= 0) {
				// OSReport(">=0\n");
				bindSubAnimChr_and_setUpdateRate(PlayerAnimStates[subAnim].regularAnim, 1, 0.0, 1.0);
			}
			else {
				// OSReport("-1\n");
				bindSubAnimChr_and_setUpdateRate(PlayerAnimStates[anim].regularAnim, 1, 0.0, 1.0);
			}
		}

		/*if(this->direction != player->direction) {
			this->direction = player->direction;
		}*/

		this->animationChr.setCurrentFrame(cosmicBuffer[this->bufferTimer].animFrame);
		if(subAnim >= 0) {
			this->subAnimationChr.setCurrentFrame(cosmicBuffer[this->bufferTimer].subAnimFrame);
		}
		else {
			this->subAnimationChr.setCurrentFrame(cosmicBuffer[this->bufferTimer].animFrame);
		}

		if(!this->hasBeenScaled) {
			this->doCosmicScale();
			this->scaleTimer++;
		}
	}

	cosmicBuffer[this->timer].pos = player->pos;
	cosmicBuffer[this->timer].rot = player->rot;
	cosmicBuffer[this->timer].anim = model->current_anim;
	cosmicBuffer[this->timer].subAnim = model->last_anim_maybe;
	cosmicBuffer[this->timer].animFrame = model->SomeAnimation_0.currentFrame;
	cosmicBuffer[this->timer].subAnimFrame = model->SomeAnimation_1.currentFrame;



	this->timer++;
	this->bufferTimer++;
	
	if((this->timer == this->delay - 20) && this->doesBeginSound) {
		PlaySoundWithFunctionB4(SoundRelatedClass, &cloneSoundHandle, SFX_COSMICMARIO_APPEAR, 1);
		this->doesBeginSound = false;
	}

	if(this->timer == this->delay) {hasStarted = true; this->bufferTimer = 0;}
	if(this->timer >= 511) {this->timer = 0;}
	if(this->bufferTimer >= 511) {this->bufferTimer = 0;}

	// OSReport("timers: %d %d\n", this->timer, this->bufferTimer);
	return true;
}

void daCosmicClone_c::doCosmicScale() {
	float scaleT = (float)this->scaleTimer / 30.0;
	if(scaleT >= 1.0) {
		this->scale = (Vec){1.0, 1.0, 1.0};

		ActivePhysics::Info HitMeBaby;
		HitMeBaby.xDistToCenter = 0.0;
		HitMeBaby.yDistToCenter = 12.0;
		HitMeBaby.xDistToEdge = 6.0;
		HitMeBaby.yDistToEdge = 12.0;
		HitMeBaby.category = 0x5;
		HitMeBaby.attack = 0x0;
		HitMeBaby.categoryBitfield = 0x4F;
		HitMeBaby.attackBitfield = 0xFFFFFFFF;
		HitMeBaby.miscFlags = 0;
		HitMeBaby.callback = &dEn_c::collisionCallback;

		this->aPhysics.initWithStruct(this, &HitMeBaby);
		this->aPhysics.addToList();

		this->hasBeenScaled = true;
	}
	else {
		this->scale = (Vec){scaleT, scaleT, scaleT};
	}
}