#include <common.h>
#include <game.h>
#include <g3dhax.h>
#include <sfx.h>
#include "gameDisplay.h"
#include "crowdClapper.h"


extern "C" bool SpawnEffect(const char*, int, Vec*, S16Vec*, Vec*);

const char* PCarcNameList [] = {
	"purplecoin",
	NULL
};

u8 purplecoinsCollected[32];
u8 purplecoinsCollected_checkpoint[32];
// u8 purplecoinsExists[32];
int purplecoins = 0;
int purplecoins_checkpoint = 0;

class daPurpleCoin_c : public dEn_c {
	int onCreate();
	int onExecute();
	int onDelete();
	int onDraw();

	mHeapAllocator_c allocator;
	m3d::mdl_c bodyModel;
	u32 purpleCoinID;
	u32 timer;

	// Water Ball
	u32 movementControllerID;
	u8 movementType;
	bool doneSearching;
	Vec ogPos;

	// Crowd Clapping
	u8 collectionID;

	static daPurpleCoin_c *build();

	bool searchForWaterBall();
	void doCollectionCounting();
	void updateModelMatrices();
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

};

static nw4r::snd::StrmSoundHandle handle;
extern "C" void AddScore(int howMany, int color);

void daPurpleCoin_c::playerCollision(ActivePhysics *apThis, ActivePhysics *apOther) {

	PlaySoundWithFunctionB4(SoundRelatedClass, &handle, SFX_PURPLE_COIN, 1);
	S16Vec nullRot = {0,0,0};
	Vec oneVec = {1.0f, 1.0f, 1.0f};
	SpawnEffect("Wm_ob_purplecoinkira", 0, &this->pos, &nullRot, &oneVec);

	dGameDisplay_c::instance->updateCometStuff(1);

	OSReport("ptr: %p\n", &purplecoinsCollected);
	OSReport("before: %d %d\n", this->purpleCoinID, purplecoinsCollected[this->purpleCoinID / 8]);
	purplecoinsCollected[this->purpleCoinID / 8] |= 1 << (this->purpleCoinID % 8);
	OSReport("after: %d %d\n", this->purpleCoinID, purplecoinsCollected[this->purpleCoinID / 8]);
	AddScore(100, apOther->owner->which_player);

	this->doCollectionCounting();

	this->Delete(1);
}


void daPurpleCoin_c::spriteCollision(ActivePhysics *apThis, ActivePhysics *apOther) {
	// dActor_c *block = apOther->owner;
	// dEn_c *blah = (dEn_c*)block;

	// OSReport("Colliding with %s\n", blah->acState.getCurrentState()->getName());
}


void daPurpleCoin_c::yoshiCollision(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
}

bool daPurpleCoin_c::collisionCat7_GroundPound(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}
bool daPurpleCoin_c::collisionCat7_GroundPoundYoshi(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}
bool daPurpleCoin_c::collisionCatD_Drill(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}
bool daPurpleCoin_c::collisionCatA_PenguinMario(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}

bool daPurpleCoin_c::collisionCat1_Fireball_E_Explosion(ActivePhysics *apThis, ActivePhysics *apOther) {
	return true;
}
bool daPurpleCoin_c::collisionCat2_IceBall_15_YoshiIce(ActivePhysics *apThis, ActivePhysics *apOther) {
	return true;
}
bool daPurpleCoin_c::collisionCat9_RollingObject(ActivePhysics *apThis, ActivePhysics *apOther) {
	return true;
}
bool daPurpleCoin_c::collisionCat13_Hammer(ActivePhysics *apThis, ActivePhysics *apOther) {
	return false;
}
bool daPurpleCoin_c::collisionCat14_YoshiFire(ActivePhysics *apThis, ActivePhysics *apOther) {
	return false;
}

bool daPurpleCoin_c::collisionCat3_StarPower(ActivePhysics *apThis, ActivePhysics *apOther) {
	return false;
}



daPurpleCoin_c *daPurpleCoin_c::build() {
	void *buffer = AllocFromGameHeap1(sizeof(daPurpleCoin_c));
	return new(buffer) daPurpleCoin_c;
}

extern "C" u32 Actor_SearchByName(u32 ID, u32 previous);

