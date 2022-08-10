#include "cosmicClone.h"
#include "gameDisplay.h"
#include "fileload.h"
#include "boss.h"


extern "C" bool SpawnEffect(const char*, int, Vec*, S16Vec*, Vec*);
extern u32 cosmicKillFlag;
extern u32 cosmicBeginFlag;

const char* TSarcNameList [] = {
	"cosmicmario",
	NULL
};

class daCustomSprite_c : public dEn_c {
	int onCreate();
	int onExecute();
	int onDelete();
	int onDraw();

	mHeapAllocator_c allocator;
	nw4r::g3d::ResFile resFile;
	m3d::mdl_c bodyModel;
	m3d::anmChr_c animationChr;

	s32 timer;

	static daCustomSprite_c *build();

	void updateModelMatrices();
	void spriteCollision(ActivePhysics *apThis, ActivePhysics *apOther);
	void playerCollision(ActivePhysics *apThis, ActivePhysics *apOther);
	void yoshiCollision(ActivePhysics *apThis, ActivePhysics *apOther);

	void bindAnimChr_and_setUpdateRate(const char* name, int unk, float unk2, float rate);

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


	USING_STATES(daCustomSprite_c);
	DECLARE_STATE(Walk);
	DECLARE_STATE(Die);
};

CREATE_STATE(daCustomSprite_c, Walk);
CREATE_STATE(daCustomSprite_c, Die);

void daCustomSprite_c::spriteCollision(ActivePhysics *apThis, ActivePhysics *apOther) {

}

extern "C" char usedForDeterminingStatePress_or_playerCollision(dEn_c* t, ActivePhysics *apThis, ActivePhysics *apOther, int unk1);

void daCustomSprite_c::playerCollision(ActivePhysics *apThis, ActivePhysics *apOther) {
	char hitType = usedForDeterminingStatePress_or_playerCollision(this, apThis, apOther, 2);

	if(hitType == 1) {  // The Player jumped on the Sprite
		doStateChange(&StateID_Die); // Switch to the Die state
	}
	else if(hitType == 3) { // The Player Spinjumped on the Sprite
		// doStateChange(&StateID_DieSpin); // Switch to the DieSpin state
	}
	else if(hitType == 0) { // The Player ran into the Sprite
		this->_vf220(apOther->owner); // Damage the Player
	}
}

// void daCustomSprite_c::playerCollision(ActivePhysics *apThis, ActivePhysics *apOther) {
// 	// Cataquack?
// 	if (acState.getCurrentState() == &StateID_Walk) { // If we currently are in the walking state
// 		bouncePlayer(player, 3.0f); //Bounce the player
// 	}
// }

// extern "C" bool SpawnEffect(const char* effectBale, int unk, Vec* effectPot, S16Vec* effectRot, Vec* effectScale);

// bool daShyGuy::collisionCatD_Drill(ActivePhysics *apThis, ActivePhysics *apOther) {
// 	PlaySound(this, SE_EMY_DOWN); // Play the SE_EMY_DOWN Sound Effect
// 	S16Vec nullRot = {0,0,0};
// 	Vec oneVec = {1.0f, 1.0f, 1.0f};
// 	SpawnEffect("Wm_mr_hardhit", 0, &pos, &nullRot, &oneVec); // Play the "Wm_mr_hardhit" Graphical Effect at the Sprite's position, a null rotation and a scale of 1

// 	doStateChange(&StateID_Die); // Switch to the Die state
// 	return true;
// }

void daCustomSprite_c::yoshiCollision(ActivePhysics *apThis, ActivePhysics *apOther) {

}

bool daCustomSprite_c::collisionCat7_GroundPound(ActivePhysics *apThis, ActivePhysics *apOther) {
	OSReport("GroundPound\n");
	return false;
}
bool daCustomSprite_c::collisionCat7_GroundPoundYoshi(ActivePhysics *apThis, ActivePhysics *apOther) {
	OSReport("GroundPoundYoshi\n");
	return false;
}
bool daCustomSprite_c::collisionCatD_Drill(ActivePhysics *apThis, ActivePhysics *apOther) {
	OSReport("Drill\n");
	return false;
}
bool daCustomSprite_c::collisionCatA_PenguinMario(ActivePhysics *apThis, ActivePhysics *apOther) {
	OSReport("PenguinMario\n");
	return false;
}
bool daCustomSprite_c::collisionCat1_Fireball_E_Explosion(ActivePhysics *apThis, ActivePhysics *apOther) {
	OSReport("Fireball_E_Explosion\n");
	return false;
}
bool daCustomSprite_c::collisionCat2_IceBall_15_YoshiIce(ActivePhysics *apThis, ActivePhysics *apOther) {
	OSReport("IceBall_15_YoshiIce\n");
	return false;
}
bool daCustomSprite_c::collisionCat9_RollingObject(ActivePhysics *apThis, ActivePhysics *apOther) {
	OSReport("RollingObject\n");
	return false;
}
bool daCustomSprite_c::collisionCat13_Hammer(ActivePhysics *apThis, ActivePhysics *apOther) {
	OSReport("Hammer\n");
	return false;
}
bool daCustomSprite_c::collisionCat14_YoshiFire(ActivePhysics *apThis, ActivePhysics *apOther) {
	OSReport("YoshiFire\n");
	return false;
}
bool daCustomSprite_c::collisionCat3_StarPower(ActivePhysics *apThis, ActivePhysics *apOther) {
	OSReport("StarPower\n");
	return false;
}



