#include "cosmicClone.h"


extern "C" bool SpawnEffect(const char*, int, Vec*, S16Vec*, Vec*);
extern u32 cosmicKillFlag;
extern u32 cosmicBeginFlag;

class daRaceRecorder_c : public dEn_c {
	int onCreate();
	int onExecute();
	int onDelete();
	int onDraw();

	mHeapAllocator_c allocator;

	CosmicBuffer cosmicBuffer[10800];

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
	bool isDone;

	u32 delay;

	dAcPy_c* player;
	dPlayerModelBase_c* model;

	static daRaceRecorder_c *build();

	void updateModelMatrices();
	void playerCollision(ActivePhysics *apThis, ActivePhysics *apOther);
	void spriteCollision(ActivePhysics *apThis, ActivePhysics *apOther);

	void bindAnimChr_and_setUpdateRate(const char* name, int unk, float unk2, float rate);
	void bindSubAnimChr_and_setUpdateRate(const char* name, int unk, float unk2, float rate);

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


void daRaceRecorder_c::playerCollision(ActivePhysics *apThis, ActivePhysics *apOther) {
	this->_vf220(apOther->owner);
}


void daRaceRecorder_c::spriteCollision(ActivePhysics *apThis, ActivePhysics *apOther) {

}

bool daRaceRecorder_c::collisionCat7_GroundPound(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}
bool daRaceRecorder_c::collisionCat7_GroundPoundYoshi(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}
bool daRaceRecorder_c::collisionCatD_Drill(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}
bool daRaceRecorder_c::collisionCatA_PenguinMario(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}

bool daRaceRecorder_c::collisionCat1_Fireball_E_Explosion(ActivePhysics *apThis, ActivePhysics *apOther) {
	return true;
}
bool daRaceRecorder_c::collisionCat2_IceBall_15_YoshiIce(ActivePhysics *apThis, ActivePhysics *apOther) {
	return true;
}
bool daRaceRecorder_c::collisionCat9_RollingObject(ActivePhysics *apThis, ActivePhysics *apOther) {
	return true;
}
bool daRaceRecorder_c::collisionCat13_Hammer(ActivePhysics *apThis, ActivePhysics *apOther) {
	return true;
}
bool daRaceRecorder_c::collisionCat14_YoshiFire(ActivePhysics *apThis, ActivePhysics *apOther) {
	return true;
}

bool daRaceRecorder_c::collisionCat3_StarPower(ActivePhysics *apThis, ActivePhysics *apOther) {
	return true;
}



daRaceRecorder_c *daRaceRecorder_c::build() {
	void *buffer = AllocFromGameHeap1(sizeof(daRaceRecorder_c));
	return new(buffer) daRaceRecorder_c;
}

int daRaceRecorder_c::onCreate() {
	player = dAcPy_c::findByID(0);
	model = (dPlayerModelBase_c*)player->modelClass;

	OSReport("Recording Started\n");
	this->onExecute();
	return true;
}


int daRaceRecorder_c::onDelete() {
	return true;
}

int daRaceRecorder_c::onDraw() {
	return true;
}


void daRaceRecorder_c::updateModelMatrices() {
	matrix.translation(pos.x, pos.y, pos.z);
	matrix.applyRotationYXZ(&rot.x, &rot.y, &rot.z);
}

int daRaceRecorder_c::onExecute() {
	updateModelMatrices();

	if(model->current_anim != 86 && !isDone) { //goal_wait
		cosmicBuffer[this->timer].pos = player->pos;
		cosmicBuffer[this->timer].rot = player->rot;
		cosmicBuffer[this->timer].anim = model->current_anim;
		cosmicBuffer[this->timer].subAnim = model->last_anim_maybe;
		cosmicBuffer[this->timer].animFrame = model->SomeAnimation_0.currentFrame;
		cosmicBuffer[this->timer].subAnimFrame = model->SomeAnimation_1.currentFrame;

		this->timer++;

		// if((int)model->current_anim < 0) {
		// 	dAcPy_c *yoshi = (dAcPy_c*)player->getYoshi();
		// 	if(yoshi) {
		// 		// model = ((dPlayerModelHandler_c*)*yoshi->modelHandler)->mdlClass;
		// 		model = (dPlayerModelBase_c*)player->modelClass;
		// 		OSReport("Switched to Yoshi\n");
		// 	}
		// 	else {
		// 		model = (dPlayerModelBase_c*)player->modelClass;
		// 		OSReport("Switched to Mario\n");
		// 	}
		// }

		if(previousAnim != model->current_anim) {
			previousAnim = model->current_anim;
			OSReport("Saved anim %d: %s", model->current_anim, PlayerAnimStates[model->current_anim].regularAnim);
			OSReport(" -> frame %d, ptr: %p\n", this->timer, ((u32)&cosmicBuffer) + (this->timer * 36));
		}

    	int nowPressed = Remocon_GetPressed(GetActiveRemocon());
    	if(nowPressed & WPAD_A) {
			OSReport("Frame %d, ptr: %p\n", this->timer, ((u32)&cosmicBuffer) + (this->timer * 36));
    	}
	}
	else if(!isDone) {
		OSReport("Recording Saved: %p, %d frames\n", &cosmicBuffer, this->timer);
		isDone = true;
	}
	return true;
}