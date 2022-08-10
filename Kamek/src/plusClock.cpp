#include <common.h>
#include <game.h>
#include <g3dhax.h>
#include <sfx.h>
#include "gameDisplay.h"
#include "timekeeper.h"


extern "C" bool SpawnEffect(const char*, int, Vec*, S16Vec*, Vec*);

const char* TACarcNameList [] = {
	"plusclock",
	NULL
};

u8 plusClocksCollected[100];

class dPlusClock_c : public dEn_c {
	int onCreate();
	int onExecute();
	int onDelete();
	int onDraw();

	mHeapAllocator_c allocator;
	m3d::mdl_c bodyModel;

	int timeToAdd;
	int type;
	u32 timer;

	mEf::es2 smoke;

	static dPlusClock_c *build();

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

static nw4r::snd::StrmSoundHandle clockHandle;
extern "C" void DisplayScoreAddPopup(Vec* pos, int type, int color, int unk);
extern "C" void AddScore(int howMany, int color);
extern "C" void getSumOfPosAndD0(Vec* outVec, u32* thisPtr);
u32 nextClockPG = 0;

void dPlusClock_c::playerCollision(ActivePhysics *apThis, ActivePhysics *apOther) {

	PlaySoundWithFunctionB4(SoundRelatedClass, &clockHandle, (this->type) ? 0xBC : SFX_PLUS_CLOCK, 1);
	if(!this->type) {
		S16Vec nullRot = {0,0,0};
		Vec oneVec = {1.0f, 1.0f, 1.0f};
		SpawnEffect("Wm_ob_starcoinget_ring", 0, &this->pos, &nullRot, &oneVec);
	}

	TimeKeeper::instance->setTime(dGameDisplay_c::instance->timer + timeToAdd);
	nextClockPG = timeToAdd;

	Vec sumPos = (Vec){0, 0, 0};
	getSumOfPosAndD0(&sumPos, (u32*)this),
	DisplayScoreAddPopup(&sumPos, 0x10, apOther->owner->which_player, 0);
	if(timeToAdd > 0)
		AddScore(timeToAdd * 20, apOther->owner->which_player);


	plusClocksCollected[this->settings & 0xFF] = 1;
	this->Delete(1);
}


void dPlusClock_c::spriteCollision(ActivePhysics *apThis, ActivePhysics *apOther) {
}


void dPlusClock_c::yoshiCollision(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
}

bool dPlusClock_c::collisionCat7_GroundPound(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}
bool dPlusClock_c::collisionCat7_GroundPoundYoshi(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}
bool dPlusClock_c::collisionCatD_Drill(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}
bool dPlusClock_c::collisionCatA_PenguinMario(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}

bool dPlusClock_c::collisionCat1_Fireball_E_Explosion(ActivePhysics *apThis, ActivePhysics *apOther) {
	return true;
}
bool dPlusClock_c::collisionCat2_IceBall_15_YoshiIce(ActivePhysics *apThis, ActivePhysics *apOther) {
	return true;
}
bool dPlusClock_c::collisionCat9_RollingObject(ActivePhysics *apThis, ActivePhysics *apOther) {
	playerCollision(apThis, apOther);
	return true;
}
bool dPlusClock_c::collisionCat13_Hammer(ActivePhysics *apThis, ActivePhysics *apOther) {
	return false;
}
bool dPlusClock_c::collisionCat14_YoshiFire(ActivePhysics *apThis, ActivePhysics *apOther) {
	return false;
}

bool dPlusClock_c::collisionCat3_StarPower(ActivePhysics *apThis, ActivePhysics *apOther) {
	return false;
}



dPlusClock_c *dPlusClock_c::build() {
	void *buffer = AllocFromGameHeap1(sizeof(dPlusClock_c));
	return new(buffer) dPlusClock_c;
}


int dPlusClock_c::onCreate() {
	if(plusClocksCollected[this->settings & 0xFF]) {
		this->Delete(1);
	}

	this->type = (this->settings >> 16) & 0xF;
	int ogTime = (this->settings >> 8) & 0xFF;
	this->timeToAdd = ogTime * ((this->type) ? -1 : 1);
	int isTopTier = (ogTime >= 60) ? 2 : 0;

	const char *filenames[4] = {
		"PlusClock",
		"BadPlusClock",
		"GreatPlusClock",
		"WorsePlusClock",
	};

	allocator.link(-1, GameHeaps[0], 0, 0x20);

	nw4r::g3d::ResFile rf(getResource("plusclock", "g3d/plusclock.brres"));
	bodyModel.setup(rf.GetResMdl(filenames[type + isTopTier]), &allocator, 0x224, 1, 0);
	SetupTextures_Enemy(&bodyModel, 0);

	allocator.unlink();

	ActivePhysics::Info HitMeBaby;

	HitMeBaby.xDistToCenter = 0.0;
	HitMeBaby.yDistToCenter = 0.0;

	HitMeBaby.xDistToEdge = 10.5;
	HitMeBaby.yDistToEdge = 10.5;

	HitMeBaby.category = 0x5;
	HitMeBaby.attack = 0x0;
	HitMeBaby.categoryBitfield = 0x4F;
	HitMeBaby.attackBitfield = 0x200;
	HitMeBaby.miscFlags = 0;
	HitMeBaby.callback = &dEn_c::collisionCallback;

	this->aPhysics.initWithStruct(this, &HitMeBaby);
	this->aPhysics.addToList();

	this->scale = (Vec){0.125, 0.125, 0.125};

	this->pos.x += 8;
	this->pos.y -= 8;
	this->pos.z = 300.0;

	this->onExecute();
	return true;
}


int dPlusClock_c::onDelete() {
	return true;
}

int dPlusClock_c::onDraw() {
	bodyModel.scheduleForDrawing();
	return true;
}


void dPlusClock_c::updateModelMatrices() {
	matrix.translation(pos.x, pos.y - 14, pos.z);
	matrix.applyRotationYXZ(&rot.x, &rot.y, &rot.z);

	bodyModel.setDrawMatrix(matrix);
	bodyModel.setScale(&scale);
	bodyModel.calcWorld(false);
}

extern "C" s16 coinConstant;

int dPlusClock_c::onExecute() {
	updateModelMatrices();

	this->rot.y = coinConstant;
	if(!this->type) {
		this->timer++;
		if(this->timer == 30) {
			S16Vec nullRot = {0,0,0};
			Vec oneVec = {0.75f, 0.75f, 0.75f};

			SpawnEffect("Wm_ob_starcoinget_ring", 0, &this->pos, &nullRot, &oneVec);
			this->timer = 0;
		}
	}
	else {
		Vec oneVec = {2.0f, 2.0f, 2.0f};
		Vec onePos = {this->pos.x, this->pos.y, this->pos.z - 200.0f};
		smoke.spawn("Wm_en_timersmoke", 0, &onePos, 0, &oneVec);
	}

	return true;
}

extern "C" void TextBoxSetBmgString(nw4r::lyt::TextBox *textBox, u32 bmgRelated, u32 someNumber, u32 unk, u32 unk2);

void newPointThingie(nw4r::lyt::TextBox *textBox, u32 bmgRelated, u32 someNumber, u32 unk, u32 unk2) {
	if(!nextClockPG) {
		TextBoxSetBmgString(textBox, bmgRelated, someNumber, unk, unk2);
	}
	else {
		char clockString[4];
		wchar_t wclockString_t[8];

		sprintf(clockString, "%+d", nextClockPG);
		//\x0B\x0159\xBEEF
		wclockString_t[0] = 0x000B;
		wclockString_t[1] = 0x0159;
		wclockString_t[2] = 0xBEEF;
		wclockString_t[3] = clockString[0];
		wclockString_t[4] = clockString[1];
		wclockString_t[5] = clockString[2];
		wclockString_t[6] = clockString[3];
		wclockString_t[7] = 0;

		textBox->SetString(wclockString_t);
		textBox->size.x += 40.0f;
		nextClockPG = 0;
	}
}

extern bool enableSpeedy;
extern "C" void sub_800E2190(u32 *StageF70Ptr, u32 *thisPtr, u32 type, u32 playerID, float unk, float unk2);
extern u32* GetCurrentPC();

void StarCoinPointThingie(u32 *StageF70Ptr, u32 *thisPtr, u32 type, u32 playerID, float unk, float unk2) {
	if(enableSpeedy) {
		TimeKeeper::instance->setTime(dGameDisplay_c::instance->timer + 10);
		nextClockPG = 10;

		Vec sumPos = (Vec){0, 0, 0};
		getSumOfPosAndD0(&sumPos, thisPtr),
		DisplayScoreAddPopup(&sumPos, 0x10, playerID, 0);
		AddScore(4000, playerID);
	}
	else {	
		sub_800E2190(StageF70Ptr, thisPtr, type, playerID, unk, unk2);
	}
}