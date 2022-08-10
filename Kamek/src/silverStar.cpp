#include <common.h>
#include <game.h>
#include <g3dhax.h>
#include <sfx.h>
#include "gameDisplay.h"


extern "C" bool SpawnEffect(const char*, int, Vec*, S16Vec*, Vec*);

const char* SSarcNameList [] = {
	"silverstar",
	NULL
};

u8 silverstarCollected[8]; //Index 7 is "How many were collected"


class dSilverStar_c : public dEn_c {
	int onCreate();
	int onExecute();
	int onDelete();
	int onDraw();

	mHeapAllocator_c allocator;
	m3d::mdl_c bubbleModel;
	m3d::mdl_c bodyModel;
	nw4r::g3d::ResFile resFile;
	m3d::anmChr_c animationChr;

	mMtx bubbleMatrix;
	Vec bubbleScale;
	S16Vec bubbleRot;
	Vec starPos;
	VEC2 displacement;

	u64 eventFlag;
	s32 timer;

	u32 effect;
	u8 type;

	u8 id;

	float cosTimer;
	float cosTimer2;
	float origY;
	float isOdd;

	Vec2 marioPositions[200];
	u32 marioPosTimer;
	u32 marioPosBufferTimer;
	bool hasFollowingStarted;
	u32 delay;

	bool collected;
	bool noDispawn;
	VEC2 finalDistance;
	VEC2 finalDisplacement;

	u32 movementControllerID;
	u8 movementType;
	bool doneSearching;
	Vec ogPos;

	static dSilverStar_c *build();

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

	USING_STATES(dSilverStar_c);
	DECLARE_STATE(Wait);
	DECLARE_STATE(Follow);
	DECLARE_STATE(Merge);
};

CREATE_STATE(dSilverStar_c, Wait);
CREATE_STATE(dSilverStar_c, Follow);
CREATE_STATE(dSilverStar_c, Merge);

static nw4r::snd::StrmSoundHandle handle;
extern "C" void AddScore(int howMany, int color);

void dSilverStar_c::playerCollision(ActivePhysics *apThis, ActivePhysics *apOther) {
	this->collected = true;
	this->removeMyActivePhysics();
	S16Vec nullRot = {0,0,0};
	Vec oneVec = {1.0f, 1.0f, 1.0f};
	SpawnEffect("Wm_mr_balloonburst", 0, &this->pos, &nullRot, &oneVec);

	// PlaySoundWithFunctionB4(SoundRelatedClass, &handle, SFX_PURPLE_COIN, 1);


	silverstarCollected[7]++;
	this->delay = silverstarCollected[7] * 7;
	silverstarCollected[this->id] = silverstarCollected[7];
	AddScore(100, apOther->owner->which_player);
	// this->Delete(1);

	doStateChange(&StateID_Follow);
}


void dSilverStar_c::spriteCollision(ActivePhysics *apThis, ActivePhysics *apOther) {

}


void dSilverStar_c::yoshiCollision(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
}

bool dSilverStar_c::collisionCat7_GroundPound(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}
bool dSilverStar_c::collisionCat7_GroundPoundYoshi(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}
bool dSilverStar_c::collisionCatD_Drill(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}
bool dSilverStar_c::collisionCatA_PenguinMario(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}

bool dSilverStar_c::collisionCat1_Fireball_E_Explosion(ActivePhysics *apThis, ActivePhysics *apOther) {
	return true;
}
bool dSilverStar_c::collisionCat2_IceBall_15_YoshiIce(ActivePhysics *apThis, ActivePhysics *apOther) {
	return true;
}
bool dSilverStar_c::collisionCat9_RollingObject(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}
bool dSilverStar_c::collisionCat13_Hammer(ActivePhysics *apThis, ActivePhysics *apOther) {
	return false;
}
bool dSilverStar_c::collisionCat14_YoshiFire(ActivePhysics *apThis, ActivePhysics *apOther) {
	return false;
}

bool dSilverStar_c::collisionCat3_StarPower(ActivePhysics *apThis, ActivePhysics *apOther) {
	return false;
}



dSilverStar_c *dSilverStar_c::build() {
	void *buffer = AllocFromGameHeap1(sizeof(dSilverStar_c));
	return new(buffer) dSilverStar_c;
}


void dSilverStar_c::bindAnimChr_and_setUpdateRate(const char* name, int unk, float unk2, float rate) {
	nw4r::g3d::ResAnmChr anmChr = this->resFile.GetResAnmChr(name);
	this->animationChr.bind(&this->bubbleModel, anmChr, unk);
	this->bubbleModel.bindAnim(&this->animationChr, unk2);
	this->animationChr.setUpdateRate(rate);
}