daCustomSprite_c *daCustomSprite_c::build() {
	void *buffer = AllocFromGameHeap1(sizeof(daCustomSprite_c));
	return new(buffer) daCustomSprite_c;
}


void daCustomSprite_c::bindAnimChr_and_setUpdateRate(const char* name, int unk, float unk2, float rate) {
	nw4r::g3d::ResAnmChr anmChr = this->resFile.GetResAnmChr(name);
	this->animationChr.bind(&this->bodyModel, anmChr, unk);
	this->bodyModel.bindAnim(&this->animationChr, unk2);
	this->animationChr.setUpdateRate(rate);
}

int daCustomSprite_c::onCreate() {

	allocator.link(-1, GameHeaps[0], 0, 0x20);

	nw4r::g3d::ResFile rf(getResource("cosmicmario", "g3d/cosmicmario.brres"));
	nw4r::g3d::ResMdl mdl = rf.GetResMdl("CosmicMario");
	bodyModel.setup(mdl, &allocator, 0x224, 1, 0);
	SetupTextures_Player(&bodyModel, 0);


	this->resFile.data = getResource("P_rcha", "g3d/model.brres");
	nw4r::g3d::ResAnmChr anmChr = this->resFile.GetResAnmChr("wait");
	this->animationChr.setup(mdl, anmChr, &this->allocator, 0);

	allocator.unlink();

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

	this->scale = (Vec){1.0, 1.0, 1.0};

	this->pos.z = 3300.0;

	this->timer = 0;
	// this->disableEatIn();
	bindAnimChr_and_setUpdateRate("wait", 1, 0.0, 1.0);

	doStateChange(&StateID_Walk);

	this->onExecute();
	return false;
}

// int daCustomSprite_c::onCreate() {
// 	/* 3D Model and Collision stuff here */

// 	this->scale = (Vec){1.0, 1.0, 1.0}; // Set the Sprite's scale to 1.0

// 	doStateChange(&StateID_Walk); // Switch to the Walk State

// 	this->onExecute(); // Start onExecute
// 	return true; // Everything went well so return true
// }


int daCustomSprite_c::onDelete() {
	return true;
}

int daCustomSprite_c::onDraw() {
	bodyModel.scheduleForDrawing();
	bodyModel._vf1C();
	return true;
}


void daCustomSprite_c::updateModelMatrices() {
	matrix.translation(pos.x, pos.y, pos.z);
	matrix.applyRotationYXZ(&rot.x, &rot.y, &rot.z);

	bodyModel.setDrawMatrix(matrix);
	bodyModel.setScale(&scale);
	bodyModel.calcWorld(false);
}

int daCustomSprite_c::onExecute() {
	acState.execute();
	updateModelMatrices();

	if(this->animationChr.isAnimationDone()) {
		this->animationChr.setCurrentFrame(0.0);
	}

	return true;
}

// Walk State

void daCustomSprite_c::beginState_Walk() {

}

void daCustomSprite_c::executeState_Walk() {
		this->pos.x += (this->direction) ? -0.4 : 0.4; // Move 0.4 units either left or right depending of the direction value
}

void daCustomSprite_c::endState_Walk() {

}

// Die State

void daCustomSprite_c::beginState_Die() {

}

void daCustomSprite_c::executeState_Die() {

}

void daCustomSprite_c::endState_Die() {

}

// void daCustomSprite_c::executeState_Turn() {
// 	this->direction = !this->direction; // Invert the direction value
// 	this->rot.y = (this->direction) ? 0xD800 : 0x2800; // Set the rotation on the Y axis either to 0xD800 or 0x2800 depending of this->direction
// }