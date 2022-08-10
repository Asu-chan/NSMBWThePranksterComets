#include "doubleDate/football.h"


/****************/
/* Initializing */
/****************/

CREATE_STATE(dRHFootball_c, Init);
CREATE_STATE(dRHFootball_c, Act);
CREATE_STATE(dRHFootball_c, Shoot);
CREATE_STATE(dRHFootball_c, Miss);

// Instancing

dRHFootball_c *dRHFootball_c::build() {
	void *buffer = AllocFromGameHeap1(sizeof(dRHFootball_c));
	return new(buffer) dRHFootball_c;
}

#include <profile.h>
Profile RHFootballProfile = Profile((buildFunc)&dRHFootball_c::build, ProfileId::RH_FOOTBALL, 0, ProfileId::RH_FOOTBALL, ProfileId::RH_FOOTBALL, 0, "RH_FOOTBALL", 0);

dRHFootball_c::dRHFootball_c() : acState(this, &StateID_Init) { }

dRHFootball_c::~dRHFootball_c() { }

/******************/
/* Main functions */
/******************/

int dRHFootball_c::onCreate() {
	if (!layoutLoaded) {
		if (!layout.loadArc("doubleDate/football.arc", false))
			return false;

		layout.build("football.brlyt");

		layoutLoaded = true;
		visible = true;

		layout.drawOrder = 150;

		if (IsWideScreen()) 
			layout.layout.rootPane->scale.x = 0.735f;

		this->pos = (Vec2){0.0f, 0.0f};
		this->scale = (Vec2){0.0f, 0.0f};

		// shadow = (dRHShadow_c*)CreateParentedObject(RH_SHADOW, this, 0, 0);
		// leaves = (dRHLeaves_c*)CreateParentedObject(RH_LEAVES, this, 0, 0);

		this->secondaryRoot = layout.findPaneByName("N_doubleDate_00");
		this->busy = false;
	}

	return true;
}
int dRHFootball_c::onDelete() {
	return layout.free();
}

extern u8 currPlay;

int dRHFootball_c::onExecute() {
	layout.update();
	acState.execute();

	shadow->pos.x = this->pos.x;
	shadow->scale = this->scale;

	secondaryRoot->trans.x = this->pos.x;
	secondaryRoot->trans.y = this->pos.y;
	secondaryRoot->scale.x = this->scale.x;
	secondaryRoot->scale.y = this->scale.y;
	secondaryRoot->rotate.z = this->rotZ;

	this->rotZ -= 7.2f;
	if(this->rotZ < -360.0f) this->rotZ += 360.0f;

	return true;
}

int dRHFootball_c::onDraw() {
	if(visible) {
		layout.scheduleForDrawing();
	}

	return true;
}

void dRHFootball_c::act() {
	acState.setState(&StateID_Act);
}

int dRHFootball_c::canBeShoot() { // Absolute perfect is 92
	if(acState.getCurrentState() == &StateID_Act) {
		if(this->actFrame == 92) {
			acState.setState(&StateID_Shoot);
			this->leaves->leavesFall();
			return 1;
		}
		return 4;

		if(this->actFrame >= 90 && this->actFrame <= 94) {
			acState.setState(&StateID_Shoot);
			this->leaves->leavesFall();
			return 1;
		}
		if(this->actFrame == 99) {
			acState.setState(&StateID_Miss);
			Vec2 soundPos = (Vec2){this->pos.x / (IsWideScreen() ? 417.5f : 304.0f), this->pos.y / 228.0f};
			return 2;
		}
	}
	return 0;
}

/**********/
/* States */
/**********/

// Init State

void dRHFootball_c::beginState_Init() {
	OSReport("Init Football.\n");
	this->scale = (Vec2){0.0f, 0.0f};
	this->busy = false;
}

void dRHFootball_c::executeState_Init() {

}

void dRHFootball_c::endState_Init() {
	
}

u32 footballSFXFrames[] = {46, 114, 164, 230, 0xFFFF};
u32 footballSFXIDs[] = {SFX_RHDD_BOUNCE_FOOTBALL, SFX_RHDD_BOUNCE_GRASS1, SFX_RHDD_BOUNCE_GRASS2, SFX_RHDD_BOUNCE_GRASS3, 0xFFFF};

