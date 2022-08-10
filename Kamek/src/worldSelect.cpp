#include "worldSelect.h"

class daWMIsland_c : public dActor_c {
public:
	u8 _125, _126, _127;
	mAllocator_c allocator;	// 0x128
	m3d::mdl_c model;		// 0x144
	m3d::fanm_c anmChr;		// 0x184
	u8 unk1[132];			// 0x1BC
	u32 resFile;			// 0x240
	u8 unk2[56];			// 0x244
	u32 islandID;			// 0x27C
	u8 unk3[84];			// 0x280
	//Total Size: 0x2D4
};

class dWorldSelect_c : public dBase_c {
public:
	u32 field_70;								// 0x70
	m2d::EmbedLayout_c layout;					// 0x74
	dStateWrapper_c<dWorldSelect_c> acState;	// 0x20C
	daWMIsland_c *islands[9];					// 0x248
	u8 unk1[0x10];								// 0x26C
	u32 SelectedIsland;							// 0x27C
	u8 unk2[0x1C];								// 0x280
	int timeToWaitUntilWipe;					// 0x29C
	u8 unk3[8];									// 0x2A0
	u8 world1Unlocked;							// 0x2A8
	u8 world2Unlocked;							// 0x2A9
	u8 world3Unlocked;							// 0x2AA
	u8 world4Unlocked;							// 0x2AB
	u8 world5Unlocked;							// 0x2AC
	u8 world6Unlocked;							// 0x2AD
	u8 world7Unlocked;							// 0x2AE
	u8 world8Unlocked;							// 0x2AF
	u8 world9Unlocked;							// 0x2B0
	u8 unk4[11];								// 0x2B1
	daCometModel_c *comets[9];					// 0x2BC
	u32 worldCount;								// 0x2E0
	//Total Size: 0x2E4

	int onCreate_orig();
	int newOnCreate();
	int onExecute_orig();
	int newOnExecute();
	int onDelete_orig();
	int newOnDelete();

	USING_STATES(dWorldSelect_c);
	REF_NINTENDO_STATE(OnStageWait);
};

int dWorldSelect_c::newOnCreate() {
	int orig_val = this->onCreate_orig();

	if(orig_val) {
		u8 wi[10];
		for(int i = 0; i < 10; i++) {
			wi[i] = GetSaveFile()->GetBlock(-1)->worlds_available[i] & 1;
		}
		this->worldCount = 8 + wi[8];
		// OSReport("Total Worlds: %d\n", this->worldCount);

		for(int i = 0; i < worldCount; i++) {
			if(!areWorldLevelsFinished(i)) {
				this->comets[i] = (daCometModel_c*)CreateChildObject(TIME_UP, this, wi[i], 0, 0);
				this->comets[i]->starID = i;
			}
		}
	}

	this->timeToWaitUntilWipe = -1;

	return orig_val;
}