int dSilverStar_c::onCreate() {
	this->noDispawn = (this->settings >> 8 & 0xF);
	if(!this->noDispawn && silverstarCollected[this->id]) {
		this->Delete(1);
		return 1;
	}

	allocator.link(-1, GameHeaps[0], 0, 0x20);

	this->resFile.data = getResource("silverstar", "g3d/silverstar.brres");
	nw4r::g3d::ResMdl mdl = this->resFile.GetResMdl("SilverStar");
	nw4r::g3d::ResMdl bmdl = this->resFile.GetResMdl("balloon");
	bodyModel.setup(mdl, &allocator, 0x224, 1, 0);
	bubbleModel.setup(bmdl, &allocator, 0x224, 1, 0);
	SetupTextures_MapObj(&bodyModel, 0);
	// SetupTextures_Enemy(&bubbleModel, 0);

	nw4r::g3d::ResAnmChr anmChr = this->resFile.GetResAnmChr("float");
	this->animationChr.setup(bmdl, anmChr, &this->allocator, 0);

	allocator.unlink();

	if(!this->noDispawn) {
		ActivePhysics::Info HitMeBaby;

		HitMeBaby.xDistToCenter = 0.0;
		HitMeBaby.yDistToCenter = 0.0;

		HitMeBaby.xDistToEdge = 13.0;
		HitMeBaby.yDistToEdge = 13.0;

		HitMeBaby.category = 0x5;
		HitMeBaby.attack = 0x0;
		HitMeBaby.categoryBitfield = 0x4F;
		HitMeBaby.attackBitfield = 0x200;
		HitMeBaby.miscFlags = 0;
		HitMeBaby.callback = &dEn_c::collisionCallback;

		this->aPhysics.initWithStruct(this, &HitMeBaby);
		this->aPhysics.addToList();
	}

	this->scale = (Vec){0.8, 0.8, 0.8};
	this->bubbleScale = (Vec){1.0, 1.0, 1.0};

	this->pos.x += 8;
	this->pos.y -= 8;
	this->pos.z = 2900.0;

	this->origY = this->pos.y;
	this->starPos = this->pos;

	this->id = this->settings & 0xFF;
    this->movementType = this->settings >> 8 & 0xF;
    this->movementControllerID = this->settings >> 12 & 0xFF;

    // OSReport("DFM: %d\n", this->disableFlagMask);
    this->disableFlagMask = 0;

	bindAnimChr_and_setUpdateRate("float", 1, 0.0, 1.0);

	if(!noDispawn) {
		doStateChange(&StateID_Wait);
	}
	else {
		this->collected = true;
		doStateChange(&StateID_Follow);
	}

	this->onExecute();
	return true;
}


int dSilverStar_c::onDelete() {
	return true;
}

int dSilverStar_c::onDraw() {
	if(!this->collected) {
		bubbleModel.scheduleForDrawing();
		bubbleModel._vf1C();
	}

	bodyModel.scheduleForDrawing();
	return true;
}


void dSilverStar_c::updateModelMatrices() {
	if(this->collected) {
		matrix.translation(pos.x + displacement.x, pos.y + displacement.y, pos.z);
	}
	else {
		matrix.translation(starPos.x, starPos.y, starPos.z);
	}
	matrix.applyRotationYXZ(&rot.x, &rot.y, &rot.z);

	bodyModel.setDrawMatrix(matrix);
	bodyModel.setScale(&scale);
	bodyModel.calcWorld(false);

	if(!this->collected) {
		bubbleMatrix.translation(pos.x, pos.y, pos.z);
		bubbleMatrix.applyRotationYXZ(&bubbleRot.x, &bubbleRot.y, &bubbleRot.z);

		bubbleModel.setDrawMatrix(bubbleMatrix);
		bubbleModel.setScale(&bubbleScale);
		bubbleModel.calcWorld(false);
	}
}


int dSilverStar_c::onExecute() {
	acState.execute();
	updateModelMatrices();

	if(this->animationChr.isAnimationDone())
		this->animationChr.setCurrentFrame(0.0);

	return true;
}

// Wait State

void dSilverStar_c::beginState_Wait() {

}

void dSilverStar_c::executeState_Wait() {
	if(this->cosTimer >= 4.0f) {
		this->cosTimer -= 4.0f;
	}

	this->starPos.y = this->origY + ((cos((M_PI/2) * this->cosTimer))); // cos((pi/2) basically forms a wave, then we ajust the speed with the cosTimer incrementing and the distance with the 16 (=2 tiles)
	this->rot.y = (0x1000 * (cos((M_PI/2) * this->cosTimer2)));

	this->cosTimer += 0.030f;
	this->cosTimer2 += 0.040f;
}

void dSilverStar_c::endState_Wait() {

}

extern float circleTimer;
extern u8 isPowerupPausing;
extern "C" u8 NextStageActorDisableFlags;