// Act State

void dRHFootball_c::beginState_Act() {
	OSReport("Act Football.\n");
	this->scale = (Vec2){0.8f, 0.8f};
	this->actTimer = 0.0f;
	this->actFrame = 0;
	this->busy = true;

	this->currentSFXWait = 0;
}

void dRHFootball_c::executeState_Act() {
	if(this->actTimer >= 0 && this->actTimer < 46) {
		this->pos.x = (3.962963f * this->actTimer) + -499.2963f;
		this->pos.y = (196.0f * cos((this->actTimer + -19.0f) / (2.0f * (27.0f / M_PI)))) + -96.0f;
	}
	else if(this->actTimer >= 46 && this->actTimer < 80) {
		this->pos.x = (3.882353f * this->actTimer) + -495.5882f;
		this->pos.y = (96.0f * cos((this->actTimer + -80.0f) / (2.0f * (34.0f / M_PI)))) + -96.0f;
	}
	else if(this->actTimer >= 80 && this->actTimer < 114) {
		this->pos.x = (3.970588f * this->actTimer) + -502.6471f;
		this->pos.y = (100.0f * cos((this->actTimer + -80.0f) / (2.0f * (34.0f / M_PI)))) + -100.0f;
	}
	else if(this->actTimer >= 114 && this->actTimer < 139) {
		this->pos.x = (5.32f * this->actTimer) + -656.48f;
		this->pos.y = (80.0f * cos((this->actTimer + -139.0f) / (2.0f * (25.0f / M_PI)))) + -100.0f;
	}
	else if(this->actTimer >= 139 && this->actTimer < 164) {
		this->pos.x = (4.44f * this->actTimer) + -534.16f;
		this->pos.y = (75.0f * cos((this->actTimer + -139.0f) / (2.0f * (25.0f / M_PI)))) + -95.0f;
	}
	else if(this->actTimer >= 164 && this->actTimer < 191) {
		this->pos.x = (4.814815f * this->actTimer) + -595.6296f;
		this->pos.y = (55.0f * cos((this->actTimer + -191.0f) / (2.0f * (27.0f / M_PI)))) + -95.0f;
	}
	else if(this->actTimer >= 191 && this->actTimer < 230) {
		this->pos.x = (3.888889f * this->actTimer) + -418.7778f;
		this->pos.y = (58.0f * cos((this->actTimer + -191.0f) / (2.0f * (27.0f / M_PI)))) + -98.0f;
	}
	else {
		acState.setState(&StateID_Init);
	}

	if (!IsWideScreen()) 
		this->pos.x *= 0.7245f;

	if(Remocon_GetPressed(GetActiveRemocon()) & WPAD_A) {
		OSReport("footframe: %d\n", this->actFrame);
	}

	this->actTimer += 1.0f;
	this->actFrame++;


	if(this->actTimer >= footballSFXFrames[this->currentSFXWait]) {
		PlaySoundWithFunctionB4(SoundRelatedClass, &ballSHandle, footballSFXIDs[this->currentSFXWait], 1);
		this->currentSFXWait++;
	}
}

void dRHFootball_c::endState_Act() {

}

// Shoot State

void dRHFootball_c::beginState_Shoot() {
	OSReport("Shoot Football: %d.\n", this->actFrame);
	this->actFrame = 0;
}

void dRHFootball_c::executeState_Shoot() {
	this->pos.x -= 10.0f;
	this->pos.y += 35.0f;
	this->actFrame++;

	if(this->actFrame == 10) {
		acState.setState(&StateID_Init);
	}
}

void dRHFootball_c::endState_Shoot() {
	
}

// Miss State

void dRHFootball_c::beginState_Miss() {
	OSReport("Miss Football.\n");
	this->actFrame = 0;
}

void dRHFootball_c::executeState_Miss() {
	this->actFrame++;

	if(this->actFrame == 1) {
		acState.setState(&StateID_Init);
	}
}

void dRHFootball_c::endState_Miss() {
	
}