int dWorldSelect_c::newOnExecute() {
	if(SelectedIsland > 8)
		SelectedIsland = 8;

	// for(int i = 0; i < 9; i++) {
	// 	if(i == SelectedIsland) {
	// 		islands[i]->unk2[0x30] = 1;
	// 	}
	// 	else {
	// 		islands[i]->unk2[0x30] = 0;
	// 	}
	// }

	int orig_val = this->onExecute_orig();

	// OSReport("selectedIsland=%d\n", this->SelectedIsland);

	/*if(this->acState.getCurrentState() == &StateID_OnStageWait) {
		if(this->comets[0]->invisible != true) {
			for(int i = 0; i < worldCount; i++) {
				if(this->comets[i])
					this->comets[i]->invisible = true;
			}
		}
		return orig_val;
	}
	else {
		if(this->comets[0]->invisible != false) {
			for(int i = 0; i < worldCount; i++) {
				if(this->comets[i])
					this->comets[i]->invisible = false;
			}
		}
	}*/

	bool isWaiting = this->acState.getCurrentState() == &StateID_OnStageWait;
	// if(this->comets[0]) {
		// if(this->comets[0]->invisible != isWaiting) { // For some reasons this creates invalid reads, probably a compiler error of some kind from what I've debugged
			for(int i = 0; i < worldCount; i++) {
				if(this->comets[i])
					this->comets[i]->invisible = isWaiting;
			}
		// }
	// }

	if(isWaiting) {return orig_val;}


	for(int i = 0; i < worldCount; i++) {
		if(this->comets[i]) {
			/* Scale */
			float scaleX = *(float*)(((u32)this->islands[i]->model.scnObj) + 0xDC);
			float scaleY = *(float*)(((u32)this->islands[i]->model.scnObj) + 0xE0);
			float scaleZ = *(float*)(((u32)this->islands[i]->model.scnObj) + 0xE4);

			Vec newScale;
			if(this->timeToWaitUntilWipe < 0) {
				newScale = (Vec){scaleX / 100.0f, scaleY / 100.0f, scaleZ / 100.0f};
			}
			else if(this->timeToWaitUntilWipe > 45) {
				float ratio = (this->timeToWaitUntilWipe - 45) / 15.0f;

				newScale = (Vec){(scaleX / 100.0f) * ratio,
								 (scaleY / 100.0f) * ratio,
								 (scaleZ / 100.0f) * ratio};
			}
			else {
				newScale = (Vec){0.0, 0.0, 0.0};
			}

			/* Position */
			float posPad = (88.235294117647f * scaleX) - 109.4117647058823f;

			Vec newPos = (Vec){this->islands[i]->matrix[0][3], this->islands[i]->matrix[1][3], this->islands[i]->matrix[2][3]};

			if     (i == 3) { newPos.y += 20.0f; newPos.z += 50.0f; }
			if     (i == 4) { newPos.z += 50.0f; }
			if     (i == 7) { newPos.z += 40.0f; }
			else if(i == 8) { newPos.y -= 40.0f; }

			/* Applying */
			this->comets[i]->pos = (Vec){newPos.x, newPos.y + 120.0f + posPad, newPos.z + 100.0f};
			this->comets[i]->scale = newScale;
			this->comets[i]->isEnabled = (this->SelectedIsland == i);
		}
	}

	// OSReport("State: %s\n", this->acState.getCurrentState()->getName());

	return orig_val;
}

int dWorldSelect_c::newOnDelete() {
	int orig_val = this->onDelete_orig();

	for(int i = 0; i < worldCount; i++) {
		if(this->comets[i])
			this->comets[i]->Delete();
	}

	return orig_val;
}

/*

class dWorldSelectGuide_c : public dBase_c {
public:
	m2d::EmbedLayout_c layout;

	int onCreate_orig();
	int newOnCreate();
	int onExecute_orig();
	int newOnExecute();
};

daCometModel_c* comet;

int dWorldSelectGuide_c::newOnCreate() {
	int orig_val = this->onCreate_orig();

	if(orig_val) {
		comet = (daCometModel_c*)CreateChildObject(TIME_UP, this, 0, 0, 0);
	}

	return orig_val;
}

int dWorldSelectGuide_c::newOnExecute() {
	int orig_val = this->onExecute_orig();

	float shitPad = (88.235294117647f * shitScale.x) -109.4117647058823f;
	OSReport("shitPad: %f\n", shitPad);
	comet->pos = (Vec){shitPos.x, shitPos.y + 120.0f + shitPad, shitPos.z + 100.0f};
	comet->scale = (Vec){shitScale.x / 100.0f, shitScale.y / 100.0f, shitScale.z / 100.0f};
	comet->isEnabled = (selectedIsland == 0);

	return orig_val;
}
*/

/******************/
/* daCometModel_c */
/******************/

daCometModel_c *daCometModel_c::build() {
	void *buffer = AllocFromGameHeap1(sizeof(daCometModel_c));
	return new(buffer) daCometModel_c;
}

void daCometModel_c::bindAnimChr_and_setUpdateRate(const char* name, int unk, float unk2, float rate) {
	nw4r::g3d::ResAnmChr anmChr = this->resFile.GetResAnmChr(name);
	this->animationChr.bind(&this->bodyModel, anmChr, unk);
	this->bodyModel.bindAnim(&this->animationChr, unk2);
	this->animationChr.setUpdateRate(rate);
}