int daPurpleCoin_c::onCreate() {
	// Parsing settings

	this->purpleCoinID = this->settings & 0xFF;

    this->movementType = this->settings >> 8 & 0xF;
    this->movementControllerID = this->settings >> 12 & 0xFF;

    this->collectionID = -1;

    if(this->movementType == 1)
    	this->searchForWaterBall();
    else if(this->movementType == 2)
    	this->collectionID = this->settings >> 12 & 0xF;

	// Taking out of existence purple coins that were already collected

	if((purplecoinsCollected[this->purpleCoinID / 8] >> (this->purpleCoinID % 8)) & 1) {
		this->doCollectionCounting();
		this->Delete(1);
		return 2;
	}
	else {
    	OSReport("Coin ID %d spawned\n", this->purpleCoinID);
	}

	// 3D Model & Collision stuff

	allocator.link(-1, GameHeaps[0], 0, 0x20);

	nw4r::g3d::ResFile rf(getResource("purplecoin", "g3d/purplecoin.brres"));
	bodyModel.setup(rf.GetResMdl("PurpleCoin"), &allocator, 0x224, 1, 0);
	SetupTextures_MapObj(&bodyModel, 0);

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

	// Default values & ending

	this->scale = (Vec){1.50, 1.50, 1.50};

	this->pos.x += 8;
	this->pos.y -= 8;
	this->pos.z = 200.0;

    this->timer = 0;

	this->onExecute();
	return true;
}


int daPurpleCoin_c::onDelete() {
	return true;
}

int daPurpleCoin_c::onDraw() {
	bodyModel.scheduleForDrawing();
	return true;
}


void daPurpleCoin_c::updateModelMatrices() {
	matrix.translation(pos.x, pos.y /*- 11*/, pos.z);
	matrix.applyRotationYXZ(&rot.x, &rot.y, &rot.z);

	bodyModel.setDrawMatrix(matrix);
	bodyModel.setScale(&scale);
	bodyModel.calcWorld(false);
}

extern "C" s16 coinConstant;

int daPurpleCoin_c::onExecute() {
	updateModelMatrices();

	this->rot.y = coinConstant;

	if(this->movementType == 1) {
		if(!this->doneSearching) {
			if(!this->searchForWaterBall()) {
				// OSReport("No Water Ball found, aborting\n");
				return true;
			}
			// OSReport("Water Ball found\n");
		}

		u32 waterBall = (u32)Actor_SearchByID(this->movementControllerID);
		if(waterBall == 0) {
			// OSReport("Water Ball lost\n");
			this->Delete(0);
			return true;
		}

		Vec ballPos = *(Vec*)(waterBall + 0x470);
		this->pos = (Vec){this->ogPos.x + ballPos.x, this->ogPos.y + ballPos.y, this->ogPos.z + ballPos.z};
		// OSReport("bp: %f %f %f\n", ballPos.x, ballPos.y, ballPos.z);
	}

	if(this->timer < 60) {
		if((purplecoinsCollected[this->purpleCoinID / 8] >> (this->purpleCoinID % 8)) & 1) {
			this->Delete(1);
		}
		this->timer++;
	}

	return true;
}

bool daPurpleCoin_c::searchForWaterBall() {
	u32 previous = 0;
	while(true) {
		previous = Actor_SearchByName(0x25E, previous);
		if(previous == 0) {
			// OSReport("No Water Ball found, aborting\n");
			return false;
		}
		else if(*(u32*)(previous + 0x4AC) == this->movementControllerID) {
			this->movementControllerID = *(u32*)previous;
			this->ogPos = this->pos;
			this->doneSearching = true;
			return true;
		}
	}
}

void daPurpleCoin_c::doCollectionCounting() {
	if(this->collectionID >= 0) { // Yoiked from 80036930
		daNiceCoin_c *prev = 0;
		while(true) {
			prev = (daNiceCoin_c*)fBase_c::search(AC_NICE_COIN, prev);
			if(prev) {
				if(prev->collectionID == this->collectionID) {
					prev->purpleCoinsCollected++;
					break;
				}
			}
			else break;
		}
		prev = 0;
		while(true) {
			prev = (daNiceCoin_c*)fBase_c::search(AC_NICE_COIN_REGULAR, prev);
			if(prev) {
				if(prev->collectionID == this->collectionID) {
					prev->purpleCoinsCollected++;
					break;
				}
			}
			else break;
		}
	}
}

extern "C" void GetPositionOfEntrance();

void PurpleCoinCheckpoint()  {
	GetPositionOfEntrance();
	purplecoins_checkpoint = purplecoins;
	for(int i = 0; i < 32; i++)
		purplecoinsCollected_checkpoint[i] = purplecoinsCollected[i];
}