// Follow State

void dSilverStar_c::beginState_Follow() {
	this->isOdd = silverstarCollected[this->id] & 1 ? 2.0f : 0.0f;
}

void dSilverStar_c::executeState_Follow() {
	// Powerup pausing

	if(isPowerupPausing) {
		this->disableFlagMask = 8;
	}
	else {
		this->disableFlagMask = 0;
	}

	// Move

	dAc_Py_c *mario = GetSpecificPlayerActor(0);
	if(hasFollowingStarted) {
		float marioDir = mario->direction ? -1 : 1;

		float starnumDisplace = silverstarCollected[this->id] * 16.0f;
		VEC2 marioPos;
		if((NextStageActorDisableFlags & 9) >= 9 && !isPowerupPausing) {
			marioPos = this->marioPositions[this->marioPosBufferTimer];
			this->pos.z = -1900.0f;
		}
		else {
			marioPos = (VEC2){this->marioPositions[this->marioPosBufferTimer].x + ((-16.0f - starnumDisplace) * marioDir), this->marioPositions[this->marioPosBufferTimer].y + 48.0f};
			this->pos.z = 2900.0f;
		}

		float distX = marioPos.x - this->pos.x;
		float distY = marioPos.y - this->pos.y;
		float distance = sqrtf((distX * distX) + (distY * distY));

		if(distance > 0.0f) {
			float directionX = distX / distance;
			float directionY = distY / distance;

			float speed = (distance / 16.0f);
			this->pos.x += directionX * speed;
			this->pos.y += directionY * speed;

			distX = marioPos.x - this->pos.x;
			distY = marioPos.y - this->pos.y;
			float ndistance = sqrtf((distX * distX) + (distY * distY));

		    if(ndistance >= distance)
		    {
		        this->pos.x = marioPos.x;
		        this->pos.y = marioPos.y;
		    }
		}
	}

	this->marioPositions[this->marioPosTimer] = (Vec2){mario->pos.x, mario->pos.y};

	this->marioPosTimer++;
	this->marioPosBufferTimer++;
	if(this->marioPosTimer == this->delay) {hasFollowingStarted = true; this->marioPosBufferTimer = 0;}
	if(this->marioPosTimer >= 200) {this->marioPosTimer = 0;}
	if(this->marioPosBufferTimer >= 200) {this->marioPosBufferTimer = 0;}

	// Rotate

	this->rot.y = (0x1000 * (cos((M_PI/2) * this->cosTimer2)));

	displacement.x = (1.5 * (cos((M_PI/2) * circleTimer + this->isOdd)));
	displacement.y = (1.5 * (sin((M_PI/2) * circleTimer + this->isOdd)));

	this->cosTimer2 += 0.040f;

	// Merge

	if(silverstarCollected[6]) {
		NextStageActorDisableFlags |= 0xF;
		doStateChange(&StateID_Merge);
	}
}

void dSilverStar_c::endState_Follow() {

}

float circleTable[5] = {1.0f, 0.25f, -0.667f, 2.667f, 1.75f};

// Merge State

void dSilverStar_c::beginState_Merge() {
	this->cosTimer = 0.0f;
	this->cosTimer2 = 0.0f;
	this->timer = 0;

	OSReport("ID: %d: %f\n", this->id, circleTable[this->id]);
	finalDisplacement.x = (30.0 * (cos((M_PI/2) * circleTable[this->id])));
	finalDisplacement.y = (30.0 * (sin((M_PI/2) * circleTable[this->id])));

	finalDisplacement.x = (finalDisplacement.x - displacement.x) / 30.0f;
	finalDisplacement.y = (finalDisplacement.y - displacement.y) / 30.0f;

	dAc_Py_c *mario = GetSpecificPlayerActor(0);
	float marioDir = mario->direction ? -1 : 1;
	float starnumDisplace = silverstarCollected[this->id] * 16.0f;
	VEC2 marioPos = (VEC2){mario->pos.x, mario->pos.y + 64.0f};

	float distX = marioPos.x - this->pos.x;
	float distY = marioPos.y - this->pos.y;
	float distance = sqrtf((distX * distX) + (distY * distY));

	if(distance > 0.0f) {
		float directionX = distX / distance;
		float directionY = distY / distance;

		float speed = (distance / 30.0f);
		this->finalDistance.x = directionX * speed;
		this->finalDistance.y = directionY * speed;
	}
}

void dSilverStar_c::executeState_Merge() {
	if(this->timer < 30) {
		this->pos.x += this->finalDistance.x;
		this->pos.y += this->finalDistance.y;
		displacement.x += finalDisplacement.x;
		displacement.y += finalDisplacement.y;
	}


	this->timer++;
}

void dSilverStar_c::endState_Merge() {

}