int daCometModel_c::onCreate() {

	allocator.link(-1, GameHeaps[0], 0, 0x20);

	this->resFile.data = getResource("cometStar", "g3d/cometStar.brres");
	nw4r::g3d::ResMdl mdl = this->resFile.GetResMdl("CometStar");
	bodyModel.setup(mdl, &allocator, 0x224, 1, 0);
    SetupTextures_Player(&bodyModel, 0);

	nw4r::g3d::ResMdl mdl2 = this->resFile.GetResMdl((this->settings) ? "CometStarDisabled" : "CometStarInactive");
	disabledModel.setup(mdl2, &allocator, 0x224, 1, 0);
    SetupTextures_Player(&disabledModel, 0);

	nw4r::g3d::ResAnmChr anmChr = this->resFile.GetResAnmChr("rotate");
	this->animationChr.setup(mdl, anmChr, &this->allocator, 0);
	this->animationChr.bind(&this->bodyModel, anmChr, 1);
	this->bodyModel.bindAnim(&this->animationChr, 0.0);
	this->animationChr.setUpdateRate(1.0);

	this->animationChr2.setup(mdl2, anmChr, &this->allocator, 0);
	this->animationChr2.bind(&this->disabledModel, anmChr, 1);
	this->disabledModel.bindAnim(&this->animationChr2, 0.0);
	this->animationChr2.setUpdateRate(1.0);

	allocator.unlink();

	this->scale = (Vec){0.01, 0.01, 0.01};

	// bindAnimChr_and_setUpdateRate("rotate", 1, 0.0, 1.0);

	this->onExecute();
	return true;
}


int daCometModel_c::onDelete() {
	return true;
}

void daCometModel_c::specialDraw1() {
	if(!this->invisible) {
		if(this->isEnabled) {
			bodyModel.scheduleForDrawing();
			bodyModel._vf1C();
		}
		else {
			disabledModel.scheduleForDrawing();
			if(this->settings) {
				disabledModel._vf1C();
			}
		}
	}
}


void daCometModel_c::updateModelMatrices() {
	matrix.translation(pos.x, pos.y, pos.z);
	matrix.applyRotationYXZ(&rot.x, &rot.y, &rot.z);

	if(this->isEnabled) {
		bodyModel.setDrawMatrix(matrix);
		bodyModel.setScale(&scale);
		bodyModel.calcWorld(false);
	}
	else {
		disabledModel.setDrawMatrix(matrix);
		disabledModel.setScale(&scale);
		disabledModel.calcWorld(false);
	}
}

int daCometModel_c::onExecute() {
	updateModelMatrices();

	if(this->animationChr.isAnimationDone()) {
		this->animationChr.setCurrentFrame(0.0);
	}

	if(this->animationChr2.isAnimationDone()) {
		this->animationChr2.setCurrentFrame(0.0);
	}

	return true;
}

/*****************/
/* Conds Checker */
/*****************/

int levelList[9][12] = {{0, 1, 2, 21, 3, 4, 5, 23, -1},
					 {0, 1, 2, 21, 3, 4, 5, 23, -1},
					 {0, 1, 2, 20, 21, 3, 4, 23, -1},
					 {0, 1, 2, 21, 3, 20, 4, 23, 37, -1},
					 {0, 1, 2, 21, 3, 20, 4, 23, -1},
					 {0, 1, 2, 3, 21, 4, 5, 23, 37, -1},
					 {0, 1, 2, 21, 20, 3, 4, 5, 23, -1},
					 {0, 1, 2, 21, 3, 4, 5, 6, 37, 23, -1},
					 {0, 1, 2, 3, 4, 5, 6, 7, -1}};

bool areWorldLevelsFinished(u32 worldID) {
	bool isFinished = true;
	SaveBlock *save = GetSaveFile()->GetBlock(-1);

	// OSReport("---\nWorld %d\n", worldID + 1);

	for(int i = 0; levelList[worldID][i] >= 0; i++) {
		int level = levelList[worldID][i];
		// OSReport("Checking Level: %02d-%02d", worldID+1, level+1);

		u32 conds = save->GetLevelCondition(worldID, level);
		if(!(conds & COND_NORMAL)) {
			isFinished = false;
			// OSReport(" -> BREAK\n");
			break;
		}
		// OSReport(" -> CONTINUE\n");
	}
	// OSReport("Result: %d\n---\n", isFinished);

	return isFinished;
}